#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 18 12:17:05 2024

@author: gruffalo
"""

import numpy as np
import pandas as pd
from preprocess_ln_model import (
    zscore_columns
    )


def denoise_mice_data(mice_data, columns_to_denoise):
    """
    Denoise specified columns in the mice data by removing rows corresponding to timepoints in the 
    'NoiseStartStop' intervals from each mouse's dataframe. The 'NoiseStartStop' column is removed in 
    the returned dictionary. Columns not specified in the list remain unchanged.

    Parameters:
    - mice_data (dict): Dictionary containing data for each mouse.
    - columns_to_denoise (list): List of column names that should be denoised.

    Returns:
    - denoised_data (dict): Dictionary containing denoised data for each mouse (without 'NoiseStartStop').
    """

    def extract_noise_indices(mouse_df):
        """
        Extract the row indices corresponding to 'NoiseStartStop' intervals for a given mouse dataframe.
        """
        # Extract start and stop timepoints of the noise epochs
        start_epochs = mouse_df['NoiseStartStop'].iloc[::2].reset_index(drop=True)
        stop_epochs = mouse_df['NoiseStartStop'].iloc[1::2].reset_index(drop=True)
        timebins = mouse_df['timebins']

        # Check if start and stop epochs have the same length
        if start_epochs.count() != stop_epochs.count():
            raise ValueError('Start and stop epochs do not have the same length')

        selected_rows = []
        epoch_bin = 0

        # Iterate through start and stop epochs to extract corresponding time indices
        for i in range(start_epochs.count()):
            while epoch_bin < len(timebins) and timebins[epoch_bin] <= stop_epochs[i]:
                if timebins[epoch_bin] >= start_epochs[i]:
                    selected_rows.append(epoch_bin)
                epoch_bin += 1

        return selected_rows

    denoised_data = {}

    # Iterate over each mouse in the dictionary
    for mouse_id, mouse_df in mice_data.items():
        # Extract noise indices
        noise_indices = extract_noise_indices(mouse_df)

        # Create a new DataFrame to store the denoised data
        denoised_df = pd.DataFrame()

        # Iterate over each column in the dataframe
        for column in mouse_df.columns:
            if column in columns_to_denoise:
                # Denoise only the specified columns by removing rows at noise indices
                denoised_df[column] = mouse_df[column].drop(noise_indices).reset_index(drop=True)
            else:
                # For columns not specified, keep them as they are (no denoising)
                denoised_df[column] = mouse_df[column]

        # Remove the 'NoiseStartStop' column
        if 'NoiseStartStop' in denoised_df.columns:
            denoised_df = denoised_df.drop(columns=['NoiseStartStop'])

        # Store the denoised dataframe in the new dictionary
        denoised_data[mouse_id] = denoised_df

    return denoised_data


def create_sorted_column_by_threshold(mice_data, mouse_id, variable_name, threshold, replace=False):
    """
    Replace or create a new column in the dataframe of a given mouse by sorting and cleaning another column.
    Values greater than the threshold are replaced with NaN.

    Parameters:
    - mice_data (dict): Dictionary containing dataframes for each mouse.
    - mouse_id (str): The ID of the mouse whose dataframe will be modified.
    - variable_name (str): The name of the column to be sorted and cleaned.
    - threshold (numeric): The condition value above which values will be replaced by NaN.
    - replace (bool): If True, replace the original column. If False, add a new sorted column.
    
    Returns:
    - None: Modifies the dataframe in-place.
    """
    # Access the dataframe of the specified mouse
    mouse_df = mice_data[mouse_id]
    
    # Check if the variable exists in the dataframe
    if variable_name not in mouse_df.columns:
        print(f"Variable '{variable_name}' not found in the dataframe of mouse '{mouse_id}'.")
        return

    # Decide the name of the column to modify
    if replace:
        column_name = variable_name
    else:
        column_name = f"{variable_name}_sorted"
        # Create the new sorted column by copying the original variable column
        mouse_df[column_name] = mouse_df[variable_name]

    # Replace values greater than the threshold with NaN
    mouse_df[column_name] = mouse_df[column_name].apply(lambda x: np.nan if x > threshold else x)
    
    if replace:
        print(f"Replaced values greater than {threshold} with NaN in column '{variable_name}'.")
    else:
        print(f"Replaced values greater than {threshold} with NaN and created new column '{column_name}'.")



def create_sorted_column_by_intervals(mice_data, mouse_id, variable_name, intervals, replace=False):
    """
    Replace values within multiple intervals of timepoints with NaN in the dataframe of a given mouse.
    If replace=True, the original column is replaced. If replace=False, a new sorted column is added.

    Parameters:
    - mice_data (dict): Dictionary containing dataframes for each mouse.
    - mouse_id (str): The ID of the mouse whose dataframe will be modified.
    - variable_name (str): The name of the column to be sorted and cleaned.
    - intervals (list of tuples): List of intervals where values should be replaced with NaN.
                                  Each interval is a tuple (start_timepoint, end_timepoint).
    - replace (bool): If True, replace the original column. If False, add a new sorted column.
    
    Returns:
    - None: Modifies the dataframe in-place.
    """
    # Access the dataframe of the specified mouse
    mouse_df = mice_data[mouse_id]
    
    # Check if the variable exists in the dataframe
    if variable_name not in mouse_df.columns:
        print(f"Variable '{variable_name}' not found in the dataframe of mouse '{mouse_id}'.")
        return

    # Decide the name of the column to modify
    if replace:
        column_name = variable_name
    else:
        column_name = f"{variable_name}_sorted"
        # Create the new sorted column by copying the original variable column
        mouse_df[column_name] = mouse_df[variable_name]

    # Replace values in each interval with NaN
    for start_timepoint, end_timepoint in intervals:
        mouse_df.loc[start_timepoint:end_timepoint, column_name] = np.nan
    
    if replace:
        print(f"Replaced values in intervals {intervals} with NaN in column '{variable_name}'.")
    else:
        print(f"Replaced values in intervals {intervals} with NaN and created new column '{column_name}'.")



def create_sorted_column_replace_zeros(mice_data, mouse_id, variable_name, replace=False):
    """
    Replace or create a new column in the dataframe of a given mouse by replacing all 0 values with NaN.

    Parameters:
    - mice_data (dict): Dictionary containing dataframes for each mouse.
    - mouse_id (str): The ID of the mouse whose dataframe will be modified.
    - variable_name (str): The name of the column to be sorted and cleaned.
    - replace (bool): If True, replace the original column. If False, add a new sorted column.
    
    Returns:
    - None: Modifies the dataframe in-place.
    """
    # Access the dataframe of the specified mouse
    mouse_df = mice_data[mouse_id]
    
    # Check if the variable exists in the dataframe
    if variable_name not in mouse_df.columns:
        print(f"Variable '{variable_name}' not found in the dataframe of mouse '{mouse_id}'.")
        return

    # Decide the name of the column to modify
    if replace:
        column_name = variable_name
    else:
        column_name = f"{variable_name}_sorted"
        # Create the new sorted column by copying the original variable column
        mouse_df[column_name] = mouse_df[variable_name]

    # Replace 0 values with NaN
    mouse_df[column_name] = mouse_df[column_name].apply(lambda x: np.nan if x == 0 else x)
    
    if replace:
        print(f"Replaced 0 values with NaN in column '{variable_name}'.")
    else:
        print(f"Replaced 0 values with NaN and created new column '{column_name}'.")



def interpolate_column(mice_data, mouse_id, column_name, replace=False):
    """
    Perform linear interpolation for a specified column in the data of a given mouse,
    and either replace the original column or create a new one.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - column_name (str): The column name that contains NaN values to be interpolated.
    - replace (bool): If True, replace the original column with the interpolated values.
                      If False, create a new column with interpolated values.

    Returns:
    - None: The function modifies the mice_data in place and does not return anything.
    """

    # Check if the mouse and the column exist in the data
    if mouse_id not in mice_data:
        raise ValueError(f"Mouse '{mouse_id}' not found in mice data.")
    if column_name not in mice_data[mouse_id].columns:
        raise ValueError(f"Column '{column_name}' not found for mouse '{mouse_id}'.")

    # Get the DataFrame for the mouse
    mouse_df = mice_data[mouse_id]

    # Perform linear interpolation on the specified column
    if replace:
        # Replace the original column with interpolated values
        mouse_df[column_name] = mouse_df[column_name].interpolate(method='linear')
        print(f"Interpolated values in column '{column_name}'.")
    else:
        # Create a new interpolated column
        new_column_name = f"{column_name}_interpolated"
        mouse_df[new_column_name] = mouse_df[column_name].interpolate(method='linear')
        print(f"Created new column '{new_column_name}' with interpolated values.")
        
        
def rebin_mice_data(mice_data, columns_to_rebin, new_bin_size):
    """
    Rebin the data of specified columns in the mice_data dictionary according to a new bin size.
    If no data is present for a given bin, a row with NaN values is created to ensure equal spacing.

    Parameters:
    - mice_data (dict): Dictionary containing data for each mouse.
    - columns_to_rebin (list): List of column names to be rebinned.
    - new_bin_size (float): The new bin size in seconds (preferably a multiple of 0.2).

    Returns:
    - rebinned_data (dict): Dictionary containing the rebinned dataframes for each mouse.
    """
    import numpy as np
    import pandas as pd

    rebinned_data = {}

    # Multiply by 10 to avoid floating-point precision issues
    scaled_new_bin_size = new_bin_size * 10
    scaled_base = 0.2 * 10

    # Check if the new bin size is a multiple of 0.2 by scaling to integers
    if scaled_new_bin_size % scaled_base != 0:
        raise ValueError(f"New bin size should be a multiple of 0.2. Received: {new_bin_size}")

    # Iterate over each mouse in the dictionary
    for mouse_id, mouse_df in mice_data.items():
        mouse_df_copy = mouse_df.copy()  # Create a copy to avoid modifying the original data

        # Get the 'timebins' column
        timebins = mouse_df_copy['timebins']

        # Generate bin edges based on new_bin_size
        bin_edges = np.arange(timebins.min(), timebins.max() + new_bin_size, new_bin_size)

        # Assign each timebin to a bin
        mouse_df_copy['rebinned_timebins'] = pd.cut(
            timebins, bins=bin_edges, include_lowest=True, right=False, labels=bin_edges[:-1]
        )

        # Group by the rebinned timebins and compute the mean for the specified columns
        rebinned_df = mouse_df_copy.groupby('rebinned_timebins', observed=True)[columns_to_rebin].mean().reset_index()

        # Rename the 'rebinned_timebins' column to 'timebins'
        rebinned_df = rebinned_df.rename(columns={'rebinned_timebins': 'timebins'})

        # Create a full range of rebinned timebins to ensure no bins are skipped
        full_time_range = pd.Series(bin_edges[:-1], name='timebins')

        # Merge the rebinned DataFrame with the full time range, filling missing values with NaN
        rebinned_df = pd.DataFrame({'timebins': full_time_range}).merge(rebinned_df, on='timebins', how='left')

        # Store the rebinned dataframe in the new dictionary
        rebinned_data[mouse_id] = rebinned_df

    return rebinned_data


def normalize_data(maze_rebinned_data, columns_to_normalize):
    """
    Normalize specified columns for each mouse in the maze_rebinned_data dictionary.

    Parameters:
    - maze_rebinned_data (dict): Dictionary containing rebinned data for each mouse.
    - columns_to_normalize (list): List of column names to normalize.

    Returns:
    - normalized_data (dict): Dictionary with the same structure as maze_rebinned_data,
      but with normalized specified columns.
    """
    normalized_data = {}

    for mouse_id, mouse_df in maze_rebinned_data.items():
        # Make a copy to avoid modifying the original data
        mouse_df_copy = mouse_df.copy()
        
        # Apply zscore normalization to the specified columns
        mouse_df_copy = zscore_columns(mouse_df_copy, columns_to_normalize)
        
        # Store the normalized DataFrame in the new dictionary
        normalized_data[mouse_id] = mouse_df_copy

    return normalized_data



# def rebin_mice_data(mice_data, columns_to_rebin, new_bin_size):
#     """
#     Rebin the data of specified columns in the mice_data dictionary according to a new bin size.
#     If no data is present for a given bin, a row with NaN values is created to ensure equal spacing.

