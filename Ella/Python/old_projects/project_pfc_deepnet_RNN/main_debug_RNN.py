#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 16 17:10:38 2024

@author: gruffalo
"""


# %%

import os
# os.chdir(r'/home/gruffalo/Dropbox/Mobs_member/EllaCallas/ADA_project/submitted')
os.chdir(r'/home/gruffalo/Documents/Python/project_pfc_deepnet')

# Import necessary packages and modules
from load_data import load_dataframes
from process_NN import (
    preprocess_data_RNN, 
)
from model_RNN import (
    RNNNeuralPredictor,
    create_data_loaders,
    train_model,
    create_sliding_data_loaders,
    train_model_with_sliding_windows,
    plot_losses
)

# %% Load data

# Load data and needed modules
all_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/alldata'
maze_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/justmaze'
figures_directory = r'/home/gruffalo/Documents/Python/project_pfc_deepnet/figures'

# Load variables and spike times for all mice during all recording sessions
all_mice_data, all_spike_times_data = load_dataframes(all_mat_directory)

# Load variables and spike times for all mice during the U-Maze session
maze_mice_data, maze_spike_times_data = load_dataframes(maze_mat_directory)

# Creating dataset
features_df, spikes_df = preprocess_data_RNN(maze_mice_data, 'Mouse508', maze_spike_times_data, 
                                             features=['Accelero', 'BreathFreq', 'Heartrate', 'LinPos'])


# %%

# Hyperparameters
seq_length = 10
batch_size = 32
num_epochs = 50
learning_rate = 0.0001

# Initialize model
input_size = features_df.shape[1]  # Number of input features
num_layers = 1
hidden_size = 1  # You can adjust this
output_size = spikes_df.shape[1]  # Number of neurons

model = RNNNeuralPredictor(input_size=input_size, hidden_size=hidden_size, 
                           output_size=output_size, num_layers=num_layers)


# %% Random split

# Assuming features_df and spikes_df are your dataframes
train_loader, val_loader = create_data_loaders(features_df, spikes_df, seq_length, batch_size)


# Train the model and track losses
train_losses, val_losses = train_model(model, train_loader, val_loader, 
                                       num_epochs=num_epochs, learning_rate=learning_rate)


# Plot the losses
plot_losses(train_losses, val_losses)


# %% Sliding window cross-validation

window_size = 200
step_size = 50

# Create sliding window data loaders
sliding_loaders = create_sliding_data_loaders(features_df, spikes_df, seq_length, window_size, step_size, batch_size)

# Train the model with sliding windows
train_losses, val_losses = train_model_with_sliding_windows(model, sliding_loaders, num_epochs, learning_rate)

# Plot the losses
plot_losses(train_losses, val_losses)

# Add prediction part and visualization of predicted data












