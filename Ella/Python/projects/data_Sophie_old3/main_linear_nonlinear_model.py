#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 27 12:17:42 2024

@author: gruffalo
"""

# %% Set working directory
import os
os.chdir(r'/home/gruffalo/Documents/Python/projects/data_Sophie/')

# Import necessary packages and modules
# import json
# import numpy as np
# import pandas as pd

from load_data import load_dataframes
from preprocess_sort_data import (
    denoise_mice_data,
    create_sorted_column_replace_zeros,
    rebin_mice_data
    )
from analyse_data import (
    spike_count_all_mice,
    )
from fit_linear_nonlinear_model import (
    # process_neuron,
    process_all_neurons
    )
from plot_results_ln_model import (
    save_results_figures
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

# %% Fit model 
    
# Collect all results
all_results = []

for mouse_id in spike_counts.keys():
    dependent_vars = spike_counts[mouse_id].columns.tolist()
    mouse_results = process_all_neurons(mouse_id, dependent_vars, spike_counts, maze_rebinned_data)
    all_results.extend([res for res in mouse_results if res is not None])
    
# Save results and figures
save_results_figures(
    all_results=all_results,
    spike_counts=spike_counts,
    maze_rebinned_data=maze_rebinned_data,
    maze_spike_times_data=maze_spike_times_data,
    figures_directory=figures_directory
)
    
# %% 

# Make results JSON-serializable
# def make_json_serializable(obj):
#     if isinstance(obj, np.ndarray):
#         return obj.tolist()
#     elif isinstance(obj, pd.DataFrame):
#         return obj.to_dict()
#     elif isinstance(obj, pd.Series):
#         return obj.to_dict()
#     elif hasattr(obj, "__dict__"):
#         return obj.__dict__
#     else:
#         return obj

# serializable_results = [
#     {key: make_json_serializable(value) for key, value in res.items()}
#     for res in all_results if res is not None
# ]

# # Save results to JSON
# with open("results_ln_model.json", "w") as f:
#     json.dump(serializable_results, f)

# # Create a summary DataFrame
# summary = [
#     {
#         "mouse_id": res["mouse_id"],
#         "dependent_var": res["dependent_var"],
#         **{name: r.get("best_mean_r_squared", np.nan) for name, r in res["results"].items()}
#     }
#     for res in all_results if res is not None
# ]

# summary_df = pd.DataFrame(summary)
# print(summary_df)

    



    
# # %% 
    
# import json

# # Load results from the saved JSON file
# with open("results_ln_model.json", "r") as f:
#     all_results = json.load(f)

# # Verify the structure of all_results
# print(f"Loaded {len(all_results)} results from JSON.")


# # Check if the file is empty
# with open("results_ln_model.json", "r") as f:
#     contents = f.read()

# if not contents.strip():
#     print("The file is empty!")
# else:
#     print(contents[:500])  # Print the first 500 characters to inspect


    
    
    
    
    
    
    