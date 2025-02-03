#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  3 16:34:39 2024

@author: gruffalo
"""

# %% Set working directory
import os
os.chdir(r'/home/gruffalo/Documents/Python/projects/data_Sophie/')

from load_save_results import ( 
    load_results
    )
from joblib import load
from preprocess_sort_data import (
    rebin_mice_data
    )
from analyse_data import (
    spike_count_all_mice,
    )
from plot_results_linear_nonlinear_model import (
    extract_r2_values,
    plot_r2_means_sem,
    plot_mean_firing_rate_vs_r2,
    plot_r2_comparison
    )
from analyse_ln_results import (
    filter_neurons_by_mean_firing_rate
    )

# %% Load data

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'

maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')
maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')

# Rebin data
new_bin_size = 0.6
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)

# Compute spike counts
spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)


# %% Load results

# results_ln_loaded = load_results(load_path + 'results_ln_model.pkl')
results_ln_loaded = load(load_path + 'results_ln_model_rs30.joblib')


# %% R2

r2_dataframe = extract_r2_values(results_ln_loaded)

plot_r2_means_sem(results_ln_loaded, r2_type='train')
plot_r2_means_sem(results_ln_loaded, r2_type='test')
# plot_r2_means_sem(results_ln_loaded_bis, r2_type='test')


plot_mean_firing_rate_vs_r2(results_ln_loaded, spike_counts, separate_subplots=False, r2_type='train')

plot_r2_comparison(results_ln_loaded, model_1='BF', model_2='HR', r2_type = 'train')
plot_r2_comparison(results_ln_loaded, model_1='motion', model_2='HRmotion', r2_type='test')


# %% Sort neurons according to firing rate

threshold = 0.5

# Filter neurons with mean firing rate >= threshold
results_filtered = filter_neurons_by_mean_firing_rate(
    loaded_results=results_ln_loaded,
    spike_counts=spike_counts,
    firing_rate_threshold=threshold,
    above_threshold=True
)

plot_mean_firing_rate_vs_r2(results_filtered, spike_counts, separate_subplots=False, r2_type='train')


plot_r2_means_sem(results_filtered, r2_type='train')

plot_r2_comparison(results_filtered, model_1='BF', model_2='HR', r2_type='train')
plot_r2_comparison(results_filtered, model_1='motion', model_2='HRmotion', r2_type='train')





















