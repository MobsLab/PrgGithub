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
    plot_multiple_variables_over_time,
    plot_variable_distribution,
    plot_variable_joyplot,
    compute_and_plot_variable_correlations
    )

from cardiosense_habheadfixed_temperature_ivabradine.analyze_heart_rate_distribution import compute_tsd_correlation

# %% Analyze first experiments (habituation)

expe_paths_hab = get_path_for_expe_cardiosense_habheadfixed_temperature('HabHeadFixed')

variables = ['Heartrate', 'BreathFreq', 'OBGamma']
data_hab = load_variables_from_path(expe_paths_hab, variables, subsample_params={"OBGamma": 0.04})

color_hab = '#FADA7A'
legend_hab = 'Habituation'

plot_variable_distribution([data_hab], 1690, 'Heartrate', colors=color_hab, legends=legend_hab)
plot_variable_distribution([data_hab], 1690, 'BreathFreq', colors=color_hab, legends=legend_hab)
plot_variable_distribution([data_hab], 1690, 'OBGamma', colors=color_hab, legends=legend_hab, ylim=(100,900))

plot_variable_distribution([data_hab], 1711, 'Heartrate', colors=color_hab, legends=legend_hab)
plot_variable_distribution([data_hab], 1711, 'BreathFreq', colors=color_hab, legends=legend_hab)
plot_variable_distribution([data_hab], 1711, 'OBGamma', colors=color_hab, legends=legend_hab, ylim=(100,900))

plot_variable_joyplot([data_hab], 1690, 'OBGamma', colors=color_hab, legends=legend_hab)

plot_variable_over_time([data_hab], 1690, 'OBGamma', dates='250130', 
                        smooth=True, smooth_window=100,
                        colors=color_hab, legends=legend_hab)

plot_multiple_variables_over_time([data_hab], 1690, ['Heartrate', 'OBGamma'], date='250205', 
                                  smooth=True, smooth_window_dict={'Heartrate': 1000, 'OBGamma': 4000},
                                  colors={'Heartrate': color_hab, 'OBGamma':'#EF9651'})
plot_multiple_variables_over_time([data_hab], 1711, ['Heartrate', 'OBGamma'], date='250205', 
                                  smooth=True, smooth_window_dict={'Heartrate': 1000, 'OBGamma': 4000},
                                  colors={'Heartrate': color_hab, 'OBGamma':'#EF9651'})

plot_multiple_variables_over_time([data_hab], 1690, ['Heartrate', 'BreathFreq','OBGamma'], date='250205', 
                                  smooth=True, smooth_window_dict={'Heartrate': 300, 'BreathFreq': 300, 'OBGamma': 3000},
                                  colors={'Heartrate': '#8D0B41', 'BreathFreq':'#0A6847', 'OBGamma':'#205781'})
plot_multiple_variables_over_time([data_hab], 1711, ['Heartrate', 'BreathFreq','OBGamma'], date='250205', 
                                  smooth=True, smooth_window_dict={'Heartrate': 300, 'BreathFreq': 300, 'OBGamma': 3000},
                                  colors={'Heartrate': '#8D0B41', 'BreathFreq':'#0A6847', 'OBGamma':'#205781'})


compute_and_plot_variable_correlations([data_hab], 1690, 'Heartrate', 'OBGamma')
r, p = compute_tsd_correlation(data_hab, 1690, '20250204', 'Heartrate', 'OBGamma')
print(f"r = {r:.3f}, p = {p:.3g}")

# %% Temperature test sessions 

expe_paths_test_temp = get_path_for_expe_cardiosense_habheadfixed_temperature('HabHeadFixed_Test_Temperature')

data_test_temp = load_variables_from_path(expe_paths_test_temp, variables, obgamma_subsample_ms=40)

color_test_temp = '#EF9651'
legend_test_temp = 'Test_HeatingPad'

plot_variable_distribution([data_test_temp], 1690, 'Heartrate', colors=color_test_temp, legends=legend_test_temp)
plot_variable_distribution([data_test_temp], 1690, 'BreathFreq', colors=color_test_temp, legends=legend_test_temp)

plot_variable_distribution([data_test_temp], 1711, 'Heartrate', colors=color_test_temp, legends=legend_test_temp)
plot_variable_distribution([data_test_temp], 1711, 'BreathFreq', colors=color_test_temp, legends=legend_test_temp)

