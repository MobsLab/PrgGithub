#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 18 11:06:12 2025

@author: gruffalo
"""

# %% Import necessary modules

from all_paths_for_experiments.path_for_expe_epm_open_field_ivabradine import get_path_for_expe_epm_open_field_ivabradine
from load_plot_matlab_data.format_matlab_variables import build_datasets
from behavior_maze_epm_open_field_ivabradine.process_epm_data import compute_behavioral_data_epm
from behavior_maze_epm_open_field_ivabradine.process_open_field_data import compute_behavioral_data_open_field
from behavior_maze_epm_open_field_ivabradine.analyze_individual_behavior_maze_epm_open_field import (
    plot_centered_maze_trajectories,
    plot_position_maze_across_time,
    plot_distance_and_speed_over_time,
    plot_recap_behavior_mouse
    )

# %% Create datasets

entries = [
    ("EPM_Saline_Exposition", "Saline_Expo", get_path_for_expe_epm_open_field_ivabradine, '#FADA7A'),
    ("EPM_Ivabradine_Exposition", "Ivabradine_Expo", get_path_for_expe_epm_open_field_ivabradine, '#6A9C89'),
    ("EPM_Saline_Reexposition", "Saline_Reexpo", get_path_for_expe_epm_open_field_ivabradine, '#C1D8C3'),
    ("EPM_Ivabradine_Reexposition", "Ivabradine_Reexpo", get_path_for_expe_epm_open_field_ivabradine, '#3D8D7A'),
    ("OF_Saline_Exposition", "Saline_Expo", get_path_for_expe_epm_open_field_ivabradine, '#FADA7A'),
    ("OF_Ivabradine_Exposition", "Ivabradine_Expo", get_path_for_expe_epm_open_field_ivabradine, '#6A9C89'),
    ("OF_Saline_Reexposition", "Saline_Reexpo", get_path_for_expe_epm_open_field_ivabradine, '#C1D8C3'),
    ("OF_Ivabradine_Reexposition", "Ivabradine_Reexpo", get_path_for_expe_epm_open_field_ivabradine, '#3D8D7A'),
]

datasets = build_datasets(entries)


# %% Analyze behavior

experiment_keys_epm = ['EPM_Saline_Exposition', 'EPM_Saline_Reexposition','EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']
experiment_keys_open_field = ['OF_Saline_Exposition', 'OF_Saline_Reexposition','OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']

compute_behavioral_data_epm(datasets, experiment_keys=experiment_keys_epm)
compute_behavioral_data_open_field(datasets, experiment_keys=experiment_keys_open_field)


# %% Plot mouse data

path_figures = '/home/gruffalo/Dropbox/Mobs_member/EllaCallas/Figures/202506_EPM_OF_Ivabradine_10mg'

import numpy as np
for mouse in np.arange(1748, 1765, 1):
    plot_recap_behavior_mouse(datasets, mouse, maze_type='EPM', save_path=path_figures)
    plot_recap_behavior_mouse(datasets, mouse, maze_type='OF', save_path=path_figures)


# %% Individual functions

mouse_list=[1752]

plot_centered_maze_trajectories(datasets, [experiment_keys_epm])

plot_position_maze_across_time(datasets, 
                               [['OF_Saline_Exposition', 'OF_Saline_Reexposition']], 
                               mouse_list=mouse_list, legend=True)

plot_distance_and_speed_over_time(datasets, 
                                  [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
                                   ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
                                  mouse_list=mouse_list, legend=True,
                                  smoothing_window_s=4)




















