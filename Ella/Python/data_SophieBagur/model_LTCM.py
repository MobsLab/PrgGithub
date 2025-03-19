#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 26 11:49:05 2024

@author: gruffalo
"""

import torch
import torch.nn as nn
import matplotlib.pyplot as plt
import numpy as np
from torch.utils.data import DataLoader, TensorDataset
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error, r2_score

from analyse_data import spike_count


# LTCM Model
class LTCM(nn.Module):
    def __init__(self, num_features, num_time_steps, kernel_size=3, padding=1):
        super().__init__()
        self.conv1d = nn.Conv1d(in_channels=num_features, out_channels=1, kernel_size=kernel_size, padding=padding)

    def forward(self, x):
        x = x.permute(0, 2, 1)  # [batch_size, num_features, num_time_steps]
        conv_out = self.conv1d(x)  # Feature maps after convolution
        avg_out = conv_out.mean(dim=2)  # Averaging over time to get a single output per sequence
        return avg_out, conv_out  # Return both the final output and feature maps


def prepare_data_for_mouse(mice_data, spike_times_data, mouse_id, neuron_id, input_columns, num_time_steps, val_split=0.2, test_split=0.1):
    """
    Prepares data for a given mouse and neuron for LTCM model training with Min-Max Normalization, including train, validation, and test sets.

    Parameters:
    mice_data (dict): Dictionary containing physiological data for each mouse.
    spike_times_data (dict): Dictionary containing spike times data for each neuron.
    mouse_id (str): The ID of the mouse (e.g., 'Mouse508').
    neuron_id (str): The ID of the neuron column in spike_count_df (e.g., 'Neuron_16').
    input_columns (list): List of physiological variables (e.g., ['Heartrate', 'BreathFreq']).
    num_time_steps (int): The number of time steps to use for input sequences.
    val_split (float): Fraction of data to use for validation (default 0.2).
    test_split (float): Fraction of data to use for testing (default 0.1).

    Returns:
    tuple: DataLoaders for training, validation, and test sets.
    """
    # Extract physiological data for the specified mouse
    physiological_data = mice_data[mouse_id][input_columns].values
    spike_count_df = spike_count(mice_data, mouse_id, spike_times_data)
    spike_counts = spike_count_df[neuron_id].values

    assert len(physiological_data) == len(spike_counts), "Mismatch in sample size."
    
    # Apply Min-Max normalization
    scaler = MinMaxScaler()
    physiological_data = scaler.fit_transform(physiological_data)  # Normalized data
    
    # Convert physiological data and spike counts into torch tensors
    X = torch.tensor(physiological_data, dtype=torch.float32)
    y = torch.tensor(spike_counts, dtype=torch.float32).view(-1, 1)
    
    # Prepare sequences of input features (time-series) and their corresponding labels
    X_seq, y_seq = [], []
    for i in range(num_time_steps, len(X)):
        X_seq.append(X[i - num_time_steps:i].numpy())
        y_seq.append(y[i].numpy())
    
    X_seq = torch.tensor(np.array(X_seq), dtype=torch.float32)
    y_seq = torch.tensor(np.array(y_seq), dtype=torch.float32)
    
    # Split the data into train, validation, and test sets
    X_train, X_temp, y_train, y_temp = train_test_split(X_seq, y_seq, test_size=val_split + test_split, shuffle=False)
    X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=test_split / (val_split + test_split), shuffle=False)

    # Create datasets and dataloaders
    train_loader = DataLoader(TensorDataset(X_train, y_train), batch_size=16, shuffle=True)
    val_loader = DataLoader(TensorDataset(X_val, y_val), batch_size=16, shuffle=False)
    test_loader = DataLoader(TensorDataset(X_test, y_test), batch_size=16, shuffle=False)

    return train_loader, val_loader, test_loader



# Training Function with Validation
def train_ltcm(model, train_loader, val_loader, num_epochs=50, learning_rate=0.001):
    """
    Train a model using training data, evaluate it on validation data, and store the feature maps for visualization.
    
    Parameters:
    model (nn.Module): The PyTorch model to be trained.
    train_loader (DataLoader): DataLoader containing the training dataset.
    val_loader (DataLoader): DataLoader containing the validation dataset.
    num_epochs (int): The number of epochs to train the model (default=50).
    learning_rate (float): Learning rate for the Adam optimizer (default=0.001).

    Returns:
    tuple: Two lists containing the training and validation losses across epochs, and a dictionary of stored feature maps.
    """
    
    criterion = nn.MSELoss()  # Loss function: Mean Squared Error Loss
    optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate, weight_decay=0.001)  # Adam optimizer with weight decay (L2 regularization)

    train_losses = []  # List to store training loss for each epoch
    val_losses = []  # List to store validation loss for each epoch

    stored_feature_maps = []  # List to store feature maps for each batch during training
    
    for epoch in range(num_epochs):
        model.train()  # Set model to training mode
        train_loss = 0.0  # Initialize training loss for this epoch
        
        # Training loop over each batch in the train_loader
        for inputs, targets in train_loader:
            optimizer.zero_grad()  # Clear the previous gradients
            outputs, feature_maps = model(inputs)  # Unpack the final output and feature maps
            loss = criterion(outputs, targets)  # Compute loss using the final output
            loss.backward()  # Backpropagate to compute gradients
            optimizer.step()  # Update model parameters
            train_loss += loss.item()  # Accumulate training loss

            # Store feature maps for the current batch
            stored_feature_maps.append(feature_maps.detach().cpu().numpy())

        train_losses.append(train_loss / len(train_loader))  # Average training loss for the epoch

        # Validation phase (no gradient computation)
        model.eval()  # Set model to evaluation mode
        val_loss = 0.0  # Initialize validation loss for this epoch
        with torch.no_grad():  # Disable gradient calculation for validation
            for inputs, targets in val_loader:
                outputs, _ = model(inputs)  # Unpack the final output and feature maps
                loss = criterion(outputs, targets)  # Compute validation loss using the final output
                val_loss += loss.item()  # Accumulate validation loss

        val_losses.append(val_loss / len(val_loader))  # Average validation loss for the epoch

        # Print the losses for both training and validation at the end of each epoch
        print(f"Epoch [{epoch+1}/{num_epochs}], Train Loss: {train_losses[-1]:.4f}, Val Loss: {val_losses[-1]:.4f}")

    return train_losses, val_losses, stored_feature_maps  # Return lists of training and validation losses and feature maps


# Function to plot the losses
def plot_losses(train_losses, val_losses):
    """
    Plot the training and validation losses over epochs.

    This function takes the lists of training and validation losses collected during
    the model's training process and plots them against the number of epochs.

    Parameters:
    train_losses (list): List containing the training losses for each epoch.
    val_losses (list): List containing the validation losses for each epoch.

    Returns:
    None: The function will display the plot but does not return any value.
    """
    
    plt.figure(figsize=(10, 6))  # Create a new figure with specified size
    plt.plot(train_losses, label='Train Loss')  # Plot training losses
    plt.plot(val_losses, label='Validation Loss')  # Plot validation losses
    plt.xlabel('Epochs')  # Label for x-axis (epochs)
    plt.ylabel('Loss')  # Label for y-axis (loss values)
    plt.title('Training and Validation Loss over Epochs')  # Plot title
    plt.legend()  # Add a legend to distinguish between train/validation losses
    plt.show()  # Display the plot


def store_and_visualize_feature_maps(stored_feature_maps, batch_num=0, feature_map_num=None):
    """
    Visualize precomputed feature maps for all batches. Allows the user to select
    which batch and feature map to visualize. If no specific feature map is chosen,
    all feature maps in the batch are visualized.

    Parameters:
    stored_feature_maps (list): List containing feature maps for each batch.
    batch_num (int): The batch number to visualize (default=0).
    feature_map_num (int or None): The specific feature map to visualize in the selected batch (default=None).
                                   If None, all feature maps are visualized for the batch.
    """
    # Check if there are feature maps to plot
    if len(stored_feature_maps) == 0:
        print("No feature maps found to visualize.")
        return
    
    # Ensure the specified batch exists
    if batch_num >= len(stored_feature_maps):
        print(f"Batch number {batch_num} exceeds available batches. Only {len(stored_feature_maps)} batches stored.")
        return

    # Get the feature maps for the specified batch
    feature_maps_batch = stored_feature_maps[batch_num]
    print(f"Feature maps for batch {batch_num} have shape: {feature_maps_batch.shape}")
    
    num_feature_maps = feature_maps_batch.shape[0]
    print(f"Visualizing batch {batch_num} with {num_feature_maps} feature maps.")
    
    # If no specific feature map is selected, visualize all feature maps in this batch
    if feature_map_num is None:
        plt.figure(figsize=(10, 5))
        for i in range(num_feature_maps):
            plt.plot(feature_maps_batch[i].squeeze(), label=f"Feature Map {i+1}")  # Squeeze to ensure correct shape
        plt.title(f'All Feature Maps for Batch {batch_num}')
        plt.xlabel('Time Steps')
        plt.ylabel('Activation')
        plt.legend()
        plt.show()
    else:
        # Ensure the specified feature map exists
        if feature_map_num >= num_feature_maps:
            print(f"Feature map number {feature_map_num} exceeds available feature maps in batch {batch_num}.")
            return
        
        # Plot the specified feature map
        plt.figure(figsize=(10, 5))
        plt.plot(feature_maps_batch[feature_map_num].squeeze(), label=f"Feature Map {feature_map_num + 1}")  # Squeeze to correct shape
        plt.title(f'Feature Map {feature_map_num + 1} for Batch {batch_num}')
        plt.xlabel('Time Steps')
        plt.ylabel('Activation')
        plt.legend()
        plt.show()


def evaluate_model(model, val_loader):
    """
    Evaluate the trained model on the validation set by calculating prediction metrics
    like Mean Squared Error (MSE) and R-squared (R²).

    Parameters:
    model (nn.Module): The trained PyTorch model.
    val_loader (DataLoader): DataLoader containing the validation dataset.

    Returns:
    tuple: The true spike counts and predicted spike counts for further visualization.
    """
    model.eval()  # Set model to evaluation mode
    true_spike_counts = []
    predicted_spike_counts = []

    with torch.no_grad():  # Disable gradient calculation
        for inputs, targets in val_loader:
            outputs, _ = model(inputs)  # Get model predictions
            true_spike_counts.extend(targets.cpu().numpy())  # Store true values
            predicted_spike_counts.extend(outputs.cpu().numpy())  # Store predicted values

    # Convert lists to numpy arrays for metric calculations
    true_spike_counts = np.array(true_spike_counts)
    predicted_spike_counts = np.array(predicted_spike_counts)

    # Calculate Mean Squared Error (MSE) and R-squared (R²)
    mse = mean_squared_error(true_spike_counts, predicted_spike_counts)
    r2 = r2_score(true_spike_counts, predicted_spike_counts)

    print(f"Mean Squared Error (MSE): {mse:.4f}")
    print(f"R-squared (R²): {r2:.4f}")

    return true_spike_counts, predicted_spike_counts


def visualize_predictions(true_spike_counts, predicted_spike_counts):
    """
    Visualize the true vs. predicted spike counts using scatter plot and time-series plot.
    
    Parameters:
    true_spike_counts (numpy array): The actual spike counts.
    predicted_spike_counts (numpy array): The predicted spike counts.
    """
    # Scatter plot: True vs. Predicted spike counts
    plt.figure(figsize=(10, 6))
    plt.scatter(true_spike_counts, predicted_spike_counts, label='Predicted vs True', alpha=0.6)
    plt.plot([min(true_spike_counts), max(true_spike_counts)], [min(true_spike_counts), max(true_spike_counts)], color='red', label='Perfect Fit')  # Diagonal line
    plt.xlabel('True Spike Counts')
    plt.ylabel('Predicted Spike Counts')
    plt.title('True vs. Predicted Spike Counts')
    plt.legend()
    plt.show()

    # Time-series plot: True and Predicted spike counts over time
    plt.figure(figsize=(12, 6))
    plt.plot(true_spike_counts, label='True Spike Counts')
    plt.plot(predicted_spike_counts, label='Predicted Spike Counts', linestyle='--')
    plt.xlabel('Time Steps')
    plt.ylabel('Spike Counts')
    plt.title('True vs. Predicted Spike Counts Over Time')
    plt.legend()
    plt.show()


# from torch.utils.data import DataLoader, TensorDataset, random_split

# def prepare_data_for_mouse(mice_data, spike_times_data, mouse_id, neuron_id, input_columns, num_time_steps, val_split=0.2):
#     """
#     Prepares data for a given mouse and neuron for LTCM model training with Min-Max Normalization.
    
