#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 19 16:22:53 2025

@author: gruffalo
"""

# %% Import modules 

import sys
python_path = "/home/gruffalo/PrgGithub/Ella/Python/"
if python_path not in sys.path:
    sys.path.append(python_path)

from all_paths_for_experiments.path_for_expe_cardiosense_habheadfixed_temperature import get_path_for_expe_cardiosense_habheadfixed_temperature
from all_paths_for_experiments.path_for_expe_cardiosense_ivabradine import get_path_for_expe_cardiosense_ivabradine

from load_plot_matlab_data.load_matlab_variables import load_data_into_datasets
from load_plot_matlab_data.format_matlab_variables import build_datasets
from load_plot_matlab_data.plot_matlab_variables import ( 
    plot_variable_over_time,
    plot_multiple_variables_over_time,
    plot_variable_distribution,
    plot_variable_joyplot,
    )

# %% Define datasets configuration and load data

entries = [
    ("HabHeadFixed", "Habituation", get_path_for_expe_cardiosense_habheadfixed_temperature, '#FADA7A'),
    ("HabHeadFixed_Test_Temperature", "Test_HeatingPad", get_path_for_expe_cardiosense_habheadfixed_temperature, '#EF9651'),
    ("HeadFixed_Temperature_Basal", "Temp_Basal", get_path_for_expe_cardiosense_habheadfixed_temperature, '#D2665A'),
    ("HeadFixed_Temperature_HeatingLamp", "Temp_Heating", get_path_for_expe_cardiosense_habheadfixed_temperature, '#B82132'),
    ("Basal_Pre_Injection", "Basal_Pre_Injection", get_path_for_expe_cardiosense_ivabradine, '#E5D0AC'),
    ("Injection_Saline", "Saline", get_path_for_expe_cardiosense_ivabradine, '#C1D8C3'),
    ("Injection_Ivabradine_5mgkg", "Ivab5", get_path_for_expe_cardiosense_ivabradine, '#6A9C89'),
    ("Injection_Ivabradine_10mgkg", "Ivab10", get_path_for_expe_cardiosense_ivabradine, '#3D8D7A'),
    ("Injection_Ivabradine_20mgkg", "Ivab20", get_path_for_expe_cardiosense_ivabradine, '#255F38'),
]

datasets = build_datasets(entries)

# Load data
variables = ['Heartrate', 'BreathFreq', 'OBGamma']
subsample_params = {"OBGamma": 0.04}

load_data_into_datasets(datasets, variables, subsample_params)

# %% Analyze first experiments (habituation)

plot_variable_distribution(datasets, 1690, 'Heartrate', experiment_keys=["HabHeadFixed"])
plot_variable_distribution(datasets, 1690, 'BreathFreq', experiment_keys=["HabHeadFixed"])
plot_variable_distribution(datasets, 1690, 'OBGamma', experiment_keys=["HabHeadFixed"])

plot_variable_distribution(datasets, 1711, 'Heartrate', experiment_keys=["HabHeadFixed"])
plot_variable_distribution(datasets, 1711, 'BreathFreq', experiment_keys=["HabHeadFixed"])
plot_variable_distribution(datasets, 1711, 'OBGamma', experiment_keys=["HabHeadFixed"])

plot_variable_joyplot(datasets, 1690, 'OBGamma', experiment_keys=['HabHeadFixed'])

plot_variable_over_time(datasets, 1690, 'OBGamma', dates='250130', 
                        experiment_keys=['HabHeadFixed'], smooth=True, smooth_window=100)

plot_multiple_variables_over_time(datasets, 1690, ['Heartrate', 'BreathFreq','OBGamma'], 
                                  date='250205', smooth=True, 
                                  smooth_window_dict={'Heartrate': 1000, 'BreathFreq': 1000, 'OBGamma': 4000})

plot_multiple_variables_over_time(datasets, 1711, ['Heartrate', 'BreathFreq','OBGamma'], 
                                  data='250130', smooth=True, 
                                  smooth_window_dict={'Heartrate': 300, 'BreathFreq': 300, 'OBGamma': 3000})

# %% Temperature test sessions 

plot_variable_distribution(datasets, 1690, 'Heartrate', experiment_keys=["HabHeadFixed_Test_Temperature"])
plot_variable_distribution(datasets, 1690, 'BreathFreq', experiment_keys=["HabHeadFixed_Test_Temperature"])
plot_variable_distribution(datasets, 1690, 'OBGamma', experiment_keys=["HabHeadFixed_Test_Temperature"])

plot_variable_distribution(datasets, 1711, 'Heartrate', experiment_keys=["HabHeadFixed_Test_Temperature"])
plot_variable_distribution(datasets, 1711, 'BreathFreq', experiment_keys=["HabHeadFixed_Test_Temperature"])
plot_variable_distribution(datasets, 1711, 'OBGamma', experiment_keys=["HabHeadFixed_Test_Temperature"])

# Compare temperature to last habituation session
plot_variable_distribution(datasets, 1690, 'Heartrate', 
                           dates=['250205', '250206', '250207', '250211'])

plot_variable_distribution(datasets, 1690, 'BreathFreq', 
                           dates=['250205', '250206', '250207', '250211'])

plot_variable_distribution(datasets, 1711, 'Heartrate', 
                           dates=['250205', '250206', '250207', '250210'])

plot_variable_distribution(datasets, 1711, 'BreathFreq', 
                           dates=['250205', '250206', '250207', '250210'])

# %% Temperature lamp sessions 

plot_variable_distribution(datasets, 1690, 'Heartrate', 
                           experiment_keys=['HeadFixed_Temperature_HeatingLamp', 
                                            'HeadFixed_Temperature_Basal'])

plot_variable_distribution(datasets, 1690, 'BreathFreq', 
                           experiment_keys=['HeadFixed_Temperature_HeatingLamp', 
                                            'HeadFixed_Temperature_Basal'])

plot_variable_distribution(datasets, 1690, 'OBGamma', 
                           experiment_keys=['HeadFixed_Temperature_HeatingLamp', 
                                            'HeadFixed_Temperature_Basal'])

plot_variable_distribution(datasets, 1711, 'Heartrate', 
                           experiment_keys=['HeadFixed_Temperature_HeatingLamp', 
                                            'HeadFixed_Temperature_Basal'])

plot_variable_distribution(datasets, 1711, 'BreathFreq', 
                           experiment_keys=['HeadFixed_Temperature_HeatingLamp', 
                                            'HeadFixed_Temperature_Basal'])

plot_variable_distribution(datasets, 1711, 'OBGamma', 
                           experiment_keys=['HeadFixed_Temperature_HeatingLamp', 
                                            'HeadFixed_Temperature_Basal'])

# %% Basal Pre_Injection

plot_variable_distribution(datasets, 1690, 'Heartrate', experiment_keys=["Basal_Pre_Injection"])
plot_variable_distribution(datasets, 1690, 'BreathFreq', experiment_keys=["Basal_Pre_Injection"])
plot_variable_distribution(datasets, 1690, 'OBGamma', experiment_keys=["Basal_Pre_Injection"])

plot_variable_distribution(datasets, 1711, 'Heartrate', experiment_keys=["Basal_Pre_Injection"])
plot_variable_distribution(datasets, 1711, 'BreathFreq', experiment_keys=["Basal_Pre_Injection"])
plot_variable_distribution(datasets, 1711, 'OBGamma', experiment_keys=["Basal_Pre_Injection"])

# %% Injection Saline

plot_variable_distribution(datasets, 1690, 'Heartrate', experiment_keys=["Injection_Saline"])
plot_variable_distribution(datasets, 1690, 'BreathFreq', experiment_keys=["Injection_Saline"])
plot_variable_distribution(datasets, 1690, 'OBGamma', experiment_keys=["Injection_Saline"])

plot_variable_distribution(datasets, 1711, 'Heartrate', experiment_keys=["Injection_Saline"])
plot_variable_distribution(datasets, 1711, 'BreathFreq', experiment_keys=["Injection_Saline"])
plot_variable_distribution(datasets, 1711, 'OBGamma', experiment_keys=["Injection_Saline"])

# %% Injection Ivabradine 5mgkg

plot_variable_distribution(datasets, 1690, 'Heartrate', experiment_keys=["Injection_Ivabradine_5mgkg"])
plot_variable_distribution(datasets, 1690, 'BreathFreq', experiment_keys=["Injection_Ivabradine_5mgkg"])

plot_variable_over_time(datasets, 1690, 'Heartrate', 
                        experiment_keys=['Injection_Ivabradine_5mgkg'], 
                        smooth=True, smooth_window=300, ylim=(4,12), xlim=(-200,12200))

plot_variable_over_time(datasets, 1712, 'Heartrate', 
                        experiment_keys=['Injection_Ivabradine_5mgkg'], 
                        smooth=True, smooth_window=300, ylim=(4,12), xlim=(-200,12200))

# %% Injection Ivabradine 10mgkg

plot_variable_distribution(datasets, 1690, 'Heartrate', experiment_keys=["Injection_Ivabradine_10mgkg"])
plot_variable_distribution(datasets, 1690, 'BreathFreq', experiment_keys=["Injection_Ivabradine_10mgkg"])

plot_variable_over_time(datasets, 1690, 'Heartrate', 
                        experiment_keys=['Injection_Ivabradine_10mgkg'], 
                        smooth=True, smooth_window=300, ylim=(4,12), xlim=(-200,12200))

plot_variable_over_time(datasets, 1712, 'Heartrate', 
                        experiment_keys=['Injection_Ivabradine_10mgkg'], 
                        smooth=True, smooth_window=300, ylim=(4,12), xlim=(-200,12200))

# %% Injection Ivabradine 20mgkg

plot_variable_distribution(datasets, 1690, 'Heartrate', experiment_keys=["Injection_Ivabradine_20mgkg"])
plot_variable_distribution(datasets, 1690, 'BreathFreq', experiment_keys=["Injection_Ivabradine_20mgkg"])

plot_variable_over_time(datasets, 1690, 'Heartrate', 
                        experiment_keys=['Injection_Ivabradine_20mgkg'], 
                        smooth=True, smooth_window=100, ylim=(2,12))

plot_variable_over_time(datasets, 1711, 'Heartrate', 
                        experiment_keys=['Injection_Ivabradine_20mgkg'], 
                        smooth=True, smooth_window=100, ylim=(2,12))

plot_multiple_variables_over_time(datasets, 1711, ['Heartrate', 'BreathFreq'], 
                                  '250305', experiment_keys=['Injection_Ivabradine_20mgkg'],
                                  smooth=True, smooth_window_dict={'Heartrate': 100, 'BreathFreq': 100})

plot_variable_over_time(datasets, 1712, 'Heartrate', 
                        experiment_keys=['Injection_Ivabradine_20mgkg'], 
                        smooth=True, smooth_window=100, ylim=(2,12))

plot_variable_over_time(datasets, 1712, 'BreathFreq', dates='250311',  
                        smooth=True, smooth_window=100, ylim=(0,5))


# %% Compare saline and ivabradine

for mouse in [1690, 1711, 1712]:
    for variable in variables:
        plot_variable_distribution(datasets, 1690, variable, 
                                   experiment_keys=["Injection_Saline", "Injection_Ivabradine_5mgkg", 
                                                    "Injection_Ivabradine_10mgkg", "Injection_Ivabradine_20mgkg"])

# %% Plot all distributions together 

plot_variable_distribution(datasets, 1690, 'Heartrate')

plot_variable_distribution(datasets, 1690, 'BreathFreq')

plot_variable_distribution(datasets, 1711, 'Heartrate')

plot_variable_distribution(datasets, 1711, 'BreathFreq')

plot_variable_distribution(datasets, 1712, 'Heartrate')

plot_variable_distribution(datasets, 1712, 'BreathFreq')
