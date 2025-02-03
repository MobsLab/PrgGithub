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
from plot_neural_data import (
    plot_scatter_neuron
    )
from preprocess_linear_model import (
    combine_dataframes_on_timebins,
    )
from plot_data_linear_model import (
    df_col_corr_heatmap
    )
from model_linear_regression_permutation import (
    cross_validate_multiple_neurons_permutation,
    cross_validate_neurons_per_mouse_permutation,
    filter_neurons_by_p_value_per_mouse,
    count_significant_neurons_per_model
    )
from plot_results_linear_model import (
    plot_combined_r2_distribution,
    plot_model_comparison_r2,
    plot_significant_neurons_proportion
    )
from perform_statistical_tests import (
    compare_r2_wilcoxon_all,
    compare_all_pairs_wilcoxon
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
new_bin_size = 1
all_rebinned_data = rebin_mice_data(all_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'LinPos'], new_bin_size)
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)


# %% Vizualize data before regression

spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)
plot_scatter_neuron(maze_rebinned_data['Mouse508']['Heartrate'].values, spike_counts['Mouse508']['Neuron_16'].values, 'Heartrate', title='Neuron 16 vs HR M508')

model_all_df = combine_dataframes_on_timebins(spike_counts['Mouse508'], maze_rebinned_data['Mouse508'])
df_col_corr_heatmap(model_all_df)


# %% Linear Regression with CV for all neurons of a given mouse

results = cross_validate_multiple_neurons_permutation(model_all_df, ['Heartrate'], k=5)

# Display the results
# for neuron, mean_r2 in results.items():
#     print(f"Neuron: {neuron}, Mean R-squared: {mean_r2}")

p_val_threshold = None
# filtered_results = filter_neurons_by_p_value_multiple(results, 
#                                                       p_value_threshold=p_val_threshold,
#                                                       correction=False,
#                                                       correction_method='fdr_bh')


# %% Linear Regression with CV for all neurons of multiple mice

# All the models (slow calculation)

results_HR = cross_validate_neurons_per_mouse_permutation(spike_counts, maze_rebinned_data, 
                                               ['Mouse507', 'Mouse508', 'Mouse509', 'Mouse510'], 
                                               ['Heartrate'], k=5)

results_BF = cross_validate_neurons_per_mouse_permutation(spike_counts, maze_rebinned_data, 
                                              ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                              ['BreathFreq'], k=5)

results_LP = cross_validate_neurons_per_mouse_permutation(spike_counts, maze_rebinned_data, 
                                              ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                              ['LinPos'], k=5)

results_SP = cross_validate_neurons_per_mouse_permutation(spike_counts, maze_rebinned_data, 
                                              ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                              ['Speed'], k=5)

results_AC = cross_validate_neurons_per_mouse_permutation(spike_counts, maze_rebinned_data, 
                                              ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                              ['Accelero'], k=5)

results_three_pred = cross_validate_neurons_per_mouse_permutation(spike_counts, maze_rebinned_data, 
                                                     ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                                     ['LinPos', 'Speed', 'Accelero'], k=5)

results_four_pred = cross_validate_neurons_per_mouse_permutation(spike_counts, maze_rebinned_data, 
                                                     ['Mouse490', 'Mouse507', 'Mouse508', 'Mouse509', 'Mouse510', 'Mouse512', 'Mouse514'], 
                                                     ['BreathFreq', 'LinPos', 'Speed', 'Accelero'], k=5)

results_five_pred = cross_validate_neurons_per_mouse_permutation(spike_counts, maze_rebinned_data, 
                                                     ['Mouse507', 'Mouse508', 'Mouse509', 'Mouse510'], 
                                                     ['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'], k=5)


# %%% Heart rate

p_val_threshold = None
filtered_results_HR = filter_neurons_by_p_value_per_mouse(results_HR, 
                                                          p_value_threshold=p_val_threshold,
                                                          correction=False, 
                                                          correction_method='bonferroni')

plot_combined_r2_distribution(filtered_results_HR, independent_vars=['Heartrate'], bins=35, color='purple', kde=True)


# %%% Breathing rate

filtered_results_BF = filter_neurons_by_p_value_per_mouse(results_BF, 
                                                          p_value_threshold=p_val_threshold,
                                                          correction=False, 
                                                          correction_method='bonferroni')

