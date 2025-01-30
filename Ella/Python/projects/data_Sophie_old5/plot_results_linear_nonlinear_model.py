#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  3 17:09:58 2024

@author: gruffalo
"""

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from scipy.stats import sem

def extract_r2_values(results_list):
    """
    Extract R² values (train and test) for each neuron, model, and mouse from a list of results dictionaries.

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
            r2_train = model_data.get('best_mean_r_squared', None)  # Train R²
            r2_test = model_data.get('r2_test', None)  # Test R²
            extracted_data.append({
                'Mouse_ID': mouse_id,
                'Neuron_ID': neuron_id,
                'Model': model_name,
                'R²_train': r2_train,
                'R²_test': r2_test
            })

    # Convert the list of extracted data to a DataFrame
    r2_data = pd.DataFrame(extracted_data)

    return r2_data



def plot_r2_means_sem(results_list, r2_type='train'):
    """
    Generate a bar plot of mean R² values with SEM for different models from the results,
    ordered in a specific sequence: BF, HR, motion, BFmotion, HRmotion, all.

    Parameters:
    - results_list (list): List of dictionaries containing the results for each neuron and mouse.
    - r2_type (str): Type of R² to plot. Options are 'train' (default) or 'test'.

    Returns:
    - None: Displays the bar plot.
    """
    # Validate the r2_type input
    if r2_type not in ['train', 'test']:
        raise ValueError("Invalid r2_type. Choose either 'train' or 'test'.")

    # Map the R² type to the corresponding column name
    r2_column = 'R²_train' if r2_type == 'train' else 'R²_test'

    # Extract R² values into a DataFrame
    r2_data = extract_r2_values(results_list)

    # Group by the model and compute mean and SEM
    summary_stats = r2_data.groupby('Model')[r2_column].agg(['mean', sem]).reset_index()

    # Define the desired order for the models
    desired_order = ['BF', 'HR', 'motion', 'BFmotion', 'HRmotion', 'all']

    # Reorder the DataFrame according to the desired order
    summary_stats['Model'] = pd.Categorical(summary_stats['Model'], categories=desired_order, ordered=True)
    summary_stats = summary_stats.sort_values('Model')

    # Create the plot
    plt.figure(figsize=(10, 6))
    plt.bar(summary_stats['Model'], summary_stats['mean'], yerr=summary_stats['sem'], capsize=5, alpha=0.7)

    # Add labels and title
    ylabel = 'Mean R² ± SEM (Train)' if r2_type == 'train' else 'Mean R² ± SEM (Test)'
    plt.ylabel(ylabel, fontsize=14)
    plt.xlabel('Model', fontsize=14)
    plt.ylim(0,0.1)
    title = 'Mean R² Values Across Models with SEM (Train)' if r2_type == 'train' else 'Mean R² Values Across Models with SEM (Test)'
    plt.title(title, fontsize=16)
    plt.xticks(rotation=45, fontsize=12)
    plt.grid(axis='y', linestyle='--', alpha=0.6)

    # Show the plot
    plt.tight_layout()
    plt.show()


