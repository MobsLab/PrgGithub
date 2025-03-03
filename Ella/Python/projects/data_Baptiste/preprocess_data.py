#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 12:04:42 2025

@author: gruffalo
"""

def filter_columns(mice_data, columns_to_keep):
    """
    Filters each mouse dataframe in the dictionary to retain only the specified columns.

    Parameters:
    - mice_data (dict): Dictionary containing dataframes for each mouse.
    - columns_to_keep (list): List of column names to retain in each dataframe.

    Returns:
    - filtered_data (dict): Dictionary with the same structure as mice_data,
      but with only the specified columns retained.
    """
    filtered_data = {}

    for mouse_id, mouse_df in mice_data.items():
        # Ensure only the columns that exist in the dataframe are selected
        filtered_data[mouse_id] = mouse_df.loc[:, mouse_df.columns.intersection(columns_to_keep)].copy()

    return filtered_data


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



# def normalize_data(mice_data, columns_to_normalize):
#     """
#     Normalize specified columns for each mouse.

#     Parameters:
#     - mice_data (dict): Dictionary containing data for each mouse.
#     - columns_to_normalize (list): List of column names to normalize.

#     Returns:
#     - normalized_data (dict): Dictionary with the same structure as mice_data,
#       but with normalized specified columns.
#     """
#     normalized_data = {}

#     for mouse_id, mouse_df in mice_data.items():
#         # Make a copy to avoid modifying the original data
#         mouse_df_copy = mouse_df.copy()
        
#         # Apply zscore normalization to the specified columns
#         mouse_df_copy = zscore_columns(mouse_df_copy, columns_to_normalize)
        
#         # Store the normalized DataFrame in the new dictionary
#         normalized_data[mouse_id] = mouse_df_copy

#     return normalized_data