# Compare temperature to last habituation session
plot_variable_distribution([data_hab, data_test_temp], 1690, 'Heartrate', 
                           dates=['250205', '250206', '250207', '250211'], ylim=(5,14),
                           colors=[color_hab, color_test_temp, color_test_temp, color_test_temp], 
                           legends=[legend_hab, legend_test_temp, legend_test_temp, legend_test_temp])

plot_variable_distribution([data_hab, data_test_temp], 1690, 'BreathFreq', 
                           dates=['250205', '250206', '250207', '250211'], ylim=(0,9),
                           colors=[color_hab, color_test_temp, color_test_temp, color_test_temp], 
                           legends=[legend_hab, legend_test_temp, legend_test_temp, legend_test_temp])

plot_variable_distribution([data_hab, data_test_temp], 1711, 'Heartrate', 
                           dates=['250205', '250206', '250207', '250210'], ylim=(5,14),
                           colors=[color_hab, color_test_temp, color_test_temp, color_test_temp], 
                           legends=[legend_hab, legend_test_temp, legend_test_temp, legend_test_temp])

plot_variable_distribution([data_hab, data_test_temp], 1711, 'BreathFreq', 
                           dates=['250205', '250206', '250207', '250210'], ylim=(0,9),
                           colors=[color_hab, color_test_temp, color_test_temp, color_test_temp], 
                           legends=[legend_hab, legend_test_temp, legend_test_temp, legend_test_temp])


# %% Temperature lamp sessions 

expe_paths_temp_basal = get_path_for_expe_cardiosense_habheadfixed_temperature('HeadFixed_Temperature_Basal')

data_temp_basal = load_variables_from_path(expe_paths_temp_basal, variables, obgamma_subsample_ms=40)

color_temp_basal = '#D2665A'
legend_temp_basal = 'No_heating'


expe_paths_temp_lamp = get_path_for_expe_cardiosense_habheadfixed_temperature('HeadFixed_Temperature_HeatingLamp')

data_temp_lamp = load_variables_from_path(expe_paths_temp_lamp, variables, obgamma_subsample_ms=40)

color_temp_lamp = '#B82132'
legend_temp_lamp = 'Heating_Lamp'

plot_variable_distribution([data_temp_basal, data_temp_lamp], 1690, 'Heartrate', 
                           dates=['250224', '250225', '250226', '250227', '250228'], ylim=(5,14),
                           colors=[color_temp_lamp, color_temp_lamp, color_temp_lamp, color_temp_basal, color_temp_basal], 
                           legends=[legend_temp_lamp, legend_temp_lamp, legend_temp_lamp, legend_temp_basal, legend_temp_basal])

plot_variable_distribution([data_temp_basal, data_temp_lamp], 1690, 'BreathFreq', 
                           dates=['250224', '250225', '250226', '250227', '250228'], ylim=(0,9),
                           colors=[color_temp_lamp, color_temp_lamp, color_temp_lamp, color_temp_basal, color_temp_basal], 
                           legends=[legend_temp_lamp, legend_temp_lamp, legend_temp_lamp, legend_temp_basal, legend_temp_basal])

plot_variable_distribution([data_temp_basal, data_temp_lamp], 1690, 'OBGamma', 
                           dates=['250224', '250225', '250226', '250227', '250228'],
                           colors=[color_temp_lamp, color_temp_lamp, color_temp_lamp, color_temp_basal, color_temp_basal], 
                           legends=[legend_temp_lamp, legend_temp_lamp, legend_temp_lamp, legend_temp_basal, legend_temp_basal])


plot_variable_distribution([data_temp_basal, data_temp_lamp], 1711, 'Heartrate', 
                           dates=['250224', '250225', '250226', '250227', '250228'], ylim=(5,14),
                           colors=[color_temp_lamp, color_temp_lamp, color_temp_lamp, color_temp_basal, color_temp_basal], 
                           legends=[legend_temp_lamp, legend_temp_lamp, legend_temp_lamp, legend_temp_basal, legend_temp_basal])