def plot_mean_firing_rate_vs_r2(loaded_results, spike_counts, separate_subplots=False, r2_type='train'):
    """
    Plots log(mean firing rates) vs. R² values for neurons across mice and for all model types together
    or on separate subplots.

    Parameters:
    - loaded_results: Loaded results containing R² values for different models.
    - spike_counts: Dictionary where keys are Mouse_IDs, and values are DataFrames of neurons' spike counts.
    - separate_subplots: Boolean. If True, plots each model on a separate subplot. Otherwise, all models in one plot.
    - r2_type: String. Either 'train' or 'test' to plot R²_train or R²_test values.

    Returns:
    - Scatter plot(s) of log(mean firing rates) vs. R² values for the models.
    """


    # Validate r2_type input
    if r2_type not in ['train', 'test']:
        raise ValueError("Invalid r2_type. Choose either 'train' or 'test'.")

    # Map r2_type to the corresponding column in the dataframe
    r2_column = 'R²_train' if r2_type == 'train' else 'R²_test'

    # Extract R² values from loaded_results
    r2_dataframe = extract_r2_values(loaded_results)

    # Compute mean firing rates for each neuron in each mouse
    mean_firing_rates = []
    for mouse_id, df in spike_counts.items():
        # Compute mean firing rate for each neuron
        mouse_means = df.mean(axis=0).reset_index()
        mouse_means.columns = ['Neuron_ID', 'Mean_Firing_Rate']
        mouse_means['Mouse_ID'] = mouse_id  # Add Mouse_ID for merging
        mean_firing_rates.append(mouse_means)

    # Combine mean firing rates into a single DataFrame
    mean_firing_rates = pd.concat(mean_firing_rates, axis=0)

    # Merge R² data with mean firing rates
    merged_data = pd.merge(r2_dataframe, mean_firing_rates, on=['Mouse_ID', 'Neuron_ID'], how='inner')

    # Get unique models from the R² DataFrame
    models = merged_data['Model'].unique()

    if separate_subplots:
        # Plot each model on a subplot grid with 2 rows and 3 columns
        num_models = len(models)
        n_cols = 3
        n_rows = (num_models + n_cols - 1) // n_cols  # Calculate rows dynamically
        fig, axes = plt.subplots(n_rows, n_cols, figsize=(15, 8), sharex=True, sharey=True)
    
        # Flatten axes for easy iteration
        axes = axes.flatten()
    
        for idx, model in enumerate(models):
            ax = axes[idx]
            model_data = merged_data[merged_data['Model'] == model]
            ax.scatter(np.log(model_data['Mean_Firing_Rate']), model_data[r2_column], alpha=0.7, label=model)
            ax.axvline(x=np.log(0.5), color='brown', linestyle='--', label='log(x=0.5)')
            ax.set_ylim(0, 0.6)
            ax.set_title(f'Log(Mean Firing Rate) vs {r2_column} ({model})')
            ax.set_xlabel('Log(Mean Firing Rate)')
            ax.set_ylabel(f'{r2_column}')
            ax.grid(True)
            ax.legend()
    
        # Remove unused subplots
        for ax in axes[len(models):]:
            fig.delaxes(ax)
    
        plt.tight_layout()
        plt.show()
        
    else:
        # Plot all models in a single plot
        plt.figure(figsize=(10, 8))

        for model in models:
            model_data = merged_data[merged_data['Model'] == model]
            plt.scatter(np.log(model_data['Mean_Firing_Rate']), model_data[r2_column], alpha=0.7, label=model)

        plt.axvline(x=np.log(0.5), color='brown', linestyle='--', label='log(x=0.5)')
        plt.ylim(0, 0.6)  # Set y-axis limit for R²
        plt.title(f'Log(Mean Firing Rate) vs {r2_column} for All Models')
        plt.xlabel('Log(Mean Firing Rate)')
        plt.ylabel(f'{r2_column}')
        plt.grid(True)
        plt.legend()
        plt.show()

    

def plot_r2_comparison(loaded_results, model_1, model_2, r2_type='train'):
    """
    Plots the R² values (train or test) for all neurons for two specified models against each other.

    Parameters:
    - loaded_results: Loaded results containing R² values for different models.
    - model_1: Name of the first model to compare.
    - model_2: Name of the second model to compare.
    - r2_type: String. Either 'train' or 'test' to plot R²_train or R²_test values.

    Returns:
    - Scatter plot of R² values for model_1 vs model_2.
    """
    import pandas as pd
    import matplotlib.pyplot as plt

    # Validate r2_type input
    if r2_type not in ['train', 'test']:
        raise ValueError("Invalid r2_type. Choose either 'train' or 'test'.")

    # Map r2_type to the corresponding column name
    r2_column = 'R²_train' if r2_type == 'train' else 'R²_test'

    # Extract R² values from loaded_results
    r2_dataframe = extract_r2_values(loaded_results)

    # Filter R² values for the two models
    r2_model_1 = r2_dataframe[r2_dataframe['Model'] == model_1].copy()
    r2_model_2 = r2_dataframe[r2_dataframe['Model'] == model_2].copy()

    # Rename R² column for merging
    r2_model_1 = r2_model_1.rename(columns={r2_column: f'{r2_column}_{model_1}'})
    r2_model_2 = r2_model_2.rename(columns={r2_column: f'{r2_column}_{model_2}'})

    # Merge the two datasets on Mouse_ID and Neuron_ID
    merged_data = pd.merge(r2_model_1, r2_model_2, on=['Mouse_ID', 'Neuron_ID'], how='inner')

    # Plot R² values for model_1 vs model_2
    plt.figure(figsize=(8, 8))
    plt.scatter(merged_data[f'{r2_column}_{model_1}'], merged_data[f'{r2_column}_{model_2}'], alpha=0.7)
    plt.plot([0, 1], [0, 1], color='brown', linestyle='--', label='y = x')  # Diagonal reference line
    plt.xlim(0, 0.55)
    plt.ylim(0, 0.55)
    plt.title(f'R² Comparison: {model_1} vs {model_2} ({r2_column})')
    plt.xlabel(f'{r2_column} {model_1}')
    plt.ylabel(f'{r2_column} {model_2}')
    plt.grid(True)
    plt.legend()
    plt.show()



