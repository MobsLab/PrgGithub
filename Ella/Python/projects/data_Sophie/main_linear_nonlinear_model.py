#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 27 12:17:42 2024

@author: gruffalo
"""

# %% Set working directory
import os
os.chdir(r'/home/gruffalo/Documents/Python/projects/data_Sophie/')

import numpy as np
from load_save_results import ( 
    load_results
    )
from preprocess_sort_data import (
    rebin_mice_data
    )
from analyse_data import (
    spike_count_all_mice,
    )
from fit_linear_nonlinear_model import (
    # process_neuron,
    process_all_neurons,
    fit_bin_size
    )
# from plot_recap_linear_nonlinear_model import (
#     save_results_figures
#     )
# from load_save_results import ( 
#     save_results
#     )
from joblib import dump
from analyse_ln_bin_size import (
    load_results_per_bin_size,
    extract_r2_for_bin_sizes,
    plot_mean_r2_vs_bin_size
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

# %% Fit model 

random_seed=30
    
# Collect all results
all_results = []

for mouse_id in spike_counts.keys():
    dependent_vars = spike_counts[mouse_id].columns.tolist()
    mouse_results = process_all_neurons(mouse_id, dependent_vars, spike_counts, maze_rebinned_data, random_seed=random_seed)
    all_results.extend([res for res in mouse_results if res is not None])
    
# %% Save results

# Using pickle 
results_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'
# file_path = save_results(all_results, results_directory, 'results_ln_model.pkl')

# Using joblib
dump(all_results, results_directory+'results_ln_model_rs30.joblib')
    
# %% Save figures

# figures_directory = load_path = 'figures/ln_recap_figures'

# save_results_figures(
#     all_results=all_results,
#     spike_counts=spike_counts,
#     maze_rebinned_data=maze_rebinned_data,
#     maze_spike_times_data=maze_spike_times_data,
#     figures_directory=figures_directory
# )

# %% Fit bin size

# Define parameters
random_seed=30

# bin_sizes = np.arange(0.2, 20.2, 0.2).tolist()
bin_sizes = [round(x, 1) for x in np.arange(0.2, 20.2, 0.2)]

# Run fit_bin_size
results_bin_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/test_bin_size'
results = fit_bin_size(
    denoised_data=maze_denoised_data,
    spike_times_data=maze_spike_times_data,
    bin_sizes=bin_sizes,
    save_directory=results_bin_directory,
    random_seed=random_seed
)

# %% Analyze bin size

results_per_bin_size = load_results_per_bin_size(results_bin_directory)

r2_dataframe = extract_r2_for_bin_sizes(results_per_bin_size)


plot_mean_r2_vs_bin_size(results_per_bin_size, r2_type='train', log_scale=False)
    
    
    
    
    