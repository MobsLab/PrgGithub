#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 25 11:30:14 2024

@author: gruffalo
"""


import numpy as np
import matplotlib.pyplot as plt



def df_col_corr_heatmap(df):
    """
    Plots a heatmap showing the correlations between each column of the given DataFrame.
    If the number of columns exceeds 6, the labels will not be displayed. The colorbar starts at 0.

    Parameters:
    df (pd.DataFrame): The input DataFrame where correlations between columns are computed.

    Returns:
    None: Displays the heatmap.
    """
    # Calculate the correlation between columns
    corr_matrix = df.corr()
    
    # Create a figure and axis object
    fig, ax = plt.subplots(figsize=(10, 8))
    
    # Create the heatmap using imshow and capture the returned object
    heatmap = ax.imshow(corr_matrix, cmap='YlOrRd', interpolation='none', vmin=0, vmax=1)
    
    # Add colorbar using the heatmap object and specify the correct figure
    cbar = fig.colorbar(heatmap, ax=ax)
    cbar.set_label('Correlation', fontsize=14)  # Set label and fontsize
    
    # Add ticks and labels only if the number of columns is 6 or less
    columns = df.columns
    if len(columns) <= 6:
        # Add ticks for each column with column names
        ax.set_xticks(np.arange(len(columns)))
        ax.set_xticklabels(columns, fontsize=14, rotation=25)
        ax.set_yticks(np.arange(len(columns)))
        ax.set_yticklabels(columns, fontsize=14)
        
        # Display the correlation values in each box
        for i in range(len(columns)):
            for j in range(len(columns)):
                ax.text(j, i, f"{corr_matrix.iloc[i, j]:.2f}", ha='center', va='center', color='black')
    else:
        # If more than 6 columns, hide ticks and labels
        ax.set_xticks([])
        ax.set_yticks([])

    # Show the plot
    plt.tight_layout()
    plt.show()



def compute_autocorrelation(mice_data, mouse_id, variable, max_lag=100, time_step=0.2, plot=True):
    """
    Computes the autocorrelation for a given variable in a specific mouse's data, 
    centered at lag 0 and including negative lags, with x-axis in seconds.

    Parameters:
    mice_data (dict): Dictionary containing the physiological data for each mouse.
    mouse_id (str): The ID of the mouse (e.g., 'Mouse508').
    variable (str): The name of the variable (e.g., 'Heartrate') for which to compute autocorrelation.
    max_lag (int): The maximum lag (number of time steps) for which to compute autocorrelation.
    time_step (float): The time difference between consecutive values (e.g., 0.2 seconds).
    plot (bool): Whether to plot the autocorrelation values (default=True).

    Returns:
    autocorr_values (dict): Dictionary of autocorrelation values with lags as keys.
    """
    
    # Ensure the mouse_id and variable exist in the data
    if mouse_id not in mice_data:
        raise ValueError(f"Mouse ID '{mouse_id}' not found in the data.")
    if variable not in mice_data[mouse_id].columns:
        raise ValueError(f"Variable '{variable}' not found in the mouse's data.")
    
    # Extract the series for the specified variable
    data_series = mice_data[mouse_id][variable]

    # Compute the autocorrelation for negative, zero, and positive lags
    autocorr_values = {}
    
    # Negative lags
    for lag in range(-max_lag, 0):
        autocorr_values[lag] = data_series.autocorr(lag=lag)
    
    # Lag 0
    autocorr_values[0] = data_series.autocorr(lag=0)
    
    # Positive lags
    for lag in range(1, max_lag + 1):
        autocorr_values[lag] = data_series.autocorr(lag=lag)

    # Plot the autocorrelation if requested
    if plot:
        plt.figure(figsize=(10, 6))
        
        # Compute time values for each lag (in seconds)
        lags = sorted(autocorr_values.keys())
        times_in_seconds = [lag * time_step for lag in lags]  # Convert lags to seconds
        
        autocorr_vals = [autocorr_values[lag] for lag in lags]
        
        # Plot the line without markers, make the line thicker
        plt.plot(times_in_seconds, autocorr_vals, color='brown', linestyle='-', linewidth=2.5, alpha=0.8)
        
        plt.axhline(0, color='black', linewidth=1)  # Add horizontal line at y=0 for reference
        plt.xlabel('Time (seconds)')
        plt.ylabel('Autocorrelation')
        plt.title(f'Autocorrelation of {variable} for {mouse_id}')
        
        # Set the y-axis limits
        plt.ylim(0, 1.05)

        plt.grid(True)  # Enable grid
        plt.show()
    
    return autocorr_values


def compute_cross_correlation(mice_data, mouse_id, variable_x, variable_y, max_lag=30, time_step=0.2, plot=True):
    """
    Computes the cross-correlation between two variables in a specific mouse's data, 
    centered at lag 0 and including negative lags, with the x-axis in seconds.

    Parameters:
    mice_data (dict): Dictionary containing the physiological data for each mouse.
    mouse_id (str): The ID of the mouse (e.g., 'Mouse508').
    variable_x (str): The first variable for cross-correlation (e.g., 'Heartrate').
    variable_y (str): The second variable for cross-correlation (e.g., 'BreathFreq').
    max_lag (int): The maximum lag (number of time steps) for which to compute cross-correlation.
    time_step (float): The time difference between consecutive values (e.g., 0.2 seconds).
    plot (bool): Whether to plot the cross-correlation values (default=True).

    Returns:
    cross_corr_values (dict): Dictionary of cross-correlation values with lags as keys.
    """
    
    # Ensure the mouse_id and variables exist in the data
    if mouse_id not in mice_data:
        raise ValueError(f"Mouse ID '{mouse_id}' not found in the data.")
    if variable_x not in mice_data[mouse_id].columns:
        raise ValueError(f"Variable '{variable_x}' not found in the mouse's data.")
    if variable_y not in mice_data[mouse_id].columns:
        raise ValueError(f"Variable '{variable_y}' not found in the mouse's data.")
    
    # Extract the series for the specified variables
    data_x = mice_data[mouse_id][variable_x].dropna()
    data_y = mice_data[mouse_id][variable_y].dropna()

    # Check if there are enough values in both variables to proceed
    if len(data_x) == 0:
        print(f"No valid values for {variable_x} in {mouse_id}.")
        return
    if len(data_y) == 0:
        print(f"No valid values for {variable_y} in {mouse_id}.")
        return

    # Ensure the two series are of the same length (after dropping NaNs)
    min_length = min(len(data_x), len(data_y))
    data_x = data_x[:min_length]
    data_y = data_y[:min_length]

    # Compute the cross-correlation for negative, zero, and positive lags
    cross_corr_values = {}
    
    # Negative lags
    for lag in range(-max_lag, 0):
        cross_corr_values[lag] = data_x.autocorr(lag=lag) if data_x.autocorr(lag=lag) else 0.0
    
    # Lag 0 (cross-correlation at lag 0 is just the correlation)
    cross_corr_values[0] = data_x.corr(data_y)
    
    # Positive lags
    for lag in range(1, max_lag + 1):
        cross_corr_values[lag] = data_y.autocorr(lag=lag) if data_y.autocorr(lag=lag) else 0.0

    # Plot the cross-correlation if requested
    if plot:
        plt.figure(figsize=(10, 6))
        
        # Compute time values for each lag (in seconds)
        lags = sorted(cross_corr_values.keys())
        times_in_seconds = [lag * time_step for lag in lags]  # Convert lags to seconds
        
        cross_corr_vals = [cross_corr_values[lag] for lag in lags]
        
        # Plot the line without markers, make the line thicker
        plt.plot(times_in_seconds, cross_corr_vals, color='brown', linestyle='-', linewidth=2.5, alpha=0.8)
        
        plt.axhline(0, color='black', linewidth=1)  # Add horizontal line at y=0 for reference
        plt.xlabel('Time (seconds)')
        plt.ylabel('Cross-Correlation')
        plt.title(f'Cross-Correlation of {variable_x} and {variable_y} for {mouse_id}')
        
        # Set the y-axis limits to fit the cross-correlation values
        if len(cross_corr_vals) > 0:
            plt.ylim(min(cross_corr_vals) - 0.1, max(cross_corr_vals) + 0.1)

        plt.grid(True)  # Enable grid
        plt.show()
    
    return cross_corr_values

