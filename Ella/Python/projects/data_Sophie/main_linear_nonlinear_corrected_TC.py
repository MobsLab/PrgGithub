#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 15:44:46 2025

@author: gruffalo
"""

# %% Set working directory
# import os
# os.chdir(r'/home/gruffalo/PrgGithub/Ella/Python/projects/data_Sophie')

# import scipy.io
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
    # plot_predictions_trace,
    plot_tuning_curve,
    plot_tuning_curve_heatmap,
    plot_mean_correction
    )
from fit_linear_nonlinear_model import (
    process_neuron
    )
from save_plots import (
    save_plot_as_svg
    )

# %% Load data and results

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'
figures_directory = load_path + 'figures/corrected_TC'

maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')
maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')

# Rebin data
new_bin_size = 0.6
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)
maze_rebinned_normalized_data = normalize_data(maze_rebinned_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'])

# Compute spike counts
spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)

# results_ln_loaded = load_results(load_path + 'results_ln_model_rs30.pkl')
results_ln_loaded = load(load_path + 'all_results_ln_model_rs30.joblib')

combined_data = combine_mouse_data(spike_counts, 
                                   maze_rebinned_normalized_data, drop_na=True)

combined_data_raw = combine_mouse_data(spike_counts, maze_rebinned_data, drop_na=True)

# %% Compute the predictions on all the dataset

predicted = predict_all_neurons(results_ln_loaded, combined_data, ['motion'])

# plot_predictions_trace(predicted, 'Mouse508', 'Neuron_16', 'motion')

# %% Substract the predictions to correct the data

corrected_motion = correct_predictions(predicted, 'motion')

# %% Plot the original and corrected tuning curves

mouse_id = 'Mouse509'
neuron_id = 'Neuron_45'

import numpy as np
for i in range(1,np.shape(spike_counts[mouse_id])[1]):
   # I modified to plot the mean subtracter tuning curve to compare shapes
   neuron_id ='Neuron_{0}'.format(i)
   
   figHR = plot_tuning_curve(neuron_id, mouse_id, 'Heartrate', 
                     8, 13, 0.5, combined_data_raw, corrected_motion)
   
   figBF = plot_tuning_curve(neuron_id, mouse_id, 'BreathFreq', 
                     2.5, 11, 0.5, combined_data_raw, corrected_motion)

save_plot_as_svg(figures_directory, f'{mouse_id}_{neuron_id}', figHR)

   
# %% Plot heat maps of original and corrected tuning curves

figHR_tuning, HR_tuning = plot_tuning_curve_heatmap(
    mouse_list=['Mouse507', 'Mouse508', 'Mouse509', 'Mouse510'],
    physiological_var="Heartrate",
    min_val=8,
    max_val=13,
    step=0.5,
    combined_data=combined_data_raw,
    model_results=corrected_motion,
    model_types=['original', 'motion'],
    vmin=-2,
    vmax=2,
    smooth_sigma=0.5,
    global_zscore=False
)

figBF_tuning, BF_tuning = plot_tuning_curve_heatmap(
    mouse_list=['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'],
    physiological_var="BreathFreq",
    min_val=2.5,
    max_val=11,
    step=0.5,
    combined_data=combined_data_raw,
    model_results=corrected_motion,
    model_types=['original', 'motion'],
    vmin=-2,
    vmax=2,
    smooth_sigma=0.5,
    global_zscore=False
)

# scipy.io.savemat(os.path.join(load_path, "HR_tuning.mat"), HR_tuning)
# scipy.io.savemat(os.path.join(load_path, "BF_tuning.mat"), BF_tuning)

save_plot_as_svg(figures_directory, 'HR_tuning_smoothed', figHR_tuning)
save_plot_as_svg(figures_directory, 'BF_tuning_smoothed', figBF_tuning)


# %% Plot mean correction

BFmeancorr = plot_mean_correction(BF_tuning, 'BreathFreq', 2.5, 11.5, 0.5)
HRmeancorr = plot_mean_correction(HR_tuning, 'Heartrate', 8, 13, 0.5)

save_plot_as_svg(figures_directory, 'HR_mean_corr', HRmeancorr)
save_plot_as_svg(figures_directory, 'BF_mean_corr', BFmeancorr)

# %% Create a corrected combined dataframe 

corrected_combined_data = correct_combined_data(combined_data, corrected_motion)

res = process_neuron('Mouse490', 'Neuron_1', combined_data)





