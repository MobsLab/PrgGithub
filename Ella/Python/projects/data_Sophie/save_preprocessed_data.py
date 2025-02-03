#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  4 10:27:01 2024

@author: gruffalo
"""

# %% Set working directory
import os
os.chdir(r'/home/gruffalo/Documents/Python/projects/data_Sophie')

from load_data import load_dataframes
from preprocess_sort_data import (
    denoise_mice_data,
    create_sorted_column_replace_zeros
    )
from load_save_results import save_results


# %% Load data

# Load data and needed modules
all_mat_directory = r'/home/gruffalo/Documents/Data_ella/alldata'
maze_mat_directory = r'/home/gruffalo/Documents/Data_ella/justmaze'
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


# %% Save

data_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'

save_results(all_denoised_data, data_directory, 'all_denoised_data.pkl')
save_results(maze_denoised_data, data_directory, 'maze_denoised_data.pkl')
save_results(all_spike_times_data, data_directory, 'all_spike_times_data.pkl')
save_results(maze_spike_times_data, data_directory, 'maze_spike_times_data.pkl')

