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

from load_plot_matlab_data.load_matlab_variables import load_variables_from_path
from load_plot_matlab_data.plot_matlab_variables import ( 
    plot_variable_over_time,
    plot_variable_distribution
    )

# %% Analyze first experiments (habituation)

expe_paths_hab = get_path_for_expe_cardiosense_habheadfixed_temperature('HabHeadFixed')

variables = ['Heartrate', 'BreathFreq']
data_hab = load_variables_from_path(expe_paths_hab, variables)

plot_variable_distribution([data_hab], 1690, 'Heartrate')
plot_variable_distribution([data_hab], 1690, 'BreathFreq')

plot_variable_distribution([data_hab], 1711, 'Heartrate')
plot_variable_distribution([data_hab], 1711, 'BreathFreq')

# %% Temperature test sessions 

expe_paths_test_temp = get_path_for_expe_cardiosense_habheadfixed_temperature('HabHeadFixed_Test_Temperature')

data_test_temp = load_variables_from_path(expe_paths_test_temp, variables)

plot_variable_distribution([data_test_temp], 1690, 'Heartrate')
plot_variable_distribution([data_test_temp], 1690, 'BreathFreq')

plot_variable_distribution([data_test_temp], 1711, 'Heartrate')
plot_variable_distribution([data_test_temp], 1711, 'BreathFreq')

# Compare temperature to last habituation session
plot_variable_distribution([data_hab, data_test_temp], 1690, 'Heartrate', dates=['250205', '250206', '250207', '250211'])
plot_variable_distribution([data_hab, data_test_temp], 1711, 'Heartrate', dates=['250205', '250206', '250207', '250210'])

# %% Basal pre-injection

expe_paths_basal = get_path_for_expe_cardiosense_ivabradine('Basal_Pre-Injection')

data_basal = load_variables_from_path(expe_paths_basal, variables)

# plot_variable_over_time(data_basal, 1690, 'Heartrate', '20250221')
# plot_variable_over_time(data_basal, 1690, 'BreathFreq', '20250221')

plot_variable_distribution([data_basal], 1690, 'Heartrate')
plot_variable_distribution([data_basal], 1690, 'BreathFreq')

plot_variable_distribution([data_basal], 1711, 'Heartrate')
plot_variable_distribution([data_basal], 1711, 'BreathFreq')

# %% Injection Saline

expe_paths_sal = get_path_for_expe_cardiosense_ivabradine('Injection_Saline')

data_sal = load_variables_from_path(expe_paths_sal, variables)

# plot_variable_over_time(data_sal, 1690, 'Heartrate', '20250221')
# plot_variable_over_time(data_sal, 1690, 'BreathFreq', '20250221')

plot_variable_distribution([data_sal], 1690, 'Heartrate')
plot_variable_distribution([data_sal], 1690, 'BreathFreq')

plot_variable_distribution([data_sal], 1711, 'Heartrate')
plot_variable_distribution([data_sal], 1711, 'BreathFreq')

# %% Injection Ivabradine 20mgkg

expe_paths_iva20 = get_path_for_expe_cardiosense_ivabradine('Injection_Ivabradine_20mgkg')

data_iva20 = load_variables_from_path(expe_paths_iva20, variables)

# plot_variable_over_time(data_iva20, 1690, 'Heartrate', '20250221')
# plot_variable_over_time(data_iva20, 1690, 'BreathFreq', '20250221')

plot_variable_distribution([data_iva20], 1690, 'Heartrate', ylim=(2,13))
plot_variable_distribution([data_iva20], 1690, 'BreathFreq')

plot_variable_distribution([data_iva20], 1711, 'Heartrate', ylim=(2,13))
plot_variable_distribution([data_iva20], 1711, 'BreathFreq')

# %% Injection Ivabradine 10mgkg

expe_paths_iva10 = get_path_for_expe_cardiosense_ivabradine('Injection_Ivabradine_10mgkg')

data_iva10 = load_variables_from_path(expe_paths_iva10, variables)

# plot_variable_over_time(data_iva10, 1690, 'Heartrate', '20250221')
# plot_variable_over_time(data_iva10, 1690, 'BreathFreq', '20250221')

plot_variable_distribution([data_iva10], 1690, 'Heartrate', ylim=(2,13))
plot_variable_distribution([data_iva10], 1690, 'BreathFreq')


# %% Injection Ivabradine 5mgkg

expe_paths_iva5 = get_path_for_expe_cardiosense_ivabradine('Injection_Ivabradine_5mgkg')

data_iva5 = load_variables_from_path(expe_paths_iva5, variables)

# plot_variable_over_time(data_iva5, 1690, 'Heartrate', '20250221')
# plot_variable_over_time(data_iva5, 1690, 'BreathFreq', '20250221')

plot_variable_distribution([data_iva5], 1690, 'Heartrate', ylim=(2,13))
plot_variable_distribution([data_iva5], 1690, 'BreathFreq')

