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
os.chdir(r'/home/gruffalo/Documents/Python/projects/data_Sophie/')

# Import necessary packages and modules
from load_data import load_dataframes
from plot_data_RNN import (
    plot_spike_count_heatmap, 
    plot_variable_conditions, 
    plot_class_violin,
    plot_decision_boundary
)
from analyse_data import spike_count_variable
from process_MLP_RNN import (
    create_data_variables,
)
from model_MLP import (
    train_and_evaluate_MLP
)
from save_plots import save_plot



# %% Load data

# Load data and needed modules
all_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/alldata'
maze_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/justmaze'
figures_directory = r'/home/gruffalo/Documents/Python/projects/data_Sophie/figures'

# Load variables and spike times for all mice during all recording sessions
all_mice_data, all_spike_times_data = load_dataframes(all_mat_directory)

# Load variables and spike times for all mice during the U-Maze session
maze_mice_data, maze_spike_times_data = load_dataframes(maze_mat_directory)


# %% Dataset visualization

# Violin plot of a variable across different conditions
VP1 = plot_variable_conditions(all_mice_data, 'Mouse507', 'BreathFreq',
                          ['Habituation_epo', 'SleepPre_epo', 'TestPre_epo',
                           'UMazeCond_epo', 'SleepPost_epo', 'TestPost_epo', 'Extinction_epo'])
save_plot(VP1, 'M507_VP_Maze_BreathFreq_test', figures_directory)

VP2 = plot_variable_conditions(all_mice_data, 'Mouse508', 'BreathFreq',
                          ['Habituation_epo', 'SleepPre_epo', 'TestPre_epo',
                           'UMazeCond_epo', 'SleepPost_epo', 'TestPost_epo', 'Extinction_epo'])
save_plot(VP2, 'M508_VP_Maze_BreathFreq', figures_directory)


VP3 = plot_variable_conditions(all_mice_data, 'Mouse508', 'BreathFreq',
                          ['NREMStartStop', 'REMStartStop', 'WakeStartStop', 'FzStartStop'])
save_plot(VP3, 'M508_VP_States_BreathFreq', figures_directory)


VP4 = plot_variable_conditions(all_mice_data, 'Mouse508', 'Heartrate',
                          ['NREMStartStop', 'REMStartStop', 'WakeStartStop', 'FzStartStop'])
save_plot(VP4, 'M508_VP_WakeSleep_Heartrate', figures_directory)


# Tuning curve of a neuron
Spikes_BR = spike_count_variable(all_mice_data, 'Mouse508', all_spike_times_data, 'BreathFreq')
TCB, _ = plot_spike_count_heatmap(Spikes_BR, 'Mouse508')
save_plot(TCB, 'M508_TC_BreathFreq', figures_directory)


Spikes_HR = spike_count_variable(all_mice_data, 'Mouse508', all_spike_times_data, 'Heartrate')
TCH, _ = plot_spike_count_heatmap(Spikes_HR, 'Mouse508')
save_plot(TCH, 'M508_TC_Heartrate', figures_directory)


# %% Classification

# %%% Can physiological variables help to classify between two given states of an animal?

# Create dataframe containing the physiological variables of interest labeled with the corresponing state
combined_df = create_data_variables(all_mice_data, 'Mouse507', ['WakeStartStop', 'NREMStartStop'], 
                                    variable_names=['Heartrate', 'BreathFreq'])

# %%% Is the data linearly separable?
# Try to fit a linear classifyer and plot the decision boundary
LS_Wake_NREM = plot_decision_boundary(combined_df, class_names=['Wake', 'NREM'], 
                                      variable_x='Heartrate', variable_y='BreathFreq')
save_plot(LS_Wake_NREM, 'M507_Linearsep_Wake_NREM', figures_directory)

VP_Wake_NREM = plot_class_violin(combined_df, class_names=['Wake', 'NREM'], 
                                 variable_x='Heartrate', variable_y='BreathFreq')
save_plot(VP_Wake_NREM, 'M507_VP_Wake_NREM', figures_directory)

# %%% Non-linear classifyer
# Train a MLP to separate between a given number of classes thanks to a given number of physiological variables
report, confmat = train_and_evaluate_MLP(all_mice_data, 'Mouse507', 
                       epoch_names=['WakeStartStop', 'NREMStartStop'], 
                       variable_names=['Heartrate', 'BreathFreq'], 
                       model_type='SimpleNN_3H')
save_plot(confmat, 'M507_Confmat_Wake_NREM', figures_directory)

report2, confmat2 = train_and_evaluate_MLP(all_mice_data, 'Mouse507', 
                       epoch_names=['FzStartStop', 'NREMStartStop'], 
                       variable_names=['Heartrate', 'BreathFreq'], 
                       model_type='SimpleNN_3H')
save_plot(confmat2, 'M507_Confmat_Fz_NREM', figures_directory)

report3, confmat3 = train_and_evaluate_MLP(all_mice_data, 'Mouse507', 
                       epoch_names=['FzStartStop', 'WakeStartStop'], 
                       variable_names=['Heartrate', 'BreathFreq'], 
                       model_type='SimpleNN_3H')
save_plot(confmat3, 'M507_Confmat_Fz_Wake', figures_directory)

report4, confmat4 = train_and_evaluate_MLP(all_mice_data, 'Mouse507', 
                       epoch_names=['FzStartStop', 'REMStartStop'], 
                       variable_names=['Heartrate', 'BreathFreq'], 
                       model_type='SimpleNN_3H')
save_plot(confmat4, 'M507_Confmat_Fz_REM', figures_directory)





