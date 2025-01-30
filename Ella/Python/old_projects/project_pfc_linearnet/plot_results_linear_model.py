#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 11:21:09 2024

@author: gruffalo
"""

import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import os
from model_linear_regression_permutation import count_significant_neurons_per_model



def plot_r2_distribution_multiple_neurons(r2_results, independent_vars=None, bins=10, color='blue', kde=True):
    """
    Plot the distribution of R-squared values for multiple neurons and return the mean R² and SEM.
    
    Parameters:
    - r2_results (dict): Dictionary returned by cross_validate_multiple_neurons,
                         where keys are neuron names and values are their mean R-squared values.
    - independent_vars (list of str, optional): List of independent variables to include in the legend.
    - bins (int): Number of bins for the histogram. Default is 10.
    - color (str): Color of the plot. Default is 'blue'.
    - kde (bool): Whether to include Kernel Density Estimate (KDE). Default is True.
    
    Returns:
    - mean_r2 (float): Mean R² value.
    - sem_r2 (float): Standard error of the mean (SEM) of the R² values.
    """
    # Extract R-squared values from the dictionary
    r2_values = list(r2_results.values())
    
    # Calculate mean and SEM
    mean_r2 = np.mean(r2_values)
    sem_r2 = np.std(r2_values) / np.sqrt(len(r2_values))

    # Create the plot
    fig = plt.figure(figsize=(8, 6))
    
    # Plot distribution using Seaborn
    sns.histplot(r2_values, kde=kde, bins=bins, color=color, alpha=0.7)
    
    # Add title and labels
    plt.title(f"Distribution of R² Values Across Neurons\nMean R²: {mean_r2:.3f}, SEM: {sem_r2:.3f}", fontsize=16, fontweight='bold')
    plt.xlabel("R²", fontsize=14, fontweight='bold')
    plt.ylabel("Frequency", fontsize=14, fontweight='bold')
    
    # Set xlim and ylim
    plt.xlim(-0.1, 1)
    plt.ylim(0, 70)

    
    # Add legend for independent variables, if provided
    if independent_vars:
        plt.legend([f"Independent Variables: {', '.join(independent_vars)}"], loc='upper right', fontsize=12)

    # Show the plot
    plt.show()
    
    return fig


def plot_r2_distribution_per_mouse(r2_results_per_mouse, independent_vars=None, bins=10, color='green', kde=True):
    """
    Plot the distribution of R-squared values for neurons across multiple mice and return the mean R² and SEM per mouse.
    
    Parameters:
    - r2_results_per_mouse (dict): Dictionary returned by cross_validate_neurons_per_mouse,
                                   where keys are mouse names, and values are dictionaries of neuron R² values.
    - independent_vars (list of str, optional): List of independent variables to include in the legend.
    - bins (int): Number of bins for the histogram. Default is 10.
    - color (str): Color of the plot. Default is 'green'.
    - kde (bool): Whether to include Kernel Density Estimate (KDE). Default is True.
    
    Returns:
    - mean_r2_per_mouse (dict): Mean R² values for each mouse.
    - sem_r2_per_mouse (dict): SEM of the R² values for each mouse.
    """
    mean_r2_per_mouse = {}
    sem_r2_per_mouse = {}

    # Loop through each mouse
    for mouse, neuron_r2 in r2_results_per_mouse.items():
        # Extract R-squared values for this mouse
        r2_values = list(neuron_r2.values())
        mean_r2 = np.mean(r2_values)
        sem_r2 = np.std(r2_values) / np.sqrt(len(r2_values))
        
        mean_r2_per_mouse[mouse] = mean_r2
        sem_r2_per_mouse[mouse] = sem_r2
        
        # Create a plot for this mouse
        fig = plt.figure(figsize=(8, 6))
        
        # Plot distribution using Seaborn
        sns.histplot(r2_values, kde=kde, bins=bins, color=color, alpha=0.7)
        
        # Add title and labels
        plt.title(f"Distribution of R² Values for {mouse}\nMean R²: {mean_r2:.3f}, SEM: {sem_r2:.3f}", fontsize=16, fontweight='bold')
        plt.xlabel("R²", fontsize=14, fontweight='bold')
        plt.ylabel("Frequency", fontsize=14, fontweight='bold')
        
        # Set xlim
        plt.xlim(-0.1, 1)
        plt.ylim(0, 70)
        
        # Add legend for independent variables, if provided
        if independent_vars:
            plt.legend([f"Independent Variables: {', '.join(independent_vars)}"], loc='upper right', fontsize=12)

        # Show the plot
        plt.show()

    return fig


def plot_combined_r2_distribution(r2_results_per_mouse, independent_vars=None, bins=10, color='purple', kde=True):
    """
    Plot the combined distribution of R-squared values across all mice and neurons and return the mean R² and SEM.
    
    Parameters:
    - r2_results_per_mouse (dict): Dictionary returned by cross_validate_neurons_per_mouse,
                                   where keys are mouse names, and values are dictionaries of neuron R² values.
    - independent_vars (list of str, optional): List of independent variables to include in the legend.
    - bins (int): Number of bins for the histogram. Default is 10.
    - color (str): Color of the plot. Default is 'purple'.
    - kde (bool): Whether to include Kernel Density Estimate (KDE). Default is True.
    
    Returns:
    - mean_r2 (float): Mean R² value across all mice.
    - sem_r2 (float): SEM of the R² values across all mice.
    """
    # Initialize an empty list to collect all R-squared values
    all_r2_values = []
    
    # Loop through each mouse and collect all R-squared values
    for mouse, neuron_r2 in r2_results_per_mouse.items():
        all_r2_values.extend(neuron_r2.values())  # Add all R² values from this mouse to the list

    # Calculate mean and SEM
    mean_r2 = np.mean(all_r2_values)
    sem_r2 = np.std(all_r2_values) / np.sqrt(len(all_r2_values))

    # Create a combined plot
    fig = plt.figure(figsize=(8, 6))
    
    # Plot distribution using Seaborn
    sns.histplot(all_r2_values, kde=kde, bins=bins, color=color, alpha=0.7)
    
    # Add title and labels
    plt.title(f"Combined Distribution of R² Values Across All Mice\nMean R²: {mean_r2:.3f}, SEM: {sem_r2:.3f}", fontsize=16, fontweight='bold')
    plt.xlabel("R²", fontsize=14, fontweight='bold')
    plt.ylabel("Frequency", fontsize=14, fontweight='bold')
    
    # Set xlim
    plt.xlim(-0.1, 1)
    plt.ylim(0, 70)
    
    # Add legend for independent variables, if provided
    if independent_vars:
        plt.legend([f"Independent Variables: {', '.join(independent_vars)}"], loc='upper right', fontsize=12)

    # Show the plot
    plt.show()

    return fig


def plot_model_comparison_r2(models_r2_results, model_labels):
    """
    Generate a bar plot for the means and SEM of R² values from different models, with y-axis in percentage.
    
    Parameters:
    - models_r2_results (list of dict): List of dictionaries, each corresponding to the output of 
                                        `filter_neurons_by_p_value_per_mouse` for different models.
    - model_labels (list of str): List of labels for each model to be used in the legend.
    
    Returns:
    - None
    """
    # Initialize lists to store the means and SEMs for each model
    means = []
    sems = []

    # Loop through the results of each model
    for model_r2 in models_r2_results:
        # Extract all R² values from the filtered results
        all_r2_values = []
        for mouse_r2 in model_r2.values():
            all_r2_values.extend(mouse_r2.values())
        
        # Calculate mean and SEM for this model
        mean_r2 = np.mean(all_r2_values)
        sem_r2 = np.std(all_r2_values) / np.sqrt(len(all_r2_values))
        
        # Append the calculated mean and SEM to the lists (convert to percentage)
        means.append(mean_r2 * 100)
        sems.append(sem_r2 * 100)

    # Create a bar plot
    fig = plt.figure(figsize=(10, 6))
    
    # Number of models
    num_models = len(model_labels)
    
    # Bar plot with error bars
    plt.bar(range(num_models), means, yerr=sems, capsize=5, color='brown', alpha=0.7)
    
    # Add labels and title
    plt.xticks(range(num_models), model_labels, fontsize=12, fontweight='bold', rotation=40)
    plt.ylabel('(%) variance explained (R²)', fontsize=14, fontweight='bold')
    # plt.title('Comparison of Mean R² Across Different Models (in %)', fontsize=16, fontweight='bold')
    
    # Display the plot
    plt.show()
    
    return fig


def plot_significant_neurons_proportion(models_r2_results, model_labels, p_value_threshold=0.05, correction=False, correction_method='fdr_bh'):
    """
    Generate a bar plot for the proportion of significant neurons for each model.
    
    Parameters:
    - models_r2_results (list of dicts): List of R² results for each model, each structured by mouse and neuron.
    - model_labels (list of str): List of labels corresponding to each model.
    - p_value_threshold (float): P-value threshold for significance. Default is 0.05.
    - correction (bool): Whether to apply multiple testing correction. Default is False.
    - correction_method (str): The correction method to apply. Default is 'fdr_bh'.
    
    Returns:
    - fig: The figure object containing the bar plot.
    """
    # Count the proportion of significant neurons for each model
    significant_proportions = count_significant_neurons_per_model(models_r2_results, model_labels, 
                                                                  p_value_threshold=p_value_threshold, 
                                                                  correction=correction, 
                                                                  correction_method=correction_method)

    # Extract the proportions in percentages for the bar plot
    proportions = [significant_proportions[label] for label in model_labels]

    # Create a bar plot
    fig = plt.figure(figsize=(10, 6))
    
    # Number of models
    num_models = len(model_labels)
    
    # Bar plot for the proportions
    plt.bar(range(num_models), proportions, color='brown', alpha=0.7)
    
    # Add labels and title
    plt.xticks(range(num_models), model_labels, fontsize=12, fontweight='bold', rotation=40)
    plt.ylabel('(%) significant neurons', fontsize=14, fontweight='bold')
    plt.ylim(0, 100)  # Set y-axis limit to 100%
    
    # Display the plot
    plt.show()
    
    return fig



def save_plot_as_svg(directory, filename, fig=None):
    """
    Save the current or passed figure as an .svg file in the specified directory, ensuring that the plot is not cropped.
    
    Parameters:
    - directory (str): The path to the directory where the plot will be saved.
    - filename (str): The name of the file (without extension) to save the plot.
    - fig (matplotlib.figure.Figure, optional): The figure object to save. If None, saves the current active figure.
    
    Returns:
    - None
    """
    # Ensure the directory exists, if not, create it
    if not os.path.exists(directory):
        os.makedirs(directory)

    # Full path to save the file (adding .svg extension)
    filepath = os.path.join(directory, f"{filename}.svg")

    # Save the provided figure or the current active figure
    if fig is None:
        plt.savefig(filepath, format='svg', bbox_inches='tight')
    else:
        fig.savefig(filepath, format='svg', bbox_inches='tight')

    print(f"Plot saved to {filepath}")
