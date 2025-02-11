#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 24 14:08:46 2024

@author: gruffalo
"""

from itertools import product
import numpy as np


def zscore_columns(df, columns_to_zscore):
    """
    Z-scores the specified columns in a copy of the DataFrame to avoid modifying the original DataFrame.

    Parameters:
    - df (pd.DataFrame): Input DataFrame.
    - columns_to_zscore (list of str): List of column names to z-score.

    Returns:
    - pd.DataFrame: A new DataFrame with z-scored columns.
    """
    # Create a copy of the DataFrame to avoid modifying the original
    df_copy = df.copy()

    for col in columns_to_zscore:
        if col not in df_copy.columns:
            print(f"Column '{col}' not found in the DataFrame. Skipping...")
            continue

        # Check for NaNs and standard deviation
        if df_copy[col].isna().all():
            print(f"Column '{col}' contains only NaN values. Skipping...")
            continue
        
        if df_copy[col].std() == 0:
            print(f"Column '{col}' has zero standard deviation. Skipping...")
            continue

        # Perform z-scoring
        df_copy[col] = (df_copy[col] - df_copy[col].mean()) / df_copy[col].std()

    return df_copy



def calculate_amplitude_thresholds(spike_counts, neuron_id, percentages):
    """
    Calculate threshold values based on specified percentages of the amplitude
    of spike counts for a given neuron.

    Parameters:
    - spike_counts (pd.DataFrame): Dataframe containing spike counts for multiple neurons.
    - neuron_id (str): The ID of the neuron for which thresholds will be calculated.
    - percentages (list of float): List of percentages to calculate thresholds, in decimal form (e.g., 0.1 for 10%).

    Returns:
    - list of float: Threshold values corresponding to the applied percentages.
    """
    if neuron_id not in spike_counts.columns:
        raise ValueError(f"Neuron '{neuron_id}' not found in the dataframe.")

    # Extract spike counts for the specified neuron
    neuron_data = spike_counts[neuron_id]

    # Calculate amplitude (difference between max and min)
    amplitude = neuron_data.max() - neuron_data.min()

    # Calculate thresholds based on the specified percentages of the amplitude
    thresholds = [amplitude * p for p in percentages]

    return thresholds


def generate_variable_shift_combinations(variables, max_shifts):
    """
    Generate all possible combinations of shift configurations for specified variables.

    Parameters:
    - variables (list of str): List of variable names to generate shifts for.
    - max_shifts (dict): Dictionary where keys are variable names and values are the maximum shift (negative integer).
                          Example: {'BreathFreq': 5, 'Heartrate': 3}

    Returns:
    - variables_shifts (list of dict): List of dictionaries with all combinations of variable shift configurations.
    """
    variables_shifts = []

    # If no shifts are specified, return a single dictionary with just baseline values for non-shifted variables
    if not max_shifts:
        variables_shifts.append({var: [0] for var in variables})
        return variables_shifts

    # Prepare a list of ranges for each variable's shifts
    shift_ranges = {var: [range(0, max_shift + 1) for max_shift in range(max_shifts[var] + 1)] for var in max_shifts}

    # Generate combinations of all specified shift ranges
    for shift_combination in product(*shift_ranges.values()):
        shift_dict = {var: [0] + [-s for s in shifts[1:]] for var, shifts in zip(shift_ranges.keys(), shift_combination)}

        # Add non-shifted variables at baseline
        for var in variables:
            if var not in shift_dict:
                shift_dict[var] = [0]
        
        variables_shifts.append(shift_dict)

    return variables_shifts


# def extract_random_bouts(data, bout_length=10, percent=10, random_state=42):
#     """
#     Extract random bouts of data for testing and keep the rest for training.

#     Parameters:
#     - data (pd.DataFrame): Input data.
#     - bout_length (int): Length of each bout.
#     - percent (float): Percent of data to allocate to testing.
#     - random_state (int, optional): Random seed for reproducibility. Default is 42.

#     Returns:
#     - train_data (pd.DataFrame): Data for training.
#     - test_data (pd.DataFrame): Data for testing.
#     """
#     if not 0 < percent < 100:
#         raise ValueError("Percent must be between 0 and 100.")
    
#     if bout_length <= 0:
#         raise ValueError("Bout length must be greater than 0.")
    
#     # Clean the data by dropping rows with at least one NaN value
#     data_cleaned = data.dropna()
    
#     # Set random seed for reproducibility
#     rng = np.random.default_rng(seed=random_state)
    
#     # Calculate the total number of test samples
#     n_samples = len(data_cleaned)
#     total_test_samples = int((percent / 100) * n_samples)
    
#     if total_test_samples < bout_length:
#         raise ValueError("Total test samples are less than bout length. Adjust bout length or percent.")
    
#     # Generate random starting indices for bouts
#     num_bouts = total_test_samples // bout_length
#     possible_indices = np.arange(0, n_samples - bout_length + 1)
#     bout_start_indices = rng.choice(possible_indices, size=num_bouts, replace=False)
    
#     # Generate test indices from the bout starts
#     test_indices = set()
#     for start in bout_start_indices:
#         test_indices.update(range(start, start + bout_length))
    
#     # Create train and test data
#     test_data = data_cleaned.iloc[list(test_indices)]
#     train_data = data_cleaned.drop(index=test_data.index)
    
#     return train_data, test_data


def extract_random_bouts(data, bout_length=10, percent=10, random_state=42):
    """
    Extract random bouts of data for testing and keep the rest for training.

    Parameters:
    - data (pd.DataFrame): Input data.
    - bout_length (int): Length of each bout.
    - percent (float): Percent of data to allocate to testing.
    - random_state (int, optional): Random seed for reproducibility. Default is 42.

    Returns:
    - train_data (pd.DataFrame): Data for training.
    - test_data (pd.DataFrame): Data for testing.
    """
    if not 0 < percent < 100:
        raise ValueError("Percent must be between 0 and 100.")
    
    if bout_length <= 0:
        raise ValueError("Bout length must be greater than 0.")

    # Remove columns that are entirely NaN
    data_filtered = data.dropna(axis=1, how='all')  

    # Drop rows with NaN values but keep all valid columns
    data_cleaned = data_filtered.dropna()

    # Set random seed for reproducibility
    rng = np.random.default_rng(seed=random_state)
    
    # Calculate the total number of test samples
    n_samples = len(data_cleaned)
    total_test_samples = int((percent / 100) * n_samples)
    
    if total_test_samples < bout_length:
        raise ValueError("Total test samples are less than bout length. Adjust bout length or percent.")
    
    # Generate random starting indices for bouts
    num_bouts = total_test_samples // bout_length
    possible_indices = np.arange(0, n_samples - bout_length + 1)
    bout_start_indices = rng.choice(possible_indices, size=num_bouts, replace=False)
    
    # Generate test indices from the bout starts
    test_indices = set()
    for start in bout_start_indices:
        test_indices.update(range(start, start + bout_length))
    
    # Create train and test data
    test_data = data_cleaned.iloc[list(test_indices)]
    train_data = data_cleaned.drop(index=test_data.index)
    
    return train_data, test_data













