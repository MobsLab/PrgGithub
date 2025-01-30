#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  7 14:43:01 2024

@author: gruffalo
"""

# %% Set working directory
import os
# os.chdir(r'/home/gruffalo/Dropbox/Mobs_member/EllaCallas/ADA_project/submitted')
os.chdir(r'/home/gruffalo/Documents/Python/projects/data_Sophie/')

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
    combine_dataframes_on_timebins
    )
from preprocess_ln_model import (
    calculate_amplitude_thresholds,
    generate_variable_shift_combinations
    )
from model_ln_regression import (
    ln_grid_cv
    )
from plot_results_ln_model import (
    plot_interpolated_coefficients
    )

# %% Load data

# Load data and needed modules
all_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/alldata'
maze_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/justmaze'
figures_directory = r'/home/gruffalo/Documents/Python/projects/data_Sophie/figures'

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
new_bin_size = 0.6
all_rebinned_data = rebin_mice_data(all_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'LinPos'], new_bin_size)
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)

# Compute spike counts
spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)


# %% LN model 

# Preprocess data for a given mouse
mouse_id = 'Mouse508'
model_all_df = combine_dataframes_on_timebins(spike_counts[mouse_id], maze_rebinned_data[mouse_id])

# Chose a given neuron
dependent_var = 'Neuron_16'

# Set threshold values
# threshold_values = [0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1]

percentages = [0, 0.001, 0.002, 0.003, 0.005, 0.01, 0.02, 0.03, 0.04, 0.05]
threshold_values = calculate_amplitude_thresholds(model_all_df, dependent_var, percentages)


# %% Motion variables

independent_vars = ['LinPos', 'Speed', 'Accelero']
variables_shifts = generate_variable_shift_combinations(independent_vars, {})

# Run the LN model with grid search and cross-validation
resultsmotion = ln_grid_cv(
    data=model_all_df,
    dependent_var=dependent_var,
    independent_vars=independent_vars,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts,
    intercept_options=[True, False],
    k=5
)


# %% Heartrate

independent_vars = ['Heartrate']
variables_shifts = generate_variable_shift_combinations(independent_vars, {'Heartrate': 5})

# Run the LN model with grid search and cross-validation
resultsHR = ln_grid_cv(
    data=model_all_df,
    dependent_var=dependent_var,
    independent_vars=independent_vars,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts,
    intercept_options=[True, False],
    k=5
)


plot_interpolated_coefficients(resultsHR['coefficients_with_names'],
                               'Heartrate', interpolation_kind='cubic')


# %% Heartrate + motion variables

independent_vars = ['Heartrate', 'LinPos', 'Speed', 'Accelero']
variables_shifts = generate_variable_shift_combinations(independent_vars, {'Heartrate': 5})

# Run the LN model with grid search and cross-validation
resultsHRmotion = ln_grid_cv(
    data=model_all_df,
    dependent_var=dependent_var,
    independent_vars=independent_vars,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts,
    intercept_options=[True, False],
    k=5
)

plot_interpolated_coefficients(resultsHRmotion['coefficients_with_names'], 
                               'Heartrate', interpolation_kind='cubic')


# %% Breathing rate

independent_vars = ['BreathFreq']
variables_shifts = generate_variable_shift_combinations(independent_vars, {'BreathFreq': 5})

# Run the LN model with grid search and cross-validation
resultsBF = ln_grid_cv(
    data=model_all_df,
    dependent_var=dependent_var,
    independent_vars=independent_vars,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts,
    intercept_options=[True, False],
    k=5
)


plot_interpolated_coefficients(resultsBF['coefficients_with_names'],
                               'BreathFreq', interpolation_kind='cubic')


# %% Breathing rate + motion variables

independent_vars = ['BreathFreq', 'LinPos', 'Speed', 'Accelero']
variables_shifts = generate_variable_shift_combinations(independent_vars, {'BreathFreq': 5})

# Run the LN model with grid search and cross-validation
resultsBFmotion = ln_grid_cv(
    data=model_all_df,
    dependent_var=dependent_var,
    independent_vars=independent_vars,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts,
    intercept_options=[True, False],
    k=5
)

plot_interpolated_coefficients(resultsBFmotion['coefficients_with_names'], 
                               'BreathFreq', interpolation_kind='cubic')


# %% All variables

independent_vars = ['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero']
variables_shifts = generate_variable_shift_combinations(independent_vars, {'BreathFreq': 5, 'Heartrate': 5})

# Run the LN model with grid search and cross-validation
resultsall = ln_grid_cv(
    data=model_all_df,
    dependent_var=dependent_var,
    independent_vars=independent_vars,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts,
    intercept_options=[True, False],
    k=5
)


plot_interpolated_coefficients(resultsall['coefficients_with_names'], 
                               'Heartrate', interpolation_kind='cubic')


plot_interpolated_coefficients(resultsall['coefficients_with_names'], 
                               'BreathFreq', interpolation_kind='cubic')

















