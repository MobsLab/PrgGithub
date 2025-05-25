# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 13:59:01 2024

@author: ellac
"""

import os
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns


def plot_scatter_neuron(data_x, data_y, x_label, title=None):
    """
    Plot a scatter plot between two columns and customize the labels and title.

    Parameters:
    - data_x: Pandas Series, x-axis data
    - data_y: Pandas Series, y-axis data
    - x_label: String, label for the x-axis
    - title: String, optional, title of the plot
    
    Returns:
    - fig: Matplotlib figure object.
    """
    fig, ax = plt.subplots()
    
    # Create scatter plot
    sns.scatterplot(x=data_x, y=data_y, ax=ax)
    
    # Set labels
    ax.set_xlabel(x_label)
    ax.set_ylabel('spike count per timebin')
    
    # Set optional title
    if title:
        ax.set_title(title)
    
    # Display grid
    ax.grid(True)
    
    return fig



def plot_raster_plot(spike_times, title):
    """
    Plot a raster plot of spike times.

    Parameters:
    - spike_times (array): Array containing spike times.
    - title (str): Plot title.
    
    Returns:
    - fig: Matplotlib figure object.
    """
    fig, ax = plt.subplots()
    ax.eventplot(spike_times.dropna().values, lineoffsets=0, linelengths=0.5, color='black')
    ax.set_xlabel('Time (s)')
    ax.set_ylabel('Neuron')
    ax.set_title(title)
    return fig


def plot_spike_time_histogram(spike_times, bins=50, color='black',
                              edgecolor='black', xlabel='Time (s)',
                              ylabel='Spike Count', title='Spike Time Histogram'):
    """
    Plot a histogram-like plot for spike times.

    Parameters:
    - spike_times (array): Array containing spike times.
    - bins (int or array, optional): Number of bins or bin edges. Default is 50.
    - color (str, optional): Color of the bars. Default is 'black'.
    - edgecolor (str, optional): Color of the bar edges. Default is 'black'.
    - xlabel (str, optional): Label for the x-axis. Default is 'Time (s)'.
    - ylabel (str, optional): Label for the y-axis. Default is 'Spike Count'.
    - title (str, optional): Plot title. Default is 'Spike Time Histogram'.
    
    Returns:
    - fig: Matplotlib figure object.
    """
    fig, ax = plt.subplots()
    ax.hist(spike_times, bins=bins, color=color, edgecolor=edgecolor)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    return fig


def plot_neuron_activity(result_df, mouse_id, neuron_key, variable_name, show_std=True):
    """
    Plot the mean activity of a neuron, with optional standard deviation error bars.

    Parameters:
    - result_df (pd.DataFrame): DataFrame returned by spike_count_variable_mean_std containing mean and std activity.
    - mouse_id (str): Identifier for the mouse.
    - neuron_key (str): The neuron key (column name prefix) to plot (e.g., 'Neuron1').
    - variable_name (str): The name of the variable (e.g., 'Accelero') to plot against.
    - show_std (bool, optional): Whether to plot standard deviation as error bars. Default is True.

    Returns:
    - None: Displays the plot.
    """

    # Check if the neuron exists in the DataFrame
    mean_col = f'{neuron_key}_mean'
    std_col = f'{neuron_key}_std'
    
    if mean_col not in result_df.columns or (show_std and std_col not in result_df.columns):
        print(f"Neuron '{neuron_key}' data not found in the result dataframe.")
        return
    
    # Extract the variable, mean activity, and (optional) std activity for the neuron
    variable_data = result_df[variable_name]
    mean_activity = result_df[mean_col]
    std_activity = result_df[std_col] if show_std else None
    
    # Set up the plot
    plt.figure(figsize=(9, 6))

    if show_std:
        # Plot mean activity with error bars (std deviation)
        plt.errorbar(variable_data, mean_activity, yerr=std_activity, fmt='-', 
                     capsize=4, color='teal', linewidth=3, ecolor='teal', elinewidth=2)
    else:
        # Plot mean activity without error bars
        plt.plot(variable_data, mean_activity, '-', color='b')

    # Set plot labels and title
    plt.xlabel(variable_name, fontsize=14, fontweight='bold')
    plt.ylabel('Neuron Activity (mean ± std)', fontsize=14, fontweight='bold')
    plt.title(f'Mean Activity of {neuron_key} in {mouse_id}', fontsize=16, fontweight='bold')

    # Customize the aesthetics
    plt.xticks(fontsize=10)
    plt.yticks(fontsize=10)
    plt.tight_layout()

    # Show the plot
    plt.show()


def plot_spike_count_heatmap(result_df, mouse_id, cmap='viridis', vmin=-2, vmax=2):
    """
    Plot a heatmap of z-scored spike counts for neurons, ordered by preferred frequency.

    Parameters:
    - result_df (DataFrame): DataFrame containing spike count data.
    - mouse_id (str): Identifier for the mouse.
    - cmap (str, optional): Colormap for the heatmap. Default is 'viridis'.
    - vmin (float, optional): Minimum value for color normalization. Default is -2.
    - vmax (float, optional): Maximum value for color normalization. Default is 2.

    Returns:
    - fig: Matplotlib figure object.
    - ax: Matplotlib axis object.
    """

    # Extract relevant data from result_df
    spike_sum_matrix = result_df.iloc[:, 1:].values.T
    row_means = np.mean(spike_sum_matrix, axis=1, keepdims=True)
    row_stds = np.std(spike_sum_matrix, axis=1, keepdims=True)
    z_scored_matrix = np.clip((spike_sum_matrix - row_means) / row_stds, vmin, vmax)
    
    # Find the indices of the maximum values in each row
    max_indices = np.argmax(z_scored_matrix, axis=1)

    # Sort the matrix based on the maximum indices
    sorted_matrix = z_scored_matrix[np.argsort(max_indices)]

    # Create a figure and axis
    fig, ax = plt.subplots()

    # Plot the matrix using imshow
    im = ax.imshow(sorted_matrix, aspect='auto', cmap=cmap, origin='upper', vmin=vmin, vmax=vmax)

    # Customize x-axis ticks to display only 1 out of 5 ticks
    xticks_labels = np.round(result_df.iloc[:,0].values[::5], 1)
    ax.set_xticks(np.arange(0, len(result_df), 5))
    ax.set_xticklabels(xticks_labels.astype(str), rotation=0)

    # Label the axes
    ax.set_xlabel(result_df.columns[0])
    ax.set_ylabel('SU ordered by preferred frequency')

    # Set a title
    ax.set_title(mouse_id)

    # Add colorbar
    cbar = fig.colorbar(im, ax=ax)
    cbar.set_label('Firing rate (z-scored)')

    return fig, ax
    

def save_plot(figure, filename, directory=None, bbox_inches='tight', dpi=300):
    """
    Save a Matplotlib figure to a file and return the figure.

    Parameters:
    - figure: Matplotlib figure to be saved.
    - filename: Name of the file to save the figure as (e.g., 'my_plot.png').
    - directory (optional): Directory where the file will be saved. Default is None (current working directory).
    - bbox_inches (optional): Bounding box in inches. Default is 'tight'.
    - dpi (optional): Dots per inch for the figure. Default is 300.

    Returns:
    - figure: The input figure.
    """
    
    if directory:
        # If directory is provided, check if it exists, and create it if not
        os.makedirs(directory, exist_ok=True)
        filepath = os.path.join(directory, filename)
    else:
        # If no directory is provided, use the filename as-is
        filepath = filename

    # Save the figure with adjusted bbox_inches and dpi
    figure.savefig(filepath, bbox_inches=bbox_inches, dpi=dpi)
    print(f"Plot saved as: {filepath} with DPI: {dpi}")

    return figure







