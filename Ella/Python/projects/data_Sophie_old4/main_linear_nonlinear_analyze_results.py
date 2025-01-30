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
from preprocess_sort_data import (
    rebin_mice_data
    )
from analyse_data import (
    spike_count_all_mice,
    )
from plot_results_linear_nonlinear_model import (
    extract_r2_values,
    plot_r2_means_sem
    )

# %% Load data

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'

all_denoised_data = load_results(load_path + 'all_denoised_data.pkl')
maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')
all_spike_times_data = load_results(load_path + 'all_spike_times_data.pkl')
maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')

# Rebin data
new_bin_size = 0.6
all_rebinned_data = rebin_mice_data(all_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'LinPos'], new_bin_size)
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)

# Compute spike counts
spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)


# %% Load results

loaded_results = load_results(load_path + 'results_ln_model.pkl')

# %% R2

r2_dataframe = extract_r2_values(loaded_results)

# Assuming `loaded_results` is the list of dictionaries
plot_r2_means_sem(loaded_results)





