#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 11:25:44 2025

@author: gruffalo
"""

import scipy.io
import pandas as pd
import os
import numpy as np

def load_mat_data(mat_folder: str, mat_filename: str) -> dict:
    """
    Loads a .mat file and processes it into a dictionary of pandas DataFrames.

    Parameters:
        mat_folder (str): Path to the folder containing the .mat file.
        mat_filename (str): Name of the .mat file.

    Returns:
        dict: A dictionary where each key is a mouse number (e.g., 'M561'),
              and the value is a pandas DataFrame with the corresponding data.
    """
    mat_path = os.path.join(mat_folder, mat_filename)
    
    # Load .mat file
    mat_data = scipy.io.loadmat(mat_path, squeeze_me=True, struct_as_record=False)
    
    # Extract column names
    if 'Name' not in mat_data:
        raise KeyError("The .mat file does not contain a 'Name' field.")
    
    column_names = list(mat_data['Name'])  # Convert to list

    # Extract the main DATA structure
    if 'DATA' not in mat_data:
        raise KeyError("The .mat file does not contain a 'DATA' structure.")
    
    data_struct = mat_data['DATA']

    # Extract the Cond structure
    if not hasattr(data_struct, 'Cond'):
        raise KeyError("The 'DATA' structure does not contain a 'Cond' field.")

    cond_data = data_struct.Cond
    
    # Initialize dictionary to store data
    mice_data = {}

    # Process each mouse's data
    for mouse_id in dir(cond_data):
        if mouse_id.startswith('__') or mouse_id == '_fieldnames':  # Ignore hidden and metadata fields
            continue

        mouse_matrix = getattr(cond_data, mouse_id)

        # Ensure the data is in an array format
        if isinstance(mouse_matrix, (list, tuple)):
            mouse_matrix = np.array(mouse_matrix)

        if isinstance(mouse_matrix, np.ndarray) and mouse_matrix.ndim == 2:
            # Ensure the number of columns matches
            if mouse_matrix.shape[1] != len(column_names):
                raise ValueError(f"Column mismatch for {mouse_id}: "
                                 f"{mouse_matrix.shape[1]} columns in matrix, "
                                 f"but {len(column_names)} column names provided.")

            df = pd.DataFrame(mouse_matrix, columns=column_names)
            mice_data[mouse_id] = df
        else:
            print(f"Warning: {mouse_id} data is not a valid 2D array, skipping.")

    return mice_data





# mat_folder = "/path/to/mat/files"
# mat_filename = "example.mat"

# mice_data = load_mat_data(mat_folder, mat_filename)

# # Example access:
# print(mice_data['M561'].head())  # Display first rows of the DataFrame for mouse 'M561'
