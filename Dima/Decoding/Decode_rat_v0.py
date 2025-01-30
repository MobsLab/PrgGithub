# %% Import libraries
import sys
import os.path
import datetime
import tensorflow as tf
import numpy as np
from tqdm import tqdm
from tqdm import trange
import matplotlib as mpl
import matplotlib.pyplot as plt

# Import custom functions
import rawDataParser
import datasetMaker

# %% Argument handling
print(flush=True)
if len(sys.argv)>1 and sys.argv[1]=="gpu":
	device_name = "/gpu:0"
	print('MOBS FULL FLOW ENCODER: DEVICE GPU', flush=True)
elif len(sys.argv)==1 or sys.argv[1]=="cpu":
	device_name = "/cpu:0"
	print('MOBS FULL FLOW ENCODER: DEVICE CPU', flush=True)
else:
	raise ValueError('didn\'t understand arguments calling scripts '+sys.argv[0])

class xmlPath():
	def __init__(self, path):
		self.xml = path
		findFolder = lambda path: path if path[-1]=='/' or len(path)==0 else findFolder(path[:-1]) 
		self.folder = findFolder(self.xml)
		self.dat = path[:-3] + 'dat'
		self.fil = path[:-3] + 'fil'

projectPath = xmlPath(os.path.expanduser(sys.argv[2]))

# %% Folders to save
dir_graph = "graph"
dir_results = 'results'
timenow = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

# %% Data handling
### Data
if not os.path.isfile(projectPath.folder+'_rawSpikesForRnn.npz'):
	
	spikeDetector = rawDataParser.SpikeDetector(projectPath)

	allGroups = []
	allSpTime = []
	allSpikes = []
	allSpkPos = []
	allSpkSpd = []

	for spikes in spikeDetector.getSpikes():
		if len(spikes['time'])==0:
			continue
		for grp,time,spk,pos,spd in sorted(zip(spikes['group'],spikes['time'],spikes['spike'],spikes['position'],spikes['speed']), key=lambda x:x[1]):
			allGroups.append(grp)
			allSpTime.append(time)
			allSpikes.append(spk)
			allSpkPos.append(pos)
			allSpkSpd.append(spd)
		
	GRP_data = np.array(allGroups)
	SPT_data = np.array(allSpTime)
	SPK_data = np.array(allSpikes)
	POS_data = np.array(allSpkPos)
	SPD_data = np.array(allSpkSpd)
	print('data parsed.')


	SPT_train, SPT_test, GRP_train, GRP_test, SPK_train, SPK_test, POS_train, POS_test, SPD_train, SPD_test = train_test_split(
		SPT_data, GRP_data, SPK_data, POS_data, SPD_data, test_size=0.1, shuffle=False, random_state=42)
	np.savez(projectPath.folder + '_rawSpikesForRnn', 
		SPT_train, SPT_test, GRP_train, GRP_test, SPK_train, SPK_test, POS_train, POS_test, SPD_train, SPD_test)
else:
	try:
		print(loaded)
	except NameError:
		print('loading data')
		Results = np.load(projectPath.folder + '_rawSpikesForRnn.npz', allow_pickle=True)
		SPT_train = Results['arr_0']
		SPT_test = Results['arr_1']
		GRP_train = Results['arr_2']
		GRP_test = Results['arr_3']
		SPK_train = Results['arr_4']
		SPK_test = Results['arr_5']
		POS_train = Results['arr_6']
		POS_test = Results['arr_7']
		SPD_train = Results['arr_8']
		SPD_test = Results['arr_9']
		loaded='data loaded'
		print(loaded)

# %% Parameters
### Params
class Params:
	def __init__(self):
		self.nGroups = np.max(GRP_train) + 1
		self.dim_output = POS_train.shape[1]
		self.nChannels = SPK_train[0].shape[0]
		self.length = len(SPK_train)

		# self.nEpochs = 10
		self.windowLength = 0.036 # in seconds, as all things should be
		self.nSteps = int(10000 * 0.036 / self.windowLength)
		
		### from units encoder params
		self.validCluWindow = 0.0005
		self.kernel = 'epanechnikov'
		self.bandwidth = 0.1
		self.masking = 20
		
		self.nFeatures = 128
		self.lstmLayers = 3
		self.lstmSize = 128
		self.lstmDropout = 0.3

		self.batch_size = 52
		self.timeMajor = True

		self.learningRates = [0.0003, 0.00003, 0.00001]
		self.lossLearningRate = 0.00003
		self.lossActivation = None
  
		# Figure out what will be the maximum length of a spike sequence for our windowLength
		self.maxLength = max(self.getMaxLength(SPT_train), self.getMaxLength(SPT_test))

	def getMaxLength(self, data):
		maxLength = 0
		n = 0
		bin_stop = data[0]
		while True:
			bin_stop = bin_stop + self.windowLength
			if bin_stop > data[-1]:
				maxLength = max(maxLength, len(data)-idx)
				break
			idx=n
			while data[n] < bin_stop:
				n += 1
			maxLength = max(maxLength, n-idx)
		return maxLength

