#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 25 11:30:14 2024

@author: gruffalo
"""


import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from scipy import signal
from analyse_data import extract_epoch_indices


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



def compute_cross_correlation(mice_data, mouse_id, variable_x, variable_y, max_lag=30, time_step=0.2, plot=True, epoch=None):
    """
    Computes and plots the cross-correlation between two variables in a specific mouse's data, 
    centered at lag 0 and including negative lags, using scipy's signal.correlate.
    
    Optionally, computes the cross-correlation within a specific epoch if provided.

    Parameters:
    mice_data (dict): Dictionary containing the physiological data for each mouse.
    mouse_id (str): The ID of the mouse (e.g., 'Mouse508').
    variable_x (str): The first variable for cross-correlation (e.g., 'Heartrate').
    variable_y (str): The second variable for cross-correlation (e.g., 'BreathFreq').
    max_lag (int): The maximum lag (number of time steps) for which to compute cross-correlation.
    time_step (float): The time difference between consecutive values (e.g., 0.2 seconds).
    plot (bool): Whether to plot the cross-correlation values (default=True).
    epoch (str, optional): The name of the epoch to use for cross-correlation. Default is None.

    Returns:
    cross_corr_values (np.array): Array of cross-correlation values.
    lags (np.array): Array of lag values.
    fig, ax (matplotlib figure and axis): The plot figure and axis (if plot is True).
    """
    
    # Ensure the mouse_id and variables exist in the data
    if mouse_id not in mice_data:
        raise ValueError(f"Mouse ID '{mouse_id}' not found in the data.")
    if variable_x not in mice_data[mouse_id].columns:
        raise ValueError(f"Variable '{variable_x}' not found in the mouse's data.")
    if variable_y not in mice_data[mouse_id].columns:
        raise ValueError(f"Variable '{variable_y}' not found in the mouse's data.")
    
    # Extract the series for the specified variables
    data_x = mice_data[mouse_id][variable_x]
    data_y = mice_data[mouse_id][variable_y]

    # If an epoch is provided, extract the corresponding indices
    if epoch is not None:
        indices = extract_epoch_indices(mice_data, mouse_id, epoch)
        data_x = data_x.iloc[indices]
        data_y = data_y.iloc[indices]

    # Combine the two variables into a single DataFrame
    combined_df = pd.DataFrame({variable_x: data_x, variable_y: data_y})

    # Drop rows where either variable_x or variable_y is NaN
    combined_df = combined_df.dropna()

    # Extract the cleaned series
    data_x_clean = combined_df[variable_x]
    data_y_clean = combined_df[variable_y]

    # Compute cross-correlation using scipy's signal.correlate
    cross_corr = signal.correlate(data_x_clean, data_y_clean, mode='full', method='auto')
    
    # Compute the lags
    lags = signal.correlation_lags(len(data_x_clean), len(data_y_clean), mode='full')

    # Normalize the cross-correlation by the maximum value
    cross_corr /= np.max(np.abs(cross_corr))

    # Limit the lags to the specified maximum lag
    max_lag_index = int(max_lag / time_step)
    center = len(cross_corr) // 2
    lags = lags[center - max_lag_index : center + max_lag_index + 1]
    cross_corr = cross_corr[center - max_lag_index : center + max_lag_index + 1]

    # Plot the cross-correlation if requested
    if plot:
        fig, ax = plt.subplots(figsize=(10, 6))
        
        # Convert lags to time in seconds for the x-axis
        times_in_seconds = lags * time_step
        
        # Plot the cross-correlation with a line
        ax.plot(times_in_seconds, cross_corr, color='brown', linestyle='-', linewidth=2.5, alpha=0.8)
        
        # Add reference lines
        ax.axvline(0, color='black', linewidth=1, linestyle='--')  # Vertical line at lag 0
        
        # Labels and title
        ax.set_xlabel('Lag (seconds)', fontsize=14)
        ax.set_ylabel('Cross-Correlation', fontsize=14)
        ax.set_title(f'Cross-Correlation of {variable_x} and {variable_y} for {mouse_id}', fontsize=16)
        
        # Set grid and layout
        ax.grid(True)
        plt.tight_layout()
        
        # Return plot along with the cross-correlation values and lags
        return cross_corr, lags, fig, ax

    # Return cross-correlation and lags without the plot if not requested
    return cross_corr, lags