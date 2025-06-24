#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 20 11:25:27 2025

@author: gruffalo
"""

# %% Import necessary modules

# from behavior_maze_epm_open_field.offline_tracking_handle_behavResourses import rename_behav_resources
from all_paths_for_experiments.path_for_expe_epm_open_field_ivabradine import ( 
    get_path_for_expe_epm_open_field_ivabradine,
    get_path_for_expe_epm_open_field_ivabradine_mf,
    )
from load_plot_matlab_data.format_matlab_variables import build_datasets
from collections import defaultdict
from behavior_maze_epm_open_field_ivabradine.align_open_field_data import create_centered_open_field_data
from behavior_maze_epm_open_field_ivabradine.process_open_field_data import (
    compute_behavioral_data_open_field,
    # compute_mean_zone_occupancy_over_time
    )
from behavior_maze_epm_open_field_ivabradine.analyze_global_behavior_maze_epm_open_field import (
    plot_centered_maze_trajectories,
    plot_centered_maze_density,
    plot_mean_distance_over_time,
    plot_mean_speed_over_time,
    compare_threshold_speed,
    plot_compare_maze_results,
    )

# %% Handle offline tracking .mat

# Done once already, no need to be done again
# path = '/media/nas8-2/ProjectCardioSense/'
# rename_behav_resources(path)

# %% Create datasets

entries = [
    ("OF_F_Saline_Exposition", "Saline_F_Expo", get_path_for_expe_epm_open_field_ivabradine_mf, '#FADA7A'),
    ("OF_M_Saline_Exposition", "Saline_M_Expo", get_path_for_expe_epm_open_field_ivabradine_mf, '#FADA7A'),
    ("OF_F_Ivabradine_Exposition", "Ivabradine_F_Expo", get_path_for_expe_epm_open_field_ivabradine_mf, '#6A9C89'),
    ("OF_M_Ivabradine_Exposition", "Ivabradine_M_Expo", get_path_for_expe_epm_open_field_ivabradine_mf, '#6A9C89'),
    ("OF_F_Saline_Reexposition", "Saline_F_Reexpo", get_path_for_expe_epm_open_field_ivabradine_mf, '#C1D8C3'),
    ("OF_M_Saline_Reexposition", "Saline_M_Reexpo", get_path_for_expe_epm_open_field_ivabradine_mf, '#C1D8C3'),
    ("OF_F_Ivabradine_Reexposition", "Ivabradine_F_Reexpo", get_path_for_expe_epm_open_field_ivabradine_mf, '#3D8D7A'),
    ("OF_M_Ivabradine_Reexposition", "Ivabradine_M_Reexpo", get_path_for_expe_epm_open_field_ivabradine_mf, '#3D8D7A'),
]

datasets = build_datasets(entries)


# %% Analyze behavior OF

compute_behavioral_data_open_field(datasets, smoothing_window_s=None)

F_Saline = ['OF_F_Saline_Exposition', 'OF_F_Saline_Reexposition'], 
F_Ivabradine = ['OF_F_Ivabradine_Exposition', 'OF_F_Ivabradine_Reexposition'], 
M_Saline = ['OF_M_Saline_Exposition', 'OF_M_Saline_Reexposition'], 
M_Ivabradine = ['OF_M_Ivabradine_Exposition', 'OF_M_Ivabradine_Reexposition'], 

# %% Plot trajectories

plot_centered_maze_density(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
    maze_type='OF')

plot_mean_distance_over_time(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']],
    legend=['Saline', 'Ivabradine'],
    plot_together=True)

plot_mean_speed_over_time(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']],
    legend=['Saline', 'Ivabradine'],
    plot_together=True)

compare_threshold_speed(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
    threshold=2, legend=["Saline", "Drug"], paired=True)


# %% Analyze behavior OF


plot_compare_maze_results(
    datasets, 
    [['OF_F_Saline_Exposition', 'OF_F_Saline_Reexposition'], 
     ['OF_M_Saline_Exposition', 'OF_M_Saline_Reexposition']], 
    'ZoneOccupation', 
    paired=False,
    groups=['Sal_Female', 'Sal_Male'])


plot_compare_maze_results(
    datasets, 
    [['OF_F_Ivabradine_Exposition', 'OF_F_Ivabradine_Reexposition'], 
     ['OF_M_Ivabradine_Exposition', 'OF_M_Ivabradine_Reexposition']], 
    'ZoneOccupation', 
    paired=False,
    groups=['Iva_Female', 'Iva_Male'])


plot_compare_maze_results(
    datasets, 
    [['OF_F_Saline_Exposition', 'OF_F_Saline_Reexposition'], 
     ['OF_M_Saline_Exposition', 'OF_M_Saline_Reexposition']], 
    'MeanSpeed', 
    paired=False,
    groups=['Sal_Female', 'Sal_Male'])


plot_compare_maze_results(
    datasets, 
    [['OF_F_Ivabradine_Exposition', 'OF_F_Ivabradine_Reexposition'], 
     ['OF_M_Ivabradine_Exposition', 'OF_M_Ivabradine_Reexposition']], 
    'MeanSpeed', 
    paired=False,
    groups=['Iva_Female', 'Iva_Male'])










