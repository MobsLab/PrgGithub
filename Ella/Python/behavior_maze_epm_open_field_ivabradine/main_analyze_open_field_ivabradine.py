#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 23 17:15:08 2025

@author: gruffalo
"""

# %% Import necessary modules

# from behavior_maze_epm_open_field.offline_tracking_handle_behavResourses import rename_behav_resources
from all_paths_for_experiments.path_for_expe_epm_open_field_ivabradine import ( 
    get_path_for_expe_epm_open_field_ivabradine,
    )
from load_plot_matlab_data.format_matlab_variables import build_datasets
from collections import defaultdict
from behavior_maze_epm_open_field_ivabradine.align_open_field_data import create_centered_open_field_data
from behavior_maze_epm_open_field_ivabradine.process_open_field_data import (
    compute_thigmotaxis_zones,
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
    ("OF_Saline_Exposition", "Saline_Expo", get_path_for_expe_epm_open_field_ivabradine, '#FADA7A'),
    ("OF_Ivabradine_Exposition", "Ivabradine_Expo", get_path_for_expe_epm_open_field_ivabradine, '#6A9C89'),
    ("OF_Saline_Reexposition", "Saline_Reexpo", get_path_for_expe_epm_open_field_ivabradine, '#C1D8C3'),
    ("OF_Ivabradine_Reexposition", "Ivabradine_Reexpo", get_path_for_expe_epm_open_field_ivabradine, '#3D8D7A'),
]

datasets = build_datasets(entries)

# %% Align and recompute coordinates for open field sessions 

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
        center = create_centered_open_field_data(paths[0])
        if center is None:
            print(f" -> Skipping date {date} due to canceled selection.")
            continue

        # Apply same center to the rest of the paths (if any)
        for path in paths[1:]:
            print(f" -> Applying same center to: {path}")
            create_centered_open_field_data(path, initial_circle=center)


# Rebuild datasets to load and integrate aligned data
datasets = build_datasets(entries)

# %% Analyze behavior OF

compute_behavioral_data_open_field(datasets)

compute_thigmotaxis_zones(
    directory_path='/media/nas8-2/ProjectCardioSense/K1750/OpenField/FEAR-Mouse-1750-23042025-EPM_00',
    plot=True)

# %% Plot trajectories

plot_centered_maze_trajectories(datasets, [['OF_Saline_Exposition'], ['OF_Saline_Reexposition']], maze_type='OF')

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
    threshold=2, paired=True, groups=['Saline', 'Ivabradine'])



# %% Analyze behavior OF

# Between exposition and reexposition
plot_compare_maze_results(
    datasets, 
    [['OF_Saline_Exposition'], 
     ['OF_Saline_Reexposition']], 
    'ZoneOccupation',
    groups=['Sal_Expo', 'Sal_Reexpo'])

plot_compare_maze_results(
    datasets, 
    [['OF_Ivabradine_Exposition'], 
     ['OF_Ivabradine_Reexposition']], 
    'ZoneOccupation',
    groups=['Iva_Expo', 'Iva_Reexpo'])

plot_compare_maze_results(
    datasets, 
    [['OF_Saline_Exposition'], 
     ['OF_Saline_Reexposition']], 
    'TraveledDistance',
    groups=['Sal_Expo', 'Sal_Reexpo'])

plot_compare_maze_results(
    datasets, 
    [['OF_Ivabradine_Exposition'], 
     ['OF_Ivabradine_Reexposition']], 
    'TraveledDistance',
    groups=['Iva_Expo', 'Iva_Reexpo'])


# All paired
plot_compare_maze_results(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
    'ZoneOccupation', 
    paired=True,
    groups=['Saline', 'Ivabradine']
    )

plot_compare_maze_results(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
    'MeanDistance', 
    paired=True,
    groups=['Saline', 'Ivabradine'])

plot_compare_maze_results(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
    'MeanSpeed', 
    paired=True,
    groups=['Saline', 'Ivabradine'])

plot_compare_maze_results(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
    'TraveledDistance', 
    paired=True,
    groups=['Saline', 'Ivabradine'])

plot_compare_maze_results(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
    'NumZoneEntries', 
    paired=True,
    groups=['Saline', 'Ivabradine'])

plot_compare_maze_results(
    datasets, 
    [['OF_Saline_Exposition', 'OF_Saline_Reexposition'], 
     ['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']], 
    'DurationZoneEntries', 
    paired=True,
    groups=['Saline', 'Ivabradine'])
