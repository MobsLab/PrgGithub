# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 13:59:01 2024

@author: ellac
"""

import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd
import joypy
from analyse_data import extract_epoch_indices


def plot_variable_time(mice_data, mouse_id, variable_name):
    """
    Plot the specified variable for a given mouse.
    
    Parameters:
    - mice_data (dict): Dictionary containing dataframes for each mouse.
    - mouse_id (str): The ID of the mouse whose variable will be plotted.
    - variable_name (str): The name of the column (variable) to plot.
    
    Returns:
    - None: Displays the plot.
    """
    # Access the dataframe of the specified mouse
    mouse_df = mice_data[mouse_id]
    
    # Check if the variable exists in the dataframe
    if variable_name not in mouse_df.columns:
        print(f"Variable '{variable_name}' not found in the dataframe of mouse '{mouse_id}'.")
        return
    
    # Plot the variable
    plt.figure(figsize=(8, 5))
    plt.plot(mouse_df[variable_name], label=variable_name)
    plt.title(f"Plot of {variable_name} for mouse {mouse_id}")
    plt.xlabel("Timepoints")
    plt.ylabel(variable_name)
    plt.legend()
    plt.grid(True)
    plt.show()


def plot_variable_conditions(mice_data, mouse_id, variable, epoch_names):
    """
    Plot a violin plot to visualize the distribution of a variable across different conditions (epochs).

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - variable (str): Variable to be plotted.
    - epoch_names (list): List of epoch names for different conditions.

    Returns:
    - fig: Matplotlib figure object.
    """

    data_dict = {}

    # Extract data for each specified epoch
    for epoch in epoch_names:
        data_dict[f'data_{epoch}'] = mice_data[mouse_id][variable][extract_epoch_indices(mice_data, mouse_id, epoch)]

    # Combine the data and create labels for conditions
    combined_data = np.concatenate([data_dict[f'data_{epoch}'] for epoch in epoch_names])
    if epoch.endswith('StartStop'):
        condition_labels = [epoch[:-9] for epoch in epoch_names for _ in range(len(data_dict[f'data_{epoch}']))]
    elif epoch.endswith('_epo'):
        condition_labels = [epoch[:-4] for epoch in epoch_names for _ in range(len(data_dict[f'data_{epoch}']))]

    # Create a DataFrame for Seaborn
    df = pd.DataFrame({variable: combined_data, 'Conditions': condition_labels})

    # Create a violin plot using Seaborn with the 'hue' parameter
    fig, ax = plt.subplots()
    sns.violinplot(x=variable, y='Conditions', hue='Conditions', data=df, palette='husl', legend=False, ax=ax)

    # Set the title
    ax.set_title(f'{mouse_id} : Violin Plot with Multiple Conditions')

    return fig


def joyplot_variables_mice(mice_data, mouse_ids, variables):
    """
    Create a joyplot for a given set of variables across multiple mice, where each variable is represented by its own column.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data (dataframes).
    - mouse_ids (list): List of mouse IDs to include in the plot.
    - variables (list): List of variables to plot.

    Returns:
    - fig, axes: The matplotlib figure and axes objects.
    """
    # Initialize a list to hold the data for plotting
    plot_data = []

    # Loop through each mouse and create a dataframe with one column for each variable
    for mouse_id in mouse_ids:
        mouse_dict = {'Mouse': [mouse_id] * len(mice_data[mouse_id])}  # Mouse column
        
        # Add the specified variables as columns
        for variable in variables:
            if variable not in mice_data[mouse_id].columns:
                print(f"Variable '{variable}' not found for mouse '{mouse_id}'. Skipping...")
                continue
            mouse_dict[variable] = mice_data[mouse_id][variable]
        
        # Create a DataFrame for this mouse and append to the list
        mouse_df = pd.DataFrame(mouse_dict)
        plot_data.append(mouse_df)
    
    # Combine all data into a single DataFrame for plotting
    combined_df = pd.concat(plot_data, ignore_index=True)

    # Create a joyplot for each variable, grouped by Mouse
    plt.figure(figsize=(16, 10), dpi=80)
    fig, axes = joypy.joyplot(combined_df, by="Mouse", column=variables, 
                              figsize=(14, 10), grid="y", fade=False, 
                              legend=True)

    # Set the title and labels
    plt.suptitle(f"{', '.join(variables)} for Mice: {', '.join(mouse_ids)}", size=16)
    plt.xlabel("Values")
    plt.ylabel("Mouse")

    return fig, axes


def plot_scatter(data_x, data_y, title=None):
    """
    Plot a scatter plot between two columns and customize the labels and title.

    Parameters:
    - data_x: Pandas Series, x-axis data
    - data_y: Pandas Series, y-axis data
    - title: String, title of the plot
    
    Returns:
    - fig: Matplotlib figure object.
    """
    fig, ax = plt.subplots()
    sns.scatterplot(x=data_x, y=data_y, ax=ax)
    if title:
        ax.set_title(title)
    ax.grid(True)
    return fig


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







