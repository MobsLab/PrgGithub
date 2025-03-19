# Load libs
import os
import sys
import datetime
import math
import tables
import struct
import numpy as np
import os.path
import subprocess
import tensorflow as tf
import matplotlib as mpl
import matplotlib.pyplot as plt
from scipy import signal
from functools import reduce
from sklearn.neighbors import KernelDensity
from bayesian_utils import butils

# %%

def build_kernel_densities(project_path, xml_path, list_channels, samplingRate, **keyword_parameters):
# 'list_channels is a dictionary'

	print('\nBUILDING RATE FUNCTIONS')
	speed_cut            = keyword_parameters.get('speed_cut',         0)
	end_time             = keyword_parameters.get('end_time',          None)
	bandwidth            = keyword_parameters.get('bandwidth',         None)
	kernel               = keyword_parameters.get('kernel',            'epanechnikov')
	masking_factor       = keyword_parameters.get('masking_factor',    20)
	cluster_modifier     = keyword_parameters.get('cluster_modifier',  1)
	rand_param           = keyword_parameters.get('rand_param',        0)
	target               = keyword_parameters.get('target',            'pos')
	split                = keyword_parameters.get('split',             0.1)
	whichsplit           = keyword_parameters.get('whichsplit',        'end')

	# Clu path
	clu_path = xml_path[:len(xml_path)-3]
	# Alocate arrays
	Rate_functions = []
	Marginal_rate_functions = []
	fake_labels = []
	fake_labels_time = []


	# Extract behavior
	if not(os.path.exists(project_path + 'nnBehavior.mat')):
		subprocess.run(["./getTsdFeature.sh", os.path.expanduser(xml_path.strip('\'')), "\""+target+"\"", "\""+str(split)+"\"", "\""+whichsplit+"\""])
	else:
		f = tables.open_file(project_path + 'nnBehavior.mat')
		positions = f.root.behavior.positions
		speed = f.root.behavior.speed
		position_time = f.root.behavior.position_time
		positions = np.swapaxes(positions[:,:],1,0)
		speed = np.swapaxes(speed[:,:],1,0)
		position_time = np.swapaxes(position_time[:,:],1,0)

		start_time = f.root.behavior.trainEpochs[:,0]
		stop_time = f.root.behavior.trainEpochs[:,1]
		end_time = f.root.behavior.testEpochs[:,1]
		if bandwidth == None:
			bandwidth = (np.max(positions) - np.min(positions))/20
		learning_time = stop_time - start_time

	### GLOBAL OCCUPATION

	selected_positions = positions[reduce(np.intersect1d,
		(np.where(speed[:,0] > speed_cut),
		np.where(position_time[:,0] > start_time),
		np.where(position_time[:,0] < stop_time)))]
	xEdges, yEdges, Occupation = butils.kde2D(selected_positions[:,0], selected_positions[:,1], bandwidth, kernel=kernel)
	Occupation[Occupation==0] = np.min(Occupation[Occupation!=0])  # We want to avoid having zeros

	mask = Occupation > (np.max(Occupation)/masking_factor)
	Occupation_inverse = 1/Occupation
	Occupation_inverse[Occupation_inverse==np.inf] = 0
	Occupation_inverse = np.multiply(Occupation_inverse, mask)

	tetrode_names = [keys for keys in list_channels.keys()]
	for tetrode in tetrode_names:
		if os.path.isfile(clu_path + 'clu.' + str(tetrode)):
			with open(
					clu_path + 'clu.' + str(tetrode), 'r') as fClu, open(
					clu_path + 'res.' + str(tetrode), 'r') as fRes, open(
					clu_path + 'spk.' + str(tetrode), 'rb') as fSpk:
				clu_str = fClu.readlines()
				res_str = fRes.readlines()
				n_clu = int(clu_str[0])-1
				n_channels = len(list_channels[tetrode])
				spikeReader = struct.iter_unpack(str(32*n_channels)+'h', fSpk.read())

				# labels = np.array([[1. if int(clu_str[n+1])-1==l else 0. for l in range(n_clu)] for n in range(len(clu_str)-1) if (int(clu_str[n+1])!=0)])
				# spike_time = np.array([[float(res_str[n])/samplingRate] for n in range(len(clu_str)-1) if (int(clu_str[n+1])!=0)])
				labels          = np.array([[1. if int(clu_str[n+1])==l else 0. for l in range(n_clu+1)] for n in range(len(clu_str)-1)])
				spike_time      = np.array([[float(res_str[n])/samplingRate] for n in range(len(clu_str)-1)])
				spike_positions = np.array([positions[np.argmin(np.abs(spike_time[n]-position_time)),:] for n in range(len(spike_time))])
				spike_speed     = np.array([speed[np.min((np.argmin(np.abs(spike_time[n]-position_time)), len(speed)-1)),:] for n in range(len(spike_time))])
		else:
			print("File "+ clu_path + 'clu.' + str(tetrode) +" not found.")
		continue
		sys.stdout.write('File from tetrode ' + str(tetrode) + ' has been succesfully opened. ')
		sys.stdout.write('Processing ...')
		sys.stdout.write('\r')
		sys.stdout.flush()
		labels = butils.modify_labels(labels,cluster_modifier)

		fake_labels_time.append(spike_time[reduce(np.intersect1d,
			(np.where(spike_time[:,0] > stop_time),
			np.where(spike_time[:,0] < end_time),
			np.where(spike_speed[:,0] > speed_cut)))])
		fake_labels.append(butils.shuffle_labels(labels[reduce(np.intersect1d,
			(np.where(spike_time[:,0] > stop_time),
			np.where(spike_time[:,0] < end_time),
			np.where(spike_speed[:,0] > speed_cut)))], rand_param))

		### MARGINAL RATE FUNCTION

		selected_positions = spike_positions[reduce(np.intersect1d,
			(np.where(spike_speed[:,0] > speed_cut),
			np.where(spike_time[:,0] > start_time),
			np.where(spike_time[:,0] < stop_time)))]
		xEdges, yEdges, MRF = butils.kde2D(selected_positions[:,0], selected_positions[:,1], bandwidth, edges=[xEdges,yEdges], kernel=kernel)
		MRF[MRF==0] = np.min(MRF[MRF!=0])
		MRF         = MRF/np.sum(MRF)
		MRF         = np.shape(selected_positions)[0]*np.multiply(MRF, Occupation_inverse)/learning_time
		Marginal_rate_functions.append(MRF)

		### LOCAL RATE FUNCTION FOR EACH CLUSTER
		Local_rate_functions = []

		for label in range(np.shape(labels)[1]):
			selected_positions = spike_positions[reduce(np.intersect1d,
				(np.where(spike_speed[:,0] > speed_cut),
				np.where(labels[:,label] == 1),
				np.where(spike_time[:,0] > start_time),
				np.where(spike_time[:,0] < stop_time)))]
			if np.shape(selected_positions)[0]!=0:
				xEdges, yEdges, LRF =  butils.kde2D(selected_positions[:,0], selected_positions[:,1], bandwidth, edges=[xEdges,yEdges], kernel=kernel)
				LRF[LRF==0] = np.min(LRF[LRF!=0])
				LRF         = LRF/np.sum(LRF)
				LRF         = np.shape(selected_positions)[0]*np.multiply(LRF, Occupation_inverse)/learning_time
				Local_rate_functions.append(LRF)
			else:
				Local_rate_functions.append(np.ones(np.shape(Occupation)))

		Rate_functions.append(Local_rate_functions)

		sys.stdout.write('We have finished building rates for group ' + str(tetrode) + ', loading next                           ')
		sys.stdout.write('\r')
		sys.stdout.flush()
	sys.stdout.write('We have finished building rates.                                                           ')
	sys.stdout.write('\r')
	sys.stdout.flush()
	return {'Occupation':Occupation, 'Marginal rate functions':Marginal_rate_functions, 'Rate functions':Rate_functions, 'Bins':[xEdges[:,0],yEdges[0,:]], 
				'fake_labels_info': {'clusters':fake_labels, 'time':fake_labels_time}, 'time_limits': [start_time, stop_time]}