params = Params()


# %% Auxiliary functions and classes
def last_relevant(output, length, timeMajor=False):
	''' Used to select the right output of 
		tf.rnn.dynamic_rnn for sequences of variable sizes '''
	if timeMajor:
		output = tf.transpose(output, [1,0,2])
	batch_size = tf.shape(output)[0]
	max_length = tf.shape(output)[1]
	out_size = int(output.get_shape()[2])
	index = tf.nn.relu(tf.range(0, batch_size) * max_length + tf.cast(length - 1, tf.int32))
	flat = tf.reshape(output, [-1, out_size])
	relevant = tf.gather(flat, index)
	return relevant

# Layers of networks
def layerLSTM(lstmSize, dropout=0.0):
	cell = tf.contrib.rnn.LSTMBlockCell(lstmSize)
	return tf.nn.rnn_cell.DropoutWrapper(cell, input_keep_prob=1.0, output_keep_prob=1.0, state_keep_prob=1-dropout)

class spikeNet:
	def __init__(self, nChannels=4, device="/cpu:0", nFeatures=128):
		self.nFeatures = nFeatures
		self.nChannels = nChannels
		self.device = device
		with tf.device(self.device):
			self.convLayer1 = tf.layers.Conv2D(8, [2,3], padding='SAME')
			self.convLayer2 = tf.layers.Conv2D(16, [2,3], padding='SAME')
			self.convLayer3 = tf.layers.Conv2D(32, [2,3], padding='SAME')

			self.maxPoolLayer1 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')
			self.maxPoolLayer2 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')
			self.maxPoolLayer3 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')

			self.dropoutLayer = tf.layers.Dropout(0.5)
			self.denseLayer1 = tf.layers.Dense(self.nFeatures, activation='relu')
			self.denseLayer2 = tf.layers.Dense(self.nFeatures, activation='relu')
			self.denseLayer3 = tf.layers.Dense(self.nFeatures, activation='relu')

	def __call__(self, input):
		return self.apply(input)

	def apply(self, input):
		with tf.device(self.device):
			x = tf.expand_dims(input, axis=3)
			x = self.convLayer1(x)
			x = self.maxPoolLayer1(x)
			x = self.convLayer2(x)
			x = self.maxPoolLayer2(x)
			x = self.convLayer3(x)
			x = self.maxPoolLayer3(x)

			x = tf.reshape(x, [-1, self.nChannels*4*32])
			x = self.denseLayer1(x)
			x = self.dropoutLayer(x)
			x = self.denseLayer2(x)
			x = self.denseLayer3(x)
		return x

	def variables(self):
		return self.convLayer1.variables + self.convLayer2.variables + self.convLayer3.variables + \
			self.maxPoolLayer1.variables + self.maxPoolLayer2.variables + self.maxPoolLayer3.variables + \
			self.denseLayer1.variables + self.denseLayer2.variables + self.denseLayer3.variables

