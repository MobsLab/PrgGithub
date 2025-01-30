#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 24 14:08:46 2024

@author: gruffalo
"""

import pandas as pd

# For the linear regression using StatsModels
def combine_dataframes_on_timebins(spike_count_df, physiological_df):
    """
    Combine two dataframes based on the 'timebins' column and remove rows with NaN values.
    Ensures efficient merging by indexing both DataFrames on 'timebins' and checking that both timebins are aligned.

    Parameters:
    - spike_count_df (pd.DataFrame): DataFrame containing spike count data indexed by 'timebins'.
    - physiological_df (pd.DataFrame): DataFrame containing physiological data, with a 'timebins' column.

    Returns:
    - combined_df (pd.DataFrame): Combined DataFrame indexed by 'timebins' and containing columns from both DataFrames.
    """

    # Ensure 'timebins' column exists in physiological_df
    if 'timebins' not in physiological_df.columns:
        raise ValueError("The physiological_df must have a 'timebins' column.")

    # Ensure 'timebins' is indexed in spike_count_df
    if spike_count_df.index.name != 'timebins':
        raise ValueError("The spike_count_df must have 'timebins' as its index.")

    # Drop rows with NaN values in 'timebins' from physiological_df
    physiological_df = physiological_df.dropna(subset=['timebins']).copy()

    # Set 'timebins' as the index in physiological_df
    physiological_df.set_index('timebins', inplace=True)

    # Ensure indices are of the same type
    physiological_df.index = physiological_df.index.astype(float)
    spike_count_df.index = spike_count_df.index.astype(float)

    # Check that both DataFrames have the same timebins
    common_timebins = spike_count_df.index.intersection(physiological_df.index)
    if common_timebins.empty:
        raise ValueError("No overlapping timebins found between the two DataFrames.")

    # Perform an inner join on the indices
    combined_df = spike_count_df.join(physiological_df, how='inner')

    return combined_df

# def combine_dataframes_on_timebins(spike_count_df, physiological_df):
#     """
#     Combine two dataframes based on the 'timebins' column and remove rows with NaN values.

#     Parameters:
#     - spike_count_df (pd.DataFrame): DataFrame containing spike count data indexed by 'timebins'.
#     - physiological_df (pd.DataFrame): DataFrame containing physiological data, with a 'timebins' column.

#     Returns:
#     - combined_df (pd.DataFrame): Combined DataFrame indexed by 'timebins' and containing columns from both DataFrames.
#     """
#     # Ensure the 'timebins' column is in the physiological data
#     if 'timebins' not in physiological_df.columns:
#         raise ValueError("The physiological_df must have a 'timebins' column.")

#     # Merge the two DataFrames on the 'timebins' column
#     combined_df = pd.merge(spike_count_df, physiological_df, on='timebins', how='inner')

#     # Remove rows with any NaN values
#     combined_df.dropna(inplace=True)

#     # Set 'timebins' as the index of the final DataFrame
#     combined_df.set_index('timebins', inplace=True)

#     return combined_df


# To create new lagged predictors 
def create_time_shifted_features(df, variables_shifts, include_original=False):
    """
    Create a dataframe with time-shifted columns for specified physiological variables, indexed by integers.

    Parameters:
    - df (pd.DataFrame): The dataframe containing physiological variables and timebins.
    - variables_shifts (dict): Dictionary where keys are the variable names and values are the time shifts.
                               Time shifts can be a single integer or a list of integers (for intervals).
                               Example: {'variable1': [-1, 0, 1], 'variable2': [-2, -1]}.
    - include_original (bool): If True, the original columns will be kept in the output dataframe.
                               If False, only the time-shifted columns will be included.

    Returns:
    - shifted_df (pd.DataFrame): DataFrame with time-shifted features, indexed by integers.
    """

    shifted_columns = {}

    # Create time-shifted columns for each variable
    for variable, shifts in variables_shifts.items():
        if variable not in df.columns:
            print(f"Variable '{variable}' not found in dataframe.")
            continue

        # Ensure shifts is a list, even if a single shift is provided
        if not isinstance(shifts, list):
            shifts = [shifts]

        # Add the original column if include_original is True
        if include_original:
            shifted_columns[variable] = df[variable]

        # Create shifted columns for each specified shift
        for shift in shifts:
            shifted_col_name = f"{variable}_t_{'plus' if shift >= 0 else 'minus'}_{abs(shift)}"
            shifted_columns[shifted_col_name] = df[variable].shift(shift)

    # Concatenate all the shifted columns at once
    shifted_df = pd.concat(shifted_columns, axis=1)

    # Reset index to integers
    shifted_df.reset_index(drop=True, inplace=True)

    return shifted_df


def combine_mouse_data(spike_counts, mice_data, mice_list):
    """
    Combine the spike counts and physiological data for each mouse in the provided list.

    Parameters:
    - spike_counts (dict): Dictionary containing DataFrames of neural data (spike counts) for each mouse.
    - mice_data (dict): Dictionary containing DataFrames of physiological data for each mouse.
    - mice_list (list): List of mice to combine data for.

    Returns:
    - combined_data (dict): Dictionary of combined DataFrames for each mouse.
    """
    combined_data = {}
    for mouse in mice_list:
        print(f"Combining data for mouse {mouse}...")
        combined_df = combine_dataframes_on_timebins(spike_counts[mouse], mice_data[mouse])
        combined_data[mouse] = combined_df
    return combined_data







