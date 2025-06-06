#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 28 10:47:24 2025

@author: gruffalo
"""

# %% Import necessary modules

from all_paths_for_experiments.get_experiment_paths import rename_behav_resources
from all_paths_for_experiments.path_for_expe_epm_open_field_ivabradine import get_path_for_expe_epm_open_field_ivabradine
from load_plot_matlab_data.format_matlab_variables import build_datasets
from behavior_maze_epm_open_field.analyze_behavior_epm import compute_behavioral_data_epm

# %% Handle offline tracking .mat

path = '/media/nas8-2/ProjectCardioSense/Tests_temporary'
rename_behav_resources(path)

# %% Create datasets

entries = [
    ("Test", "Test", get_path_for_expe_epm_open_field_ivabradine, '#FADA7A'),
]

datasets = build_datasets(entries)


# %% Analyze EPM

compute_behavioral_data_epm(datasets, ['Test'])