plot_variable_distribution([data_temp_basal, data_temp_lamp], 1711, 'BreathFreq', 
                           dates=['250224', '250225', '250226', '250227', '250228'], ylim=(0,9),
                           colors=[color_temp_lamp, color_temp_lamp, color_temp_lamp, color_temp_basal, color_temp_basal], 
                           legends=[legend_temp_lamp, legend_temp_lamp, legend_temp_lamp, legend_temp_basal, legend_temp_basal])

plot_variable_distribution([data_temp_basal, data_temp_lamp], 1711, 'OBGamma', 
                           dates=['250224', '250225', '250226', '250227', '250228'],
                           colors=[color_temp_lamp, color_temp_lamp, color_temp_lamp, color_temp_basal, color_temp_basal], 
                           legends=[legend_temp_lamp, legend_temp_lamp, legend_temp_lamp, legend_temp_basal, legend_temp_basal])


# %% Basal pre-injection

expe_paths_basal = get_path_for_expe_cardiosense_ivabradine('Basal_Pre-Injection')

data_basal = load_variables_from_path(expe_paths_basal, variables, obgamma_subsample_ms=40)

color_basal = '#E5D0AC'
legend_basal ='Basal_Pre-Injection'

plot_variable_distribution([data_basal], 1690, 'Heartrate', colors=color_basal, legends=legend_basal)
plot_variable_distribution([data_basal], 1690, 'BreathFreq', colors=color_basal, legends=legend_basal)
plot_variable_distribution([data_basal], 1690, 'OBGamma', colors=color_basal, legends=legend_basal)

plot_variable_distribution([data_basal], 1711, 'Heartrate', colors=color_basal, legends=legend_basal)
plot_variable_distribution([data_basal], 1711, 'BreathFreq', colors=color_basal, legends=legend_basal)
plot_variable_distribution([data_basal], 1711, 'OBGamma', colors=color_basal, legends=legend_basal)

# %% Injection Saline

expe_paths_sal = get_path_for_expe_cardiosense_ivabradine('Injection_Saline')

data_sal = load_variables_from_path(expe_paths_sal, variables, obgamma_subsample_ms=40)

color_sal = '#C1D8C3'
legend_sal = 'Saline'

plot_variable_distribution([data_sal], 1690, 'Heartrate', colors=color_sal, legends=legend_sal)
plot_variable_distribution([data_sal], 1690, 'BreathFreq', colors=color_sal, legends=legend_sal)

plot_variable_distribution([data_sal], 1711, 'Heartrate', colors=color_sal, legends=legend_sal)
plot_variable_distribution([data_sal], 1711, 'BreathFreq', colors=color_sal, legends=legend_sal)


# %% Injection Ivabradine 5mgkg

expe_paths_iva5 = get_path_for_expe_cardiosense_ivabradine('Injection_Ivabradine_5mgkg')

data_iva5 = load_variables_from_path(expe_paths_iva5, variables, obgamma_subsample_ms=40)

color_iva5 = '#6A9C89'
legend_iva5 = 'Ivab5'

plot_variable_distribution([data_iva5], 1690, 'Heartrate', ylim=(1.5,13.5), colors=color_iva5, legends=legend_iva5)
plot_variable_distribution([data_iva5], 1690, 'BreathFreq', colors=color_iva5, legends=legend_iva5)


# %% Injection Ivabradine 10mgkg

expe_paths_iva10 = get_path_for_expe_cardiosense_ivabradine('Injection_Ivabradine_10mgkg')

data_iva10 = load_variables_from_path(expe_paths_iva10, variables, obgamma_subsample_ms=40)

color_iva10 = '#3D8D7A'
legend_iva10 = 'Ivab10'

plot_variable_distribution([data_iva10], 1690, 'Heartrate', ylim=(1.5,13.5), colors=color_iva10, legends=legend_iva10)
plot_variable_distribution([data_iva10], 1690, 'BreathFreq', colors=color_iva10, legends=legend_iva10)


# %% Injection Ivabradine 20mgkg

expe_paths_iva20 = get_path_for_expe_cardiosense_ivabradine('Injection_Ivabradine_20mgkg')

data_iva20 = load_variables_from_path(expe_paths_iva20, variables, obgamma_subsample_ms=40)

color_iva20 = '#255F38'
legend_iva20 = 'Ivab20'

