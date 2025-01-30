#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 17 10:20:59 2024

@author: gruffalo
"""

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

# %%

class NeuralActivityDataset(Dataset):
    def __init__(self, features_df, spikes_df, seq_length):
        """
        Initialize the dataset with features, spikes, and sequence length.
        
        Parameters:
        - features_df (pd.DataFrame): DataFrame containing input features (e.g., accelerometer, heart rate).
        - spikes_df (pd.DataFrame): DataFrame containing output neural spikes (neural activity).
        - seq_length (int): Number of timepoints to include in each sequence.
        """
        self.features = torch.tensor(features_df.values, dtype=torch.float32)
        self.spikes = torch.tensor(spikes_df.values, dtype=torch.float32)
        self.seq_length = seq_length

    def __len__(self):
        """Return the total number of sequences."""
        return len(self.features) - self.seq_length + 1

    def __getitem__(self, idx):
        """
        Return one sequence of features and corresponding spikes.
        A sequence consists of 'seq_length' timepoints.
        """
        # Extract the sequence of features and the corresponding spikes
        feature_seq = self.features[idx:idx + self.seq_length]
        spike_seq = self.spikes[idx:idx + self.seq_length]
        
        return feature_seq, spike_seq


class RNNNeuralPredictor(nn.Module):
    def __init__(self, input_size, hidden_size, output_size, num_layers=1):
        """
        Initialize the RNN-based neural activity predictor.
        
        Parameters:
        - input_size (int): Number of input features (e.g., 4 if Accelero, BreathFreq, etc.).
        - hidden_size (int): Number of units in the RNN's hidden layer (you can experiment with this).
        - output_size (int): Number of neurons whose activity we are predicting.
        - num_layers (int): Number of RNN layers (default is 1).
        """
        super(RNNNeuralPredictor, self).__init__()

        # Define the RNN layer: processes input sequences
        self.rnn = nn.RNN(input_size=input_size, hidden_size=hidden_size, num_layers=num_layers, batch_first=True)

        # Fully connected layer: maps the RNN output to neuron activity prediction
        self.fc = nn.Linear(hidden_size, output_size)

    def forward(self, x):
        """
        Perform a forward pass through the RNN model.
        
        Parameters:
        - x (torch.Tensor): Input tensor of shape (batch_size, sequence_length, input_size).
        
        Returns:
        - output (torch.Tensor): Predicted neural activity for each timepoint in the sequence.
        """
        # Pass the input through the RNN layer
        rnn_out, _ = self.rnn(x)

        # Pass the RNN's output through the fully connected layer
        output = self.fc(rnn_out)
        return output
    
# %%

def create_data_loaders(features_df, spikes_df, seq_length, batch_size, val_split=0.2):
    """
    Create DataLoader objects for training and validation datasets.

    Parameters:
    - features_df (pd.DataFrame): Input features DataFrame.
    - spikes_df (pd.DataFrame): Target spikes DataFrame.
    - seq_length (int): Sequence length for the RNN.
    - batch_size (int): Batch size for training.
    - val_split (float): Fraction of data to use for validation.

    Returns:
    - train_loader (DataLoader): DataLoader for training set.
    - val_loader (DataLoader): DataLoader for validation set.
    """
    # Split the data into training and validation sets
    train_features, val_features, train_spikes, val_spikes = train_test_split(
        features_df, spikes_df, test_size=val_split, shuffle=True)

    # Create datasets for training and validation
    train_dataset = NeuralActivityDataset(train_features, train_spikes, seq_length)
    val_dataset = NeuralActivityDataset(val_features, val_spikes, seq_length)

    # Create DataLoaders for training and validation
    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    val_loader = DataLoader(val_dataset, batch_size=batch_size, shuffle=False)

    return train_loader, val_loader


def train_model(model, train_loader, val_loader, num_epochs=50, learning_rate=0.001):
    """
    Train the RNN model, tracking training and validation losses.

    Parameters:
    - model: The RNN model to be trained.
    - train_loader (DataLoader): DataLoader for training dataset.
    - val_loader (DataLoader): DataLoader for validation dataset.
    - num_epochs (int): Number of training epochs.
    - learning_rate (float): Learning rate for optimization.
    """
    # Loss function: Mean Squared Error
    criterion = nn.MSELoss()

    # Optimizer: Adam optimizer
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)

    train_losses = []
    val_losses = []

    for epoch in range(num_epochs):
        # Training phase
        model.train()
        running_train_loss = 0.0
        for inputs, targets in train_loader:
            # Forward pass
            outputs = model(inputs)
            loss = criterion(outputs, targets)

            # Backward pass and optimization
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            running_train_loss += loss.item()

        # Compute the average training loss
        avg_train_loss = running_train_loss / len(train_loader)
        train_losses.append(avg_train_loss)

        # Validation phase
        model.eval()
        running_val_loss = 0.0
        with torch.no_grad():
            for inputs, targets in val_loader:
                outputs = model(inputs)
                loss = criterion(outputs, targets)
                running_val_loss += loss.item()

        # Compute the average validation loss
        avg_val_loss = running_val_loss / len(val_loader)
        val_losses.append(avg_val_loss)

        # Print epoch loss
        print(f'Epoch {epoch+1}/{num_epochs}, Train Loss: {avg_train_loss:.4f}, Val Loss: {avg_val_loss:.4f}')

    return train_losses, val_losses

# %%

def sliding_window_split(features_df, spikes_df, seq_length, window_size, step_size):
    """
    Perform a sliding window split on the features and spikes dataframes.
    
    Parameters:
    - features_df (pd.DataFrame): Input features DataFrame.
    - spikes_df (pd.DataFrame): Target spikes DataFrame.
    - seq_length (int): Sequence length for the RNN.
    - window_size (int): Size of the window for training data.
    - step_size (int): The step size to move the window.
    
    Returns:
    - List of tuples: Each tuple contains train_features, val_features, train_spikes, val_spikes
    """
    total_timepoints = len(features_df)
    splits = []
    
    # Slide the window across the data
    for start_idx in range(0, total_timepoints - seq_length - window_size, step_size):
        end_idx = start_idx + window_size
        
        # Train set
        train_features = features_df.iloc[start_idx:end_idx]
        train_spikes = spikes_df.iloc[start_idx:end_idx]
        
        # Validation set: directly after the training window
        val_features = features_df.iloc[end_idx:end_idx + seq_length]
        val_spikes = spikes_df.iloc[end_idx:end_idx + seq_length]
        
        splits.append((train_features, val_features, train_spikes, val_spikes))
    
    return splits


def create_sliding_data_loaders(features_df, spikes_df, seq_length, window_size, step_size, batch_size):
    """
    Create DataLoader objects for sliding window splits.

    Parameters:
    - features_df (pd.DataFrame): Input features DataFrame.
    - spikes_df (pd.DataFrame): Target spikes DataFrame.
    - seq_length (int): Sequence length for the RNN.
    - window_size (int): Window size for the training set.
    - step_size (int): Step size to slide the window.
    - batch_size (int): Batch size for training.

    Returns:
    - List of tuples (train_loader, val_loader): Each tuple corresponds to a split.
    """
    sliding_splits = sliding_window_split(features_df, spikes_df, seq_length, window_size, step_size)
    loaders = []

    for train_features, val_features, train_spikes, val_spikes in sliding_splits:
        # Create datasets for training and validation
        train_dataset = NeuralActivityDataset(train_features, train_spikes, seq_length)
        val_dataset = NeuralActivityDataset(val_features, val_spikes, seq_length)

        # Create DataLoaders for training and validation
        train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
        val_loader = DataLoader(val_dataset, batch_size=batch_size, shuffle=False)

        loaders.append((train_loader, val_loader))

    return loaders


def train_model_with_sliding_windows(model, sliding_loaders, num_epochs=50, learning_rate=0.001):
    """
    Train the RNN model using sliding window splits, tracking training and validation losses.

    Parameters:
    - model: The RNN model to be trained.
    - sliding_loaders (list of tuples): List of DataLoader pairs (train_loader, val_loader).
    - num_epochs (int): Number of training epochs.
    - learning_rate (float): Learning rate for optimization.
    """
    # Loss function: Mean Squared Error
    criterion = nn.MSELoss()

    # Optimizer: Adam optimizer
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)

    train_losses = []
    val_losses = []

    for epoch in range(num_epochs):
        total_train_loss = 0.0
        total_val_loss = 0.0
        num_splits = len(sliding_loaders)
        
        for train_loader, val_loader in sliding_loaders:
            # Training phase
            model.train()
            running_train_loss = 0.0
            for inputs, targets in train_loader:
                outputs = model(inputs)
                loss = criterion(outputs, targets)
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()
                running_train_loss += loss.item()

            # Compute the average training loss for this split
            avg_train_loss = running_train_loss / len(train_loader)
            total_train_loss += avg_train_loss

            # Validation phase
            model.eval()
            running_val_loss = 0.0
            with torch.no_grad():
                for inputs, targets in val_loader:
                    outputs = model(inputs)
                    loss = criterion(outputs, targets)
                    running_val_loss += loss.item()

            # Compute the average validation loss for this split
            avg_val_loss = running_val_loss / len(val_loader)
            total_val_loss += avg_val_loss

        # Average the losses across all sliding windows
        train_losses.append(total_train_loss / num_splits)
        val_losses.append(total_val_loss / num_splits)

        # Print epoch loss
        print(f'Epoch {epoch+1}/{num_epochs}, Train Loss: {train_losses[-1]:.4f}, Val Loss: {val_losses[-1]:.4f}')

    return train_losses, val_losses


# %%

def plot_losses(train_losses, val_losses):
    """
    Plot training and validation losses over epochs and annotate the final loss values.

    Parameters:
    - train_losses (list): List of training losses.
    - val_losses (list): List of validation losses.
    """
    plt.figure(figsize=(10, 5))

    # Plot training and validation losses
    plt.plot(train_losses, label='Training Loss', color='blue')
    plt.plot(val_losses, label='Validation Loss', color='orange')

    # Annotate the final loss values
    final_train_loss = train_losses[-1]
    final_val_loss = val_losses[-1]

    plt.text(len(train_losses) - 1, final_train_loss, f'{final_train_loss:.4f}', 
             color='blue', fontsize=12, ha='right', va='bottom')
    plt.text(len(val_losses) - 1, final_val_loss, f'{final_val_loss:.4f}', 
             color='orange', fontsize=12, ha='right', va='bottom')

    # Set plot labels and title
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.title('Training and Validation Loss Over Epochs')

    # Show the plot
    plt.show()