# %% Training model
with tf.Graph().as_default():

	print()
	print('TRAINING')

	dataIterator, trainingTensors, dataPlaceholders = datasetMaker.makeDataset(params, training=True)
	with tf.device(device_name):
		spkParserNet = []
		allFeatures = []

		# CNN plus dense on every group indepedently
		for group in range(params.nGroups):
			spkParserNet.append(spikeNet(nChannels=params.nChannels, device=device_name, nFeatures=params.nFeatures))

			x = spkParserNet[group].apply(trainingTensors[2*group+2])
			x = tf.reshape(tf.matmul(trainingTensors[2*group+3], x), [-1, params.batch_size, spkParserNet[group].nFeatures])
			# x = spkParserNet[group].apply(tf.tensordot(trainingTensors[2*group+3], trainingTensors[2*group+2], axes=[[1],[0]]))
			# x = tf.reshape(x, [-1, params.batch_size, spkParserNet[group].nFeatures])
			allFeatures.append( x )
		allFeatures = tf.tuple(allFeatures)
		allFeatures = tf.concat(allFeatures, axis=2)

		# LSTM on the concatenated outputs of previous graphs
		if device_name=="/gpu:0":
			lstm = tf.contrib.cudnn_rnn.CudnnLSTM(params.lstmLayers, params.lstmSize, dropout=params.lstmDropout)
			outputs, finalState = lstm(allFeatures, training=True)
		else:
			lstm = [layerLSTM(params.lstmSize, dropout=params.lstmDropout) for _ in range(params.lstmLayers)]
			lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
			outputs, finalState = tf.nn.dynamic_rnn(
				lstm, 
				allFeatures, 
				dtype=tf.float32, 
				time_major=params.timeMajor, 
				sequence_length=trainingTensors[1])

	# dense to extract regression on output and loss
	denseOutput = tf.layers.Dense(params.dim_output, activation = None, name="pos")
	denseLoss1  = tf.layers.Dense(params.lstmSize, activation = tf.nn.relu, name="loss1")
	denseLoss2  = tf.layers.Dense(1, activation = params.lossActivation, name="loss2")

	output = last_relevant(outputs, trainingTensors[1], timeMajor=params.timeMajor)
	outputLoss = denseLoss2(denseLoss1(output))[:,0]
	outputPos = denseOutput(output)

	lossPos =  tf.losses.mean_squared_error(outputPos, trainingTensors[0], reduction=tf.losses.Reduction.NONE)
	lossPos =  tf.reduce_mean(lossPos, axis=1)
	lossLoss = tf.losses.mean_squared_error(outputLoss, lossPos)
	lossPos  = tf.reduce_mean(lossPos)

	optimizers = []
	for lr in range(len(params.learningRates)):
		optimizers.append(tf.train.RMSPropOptimizer(params.learningRates[lr]).minimize(lossPos + lossLoss))
	saver = tf.train.Saver()



	### Training and testing
	trainLosses = []
	with tf.Session() as sess:

		# initialize variables and input framework
		sess.run(tf.group(tf.global_variables_initializer(), tf.local_variables_initializer()))
		sess.run(dataIterator.initializer, 
			feed_dict={dataPlaceholders['groups']:GRP_train, 
			dataPlaceholders['timeStamps']:SPT_train, 
			dataPlaceholders['spikes']:SPK_train, 
			dataPlaceholders['positions']:POS_train / np.max(POS_train)})

		### training
		epoch_loss = 0
		epoch_loss2 = 0
		loopSize = 50
		t = trange(params.nSteps, desc='Bar desc', leave=True)
		for i in t:

			for lr in range(len(params.learningRates)):
				if (i < (lr+1) * params.nSteps / len(params.learningRates)) and (i >= lr * params.nSteps / len(params.learningRates)):
					_, c, c2 = sess.run([optimizers[lr], lossPos, lossLoss])
					break
				if lr==len(params.learningRates)-1:
					print('not run:',i)
			t.set_description("loss: %f" % c)
			t.refresh()
			epoch_loss += c
			epoch_loss2 += c2
			
			if i%loopSize==0 and (i != 0):
				trainLosses.append(np.array([epoch_loss/loopSize, epoch_loss2/loopSize]))
				epoch_loss=0
				epoch_loss2=0

		saver.save(sess, os.path.join(projectPath.folder, dir_graph, timenow) + '/_graphForRnn')


