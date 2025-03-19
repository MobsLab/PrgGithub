#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 22 17:55:27 2024

@author: gruffalo
"""

import os
import h5py
import scipy.io
import pandas as pd
import numpy as np


def load_vars(mat_directory, exclude_files=['Spk_times.mat', 'OBSpec.mat']):
    """
    Load data from MATLAB .mat files (v7.3 and older formats) in the specified directory for multiple mice,
    using file names as column names in the resulting DataFrames. Shorter arrays are padded
    with NaN to match the longest array length.
    
    Parameters:
    - mat_directory (str): Path to the directory containing mice subdirectories with .mat files.
    - exclude_files (list, optional): List of filenames to exclude. Default is None.
    
    Returns:
    - dict: A dictionary where keys are mouse identifiers and values are corresponding DataFrames
            with file names as column names.
    """
    if exclude_files is None:
        exclude_files = []

    # Initialize a dictionary to store DataFrames for each mouse
    mice_data = {}

    # Iterate through mice directories
    for mouse_directory in os.listdir(mat_directory):
        mouse_path = os.path.join(mat_directory, mouse_directory)

        # Check if the item in the directory is a subdirectory (each mouse has its own directory)
        if os.path.isdir(mouse_path):
            data_dict = {}
            max_length = 0  # To track the length of the longest array

            # Iterate through .mat files for this mouse
            for filename in os.listdir(mouse_path):
                if filename.endswith('.mat') and filename not in exclude_files:
                    file_path = os.path.join(mouse_path, filename)
                    column_name = filename[:-4]  # Use the file name without the .mat extension

                    try:
                        # Attempt to load the file as an HDF5-based (v7.3) MATLAB file
                        with h5py.File(file_path, 'r') as mat_file:
                            for key in mat_file.keys():
                                dataset = mat_file[key]
                                if isinstance(dataset, h5py.Dataset):
                                    # Flatten multi-dimensional arrays into a single column
                                    data = dataset[()].ravel(order='F').astype(float)  # Ensure float type
                                    data_dict[column_name] = data
                                    # Update the max length
                                    max_length = max(max_length, len(data))
                    except OSError:
                        # Fall back to loading the file as an older MATLAB format
                        mat_data = scipy.io.loadmat(file_path)
                        # Extract data assuming a key named 'data'
                        if 'data' in mat_data:
                            data = mat_data['data'].flatten().astype(float)  # Ensure float type
                            data_dict[column_name] = data
                            # Update the max length
                            max_length = max(max_length, len(data))

            # Ensure all arrays are of the same length by padding with NaN
            for key in data_dict:
                if len(data_dict[key]) < max_length:
                    # Ensure data is float before padding
                    data_dict[key] = np.pad(data_dict[key].astype(float), (0, max_length - len(data_dict[key])), 
                                            mode='constant', constant_values=np.nan)

            # Convert the dictionary to a DataFrame
            if data_dict:  # Ensure there is data before creating the DataFrame
                mouse_df = pd.DataFrame(data_dict)
                # Store the mouse's DataFrame in the dictionary with the mouse identifier as the key
                mice_data[mouse_directory] = mouse_df

    return mice_data


def load_spike_times(mat_directory):
    """
    Load 'Spk_times.mat' data from the specified directory for multiple mice,
    handling both MATLAB v7.3 and older .mat file formats.
    
    Parameters:
    - mat_directory (str): Path to the directory containing mice subdirectories with 'Spk_times.mat'.
    
    Returns:
    - dict: A dictionary where keys are mouse identifiers and values are corresponding DataFrames
            with spike times for each neuron.
    """
    spike_times_data = {}

    # Iterate through mice directories
    for mouse_directory in os.listdir(mat_directory):
        mouse_path = os.path.join(mat_directory, mouse_directory)

        # Check if the item in the directory is a subdirectory (each mouse has its own directory)
        if os.path.isdir(mouse_path):
            spk_times_file_path = os.path.join(mouse_path, 'Spk_times.mat')

            # Check if 'Spk_times.mat' exists for this mouse
            if os.path.isfile(spk_times_file_path):
                try:
                    # Attempt to load the file as a MATLAB v7.3 HDF5-based file
                    with h5py.File(spk_times_file_path, 'r') as mat_file:
                        # Access the spike times cell array
                        spike_times_ref = mat_file.get('data')
                        
                        if spike_times_ref is not None:
                            dfs = []

                            # Iterate through each cell in the array (representing neuron spike times)
                            for i in range(spike_times_ref.shape[0]):
                                neuron_data_ref = spike_times_ref[i, 0]  # Reference to the neuron's data
                                neuron_data = mat_file[neuron_data_ref][:]
                                
                                # Flatten the data if it has an extra dimension
                                if neuron_data.ndim > 1:
                                    neuron_data = neuron_data.flatten()
                                
                                # Create a DataFrame for this neuron's spike times
                                neuron_column = f'Neuron_{i+1}'
                                spike_times_df = pd.DataFrame(neuron_data, columns=[neuron_column])
                                dfs.append(spike_times_df)

                            # Concatenate all DataFrames for this mouse
                            if dfs:
                                mouse_df = pd.concat(dfs, axis=1)
                                # Store the DataFrame in the dictionary with the mouse identifier as the key
                                spike_times_data[mouse_directory] = mouse_df

                except OSError:
                    # Fall back to loading the file as an older MATLAB format
                    mat_data = scipy.io.loadmat(spk_times_file_path)

                    # Extract spike times data
                    spike_times = mat_data.get('data', None)

                    dfs = []
                    
                    # Store the spike times data in a DataFrame with columns for each neuron
                    if spike_times is not None:
                        for i in range(spike_times.shape[1]):
                            neuron_columns = [f'Neuron_{i+1}']
                            spike_times_df = pd.DataFrame(spike_times[0, i], columns=neuron_columns)
                            dfs.append(spike_times_df)
                            
                        # Concatenate all DataFrames for this mouse
                        if dfs:
                            mouse_df = pd.concat(dfs, axis=1)
                            # Store the DataFrame in the dictionary with the mouse identifier as the key
                            spike_times_data[mouse_directory] = mouse_df

    return spike_times_data


def load_dataframes(directory):
    """
    Load variables and spike times data from the specified directory.
    Uses the two previously defined functions to return all the data needed. 

    Parameters:
    - directory (str): Directory path containing the data.

    Returns:
    - tuple: A tuple containing the loaded variables and spike times data.
    """
    mice_data = load_vars(directory)
    spike_times_data = load_spike_times(directory)

    return mice_data, spike_times_data
