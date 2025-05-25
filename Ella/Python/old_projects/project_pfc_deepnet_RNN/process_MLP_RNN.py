# -*- coding: utf-8 -*-
"""
Created on Wed Jan 24 18:55:33 2024

@author: ellac
"""

# -*- coding: utf-8 -*-
"""
Created on Sun Jan 21 16:11:10 2024

@author: ellac
"""

import pandas as pd
import torch
from analyse_data import extract_epoch_indices, spike_count
from sklearn.model_selection import train_test_split
from sklearn.utils import shuffle

## For the MLP

def create_data_variables(mice_data, mouse_id, epoch_names, variable_names):
    """
    Create a combined DataFrame containing data for specified epochs and variables,
    with NaN values removed.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the specific mouse.
    - epoch_names (list): List of epoch names to include in the combined DataFrame.
    - variable_names (list): List of variable names to include in the combined DataFrame.

    Returns:
    - combined_df (pd.DataFrame): Combined DataFrame with data for specified epochs and variables,
                                   excluding rows with NaN values.
    """

    # Initialize an empty list to store DataFrames for each epoch
    epoch_dfs = []

    # Iterate through the list of epoch names
    for epoch_name in epoch_names:
        # Extract indices for the specified epoch
        epoch_indices = extract_epoch_indices(mice_data, mouse_id, epoch_name)

        # Extract data using the indices for each variable
        variable_data = {var: mice_data[mouse_id][var][epoch_indices] for var in variable_names}

        # Create label array
        if epoch_name.endswith('StartStop'):
            labels = [epoch_name[:-9]] * len(variable_data[variable_names[0]])
        elif epoch_name.endswith('_epo'):
            labels = [epoch_name[:-4]] * len(variable_data[variable_names[0]])

        # Add label to variable_data dictionary
        variable_data['Label'] = labels

        # Create a DataFrame for the epoch data
        epoch_df = pd.DataFrame(variable_data)

        # Drop rows with NaN values
        epoch_df = epoch_df.dropna()

        # Append the DataFrame to the list
        epoch_dfs.append(epoch_df)

    # Concatenate all DataFrames in the list
    combined_df = pd.concat(epoch_dfs, ignore_index=True)

    return combined_df


# Function for loading and preprocessing data
def load_and_preprocess_data(mice_data, mouse_id, epoch_names, variable_names):
    """
    Load and preprocess data for training and evaluation.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - epoch_names (list): List of epoch names for different conditions.
    - variable_names (list): List of variable names to be included.

    Returns:
    - Tuple: A tuple containing training data (X_train, y_train),
      prediction data (X_pred, y_pred), and label mapping (dict).

    This function loads and preprocesses the data for training and evaluation. It creates a DataFrame
    using the provided parameters and converts the relevant columns to PyTorch tensors. The 'Label' column
    is mapped to numerical values, and the data is shuffled before being split into training and prediction sets.
    The function returns a tuple containing the training data, prediction data, and label mapping.
    """
    result_combined_df = create_data_variables(mice_data, mouse_id, epoch_names, variable_names)
    
    # Convert DataFrame to PyTorch tensors
    X = torch.tensor(result_combined_df[variable_names].values, dtype=torch.float32)

    # Map string labels to numerical values
    label_mapping = {label: idx for idx, label in enumerate(result_combined_df['Label'].unique())}
    result_combined_df['Label'] = result_combined_df['Label'].map(label_mapping)

    # Convert the 'Label' column to a PyTorch tensor
    y = torch.tensor(result_combined_df['Label'].values, dtype=torch.long)

    # Data Shuffling
    X_shuffled, y_shuffled = shuffle(X, y, random_state=42)

    # Split into training, validation, and test sets
    X_train, X_pred, y_train, y_pred = train_test_split(X_shuffled, y_shuffled, test_size=0.3, random_state=42, stratify=y_shuffled)

    return X_train, y_train, X_pred, y_pred, label_mapping


## For the RNN

def preprocess_data_RNN(mice_data, mouse_id, spike_times_data, 
                        features=['Accelero', 'BreathFreq', 'Heartrate', 'LinPos']):
    """
    Preprocess data for training a Recurrent Neural Network (RNN).

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - spike_times_data (dict): Dictionary containing spike times data.
    - features (list): List of feature names to include. Default features are ['Accelero', 'BreathFreq', 'Heartrate', 'LinPos'].

    Returns:
    - features_df (pd.DataFrame): DataFrame containing selected features.
    - spikes_RNN (pd.DataFrame): DataFrame containing spike count data for RNN.
    """

    # Calculate spike counts for RNN
    spikes_RNN = spike_count(mice_data, mouse_id, spike_times_data)

    # Extract selected features
    features_df = mice_data[mouse_id][features]
    
    return features_df, spikes_RNN



