#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 23 17:15:08 2025

@author: gruffalo
"""

# %% Import necessary modules

from all_paths_for_experiments.get_experiment_paths import rename_behav_resources
from all_paths_for_experiments.path_for_expe_epm_open_field_ivabradine import get_path_for_expe_epm_open_field_ivabradine
from behavior_maze_epm_open_field.align_open_field_data import create_centered_open_field_data
from behavior_maze_epm_open_field.process_open_field_data import compute_thigmotaxis_zones
from load_plot_matlab_data.format_matlab_variables import build_datasets
from behavior_maze_epm_open_field.analyze_behavior_epm import compute_behavioral_data_epm

# %% Handle offline tracking .mat

path = '/media/nas8-2/ProjectCardioSense/Tests_temporary'
rename_behav_resources(path)

# %% Align and recompute coordinates for open field sessions 

testnew = get_path_for_expe_epm_open_field_ivabradine('Test')

for path in testnew['path']:
    print(path)
    create_centered_open_field_data(path)

compute_thigmotaxis_zones('/media/nas8-2/ProjectCardioSense/Tests_temporary/FEAR-Mouse-1756-23042025-EPM_00')

# import scipy.io
# thigmo_mat_contents = scipy.io.loadmat(directory+'Thigmotaxis_Zones.mat', struct_as_record=False, squeeze_me=True)
# thigmo_zone_epochs = thigmo_mat_contents['AlignedZoneEpoch']  # e.g., could be a struct array or dict


# %% Create datasets

entries = [
    ("Test", "Test", get_path_for_expe_epm_open_field_ivabradine, '#FADA7A'),
]

datasets = build_datasets(entries)


# %% Analyze EPM

compute_behavioral_data_epm(datasets, ['Test'])






