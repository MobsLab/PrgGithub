#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 15:44:46 2025

@author: gruffalo
"""

# %% Set working directory
# import os
# os.chdir(r'/home/gruffalo/PrgGithub/Ella/Python/projects/data_Sophie')

from load_save_results import ( 
    load_results
    )
from joblib import load
from preprocess_sort_data import (
    rebin_mice_data,
    normalize_data
    )
from analyse_data import (
    spike_count_all_mice,
    )
from preprocess_linear_model import (
    combine_mouse_data
    )
from analyse_ln_corrected_TC import (
    predict_all_neurons,
    correct_predictions,
    correct_combined_data
    )
from plot_ln_corrected_TC import (
    plot_predictions_trace,
    plot_tuning_curve
    )

# %% Load data and results

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'

maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')
maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')

# Rebin data
new_bin_size = 0.6
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)
maze_rebinned_normalized_data = normalize_data(maze_rebinned_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'])

# Compute spike counts
spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)

# results_ln_loaded = load_results(load_path + 'results_ln_model.pkl')
results_ln_loaded = load(load_path + 'results_ln_model_rs30.joblib')

combined_data = combine_mouse_data(spike_counts, 
                                   maze_rebinned_normalized_data, drop_na=True)

combined_data_raw = combine_mouse_data(spike_counts, maze_rebinned_data, drop_na=True)

# %% Compute the predictions on all the dataset

predicted = predict_all_neurons(results_ln_loaded, combined_data, ['motion'])

plot_predictions_trace(predicted, 'Mouse508', 'Neuron_16', 'motion')

# %% Substract the predictions to correct the data

corrected_motion = correct_predictions(predicted, 'motion')

# %% Plot the original and corrected tuning curves

mouse_id = 'Mouse508'

import numpy as np
for i in range(1,np.shape(spike_counts[mouse_id])[1]):
   # I modified to plot the mean subtracter tuning curve to compare shapes
   neuron_id ='Neuron_{0}'.format(i)
   
   plot_tuning_curve(neuron_id, mouse_id, 'Heartrate', 
                     8, 13, 0.3, combined_data_raw, corrected_motion)
   
   plot_tuning_curve(neuron_id, mouse_id, 'BreathFreq', 
                     2.5, 11, 0.3, combined_data_raw, corrected_motion)


# %% Create a corrected combined dataframe 

corrected_combined_data = correct_combined_data(combined_data, corrected_motion)







