#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 27 12:17:42 2024

@author: gruffalo
"""

# %% Set working directory
# import os
# os.chdir(r'/home/gruffalo/PrgGithub/Ella/Python/projects/data_Sophie')

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
    process_all_neurons
    )
# from plot_recap_linear_nonlinear_model import (
#     save_results_figures
#     )
# from load_save_results import ( 
#     save_results
#     )
from joblib import dump



# %% Load data

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'

maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')
maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')

# Rebin data
new_bin_size = 0.6
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)

# Compute spike counts
spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)

# %% Fit model (long calculation)

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




    
    
    