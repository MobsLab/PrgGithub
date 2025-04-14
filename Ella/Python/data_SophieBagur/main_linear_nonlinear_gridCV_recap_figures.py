#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 27 12:27:14 2024

@author: gruffalo
"""

# %% Set working directory
import os
os.chdir(r'/home/gruffalo/PrgGithub/Ella/Python/data_SophieBagur')

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
    create_recapitulatory_figure,
    create_visualization_figure
    )
from save_plots import save_plot_as_svg

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
# train_data, test_data = extract_random_bouts(data, bout_length=10, percent=10, random_state=22)
train_data, test_data = extract_random_bouts(data, bout_length=10, percent=10, random_state=30)

# Set threshold values
# threshold_values = [0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1]

percentages = [0, 0.001, 0.002, 0.003, 0.005, 0.01, 0.02, 0.03, 0.04, 0.05]
threshold_values = calculate_amplitude_thresholds(model_all_df, dependent_var, percentages)


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


# Summarize the R2 results
results_list = [resultsmotion, resultsBF, resultsBFmotion, resultsHR, resultsHRmotion, resultsall]

model_names = ['Motion', 'BF', 'BF+Motion', 'HR', 'HR+Motion', 'All']


# %% Recap figure


recap_fig = create_recapitulatory_figure(
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
            variable_column="Accelero"
)

# save_plot_as_svg(figures_directory + '/ln_recap_figures', 
#                  f'241127_{dependent_var}_ln_recap_figure',
#                  fig=recap_fig)


visu_fig =  create_visualization_figure(
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

# save_plot_as_svg(figures_directory + '/ln_recap_figures', 
#                  f'241127_{dependent_var}_ln_visualize_figure',
#                  fig=visu_fig)