plot_combined_r2_distribution(filtered_results_BF, independent_vars=['BreathFreq'], bins=35, color='purple', kde=True)


# %%% Linearized position

filtered_results_LP = filter_neurons_by_p_value_per_mouse(results_LP, 
                                                          p_value_threshold=p_val_threshold,
                                                          correction=False, 
                                                          correction_method='bonferroni')

plot_combined_r2_distribution(filtered_results_LP, independent_vars=['LinPos'], bins=35, color='purple', kde=True)


# %%% Speed

filtered_results_SP = filter_neurons_by_p_value_per_mouse(results_SP, 
                                                          p_value_threshold=p_val_threshold,
                                                          correction=False, 
                                                          correction_method='bonferroni')

plot_combined_r2_distribution(filtered_results_SP, independent_vars=['Speed'], bins=35, color='purple', kde=True)


# %%% Accelerometer

filtered_results_AC = filter_neurons_by_p_value_per_mouse(results_AC, 
                                                          p_value_threshold=p_val_threshold,
                                                          correction=False, 
                                                          correction_method='bonferroni')

plot_combined_r2_distribution(filtered_results_AC, independent_vars=['Accelero'], bins=35, color='purple', kde=True)


# %%% 'LinPos', 'Speed', 'Accelero'

filtered_results_three = filter_neurons_by_p_value_per_mouse(results_three_pred, 
                                                          p_value_threshold=p_val_threshold,
                                                          correction=False, 
                                                          correction_method='bonferroni')

plot_combined_r2_distribution(filtered_results_three, independent_vars=['LinPos', 'Speed', 'Accelero'], bins=35, color='purple', kde=True)


# %%% 'BreathFreq', 'LinPos', 'Speed', 'Accelero'

filtered_results_four = filter_neurons_by_p_value_per_mouse(results_four_pred, 
                                                          p_value_threshold=p_val_threshold,
                                                          correction=False, 
                                                          correction_method='bonferroni')

plot_combined_r2_distribution(filtered_results_four, independent_vars=['BreathFreq', 'LinPos', 'Speed', 'Accelero'], bins=35, color='purple', kde=True)

# %%% 'Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'

filtered_results_five = filter_neurons_by_p_value_per_mouse(results_five_pred, 
                                                          p_value_threshold=p_val_threshold,
                                                          correction=False, 
                                                          correction_method='bonferroni')

plot_combined_r2_distribution(filtered_results_five, independent_vars=['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'], bins=35, color='purple', kde=True)


# %% Plot with all the results, no filtering of significance

models_r2_results = [filtered_results_HR, filtered_results_LP, filtered_results_BF,
                     filtered_results_SP, filtered_results_AC, filtered_results_three,
                     filtered_results_four, filtered_results_five]
model_labels = ['Heartrate', 'LinPos', 'BreathFreq', 'Speed', 'Accelero', 
                'LP + SP + AC', 'BF + LP + SP + AC', 'Full model']
model_comparison = plot_model_comparison_r2(models_r2_results, model_labels)

save_plot_as_svg(figures_directory, 'mean_R2_linear_model_all_neurons_v2', fig=model_comparison)


# %% Run statistical tests to compare the results between models

models_all_results = [results_HR, results_LP, results_BF,
                     results_SP, results_AC, results_three_pred,
                     results_four_pred, results_five_pred]

compare_r2_wilcoxon_all(results_HR, results_LP, showplot=True)


significant_pairs = compare_all_pairs_wilcoxon(models_all_results, model_labels, 
                                               alpha=0.05, correction=True, 
                                               correction_method='fdr_bh')


# %% Count the significant neurons for each model

significant_proportions = count_significant_neurons_per_model(models_all_results, model_labels, 
                                                              p_value_threshold=0.05, 
                                                              correction=True, correction_method='bonferroni')


neurons_proportion = plot_significant_neurons_proportion(models_all_results, model_labels, 
                                                         p_value_threshold=0.05, 
                                                         correction=True, correction_method='bonferroni')


save_plot_as_svg(figures_directory, 'proportion_significant_neurons_bonferroni_v2', fig=neurons_proportion)




















