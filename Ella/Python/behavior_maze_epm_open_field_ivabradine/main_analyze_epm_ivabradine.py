#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 28 10:47:24 2025

@author: gruffalo
"""

# %% Import necessary modules

# from behavior_maze_epm_open_field.offline_tracking_handle_behavResourses import rename_behav_resources
from all_paths_for_experiments.path_for_expe_epm_open_field_ivabradine import get_path_for_expe_epm_open_field_ivabradine
from load_plot_matlab_data.format_matlab_variables import build_datasets
from collections import defaultdict
from behavior_maze_epm_open_field_ivabradine.align_epm_data import create_centered_epm_data
from behavior_maze_epm_open_field_ivabradine.process_epm_data import compute_behavioral_data_epm
from behavior_maze_epm_open_field_ivabradine.analyze_global_behavior_maze_epm_open_field import (
    print_maze_variable_data,
    plot_centered_maze_trajectories,
    plot_centered_maze_density,
    plot_distribution_speed,
    plot_mean_speed_over_time,
    compare_threshold_speed,
    plot_compare_maze_results
    )

# %% Handle offline tracking .mat

# # Done once already, no need to be done again
# path = '/media/nas8-2/ProjectCardioSense/'
# rename_behav_resources(path)

# %% Create datasets

entries = [
    ("EPM_Saline_Exposition", "Saline_Expo", get_path_for_expe_epm_open_field_ivabradine, '#FADA7A'),
    ("EPM_Ivabradine_Exposition", "Ivabradine_Expo", get_path_for_expe_epm_open_field_ivabradine, '#6A9C89'),
    ("EPM_Saline_Reexposition", "Saline_Reexpo", get_path_for_expe_epm_open_field_ivabradine, '#C1D8C3'),
    ("EPM_Ivabradine_Reexposition", "Ivabradine_Reexpo", get_path_for_expe_epm_open_field_ivabradine, '#3D8D7A'),
]

datasets = build_datasets(entries)


# entries = [
#     ("TestEPM", "Saline_Expo", get_path_for_expe_epm_open_field_ivabradine, '#FADA7A'),
# ]

# datasets = build_datasets(entries)

# %% Align and recompute coordinates for epm sessions 

# Use same coordinates for a given date (same ref maze not moved)
for key in datasets.keys():
    date_to_paths = defaultdict(list)

    # Build a date-to-path mapping
    for path, date in zip(datasets[key]['paths']['path'], datasets[key]['paths']['date']):
        date_to_paths[date].append(path)

    # For each date group, apply the same center
    for date, paths in date_to_paths.items():
        print(f"\nProcessing date: {date}")

        # Run the center selection once
        print(f" -> Selecting center for first experiment: {paths[0]}")
        center = create_centered_epm_data(paths[0])
        if center is None:
            print(f" -> Skipping date {date} due to canceled selection.")
            continue

        # Apply same center to the rest of the paths (if any)
        for path in paths[1:]:
            print(f" -> Applying same center to: {path}")
            create_centered_epm_data(path, manual_center=center)
            
            
# Rebuild datasets to load and integrate aligned data
datasets = build_datasets(entries)


# %% Analyze behavior EPM

compute_behavioral_data_epm(datasets, smoothing_window_s=None)

print_maze_variable_data(datasets, experiment_key='EPM_Ivabradine_Reexposition', variable='TotalTimeAllZones')

# %% Plot centered trajectories

plot_centered_maze_trajectories(datasets, [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
                                           ['EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']], maze_type='EPM')

plot_centered_maze_density(datasets, [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
                                      ['EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']], maze_type='EPM')

plot_distribution_speed(datasets, [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
                                      ['EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']])

plot_mean_speed_over_time(
    datasets, 
    [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
     ['EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']],
    legend=['Saline', 'Ivabradine'],
    plot_together=True)

compare_threshold_speed(
    datasets, 
    [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
     ['EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']],
    threshold=2, paired=True, groups=['Saline', 'Ivabradine'])

# %% Compare behavior

# Between exposition and reexposition
plot_compare_maze_results(datasets, [['EPM_Saline_Exposition'], 
                                    ['EPM_Saline_Reexposition']], 
                         'ZoneOccupation', paired=False,
                         groups=['Sal_Expo', 'Sal_Reexpo'])

plot_compare_maze_results(datasets, [['EPM_Ivabradine_Exposition'], 
                                    ['EPM_Ivabradine_Reexposition']], 
                         'ZoneOccupation', paired=False,
                         groups=['Iva_Expo', 'Iva_Reexpo'])


plot_compare_maze_results(datasets, [['EPM_Saline_Exposition'], 
                                    ['EPM_Saline_Reexposition']], 
                         'TraveledDistance', paired=False,
                         groups=['Sal_Expo', 'Sal_Reexpo'])

plot_compare_maze_results(datasets, [['EPM_Ivabradine_Exposition'], 
                                    ['EPM_Ivabradine_Reexposition']], 
                         'TraveledDistance', paired=False,
                         groups=['Iva_Expo', 'Iva_Reexpo'])

# Exposition
plot_compare_maze_results(datasets, [['EPM_Saline_Exposition'], 
                                    ['EPM_Ivabradine_Exposition']], 
                         'ZoneOccupation', paired=False)

plot_compare_maze_results(datasets, [['EPM_Saline_Exposition'], 
                                    ['EPM_Ivabradine_Exposition']], 
                         'MeanSpeed', paired=False)

# Reexposition
plot_compare_maze_results(datasets, [['EPM_Saline_Reexposition'], 
                                    ['EPM_Ivabradine_Reexposition']], 
                         'ZoneOccupation', paired=False)

plot_compare_maze_results(datasets, [['EPM_Saline_Reexposition'], 
                                    ['EPM_Ivabradine_Reexposition']], 
                         'MeanSpeed', paired=False)

# All together paired
plot_compare_maze_results(datasets, [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
                                    ['EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']], 
                         'ZoneOccupation', paired=True,
                         groups=['Saline', 'Ivabradine'])

plot_compare_maze_results(datasets, [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
                                    ['EPM_Ivabradine_Exposition','EPM_Ivabradine_Reexposition']], 
                         'DurationZoneEntries', paired=True,
                         groups=['Saline', 'Ivabradine'])

plot_compare_maze_results(datasets, [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
                                    ['EPM_Ivabradine_Exposition','EPM_Ivabradine_Reexposition']], 
                         'MeanSpeed', paired=True,
                         groups=['Saline', 'Ivabradine'])

plot_compare_maze_results(datasets, [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
                                    ['EPM_Ivabradine_Exposition','EPM_Ivabradine_Reexposition']], 
                         'TraveledDistance', paired=True,
                         groups=['Saline', 'Ivabradine'])

plot_compare_maze_results(datasets, [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition'], 
                                    ['EPM_Ivabradine_Exposition','EPM_Ivabradine_Reexposition']], 
                         'NumZoneEntries', paired=True)