#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 26 11:11:11 2024

@author: gruffalo
"""

# %%

# Set working directory
import os
# os.chdir(r'/home/gruffalo/Dropbox/Mobs_member/EllaCallas/ADA_project/submitted')
os.chdir(r'/home/gruffalo/Documents/Python/project_pfc_deepnet_TCN/')

# Import necessary packages and modules
from load_data import load_dataframes
from preprocess_sort_data import (
        create_sorted_column_by_intervals,
        create_sorted_column_by_threshold,
        create_sorted_column_replace_zeros
        )
from model_LTCM import (
    prepare_data_for_mouse,
    LTCM, 
    train_ltcm,
    plot_losses,
    store_and_visualize_feature_maps,
    evaluate_model,
    visualize_predictions
    )
from model_LTCM_KFold_CV import (
    prepare_data_for_mouse_cv,
    kfold_cross_validation
    )

# %% Load data

# Load data and needed modules
all_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/alldata'
maze_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/justmaze'
figures_directory = r'/home/gruffalo/Documents/Python/project_pfc_deepnet_TCN/figures'

# Load variables and spike times for all mice during all recording sessions
all_mice_data, all_spike_times_data = load_dataframes(all_mat_directory)

# Load variables and spike times for all mice during the U-Maze session
maze_mice_data, maze_spike_times_data = load_dataframes(maze_mat_directory)


# %% Preprocess data

# High accelerometer values (unplugged mice)

intervals_507 = [(122661, 124783)]
create_sorted_column_by_intervals(all_mice_data, 'Mouse507', 'Accelero', intervals_507, replace=True)

intervals_510 = [(51585, 52099)]
create_sorted_column_by_intervals(all_mice_data, 'Mouse510', 'Accelero', intervals_510, replace=True)

intervals_512 = [(103493, 104690), (125409, 133528)]
create_sorted_column_by_intervals(all_mice_data, 'Mouse512', 'Accelero', intervals_512, replace=True)

# High speed value
create_sorted_column_by_threshold(maze_mice_data, 'Mouse508', 'Speed', 150, replace=True)

# Scaling problems between sleep and UMaze
create_sorted_column_replace_zeros(all_mice_data, 'Mouse514', 'Accelero', replace=True)


# %% Linear Temporal Convolutional Model

# Prepare data
mouse_id = 'Mouse508'
neuron_id = 'Neuron_16'
input_columns = ['Heartrate', 'BreathFreq']  
num_time_steps = 20

# %% Train the model with a single Cross-validation
train_loader, val_loader, test_loader = prepare_data_for_mouse(maze_mice_data, maze_spike_times_data, 
                                                               mouse_id, neuron_id, input_columns, 
                                                               num_time_steps)


# Initialize the LTCM model
model = LTCM(num_features=len(input_columns), num_time_steps=num_time_steps)

# Train the model
train_losses, val_losses, stored_feature_maps = train_ltcm(model, 
                                                           train_loader, val_loader, 
                                                           num_epochs=50, learning_rate=0.001)

# Plot training and validation losses
plot_losses(train_losses, val_losses)

# Visualize feature maps
store_and_visualize_feature_maps(stored_feature_maps, batch_num=2)


# Evaluate the model on the test set
true_spike_counts, predicted_spike_counts = evaluate_model(model, test_loader)

# Visualize predictions for the test set
visualize_predictions(true_spike_counts, predicted_spike_counts)


# %% Train the model with K-Fold Cross-validation
# Prepare the dataset for the specified mouse and neuron
dataset = prepare_data_for_mouse_cv(maze_mice_data, maze_spike_times_data,
                                 mouse_id, neuron_id, input_columns, num_time_steps)

# Perform K-fold cross-validation
avg_train_loss, avg_val_loss = kfold_cross_validation(k=5, dataset=dataset, model_class=LTCM, 
                                                      num_features=len(input_columns), 
                                                      num_time_steps=num_time_steps, num_epochs=50,
                                                      learning_rate=0.001)