# %% Back compatibility converting before inferring
variables = []
print("Cleaning graph.")
with tf.Graph().as_default(), tf.device("/cpu:0"):


	# one CNN network per group of electrode
	embeddings = []
	for group in range(params.nGroups):
		with tf.variable_scope("group"+str(group)+"-encoder"):
			x = tf.placeholder(tf.float32, shape=[None, params.nChannels, 32], name="x")
			realSpikes = tf.math.logical_not(tf.equal(tf.reduce_sum(x, [1,2]), tf.constant(0.)))
			nSpikesTot = tf.shape(x)[0]; idMatrix = tf.eye(nSpikesTot)
			completionTensor = tf.transpose(tf.gather(idMatrix, tf.where(realSpikes))[:,0,:], [1,0], name="completion")
			x = tf.boolean_mask(x, realSpikes)
		newSpikeNet = spikeNet(nChannels=params.nChannels, device="/cpu:0", nFeatures=params.nFeatures)
		x = newSpikeNet.apply(x)
		x = tf.matmul(completionTensor, x)

		embeddings.append(x)
		variables += newSpikeNet.variables()
	fullEmbedding = tf.concat(embeddings, axis=1)

	if sys.argv[1]=="gpu":
		with tf.variable_scope("cudnn_lstm"):
			lstm = tf.nn.rnn_cell.MultiRNNCell(
					[tf.contrib.cudnn_rnn.CudnnCompatibleLSTMCell(params.lstmSize) for _ in range(params.lstmLayers)])
	else:
		lstm = [layerLSTM(params.lstmSize, dropout=params.lstmDropout) for _ in range(params.lstmLayers)]
		lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
		outputs, finalState = tf.nn.dynamic_rnn(
			lstm, 
			tf.expand_dims(fullEmbedding, axis=1), 
			dtype=tf.float32, 
			time_major=params.timeMajor)
		variables += lstm.variables
 
	# Final position decoder
	output = tf.cond(tf.shape(outputs)[0]>0, lambda: outputs[-1,:,:], lambda: outputs)
	denseOutput = tf.layers.Dense(params.dim_output, activation = None, name="pos")
	denseLoss1  = tf.layers.Dense(params.lstmSize, activation = tf.nn.relu, name="loss1")
	denseLoss2  = tf.layers.Dense(1, activation = params.lossActivation, name="loss2")

	x = denseOutput(tf.reshape(output, [-1,params.lstmSize]))
	y = denseLoss2(denseLoss1(tf.reshape(output, [-1,params.lstmSize])))
	variables += denseOutput.variables
	variables += denseLoss1.variables
	variables += denseLoss2.variables

	with tf.variable_scope("bayesianDecoder"):
		position = tf.identity(tf.cond(tf.shape(outputs)[0]>0, lambda: tf.reshape(x, [2]), lambda: tf.constant([0,0], dtype=tf.float32)), name="positionGuessed")
		loss     = tf.identity(tf.cond(tf.shape(outputs)[0]>0, lambda: tf.reshape(y, [1]), lambda: tf.constant([0], dtype=tf.float32)), name="standardDeviation")
		fakeProba= tf.constant(np.zeros([45,45]), dtype=tf.float32, name="positionProba")		
	
	subGraphToRestore = tf.train.Saver({v.op.name: v for v in variables})

	### Converting
	graphToSave = tf.train.Saver()
	with tf.Session() as sess:
		saver.save(sess, os.path.join(projectPath.folder, dir_graph, timenow) + '/_graphForRnn')
		saver.save(sess, os.path.join(projectPath.folder, dir_graph, timenow) + '/_graphDecoder')

# %% Loading and inferring
print()
print("INFERRING")

tf.contrib.rnn
with tf.Graph().as_default(), tf.device("/cpu:0"):
	saver = tf.train.import_meta_graph(projectPath.folder + '_graphDecoder.meta')

	def getSpikes(bin, group):
		binStart = SPT_test[0] + bin*params.windowLength
		return SPK_test[
			np.logical_and(
				np.logical_and(SPT_test>binStart, SPT_test<binStart+params.windowLength),
				GRP_test==group)]
	def getSpikesWithBlanks(bin, group):
		binStart = SPT_test[0] + bin*params.windowLength
		spikes = SPK_test[np.logical_and(SPT_test>binStart, SPT_test<binStart+params.windowLength)]
		groups = GRP_test[np.logical_and(SPT_test>binStart, SPT_test<binStart+params.windowLength)]==group
		for spk in range(spikes.shape[0]):
			spikes[spk,:,:] *= groups[spk]
		return spikes

	with tf.Session() as sess:
		saver.save(sess, os.path.join(projectPath.folder, dir_graph, timenow) + '/_graphDecoder')

		testOutput = []
		for bin in trange(int((SPT_test[-1]-SPT_test[0])//params.windowLength)-1):
			testOutput.append(np.concatenate(
				sess.run(
					[tf.get_default_graph().get_tensor_by_name("bayesianDecoder/positionProba:0"), 
					tf.get_default_graph().get_tensor_by_name("bayesianDecoder/positionGuessed:0"), 
					 tf.get_default_graph().get_tensor_by_name("bayesianDecoder/standardDeviation:0")], 
					{tf.get_default_graph().get_tensor_by_name("group"+str(group)+"-encoder/x:0"):getSpikesWithBlanks(bin, group)
						for group in range(params.nGroups)}), 
				axis=0))

	testOutput = np.array(testOutput)

	pos = []
	spd = []
	n = 0
	bin_stop = SPT_test[0]
	while True:
		bin_stop = bin_stop + params.windowLength
		if bin_stop > SPT_test[-1]:
			break
		idx=n
		while SPT_test[n] < bin_stop:
			n += 1
		pos.append(np.mean(POS_test[idx:n,:], axis=0))
		spd.append(np.mean(SPD_test[idx:n,:]))
	pos.pop()
	spd.pop()
	pos = np.array(pos) / np.max(POS_train)
	spd = np.array(spd)

	fileName = os.path.join(projectPath.folder, dir_results, timenow) + '_resultsForRnn_temp'
	np.savez(os.path.expanduser(fileName), pos=pos, spd=spd, testOutput=testOutput, trainLosses=[])