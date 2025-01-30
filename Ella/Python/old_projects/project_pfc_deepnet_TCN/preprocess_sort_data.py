#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 18 12:17:05 2024

@author: gruffalo
"""

import numpy as np


def denoise_mice_data(mice_data):
    """
    Denoise the mice data by removing rows corresponding to timepoints in the 'NoiseStartStop' intervals
    from each mouse's dataframe. The 'NoiseStartStop' column is removed in the returned dictionary.

    Parameters:
    - mice_data (dict): Dictionary containing data for each mouse.

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

        # Remove rows corresponding to noise indices from all columns
        denoised_df = mouse_df.drop(noise_indices).reset_index(drop=True)

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

