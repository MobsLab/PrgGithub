#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  3 17:09:58 2024

@author: gruffalo
"""

import matplotlib.pyplot as plt
import pandas as pd
from scipy.stats import sem

def extract_r2_values(results_list):
    """
    Extract R² values for each neuron, model, and mouse from a list of results dictionaries.

    Parameters:
    - results_list (list): List of dictionaries containing the results for each neuron and mouse.

    Returns:
    - r2_data (pd.DataFrame): A DataFrame containing the extracted R² values with mouse, neuron, and model details.
    """

    # Initialize a list to hold the extracted data
    extracted_data = []

    # Loop through each result dictionary in the list
    for result in results_list:
        if result is None:  # Skip if the result is None
            continue
        
        mouse_id = result['mouse_id']
        neuron_id = result['dependent_var']
        models = result['results']  # Access the models dictionary

        # Extract R² for each model
        for model_name, model_data in models.items():
            r2_value = model_data.get('best_mean_r_squared', None)  # Get R² value, default to None if not present
            extracted_data.append({
                'Mouse_ID': mouse_id,
                'Neuron_ID': neuron_id,
                'Model': model_name,
                'R²': r2_value
            })

    # Convert the list of extracted data to a DataFrame
    r2_data = pd.DataFrame(extracted_data)

    return r2_data


def plot_r2_means_sem(results_list):
    """
    Generate a bar plot of mean R² values with SEM for different models from the results,
    ordered in a specific sequence: BF, HR, motion, BFmotion, HRmotion, all.

    Parameters:
    - results_list (list): List of dictionaries containing the results for each neuron and mouse.

    Returns:
    - None: Displays the bar plot.
    """
    # Extract R² values into a DataFrame
    r2_data = extract_r2_values(results_list)

    # Group by the model and compute mean and SEM
    summary_stats = r2_data.groupby('Model')['R²'].agg(['mean', sem]).reset_index()

    # Define the desired order for the models
    desired_order = ['BF', 'HR', 'motion', 'BFmotion', 'HRmotion', 'all']

    # Reorder the DataFrame according to the desired order
    summary_stats['Model'] = pd.Categorical(summary_stats['Model'], categories=desired_order, ordered=True)
    summary_stats = summary_stats.sort_values('Model')

    # Create the plot
    plt.figure(figsize=(10, 6))
    plt.bar(summary_stats['Model'], summary_stats['mean'], yerr=summary_stats['sem'], capsize=5, alpha=0.7)

    # Add labels and title
    plt.ylabel('Mean R² ± SEM', fontsize=14)
    plt.xlabel('Model', fontsize=14)
    plt.title('Mean R² Values Across Models with SEM', fontsize=16)
    plt.xticks(rotation=45, fontsize=12)
    plt.grid(axis='y', linestyle='--', alpha=0.6)

    # Show the plot
    plt.tight_layout()
    plt.show()


# def plot_r2_means_sem(results_list):
#     """
#     Generate a bar plot of mean R² values with SEM for different models from the results.

#     Parameters:
#     - results_list (list): List of dictionaries containing the results for each neuron and mouse.

#     Returns:
#     - None: Displays the bar plot.
#     """
#     # Extract R² values into a DataFrame
#     r2_data = extract_r2_values(results_list)

#     # Group by the model and compute mean and SEM
#     summary_stats = r2_data.groupby('Model')['R²'].agg(['mean', sem]).reset_index()

#     # Create the plot
#     plt.figure(figsize=(10, 6))
#     plt.bar(summary_stats['Model'], summary_stats['mean'], yerr=summary_stats['sem'], capsize=5, alpha=0.7)

#     # Add labels and title
#     plt.ylabel('Mean R² ± SEM', fontsize=14)
#     plt.xlabel('Model', fontsize=14)
#     plt.title('Mean R² Values Across Models with SEM', fontsize=16)
#     plt.xticks(rotation=45, fontsize=12)
#     plt.grid(axis='y', linestyle='--', alpha=0.6)

#     # Show the plot
#     plt.tight_layout()
#     plt.show()
    

