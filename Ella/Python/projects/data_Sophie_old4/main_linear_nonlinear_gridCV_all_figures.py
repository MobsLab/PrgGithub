#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  7 14:43:01 2024

@author: gruffalo
"""

# %% Set working directory
import os
os.chdir(r'/home/gruffalo/Documents/Python/projects/data_Sophie/')

# Import necessary packages and modules
from load_data import load_dataframes
from preprocess_sort_data import (
    denoise_mice_data,
    create_sorted_column_replace_zeros,
    rebin_mice_data
    )
from analyse_data import (
    spike_count_all_mice,
    )
from preprocess_linear_model import (
    combine_dataframes_on_timebins
    )
from preprocess_ln_model import (
    zscore_columns,
    calculate_amplitude_thresholds,
    generate_variable_shift_combinations,
    extract_random_bouts
    )
from model_ln_regression import (
    ln_grid_cv
    )
from plot_recap_linear_nonlinear_model import (
    plot_spike_rate_histogram,
    plot_neuron_tuning_curve,
    plot_r2_values,
    plot_coefficients,
    plot_interpolated_coefficients,
    plot_predictions,
    create_recapitulatory_figure,
    create_visualization_figure
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

# Chose a given neuron
mouse_id = 'Mouse508'
dependent_var = 'Neuron_16'

# Preprocess data for a given mouse
maze_rebinned_normalized_data = zscore_columns(maze_rebinned_data[mouse_id], ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'])
model_all_df = combine_dataframes_on_timebins(spike_counts[mouse_id], maze_rebinned_normalized_data)

# Split the data 
data = model_all_df
train_data, test_data = extract_random_bouts(data, bout_length=10, percent=10, random_state=42)

# Set threshold values
# threshold_values = [0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1]

percentages = [0, 0.001, 0.002, 0.003, 0.005, 0.01, 0.02, 0.03, 0.04, 0.05]
threshold_values = calculate_amplitude_thresholds(model_all_df, dependent_var, percentages)


# %% Dependent variable

plot_spike_rate_histogram(
    spike_counts,
    mouse_id=mouse_id, 
    neurons=[dependent_var], 
    bins=25)


# Tuning curve of a neuron
# Breathing Frequency
plot_neuron_tuning_curve(
    mice_data=maze_rebinned_data, 
    mouse_id=mouse_id, 
    spike_times_data=maze_spike_times_data, 
    variable='Heartrate', 
    neuron_key=dependent_var,
    interval_step=0.3, 
    min_value=8, 
    max_value=13
    )


# Heart rate
plot_neuron_tuning_curve(
    mice_data=maze_rebinned_data, 
    mouse_id=mouse_id, 
    spike_times_data=maze_spike_times_data, 
    variable='BreathFreq', 
    neuron_key=dependent_var,
    interval_step=0.3, 
    min_value=2.5, 
    max_value=11
    )


# %% Motion variables

independent_vars_motion = ['LinPos', 'Speed', 'Accelero']
variables_shifts_motion = generate_variable_shift_combinations(independent_vars_motion, {})

# Run the LN model with grid search and cross-validation
resultsmotion = ln_grid_cv(
    data=train_data,
    dependent_var=dependent_var,
    independent_vars=independent_vars_motion,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts_motion,
    intercept_options=[True, False],
    k=5
)

plot_coefficients(resultsmotion)

# Plot the predictions on the test data
plot_predictions(test_data, 
                 resultsmotion, 
                 independent_vars=independent_vars_motion, 
                 dependent_var=dependent_var,
                 variables_shifts=resultsmotion['best_shift_config'])


# %% Heartrate

independent_vars_HR = ['Heartrate']
variables_shifts_HR = generate_variable_shift_combinations(independent_vars_HR, {'Heartrate': 5})

# Run the LN model with grid search and cross-validation
resultsHR = ln_grid_cv(
    data=train_data,
    dependent_var=dependent_var,
    independent_vars=independent_vars_HR,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts_HR,
    intercept_options=[True, False],
    k=5
)


plot_interpolated_coefficients(resultsHR['coefficients_with_names'],
                               'Heartrate', interpolation_kind='cubic')

# Plot the predictions on the test data
plot_predictions(test_data, 
                 resultsHR, 
                 independent_vars=independent_vars_HR, 
                 dependent_var=dependent_var,
                 variables_shifts=resultsHR['best_shift_config'])


# %% Heartrate + motion variables

independent_vars_HRmotion = ['Heartrate', 'LinPos', 'Speed', 'Accelero']
variables_shifts_HRmotion = generate_variable_shift_combinations(independent_vars_HRmotion, {'Heartrate': 5})

# Run the LN model with grid search and cross-validation
resultsHRmotion = ln_grid_cv(
    data=train_data,
    dependent_var=dependent_var,
    independent_vars=independent_vars_HRmotion,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts_HRmotion,
    intercept_options=[True, False],
    k=5
)

plot_interpolated_coefficients(resultsHRmotion['coefficients_with_names'], 
                               'Heartrate', interpolation_kind='cubic')


# Plot the predictions on the test data
plot_predictions(test_data, 
                 resultsHRmotion, 
                 independent_vars=independent_vars_HRmotion, 
                 dependent_var=dependent_var,
                 variables_shifts=resultsHRmotion['best_shift_config'])


# %% Breathing rate

independent_vars_BF = ['BreathFreq']
variables_shifts_BF = generate_variable_shift_combinations(independent_vars_BF, {'BreathFreq': 5})

# Run the LN model with grid search and cross-validation
resultsBF = ln_grid_cv(
    data=train_data,
    dependent_var=dependent_var,
    independent_vars=independent_vars_BF,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts_BF,
    intercept_options=[True, False],
    k=5
)


plot_interpolated_coefficients(resultsBF['coefficients_with_names'],
                               'BreathFreq', interpolation_kind='cubic')

# Plot the predictions on the test data
plot_predictions(test_data, 
                 resultsBF, 
                 independent_vars=independent_vars_BF, 
                 dependent_var=dependent_var,
                 variables_shifts=resultsBF['best_shift_config'])



# %% Breathing rate + motion variables

independent_vars_BFmotion = ['BreathFreq', 'LinPos', 'Speed', 'Accelero']
variables_shifts_BFmotion = generate_variable_shift_combinations(independent_vars_BFmotion, {'BreathFreq': 5})

# Run the LN model with grid search and cross-validation
resultsBFmotion = ln_grid_cv(
    data=train_data,
    dependent_var=dependent_var,
    independent_vars=independent_vars_BFmotion,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts_BFmotion,
    intercept_options=[True, False],
    k=5
)

plot_interpolated_coefficients(resultsBFmotion['coefficients_with_names'], 
                               'BreathFreq', interpolation_kind='cubic')

# Plot the predictions on the test data
plot_predictions(test_data, 
                 resultsBFmotion, 
                 independent_vars=independent_vars_BFmotion, 
                 dependent_var=dependent_var,
                 variables_shifts=resultsBFmotion['best_shift_config'])


# %% All variables

independent_vars_all = ['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero']
variables_shifts_all = generate_variable_shift_combinations(independent_vars_all, {'BreathFreq': 5, 'Heartrate': 5})

# Run the LN model with grid search and cross-validation
resultsall = ln_grid_cv(
    data=train_data,
    dependent_var=dependent_var,
    independent_vars=independent_vars_all,
    threshold_values=threshold_values,
    variables_shifts=variables_shifts_all,
    intercept_options=[True, False],
    k=5
)


plot_interpolated_coefficients(resultsall['coefficients_with_names'], 
                               'Heartrate', interpolation_kind='cubic')


plot_interpolated_coefficients(resultsall['coefficients_with_names'], 
                               'BreathFreq', interpolation_kind='cubic')

# Plot the predictions on the test data
plot_predictions(test_data, 
                 resultsall, 
                 independent_vars=independent_vars_all, 
                 dependent_var=dependent_var,
                 variables_shifts=resultsall['best_shift_config'])

# Summarize the R2 results
results_list = [resultsmotion, resultsBF, resultsBFmotion, resultsHR, resultsHRmotion, resultsall]

model_names = ['Motion', 'BF', 'BF+Motion', 'HR', 'HR+Motion', 'All']

plot_r2_values(results_list, model_names)


# %% Recap figure


create_recapitulatory_figure(
    mouse_id=mouse_id,
    dependent_var=dependent_var,
    spike_count_dict=spike_counts,
    maze_rebinned_data=maze_rebinned_data,
    maze_spike_times_data=maze_spike_times_data,
    test_data=test_data,
    resultsmotion=resultsmotion,
    resultsHR=resultsHR,
    resultsHRmotion=resultsHRmotion,
    resultsBF=resultsBF,
    resultsBFmotion=resultsBFmotion,
    resultsall=resultsall,
    independent_vars_motion=independent_vars_motion,
    independent_vars_HR=independent_vars_HR,
    independent_vars_HRmotion=independent_vars_HRmotion,
    independent_vars_BF=independent_vars_BF,
    independent_vars_BFmotion=independent_vars_BFmotion,
    independent_vars_all=independent_vars_all,
    accelerometer_column="Accelero"
)


create_visualization_figure(
    data_predictions=data,
    data_variables=maze_rebinned_data[mouse_id],
    resultsmotion=resultsmotion,
    resultsHR=resultsHR,
    resultsHRmotion=resultsHRmotion,
    resultsBF=resultsBF,
    resultsBFmotion=resultsBFmotion,
    resultsall=resultsall,
    independent_vars_motion=independent_vars_motion,
    independent_vars_HR=independent_vars_HR,
    independent_vars_HRmotion=independent_vars_HRmotion,
    independent_vars_BF=independent_vars_BF,
    independent_vars_BFmotion=independent_vars_BFmotion,
    independent_vars_all=independent_vars_all,
    dependent_var=dependent_var
)













