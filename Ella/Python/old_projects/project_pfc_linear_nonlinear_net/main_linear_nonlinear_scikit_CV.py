#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  7 14:43:01 2024

@author: gruffalo
"""

# %%

# Set working directory
import os
# os.chdir(r'/home/gruffalo/Dropbox/Mobs_member/EllaCallas/ADA_project/submitted')
os.chdir(r'/home/gruffalo/Documents/Python/project_pfc_linear_nonlinear_net')

# Import necessary packages and modules
from load_data import load_dataframes
from preprocess_sort_data import (
    denoise_mice_data,
    create_sorted_column_replace_zeros,
    rebin_mice_data
    )
from analyse_data import (
    spike_count_all_mice
    )
from preprocess_linear_model import (
    combine_dataframes_on_timebins,
    )
from plot_data_linear_model import (
    df_col_corr_heatmap
    )


from model_ln_regression import (
    k_fold_cross_validation_sklearn,
    cross_validate_multiple_neurons,
    cross_validate_neurons_per_mouse
    )
from plot_results_ln_model import (
    plot_r2_distribution_multiple_neurons,
    plot_r2_distribution_per_mouse,
    plot_combined_r2_distribution,
    )

# %% Load data

# Load data and needed modules
all_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/alldata'
maze_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/justmaze'
figures_directory = r'/home/gruffalo/Documents/Python/project_pfc_linear_nonlinear_net/figures'

# Load variables and spike times for all mice during all recording sessions
all_mice_data, all_spike_times_data = load_dataframes(all_mat_directory)

# Load variables and spike times for all mice during the U-Maze session
maze_mice_data, maze_spike_times_data = load_dataframes(maze_mat_directory)

# %% Preprocess data

# Denoise data
all_denoised_data = denoise_mice_data(all_mice_data, ['BreathFreq', 'Heartrate', 'timebins', 'Accelero', 'LinPos'])
maze_denoised_data = denoise_mice_data(maze_mice_data, ['BreathFreq', 'Heartrate', 'timebins', 'Accelero', 'Speed', 'LinPos'])

# Scaling problems between sleep and UMaze
create_sorted_column_replace_zeros(all_denoised_data, 'Mouse514', 'Accelero', replace=True)
create_sorted_column_replace_zeros(maze_denoised_data, 'Mouse514', 'Accelero', replace=True)

# Rebin data
new_bin_size = 1
all_rebinned_data = rebin_mice_data(all_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'LinPos'], new_bin_size)
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)

# Compute spike counts
spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)

# %% Linear Regression with CV for a given neuron

# Data for mouse 508
model_all_df = combine_dataframes_on_timebins(spike_counts['Mouse508'], maze_rebinned_data['Mouse508'])
df_col_corr_heatmap(model_all_df)

dependent_var = 'Neuron_16'
independent_vars = ['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero']

# Call the function for K-Fold Cross Validation
mean_r2 = k_fold_cross_validation_sklearn(model_all_df, dependent_var, independent_vars, k=5)


# %% Linear Regression with CV for all neurons of a given mouse

results = cross_validate_multiple_neurons(model_all_df, ['Heartrate'], k=5)

# Display the results
# for neuron, mean_r2 in results.items():
#     print(f"Neuron: {neuron}, Mean R-squared: {mean_r2}")

plot_r2_distribution_multiple_neurons(results, independent_vars=['Heartrate'], bins=20, color='blue')


# %% Linear Regression with CV for all neurons of multiple mice

# Heart rate
results_HR = cross_validate_neurons_per_mouse(spike_counts, maze_rebinned_data, 
                                               ['Mouse507', 'Mouse508', 'Mouse509', 'Mouse510'], 
                                               ['Heartrate'], k=5)

# Display the results
# for mouse, neurons_r2 in results_HR.items():
#     print(f"Results for {mouse}:")
#     for neuron, mean_r2 in neurons_r2.items():
#         print(f"  Neuron: {neuron}, Mean R-squared: {mean_r2}")

plot_r2_distribution_per_mouse(results_HR, independent_vars=['Heartrate'], bins=25, color='blue', kde=True)
plot_combined_r2_distribution(results_HR, independent_vars=['Heartrate'], bins=35, color='purple', kde=True)

# Breathing rate
results_BF = cross_validate_neurons_per_mouse(spike_counts, maze_rebinned_data, 
                                              ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                              ['BreathFreq'], k=5)

# plot_r2_distribution_per_mouse(results_BF, independent_vars=['BreathFreq'], bins=25, color='blue', kde=True)
plot_combined_r2_distribution(results_BF, independent_vars=['BreathFreq'], bins=35, color='purple', kde=True)

# Linearized position
results_LP = cross_validate_neurons_per_mouse(spike_counts, maze_rebinned_data, 
                                              ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                              ['LinPos'], k=5)

# plot_r2_distribution_per_mouse(results_LP, independent_vars=['LinPos'], bins=25, color='blue', kde=True)
plot_combined_r2_distribution(results_LP, independent_vars=['LinPos'], bins=35, color='purple', kde=True)

# Speed
results_SP = cross_validate_neurons_per_mouse(spike_counts, maze_rebinned_data, 
                                              ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                              ['Speed'], k=5)

# plot_r2_distribution_per_mouse(results_SP, independent_vars=['Speed'], bins=25, color='blue', kde=True)
plot_combined_r2_distribution(results_SP, independent_vars=['Speed'], bins=35, color='purple', kde=True)

# Accelerometer
results_AC = cross_validate_neurons_per_mouse(spike_counts, maze_rebinned_data, 
                                              ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                              ['Accelero'], k=5)

# plot_r2_distribution_per_mouse(results_AC, independent_vars=['Accelero'], bins=25, color='blue', kde=True)
plot_combined_r2_distribution(results_AC, independent_vars=['Accelero'], bins=35, color='purple', kde=True)


# 'BreathFreq', 'LinPos', 'Speed', 'Accelero'

results_four_pred = cross_validate_neurons_per_mouse(spike_counts, maze_rebinned_data, 
                                                     ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                                     ['BreathFreq', 'LinPos', 'Speed', 'Accelero'], k=5)

# plot_r2_distribution_per_mouse(results_four_pred, independent_vars=['BreathFreq', 'LinPos', 'Speed', 'Accelero'], bins=25, color='blue', kde=True)
plot_combined_r2_distribution(results_four_pred, independent_vars=['BreathFreq', 'LinPos', 'Speed', 'Accelero'], bins=35, color='purple', kde=True)

# 'Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'

results_five_pred = cross_validate_neurons_per_mouse(spike_counts, maze_rebinned_data, 
                                                     ['Mouse507', 'Mouse508', 'Mouse509', 'Mouse510'], 
                                                     ['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'], k=5)

# plot_r2_distribution_per_mouse(results_five_pred, independent_vars=['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'], bins=25, color='blue', kde=True)
plot_combined_r2_distribution(results_five_pred, independent_vars=['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'], bins=35, color='purple', kde=True)










