#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 16 14:57:18 2024

@author: gruffalo
"""

# %%

# Set working directory
import os
# os.chdir(r'/home/gruffalo/Dropbox/Mobs_member/EllaCallas/ADA_project/submitted')
os.chdir(r'/home/gruffalo/Documents/Python/project_pfc_visualize_data')

# Import necessary packages and modules
from load_data import load_dataframes
from preprocess_sort_data import (
    denoise_mice_data,
    create_sorted_column_replace_zeros
    )
from analyse_data import ( 
    spike_count,
    spike_count_variable,
    spike_count_variable_mean_std,
    )
from plot_physiological_data import (
    plot_variable_time,
    plot_variable_conditions,
    joyplot_variables_mice,
    save_plot
)
from plot_neural_data import (
    plot_scatter_neuron,
    plot_neuron_activity,
    plot_spike_count_heatmap
    )
from plot_data_linear_model import (
    compute_autocorrelation,
    compute_cross_correlation
    )

# %% Load data

# Load data and needed modules
all_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/alldata'
maze_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/justmaze'
figures_directory = r'/home/gruffalo/Documents/Python/project_pfc_visualize_data/figures'

# Load variables and spike times for all mice during all recording sessions
all_mice_data, all_spike_times_data = load_dataframes(all_mat_directory)

# Load variables and spike times for all mice during the U-Maze session
maze_mice_data, maze_spike_times_data = load_dataframes(maze_mat_directory)

# %% Preprocess data

# Denoise data
all_denoised_data = denoise_mice_data(all_mice_data, ['BreathFreq', 'Heartrate', 'timebins', 'Accelero', 'LinPos'])
maze_denoised_data = denoise_mice_data(maze_mice_data, ['BreathFreq', 'Heartrate', 'timebins', 'Accelero', 'Speed', 'LinPos'])

# Scaling problems between sleep and UMaze
create_sorted_column_replace_zeros(all_denoised_data, 'Mouse514', 'Accelero', replace=True)
create_sorted_column_replace_zeros(maze_denoised_data, 'Mouse514', 'Accelero', replace=True)


# %% Dataset visualization

# %%% Physiological variables

# Example usage
plot_variable_time(maze_denoised_data, 'Mouse508', 'Heartrate')
plot_variable_time(all_denoised_data, 'Mouse510', 'BreathFreq')


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
mouse_ids = ['Mouse507', 'Mouse508', 'Mouse510']  
variables = ['Heartrate', 'BreathFreq']     
fig, axes = joyplot_variables_mice(all_denoised_data, mouse_ids, variables)

# Auto-correlations and Cross-correlations

autocorr_values = compute_autocorrelation(maze_denoised_data, 'Mouse508', 'Heartrate', max_lag=500, time_step=0.2)
autocorr_values = compute_autocorrelation(maze_denoised_data, 'Mouse508', 'BreathFreq', max_lag=500, time_step=0.2)

cross_corr_values = compute_cross_correlation(all_denoised_data, 'Mouse508', 'Heartrate', 'BreathFreq', max_lag=500, time_step=0.2)

# %%% Neural variables

# Scatter plot of a specific neuron against a variable
spike_count_df = spike_count(maze_mice_data, 'Mouse508', maze_spike_times_data)
plot_scatter_neuron(maze_mice_data['Mouse508']['Heartrate'].values, spike_count_df['Neuron_16'].values, 'Heartrate', title='Neuron 16 vs HR M508')


# Tuning curve of a neuron
# Breathing Frequency
Spikes_meanstd_BR = spike_count_variable_mean_std(all_denoised_data, 'Mouse514', 
                                          all_spike_times_data, 'BreathFreq', 
                                          interval_step=0.3, min_value=2.5, max_value=11)
import numpy as np
for key in range(0,int((np.size(Spikes_meanstd_BR,1)-1)/2)):
    plot_neuron_activity(Spikes_meanstd_BR, 'Mouse514', f'Neuron_{key}', 'BreathFreq', show_std=True)

# Heart rate
Spikes_meanstd_BR = spike_count_variable_mean_std(all_denoised_data, 'Mouse510', 
                                          all_spike_times_data, 'Heartrate', 
                                          interval_step=0.3, min_value=8, max_value=13)
import numpy as np
for key in range(0,int((np.size(Spikes_meanstd_BR,1)-1)/2)):
    plot_neuron_activity(Spikes_meanstd_BR, 'Mouse510', f'Neuron_{key}', 'Heartrate', show_std=True)

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





