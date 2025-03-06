#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 12:04:42 2025

@author: gruffalo
"""

def filter_columns(mice_data, columns_to_keep, drop_na=True):
    """
    Filters each mouse dataframe in the dictionary to retain only the specified columns.
    Optionally drops rows containing at least one NaN value.

    Parameters:
    - mice_data (dict): Dictionary containing dataframes for each mouse.
    - columns_to_keep (list): List of column names to retain in each dataframe.
    - drop_na (bool, optional): If True, drop rows that contain at least one NaN in the selected columns.

    Returns:
    - filtered_data (dict): Dictionary with the same structure as mice_data,
      but with only the specified columns retained and optionally cleaned of NaN rows.
    """
    filtered_data = {}

    for mouse_id, mouse_df in mice_data.items():
        # Select only the specified columns that exist in the dataframe
        filtered_df = mouse_df.loc[:, mouse_df.columns.intersection(columns_to_keep)].copy()

        # Drop rows containing NaN values if drop_na is True
        if drop_na:
            filtered_df = filtered_df.dropna()

        # Store the filtered dataframe in the dictionary
        filtered_data[mouse_id] = filtered_df

    return filtered_data


def filter_mice(mice_data, n):
    """
    Filters out mice with fewer than n datapoints.
    
    Parameters:
    mice_data (dict): Dictionary where keys are mouse IDs and values are DataFrames.
    n (int): Minimum number of datapoints required for a mouse to be included.
    
    Returns:
    dict: Filtered dictionary containing only mice with at least n datapoints.
    """
    return {mouse: df for mouse, df in mice_data.items() if len(df) >= n}



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


def normalize_data(mice_data, columns_to_normalize, drop_na=True):
    """
    Normalize specified columns for each mouse while keeping all other columns.
    Optionally drops rows containing NaN values before normalization.

    Parameters:
    - mice_data (dict): Dictionary containing data for each mouse.
    - columns_to_normalize (list): List of column names to normalize.
    - drop_na (bool, optional): If True, drop rows containing NaN values in the specified columns.

    Returns:
    - normalized_data (dict): Dictionary with the same structure as mice_data,
      but with specified columns normalized and other columns unchanged.
    """
    normalized_data = {}

    for mouse_id, mouse_df in mice_data.items():
        # Make a copy to avoid modifying the original data
        mouse_df_copy = mouse_df.copy()

        # Drop rows containing NaN values in specified columns if drop_na is True
        if drop_na:
            # mouse_df_copy = mouse_df_copy.dropna(subset=columns_to_normalize)
            mouse_df_copy = mouse_df_copy.dropna()

        # Normalize only the specified columns
        normalized_columns = zscore_columns(mouse_df_copy[columns_to_normalize], columns_to_normalize)

        # Replace original columns with normalized values while keeping all other columns
        mouse_df_copy[columns_to_normalize] = normalized_columns

        # Store the modified DataFrame in the new dictionary
        normalized_data[mouse_id] = mouse_df_copy

    return normalized_data



def add_interaction_term(mouse_data, col1, col2, new_col_name):
    """
    Adds an interaction term to each dataframe in the mouse_data dictionary.
    
    Parameters:
    mouse_data (dict): Dictionary where keys are mouse IDs and values are dataframes.
    col1 (str): Name of the first column.
    col2 (str): Name of the second column.
    new_col_name (str): Name of the new interaction column.
    
    Returns:
    dict: Updated dictionary with interaction terms added.
    """
    for mouse, df in mouse_data.items():
        df[new_col_name] = df[col1] * df[col2]
    return mouse_data