plot_variable_over_time([data_iva20], 1690, 'Heartrate', dates='250305', 
                        smooth=True, smooth_window=100,
                        colors=color_iva20, legends=legend_iva20)
plot_multiple_variables_over_time([data_iva20], 1690, ['Heartrate', 'BreathFreq','OBGamma'], date='250305', 
                                  smooth=True, smooth_window_dict={'Heartrate': 300, 'BreathFreq': 300, 'OBGamma': 3000},
                                  colors={'Heartrate': '#8D0B41', 'BreathFreq':'#0A6847', 'OBGamma':'#205781'})



plot_variable_distribution([data_iva20], 1690, 'Heartrate', ylim=(1.5,13.5), colors=color_iva20, legends=legend_iva20)
plot_variable_distribution([data_iva20], 1690, 'BreathFreq', colors=color_iva20, legends=legend_iva20)

plot_variable_distribution([data_iva20], 1711, 'Heartrate', ylim=(1,13), colors=color_iva20, legends=legend_iva20)
plot_variable_distribution([data_iva20], 1711, 'BreathFreq', colors=color_iva20, legends=legend_iva20)


# %% Compare saline and ivabradine

plot_variable_distribution([data_sal, data_iva5, data_iva10, data_iva20], 1690, 'Heartrate', 
                           dates = ['250304', '250313', '250311', '250312', '250305'], ylim=(1.5,13.5),
                           colors= [color_sal, color_sal, color_iva5, color_iva10, color_iva20],
                           legends= [legend_sal, legend_sal, legend_iva5, legend_iva10, legend_iva20])

plot_variable_distribution([data_sal, data_iva5, data_iva10, data_iva20], 1690, 'BreathFreq', 
                           dates = ['250304', '250313', '250311', '250312', '250305'], ylim=(0,9),
                           colors= [color_sal, color_sal, color_iva5, color_iva10, color_iva20],
                           legends= [legend_sal, legend_sal, legend_iva5, legend_iva10, legend_iva20])

plot_variable_distribution([data_sal, data_iva5, data_iva10, data_iva20], 1690, 'OBGamma', 
                           dates = ['250304', '250313', '250311', '250312', '250305'], ylim=(100,900),
                           colors= [color_sal, color_sal, color_iva5, color_iva10, color_iva20],
                           legends= [legend_sal, legend_sal, legend_iva5, legend_iva10, legend_iva20])


plot_variable_distribution([data_sal, data_iva20], 1711, 'Heartrate', 
                           dates = ['250304', '250305'], ylim=(1.5,13.5),
                           colors= [color_sal, color_iva20],
                           legends= [legend_sal, legend_iva20])

plot_variable_distribution([data_sal, data_iva20], 1711, 'BreathFreq', 
                           dates = ['250304', '250305'], ylim=(0,9),
                           colors= [color_sal, color_iva20],
                           legends= [legend_sal, legend_iva20])

plot_variable_distribution([data_sal, data_iva20], 1711, 'OBGamma', 
                           dates = ['250304', '250305'], ylim=(100,900),
                           colors= [color_sal, color_iva20],
                           legends= [legend_sal, legend_iva20])


plot_variable_distribution([data_sal, data_iva5, data_iva10, data_iva20], 1712, 'Heartrate', 
                           dates = ['250304', '250313', '250311', '250312', '250305'], ylim=(1.5,13.5),
                           colors= [color_sal, color_sal, color_iva5, color_iva10, color_iva20],
                           legends= [legend_sal, legend_sal, legend_iva5, legend_iva10, legend_iva20])

plot_variable_distribution([data_sal, data_iva5, data_iva10, data_iva20], 1712, 'BreathFreq', 
                           dates = ['250304', '250313', '250311', '250312', '250305'], ylim=(0,9),
                           colors= [color_sal, color_sal, color_iva5, color_iva10, color_iva20],
                           legends= [legend_sal, legend_sal, legend_iva5, legend_iva10, legend_iva20])

plot_variable_distribution([data_sal, data_iva5, data_iva10, data_iva20], 1712, 'OBGamma', 
                           dates = ['250304', '250313', '250311', '250312', '250305'], ylim=(100,900),
                           colors= [color_sal, color_sal, color_iva5, color_iva10, color_iva20],
                           legends= [legend_sal, legend_sal, legend_iva5, legend_iva10, legend_iva20])