#     Parameters:
#     - mice_data (dict): Dictionary containing data for each mouse.
#     - columns_to_rebin (list): List of column names to be rebinned.
#     - new_bin_size (float): The new bin size in seconds (preferably a multiple of 0.2).

#     Returns:
#     - rebinned_data (dict): Dictionary containing the rebinned dataframes for each mouse.
#     """

#     rebinned_data = {}

#     # Multiply by 10 to avoid floating-point precision issues
#     scaled_new_bin_size = new_bin_size * 10
#     scaled_base = 0.2 * 10

#     # Iterate over each mouse in the dictionary
#     for mouse_id, mouse_df in mice_data.items():
#         # Get the 'timebins' column
#         timebins = mouse_df['timebins']
        
#         # Check if the new bin size is a multiple of 0.2 by scaling to integers
#         if scaled_new_bin_size % scaled_base != 0:
#             raise ValueError(f"New bin size should be a multiple of 0.2. Received: {new_bin_size}")
        
#         # Generate bin edges based on new_bin_size
#         bin_edges = np.arange(timebins.min(), timebins.max() + new_bin_size, new_bin_size)
        
#         # Assign each timebin to a bin
#         mouse_df['rebinned_timebins'] = pd.cut(timebins, bins=bin_edges, include_lowest=True, right=False, labels=bin_edges[:-1])
        
#         # Group by the rebinned timebins and compute the mean for the specified columns
#         rebinned_df = mouse_df.groupby('rebinned_timebins', observed=True)[columns_to_rebin].mean().reset_index()
        
#         # Rename the 'rebinned_timebins' column to 'timebins'
#         rebinned_df = rebinned_df.rename(columns={'rebinned_timebins': 'timebins'})

#         # Create a full range of rebinned timebins to ensure no bins are skipped
#         full_time_range = pd.Series(bin_edges[:-1], name='timebins')
        
#         # Merge the rebinned DataFrame with the full time range, filling missing values with NaN
#         rebinned_df = pd.DataFrame({'timebins': full_time_range}).merge(rebinned_df, on='timebins', how='left')

#         # Store the rebinned dataframe in the new dictionary
#         rebinned_data[mouse_id] = rebinned_df

#     return rebinned_data




        

