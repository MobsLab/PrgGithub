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

from all_paths_for_experiments.path_for_expe_cardiosense_ivabradine import get_path_for_expe_cardiosense_ivabradine
from load_plot_matlab_data.load_matlab_variables import load_variables_from_path
from load_plot_matlab_data.plot_matlab_variables import ( 
    plot_variable_over_time,
    plot_variable_distribution
    )

# %% 

# expe_paths = get_path_for_expe_cardiosense_ivabradine('Basal_Pre-Injection')
expe_paths = get_path_for_expe_cardiosense_ivabradine('Test')

variables = ['Heartrate', 'BreathFreq']
data = load_variables_from_path(expe_paths, variables)

plot_variable_over_time(data, 1690, 'Heartrate', '20250221')
plot_variable_over_time(data, 1690, 'BreathFreq', '20250221')

plot_variable_distribution(data, 1690, 'Heartrate')
plot_variable_distribution(data, 1690, 'BreathFreq')

plot_variable_distribution(data, 1712, 'Heartrate')
plot_variable_distribution(data, 1712, 'BreathFreq')
