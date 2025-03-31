#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 26 17:05:01 2024

@author: gruffalo
"""

from sklearn.model_selection import KFold
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset
from sklearn.preprocessing import MinMaxScaler
from analyse_data import spike_count


# LTCM Model
class LTCM(nn.Module):
    def __init__(self, num_features, num_time_steps, kernel_size=3, padding=1):
        super().__init__()
        self.conv1d = nn.Conv1d(in_channels=num_features, out_channels=1, kernel_size=kernel_size, padding=padding)

    def forward(self, x):
        x = x.permute(0, 2, 1)  # [batch_size, num_features, num_time_steps]
        conv_out = self.conv1d(x)
        conv_out = conv_out.mean(dim=2)  # Averaging over time to get a single output per sequence
        return conv_out


# Function to prepare the data
def prepare_data_for_mouse_cv(mice_data, spike_times_data, mouse_id, neuron_id, input_columns, num_time_steps):
    """
    Prepares the dataset for K-fold cross-validation by creating input sequences and normalizing the data.
    """
    # Extract physiological data and spike counts for the specified mouse and neuron
    physiological_data = mice_data[mouse_id][input_columns].values
    spike_count_df = spike_count(mice_data, mouse_id, spike_times_data)
    spike_counts = spike_count_df[neuron_id].values

    assert len(physiological_data) == len(spike_counts), "Mismatch in sample size."

    # Normalize the physiological data
    scaler = MinMaxScaler()
    physiological_data = scaler.fit_transform(physiological_data)

    # Convert to tensors
    X = torch.tensor(physiological_data, dtype=torch.float32)
    y = torch.tensor(spike_counts, dtype=torch.float32).view(-1, 1)

    # Prepare sequences and labels
    X_seq, y_seq = [], []
    for i in range(num_time_steps, len(X)):
        X_seq.append(X[i - num_time_steps:i].numpy())
        y_seq.append(y[i].numpy())

    X_seq = torch.tensor(X_seq, dtype=torch.float32)
    y_seq = torch.tensor(y_seq, dtype=torch.float32)

    # Create a dataset
    dataset = TensorDataset(X_seq, y_seq)

    return dataset


# K-Fold Cross-Validation Function
def kfold_cross_validation(k, dataset, model_class, num_features, num_time_steps, num_epochs=50, learning_rate=0.001):
    """
    Implements K-fold cross-validation for the model.

    Parameters:
    k (int): The number of folds.
    dataset (TensorDataset): The dataset to be split into folds.
    model_class: The model class to instantiate for each fold.
    num_features (int): The number of input features.
    num_time_steps (int): The number of time steps used in each input sequence.
    num_epochs (int): The number of training epochs.
    learning_rate (float): Learning rate for the Adam optimizer.

    Returns:
    tuple: Average training and validation losses across all folds.
    """

    kf = KFold(n_splits=k, shuffle=True)  # Shuffle data before splitting into k folds
    fold_train_losses = []
    fold_val_losses = []

    for fold, (train_idx, val_idx) in enumerate(kf.split(dataset)):
        print(f"Fold {fold+1}/{k}")

        # Split dataset into training and validation sets for this fold
        train_subset = torch.utils.data.Subset(dataset, train_idx)
        val_subset = torch.utils.data.Subset(dataset, val_idx)
        train_loader = DataLoader(train_subset, batch_size=16, shuffle=False)
        val_loader = DataLoader(val_subset, batch_size=16, shuffle=False)

        # Initialize a new instance of the model for each fold
        model = model_class(num_features=num_features, num_time_steps=num_time_steps)
        
        # Train the model for the current fold
        train_losses, val_losses = train_ltcm_cv(model, train_loader, val_loader, num_epochs, learning_rate)

        # Store the losses for this fold
        fold_train_losses.append(train_losses[-1])  # Save the last training loss of this fold
        fold_val_losses.append(val_losses[-1])  # Save the last validation loss of this fold

    # Calculate the average losses across all folds
    avg_train_loss = sum(fold_train_losses) / k
    avg_val_loss = sum(fold_val_losses) / k

    print(f"Average Train Loss: {avg_train_loss:.4f}, Average Val Loss: {avg_val_loss:.4f}")

    return avg_train_loss, avg_val_loss


# Training Function with Validation
def train_ltcm_cv(model, train_loader, val_loader, num_epochs=50, learning_rate=0.001):
    """
    Train a model using cross-validation and return training and validation losses.

    Parameters:
    model (nn.Module): The PyTorch model to be trained.
    train_loader (DataLoader): DataLoader containing the training dataset.
    val_loader (DataLoader): DataLoader containing the validation dataset.
    num_epochs (int): The number of epochs to train the model (default=50).
    learning_rate (float): Learning rate for the Adam optimizer (default=0.001).

    Returns:
    tuple: Two lists containing the training and validation losses across epochs.
    """
    
    criterion = nn.MSELoss()  # Loss function: Mean Squared Error Loss
    optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate, weight_decay=0.001)  # Adam optimizer with weight decay (L2 regularization)

    train_losses = []  # List to store training loss for each epoch
    val_losses = []  # List to store validation loss for each epoch

    for epoch in range(num_epochs):
        model.train()  # Set model to training mode
        train_loss = 0.0  # Initialize training loss for this epoch
        
        # Training loop over each batch in the train_loader
        for inputs, targets in train_loader:
            optimizer.zero_grad()  # Clear the previous gradients
            outputs, _ = model(inputs)  # Unpack the final output and feature maps; ignore feature maps
            loss = criterion(outputs, targets)  # Compute loss using the final output (avg_out)
            loss.backward()  # Backpropagate to compute gradients
            optimizer.step()  # Update model parameters
            train_loss += loss.item()  # Accumulate training loss

        train_losses.append(train_loss / len(train_loader))  # Average training loss for the epoch

        # Validation phase (no gradient computation)
        model.eval()  # Set model to evaluation mode
        val_loss = 0.0  # Initialize validation loss for this epoch
        with torch.no_grad():  # Disable gradient calculation for validation
            for inputs, targets in val_loader:
                outputs, _ = model(inputs)  # Unpack the final output and feature maps; ignore feature maps
                loss = criterion(outputs, targets)  # Compute validation loss using the final output (avg_out)
                val_loss += loss.item()  # Accumulate validation loss

        val_losses.append(val_loss / len(val_loader))  # Average validation loss for the epoch

        # Print the losses for both training and validation at the end of each epoch
        print(f"Epoch [{epoch+1}/{num_epochs}], Train Loss: {train_losses[-1]:.4f}, Val Loss: {val_losses[-1]:.4f}")

    return train_losses, val_losses  # Return lists of training and validation losses