#     Parameters:
#     mice_data (dict): Dictionary containing physiological data for each mouse.
#     spike_times_data (dict): Dictionary containing spike times data for each neuron.
#     mouse_id (str): The ID of the mouse (e.g., 'Mouse508').
#     neuron_id (str): The ID of the neuron column in spike_count_df (e.g., 'Neuron_16').
#     input_columns (list): List of physiological variables (e.g., ['Heartrate', 'BreathFreq']).
#     num_time_steps (int): The number of time steps to use for input sequences.
#     val_split (float): Fraction of data to use for validation (default 0.2).
    
#     Returns:
#     DataLoader: DataLoader with the physiological input features and neuron spike counts.
#     """
#     # Extract physiological data for the specified mouse
#     physiological_data = mice_data[mouse_id][input_columns].values
#     spike_count_df = spike_count(mice_data, mouse_id, spike_times_data)
#     spike_counts = spike_count_df[neuron_id].values

#     assert len(physiological_data) == len(spike_counts), "Mismatch in sample size."
    
#     # Apply Min-Max normalization
#     scaler = MinMaxScaler()
#     physiological_data = scaler.fit_transform(physiological_data)  # Normalized data
    
#     # Convert physiological data and spike counts into torch tensors
#     X = torch.tensor(physiological_data, dtype=torch.float32)
#     y = torch.tensor(spike_counts, dtype=torch.float32).view(-1, 1)
    
#     # Prepare sequences of input features (time-series) and their corresponding labels
#     X_seq, y_seq = [], []
#     for i in range(num_time_steps, len(X)):
#         X_seq.append(X[i - num_time_steps:i].numpy())
#         y_seq.append(y[i].numpy())
    
#     X_seq = torch.tensor(np.array(X_seq), dtype=torch.float32)
#     y_seq = torch.tensor(np.array(y_seq), dtype=torch.float32)
    
#     # Create a dataset and split it into training and validation sets
#     dataset = TensorDataset(X_seq, y_seq)
#     train_size = int((1 - val_split) * len(dataset))
#     val_size = len(dataset) - train_size
#     train_dataset, val_dataset = random_split(dataset, [train_size, val_size])
    
#     train_loader = DataLoader(train_dataset, batch_size=16, shuffle=True)
#     val_loader = DataLoader(val_dataset, batch_size=16, shuffle=False)

#     return train_loader, val_loader
