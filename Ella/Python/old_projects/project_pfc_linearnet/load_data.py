# -*- coding: utf-8 -*-
"""
Created on Wed Jan 17 23:07:41 2024

@author: ellac
"""

import os
import pandas as pd
import scipy.io


def load_vars(mat_directory, exclude_files=['Spk_times.mat', 'OBSpec.mat']):
    """
    Load data from .mat files in the specified directory for multiple mice.
    
    Parameters:
    - mat_directory (str): Path to the directory containing mice subdirectories with .mat files.
    - exclude_files (list, optional): List of filenames to exclude. Default is None.
    
    Returns:
    - dict: A dictionary where keys are mouse identifiers and values are corresponding dataframes.
    """
    if exclude_files is None:
        exclude_files = []

    # Initialize a dictionary to store dataframes for each mouse
    mice_data = {}

    # Iterate through mice directories
    for mouse_directory in os.listdir(mat_directory):
        mouse_path = os.path.join(mat_directory, mouse_directory)

        # Check if the item in the directory is a subdirectory (each mouse has its own directory)
        if os.path.isdir(mouse_path):
            # Initialize an empty list to store DataFrames for this mouse
            dfs = []

            # Iterate through .mat files for this mouse
            for filename in os.listdir(mouse_path):
                if filename.endswith('.mat') and filename not in exclude_files:
                    file_path = os.path.join(mouse_path, filename)

                    # Load .mat file
                    mat_data = scipy.io.loadmat(file_path)

                    # Extract data and append to the DataFrame
                    data_dict = {
                        filename[:-4]: mat_data['data'].flatten(),
                    }
                    temp_df = pd.DataFrame(data_dict)
                    dfs.append(temp_df)

            # Concatenate all DataFrames for this mouse
            mouse_df = pd.concat(dfs, axis=1)

            # Store the mouse's dataframe in the dictionary with the mouse identifier as the key
            mice_data[mouse_directory] = mouse_df

    return mice_data


def load_spike_times(mat_directory):
    """
    Load 'Spk_times.mat' data from the specified directory for multiple mice.
    
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
                # Load 'Spk_times.mat' file
                mat_data = scipy.io.loadmat(spk_times_file_path)

                # Extract spike times data
                spike_times = mat_data.get('data', None)

                dfs = []
                
                # Store the spike times data in a DataFrame with columns for each neuron
                if spike_times is not None:
                    for i in range(spike_times.shape[1]):
                        neuron_columns = [f'Neuron_{i+1}']
                        spike_times_df = pd.DataFrame(spike_times[0,i], columns=neuron_columns)
                        dfs.append(spike_times_df)
                        
                    # Concatenate all DataFrames for this mouse
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