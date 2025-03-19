#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 16 14:57:18 2024

@author: gruffalo
"""

# %%

# Set working directory
# import os
# os.chdir(r'/home/gruffalo/PrgGithub/Ella/Python/projects/data_Sophie')

# Import necessary packages and modules
from load_save_results import load_results
from preprocess_sort_data import (
    rebin_mice_data
    )
from analyse_data import ( 
    spike_count,
    spike_count_all_mice,
    spike_count_variable,
    spike_count_variable_mean_std,
    )
from plot_physiological_data import (
    plot_variable_time,
    plot_variable_histogram,
    plot_variable_conditions,
    joyplot_variables_mice
)
from plot_neural_data import (
    plot_scatter_neuron,
    plot_neuron_activity,
    plot_spike_count_heatmap
    )
from plot_data_linear_model import (
    compute_cross_correlation
    )
from save_plots import save_plot

# %% Load data

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'
figures_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/figures/visualize_data'

maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')
all_denoised_data = load_results(load_path + 'all_denoised_data.pkl')

maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')
all_spike_times_data = load_results(load_path + 'all_spike_times_data.pkl')


# Rebin data
new_bin_size = 0.6
all_rebinned_data = rebin_mice_data(all_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'LinPos'], new_bin_size)
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)

# Compute spike counts
spike_counts = spike_count_all_mice(maze_rebinned_data, maze_spike_times_data)


# %% Dataset visualization

# %%% Physiological variables

# Across time
plot_variable_time(maze_denoised_data, 'Mouse508', 'Heartrate')
plot_variable_time(maze_rebinned_data, 'Mouse508', 'Heartrate')

plot_variable_time(all_denoised_data, 'Mouse510', 'BreathFreq')

# Histograms
plot_variable_histogram(maze_denoised_data, 'Mouse508', 'Heartrate', bins=50)
plot_variable_histogram(maze_rebinned_data, 'Mouse508', 'Heartrate', bins=50)

plot_variable_histogram(maze_denoised_data, 'Mouse508', 'BreathFreq', bins=50)
plot_variable_histogram(maze_rebinned_data, 'Mouse508', 'BreathFreq', bins=50)


# Violin plot of a variable across different conditions
VP1 = plot_variable_conditions(all_denoised_data, 'Mouse507', 'BreathFreq',
                          ['Habituation_epo', 'SleepPre_epo', 'TestPre_epo',
                           'UMazeCond_epo', 'SleepPost_epo', 'TestPost_epo', 'Extinction_epo'])
save_plot(VP1, 'M507_VP_Maze_BreathFreq_test', figures_directory)


VP2 = plot_variable_conditions(all_denoised_data, 'Mouse508', 'BreathFreq',
                          ['Habituation_epo', 'SleepPre_epo', 'TestPre_epo',
                           'UMazeCond_epo', 'SleepPost_epo', 'TestPost_epo', 'Extinction_epo'])
save_plot(VP2, 'M508_VP_Maze_BreathFreq', figures_directory)


VP3 = plot_variable_conditions(all_denoised_data, 'Mouse508', 'BreathFreq',
                          ['NREMStartStop', 'REMStartStop', 'WakeStartStop', 'FzStartStop'])
save_plot(VP3, 'M508_VP_States_BreathFreq', figures_directory)


VP4 = plot_variable_conditions(all_denoised_data, 'Mouse508', 'Heartrate',
                          ['NREMStartStop', 'REMStartStop', 'WakeStartStop', 'FzStartStop'])
save_plot(VP4, 'M508_VP_WakeSleep_Heartrate', figures_directory)


# Joy plot for a variable across different mice
mouse_ids = ['Mouse507', 'Mouse508', 'Mouse509', 'Mouse510']  
variables = ['Heartrate', 'BreathFreq']     
fig, axes = joyplot_variables_mice(all_denoised_data, mouse_ids, variables)

# Auto-correlations and Cross-correlations
max_lag=10
compute_cross_correlation(maze_denoised_data, 'Mouse508', 'Heartrate', 'Heartrate', max_lag=max_lag, time_step=0.2)
compute_cross_correlation(maze_denoised_data, 'Mouse508', 'BreathFreq', 'BreathFreq', max_lag=max_lag, time_step=0.2)
compute_cross_correlation(maze_denoised_data, 'Mouse508', 'Heartrate', 'BreathFreq', max_lag=max_lag, time_step=0.2)

compute_cross_correlation(all_denoised_data, 'Mouse508', 'Heartrate', 'BreathFreq', max_lag=max_lag, time_step=0.2)

compute_cross_correlation(all_denoised_data, 'Mouse508', 'Heartrate', 'BreathFreq', max_lag=max_lag, time_step=0.2, epoch='NREMStartStop')
compute_cross_correlation(all_denoised_data, 'Mouse508', 'Heartrate', 'BreathFreq', max_lag=max_lag, time_step=0.2, epoch='WakeStartStop')
compute_cross_correlation(all_denoised_data, 'Mouse508', 'Heartrate', 'BreathFreq', max_lag=max_lag, time_step=0.2, epoch='FzStartStop')


# %%% Neural variables

# Scatter plot of a specific neuron against a variable
spike_count_df = spike_count(maze_denoised_data, 'Mouse508', maze_spike_times_data)
plot_scatter_neuron(maze_denoised_data['Mouse508']['Heartrate'].values, spike_count_df['Neuron_16'].values, 'Heartrate', title='Neuron 16 vs HR M508')


# Tuning curve of a neuron
# Breathing Frequency
Spikes_meanstd_BR = spike_count_variable_mean_std(all_denoised_data, 'Mouse508', 
                                          all_spike_times_data, 'BreathFreq', 
                                          interval_step=0.3, min_value=2.5, max_value=11)

import numpy as np
for key in range(0,int((np.size(Spikes_meanstd_BR,1)-1)/2)):
    plot_neuron_activity(Spikes_meanstd_BR, 'Mouse514', f'Neuron_{key}', 'BreathFreq', show_std=True)

# Heart rate
Spikes_meanstd_HR = spike_count_variable_mean_std(all_denoised_data, 'Mouse508', 
                                          all_spike_times_data, 'Heartrate', 
                                          interval_step=0.3, min_value=8, max_value=13)
import numpy as np
for key in range(0,int((np.size(Spikes_meanstd_BR,1)-1)/2)):
    plot_neuron_activity(Spikes_meanstd_HR, 'Mouse510', f'Neuron_{key}', 'Heartrate', show_std=True)

# Tuning curve of all neurons for a given mouse
Spikes_BR = spike_count_variable(all_denoised_data, 'Mouse508', 
                                 all_spike_times_data, 'BreathFreq',
                                 interval_step=0.3, min_value=2.5, max_value=11)
heatmapBF, _ = plot_spike_count_heatmap(Spikes_BR, 'Mouse508')
save_plot(heatmapBF, 'M508_HM_BreathFreq', figures_directory)


Spikes_HR = spike_count_variable(all_denoised_data, 'Mouse508', 
                                 all_spike_times_data, 'Heartrate',
                                 interval_step=0.3, min_value=8, max_value=13)
heatmapHR, _ = plot_spike_count_heatmap(Spikes_HR, 'Mouse508')
save_plot(heatmapHR, 'M508_HM_Heartrate', figures_directory)





