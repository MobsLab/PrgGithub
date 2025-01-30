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
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import LabelEncoder
from analyse_data import extract_epoch_indices


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

    # Customize x-axis ticks to display only 1 out of 4 ticks
    xticks_labels = np.round(result_df.iloc[:,0].values[::4], 1)
    ax.set_xticks(np.arange(0, len(result_df), 4))
    ax.set_xticklabels(xticks_labels.astype(str), rotation=45)

    # Label the axes
    ax.set_xlabel(result_df.columns[0])
    ax.set_ylabel('SU ordered by preferred frequency')

    # Set a title
    ax.set_title(mouse_id)

    # Add colorbar
    cbar = fig.colorbar(im, ax=ax)
    cbar.set_label('Firing rate (z-scored)')

    return fig, ax
    

def plot_class_values(combined_df, class_names, variable_x, variable_y, color_map='viridis'):
    """
    Create a scatter plot to visualize values of two variables for specified classes.

    Parameters:
    - combined_df (DataFrame): DataFrame containing data for multiple classes.
    - class_names (list): List of class labels to visualize.
    - variable_x (str): Name of the variable to be plotted on the x-axis.
    - variable_y (str): Name of the variable to be plotted on the y-axis.
    - color_map (str, optional): Colormap for class distinctions. Default is 'viridis'.

    Returns:
    - fig (matplotlib.figure.Figure): Matplotlib figure containing the scatter plot.
    """

    # Filter the DataFrame for the specified classes
    class_df = combined_df[combined_df['Label'].isin(class_names)]

    # Create a scatter plot with seaborn
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.scatterplot(x=variable_x, y=variable_y, data=class_df, hue='Label', palette=color_map, ax=ax)

    # Set plot labels and title
    ax.set_xlabel(variable_x)
    ax.set_ylabel(variable_y)
    ax.set_title(f'Scatter Plot for {", ".join(class_names)}')

    # Show the legend
    ax.legend()

    # Return the figure
    return fig


def plot_decision_boundary(combined_df, class_names, variable_x, variable_y):
    """
    Plot a scatter plot of two variables and visualize the decision boundary
    from a logistic regression model to assess linear separability.

    Parameters:
    - combined_df (DataFrame): DataFrame containing data for multiple classes.
    - class_names (list): List of class labels to visualize.
    - variable_x (str): Name of the first variable (x-axis).
    - variable_y (str): Name of the second variable (y-axis).
    
    Returns:
    - fig (matplotlib.figure.Figure): Matplotlib figure with the scatter plot and decision boundary.
    """

    # Filter the DataFrame for the specified classes
    class_df = combined_df[combined_df['Label'].isin(class_names)]

    # Encode class labels to binary (0, 1) for logistic regression
    le = LabelEncoder()
    class_df['Label_encoded'] = le.fit_transform(class_df['Label'])

    # Fit a logistic regression model
    X = class_df[[variable_x, variable_y]].values
    y = class_df['Label_encoded'].values
    clf = LogisticRegression()
    clf.fit(X, y)

    # Set up the figure
    fig, ax = plt.subplots(figsize=(10, 6))

    # Create a scatter plot of the two variables
    sns.scatterplot(x=variable_x, y=variable_y, data=class_df, hue='Label', palette="Set2", ax=ax)

    # Create a meshgrid for plotting decision boundary
    x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
    y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
    xx, yy = np.meshgrid(np.linspace(x_min, x_max, 100), np.linspace(y_min, y_max, 100))
    Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])
    Z = Z.reshape(xx.shape)

    # Plot the decision boundary
    ax.contourf(xx, yy, Z, alpha=0.2, cmap='coolwarm')
    ax.set_title(f'Decision Boundary for {variable_x} vs {variable_y}')

    # Set axis labels
    ax.set_xlabel(variable_x)
    ax.set_ylabel(variable_y)

    return fig


def plot_class_violin(combined_df, class_names, variable_x, variable_y):
    """
    Create four violin plots to visualize the distribution of two variables across two classes.

    Parameters:
    - combined_df (DataFrame): DataFrame containing data for multiple classes.
    - class_names (list): List of class labels to visualize (should be two classes).
    - variable_x (str): Name of the first variable.
    - variable_y (str): Name of the second variable.

    Returns:
    - fig (matplotlib.figure.Figure): Matplotlib figure containing the violin plots.
    """

    # Filter the DataFrame for the specified classes
    class_df = combined_df[combined_df['Label'].isin(class_names)]

    # Set up the figure with 2x2 layout for four plots (two variables, two states)
    fig, axes = plt.subplots(1, 2, figsize=(12, 6))

    # Create a violin plot for the first variable
    sns.violinplot(x='Label', y=variable_x, data=class_df, ax=axes[0], hue='Label', palette="Set2", split=True, legend=False)
    axes[0].set_title(f'Violin Plot of {variable_x}')

    # Create a violin plot for the second variable
    sns.violinplot(x='Label', y=variable_y, data=class_df, ax=axes[1], hue='Label', palette="Set2", split=True, legend=False)
    axes[1].set_title(f'Violin Plot of {variable_y}')

    # Set axis labels
    axes[0].set_xlabel('Class')
    axes[0].set_ylabel(variable_x)
    axes[1].set_xlabel('Class')
    axes[1].set_ylabel(variable_y)

    # Return the figure
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







