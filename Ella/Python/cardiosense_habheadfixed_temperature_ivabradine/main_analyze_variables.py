#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  7 16:26:50 2025

@author: gruffalo
"""

# %% Import modules 

import sys
python_path = "/home/gruffalo/PrgGithub/Ella/Python/"
if python_path not in sys.path:
    sys.path.append(python_path)

from all_paths_for_experiments.path_for_expe_cardiosense_habheadfixed_temperature import get_path_for_expe_cardiosense_habheadfixed_temperature
from all_paths_for_experiments.path_for_expe_cardiosense_ivabradine import get_path_for_expe_cardiosense_ivabradine_determine_dosage

from load_plot_matlab_data.load_matlab_variables import load_data_into_datasets
from load_plot_matlab_data.format_matlab_variables import build_datasets
from cardiosense_habheadfixed_temperature_ivabradine.analyze_variable_distribution import (
    plot_variable_correlations,
    plot_cross_correlation_between_variables
    )

# %% Define datasets configuration and load data

entries = [
    ("HabHeadFixed", "Habituation", get_path_for_expe_cardiosense_habheadfixed_temperature, '#FADA7A'),
    ("HabHeadFixed_Test_Temperature", "Test_HeatingPad", get_path_for_expe_cardiosense_habheadfixed_temperature, '#EF9651'),
    ("HeadFixed_Temperature_Basal", "Temp_Basal", get_path_for_expe_cardiosense_habheadfixed_temperature, '#D2665A'),
    ("HeadFixed_Temperature_HeatingLamp", "Temp_Heating", get_path_for_expe_cardiosense_habheadfixed_temperature, '#B82132'),
    ("Basal_Pre_Injection", "Basal_Pre_Injection", get_path_for_expe_cardiosense_ivabradine_determine_dosage, '#E5D0AC'),
    ("Injection_Saline", "Saline", get_path_for_expe_cardiosense_ivabradine_determine_dosage, '#C1D8C3'),
    ("Injection_Ivabradine_5mgkg", "Ivab5", get_path_for_expe_cardiosense_ivabradine_determine_dosage, '#6A9C89'),
    ("Injection_Ivabradine_10mgkg", "Ivab10", get_path_for_expe_cardiosense_ivabradine_determine_dosage, '#3D8D7A'),
    ("Injection_Ivabradine_20mgkg", "Ivab20", get_path_for_expe_cardiosense_ivabradine_determine_dosage, '#255F38'),
]

datasets = build_datasets(entries)

# Load data
variables = ['Heartrate', 'BreathFreq', 'OBGamma']
subsample_params = {"OBGamma": 0.04}

load_data_into_datasets(datasets, variables, subsample_params)

# %% Cross-correlations

plot_variable_correlations(datasets, 1712, 'Heartrate', 'BreathFreq')

# 
plot_cross_correlation_between_variables(
    datasets,
    mouse_id=1690,
    var1='Heartrate',
    var2='BreathFreq',
    experiment_keys=['HabHeadFixed'],
    max_lag_seconds=20,
    bin_size=0.1
)

plot_cross_correlation_between_variables(
    datasets,
    mouse_id=1690,
    var1='Heartrate',
    var2='BreathFreq',
    experiment_keys=['Injection_Saline'],
    max_lag_seconds=20,
    bin_size=0.1
)

plot_cross_correlation_between_variables(
    datasets,
    mouse_id=1690,
    var1='Heartrate',
    var2='BreathFreq',
    experiment_keys=['Injection_Ivabradine_5mgkg', 'Injection_Ivabradine_10mgkg', 'Injection_Ivabradine_20mgkg'],
    max_lag_seconds=20,
    bin_size=0.1
)

plot_cross_correlation_between_variables(
    datasets,
    mouse_id=1711,
    var1='Heartrate',
    var2='BreathFreq',
    experiment_keys=['HabHeadFixed'],
    max_lag_seconds=20,
    bin_size=0.1
)

plot_cross_correlation_between_variables(
    datasets,
    mouse_id=1711,
    var1='Heartrate',
    var2='BreathFreq',
    experiment_keys=['Injection_Saline', 'Injection_Ivabradine_20mgkg'],
    max_lag_seconds=20,
    bin_size=0.1
)

plot_cross_correlation_between_variables(
    datasets,
    mouse_id=1712,
    var1='Heartrate',
    var2='BreathFreq',
    experiment_keys=['HabHeadFixed'],
    max_lag_seconds=20,
    bin_size=0.1
)

plot_cross_correlation_between_variables(
    datasets,
    mouse_id=1712,
    var1='Heartrate',
    var2='BreathFreq',
    experiment_keys=['Injection_Saline'],
    max_lag_seconds=20,
    bin_size=0.1
)

plot_cross_correlation_between_variables(
    datasets,
    mouse_id=1712,
    var1='Heartrate',
    var2='BreathFreq',
    experiment_keys=['Injection_Ivabradine_5mgkg', 'Injection_Ivabradine_10mgkg', 'Injection_Ivabradine_20mgkg'],
    max_lag_seconds=20,
    bin_size=0.1
)

