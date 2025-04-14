#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 20 17:53:51 2024

@author: gruffalo
"""

# %% Set working directory
import os
os.chdir(r'/home/gruffalo/PrgGithub/Ella/Python/data_SophieBagur')

import numpy as np
from load_save_results import ( 
    load_results
    )
from preprocess_sort_data import (
    rebin_mice_data
    )
# from fit_linear_nonlinear_model import (
#     fit_bin_size,
#     fit_time_lag
#     )
from analyse_ln_bin_size import (
    load_results_per_bin_size,
    extract_r2_for_bin_sizes,
    plot_mean_r2_vs_bin_size
    )
from analyse_ln_time_lag import (
    load_results_per_time_lag,
    extract_r2_for_time_lags,
    plot_mean_r2_vs_time_lag
    )


# %% Load data

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'

maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')
maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')


# %% Fit bin size

# Define parameters
random_seed=30

# bin_sizes = np.arange(0.2, 20.2, 0.2).tolist()
bin_sizes = [round(x, 1) for x in np.arange(0.2, 20.2, 0.2)]

# Run fit_bin_size
results_bin_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/test_bin_size'
# results_per_bin_size = fit_bin_size(
#     denoised_data=maze_denoised_data,
#     spike_times_data=maze_spike_times_data,
#     bin_sizes=bin_sizes,
#     save_directory=results_bin_directory,
#     random_seed=random_seed
# )

# %% Analyze bin size

results_bin_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/test_bin_size'

results_per_bin_size = load_results_per_bin_size(results_bin_directory)

r2_bin_dataframe = extract_r2_for_bin_sizes(results_per_bin_size)

plot_mean_r2_vs_bin_size(results_per_bin_size, r2_type='train', log_scale=False)
    
# %% Fit time lag

# Rebin data
new_bin_size = 1
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)

# Define the time lag range
lag_range = (-10, 10)  # Test lags from -10 to +10

# Set the random seed for reproducibility
random_seed = 30

# Create the save directory if it doesn't exist
results_lag_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/test_lag_size'

# Call the fit_time_lag function
# results_per_lag = fit_time_lag(
#     denoised_data=maze_rebinned_data,
#     spike_times_data=maze_spike_times_data,
#     lag_range=lag_range,
#     save_directory=results_lag_directory,
#     random_seed=random_seed
# )


# %% Analyze time lag

results_lag_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/test_lag_size'

results_per_lag = load_results_per_time_lag(results_lag_directory)

r2_lag_dataframe = extract_r2_for_time_lags(results_per_lag)

plot_mean_r2_vs_time_lag(results_per_lag, r2_type='train')









   