# %%

def DecodeBayes(bin_time, guessed_clusters_info, bayes_matrices, time_limits, **keyword_parameters):
	masking_factor       = keyword_parameters.get('masking_factor',    20)
	start_time           = keyword_parameters.get('start_time',        0)
	stop_time            = keyword_parameters.get('stop_time',         None)

	### Format matrices
	space_bins = [np.array((bayes_matrices['Bins'][0][b],bayes_matrices['Bins'][1][b])) for b in range(np.shape(bayes_matrices['Bins'][0])[0])]
	Occupation, Marginal_rate_functions, Rate_functions = [bayes_matrices[key] for key in ['Occupation','Marginal rate functions','Rate functions']]
	guessed_clusters, guessed_clusters_time = [guessed_clusters_info[key] for key in ['clusters','time']]
	mask = Occupation > (np.max(Occupation)/masking_factor)



	n_bins = math.floor((stop_time - start_time)/bin_time)
	All_Poisson_term = [np.exp( (-bin_time)*Marginal_rate_functions[tetrode] ) for tetrode in range(np.shape(guessed_clusters)[0])]
	All_Poisson_term = reduce(np.multiply, All_Poisson_term)

	log_RF = []
	for tetrode in range(np.shape(Rate_functions)[0]):
		temp = []
		for cluster in range(np.shape(Rate_functions[tetrode])[0]):
			temp.append(np.log(Rate_functions[tetrode][cluster] + np.min(Rate_functions[tetrode][cluster][Rate_functions[tetrode][cluster]!=0])))
		log_RF.append(temp)




	### Decoding loop
	position_proba = [np.ones(np.shape(Occupation))] * n_bins
	position_true = [np.ones(2)] * n_bins
	nSpikes = []
	for bin in range(n_bins):

		bin_start_time = start_time + bin*bin_time
		bin_stop_time = bin_start_time + bin_time

		binSpikes = 0
		tetrodes_contributions = []
		tetrodes_contributions.append(All_Poisson_term)

		for tetrode in range(np.shape(guessed_clusters)[0]):

			# Clusters inside our window
			bin_probas = guessed_clusters[tetrode][np.intersect1d(
				np.where(guessed_clusters_time[tetrode][:,0] > bin_start_time), 
				np.where(guessed_clusters_time[tetrode][:,0] < bin_stop_time))]
			bin_clusters = np.sum(bin_probas, 0)
			binSpikes = binSpikes + np.sum(bin_clusters)


			# Terms that come from spike information (with normalization)
			if np.sum(bin_clusters) > 0.5:
				place_maps = reduce(np.multiply, 
					# [np.power( Rate_functions[tetrode][cluster] , bin_clusters[cluster] ) 
					# for cluster in range(np.shape(bin_clusters)[0])])
					[butils.exp256( (log_RF[tetrode][cluster] * bin_clusters[cluster]) )
					for cluster in range(np.shape(bin_clusters)[0])])


				spike_pattern = math.pow(bin_time, np.sum(bin_clusters)) * place_maps
			else:
				spike_pattern = np.multiply(np.ones(np.shape(Occupation)), mask)

			tetrodes_contributions.append( spike_pattern )#/np.sum(spike_pattern) )

		nSpikes.append(binSpikes)

		position_proba[bin] = reduce( np.multiply, tetrodes_contributions )
		position_proba[bin] = position_proba[bin] / np.sum(position_proba[bin])

		if bin % (n_bins//20) == 0:
			print('Looking good. Already finished '+str(bin)+' out of '+str(n_bins)+' : %.3f %%' % (bin*100/n_bins))

	return position_proba