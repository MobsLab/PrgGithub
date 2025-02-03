#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan  6 10:29:47 2025

@author: gruffalo
"""

def load_results_per_time_lag(folder_path):
    """
    Load all results for different time lags from a specified folder.

    Parameters:
    - folder_path (str): Path to the folder containing saved joblib files for different time lags.

    Returns:
    - results_per_lag (dict): Dictionary with the same structure as the output of fit_time_lag,
      where keys are time lags and values are dictionaries containing results and file paths.
    """
    import os
    from joblib import load
    import re

    results_per_lag = {}

    # Iterate over all joblib files in the folder
    for file_name in os.listdir(folder_path):
        if file_name.endswith('.joblib'):
            try:
                # Extract time lag from the file name using regex
                match = re.search(r'results_ln_model_lag_(neg\d+|\d+).joblib', file_name)
                if match:
                    lag_str = match.group(1).replace('neg', '-')
                    time_lag = int(lag_str)

                    # Load the results
                    file_path = os.path.join(folder_path, file_name)
                    all_results = load(file_path)

                    # Store the results in the dictionary
                    results_per_lag[time_lag] = {
                        "lag": time_lag,
                        "results": all_results,
                        "joblib_path": file_path
                    }

                    print(f"Successfully loaded results for time lag: {time_lag}")
                else:
                    print(f"File name does not match expected format: {file_name}")

            except Exception as e:
                print(f"Error loading file {file_name}: {e}")

    return results_per_lag


def extract_r2_for_time_lags(results_per_lag):
    """
    Extract R²_train and R²_test values for each time lag, mouse, neuron, and model.

    Parameters:
    - results_per_lag (dict): Dictionary containing results for each time lag.

    Returns:
    - r2_dataframe (pd.DataFrame): DataFrame with columns: 
      [time_lag, Mouse_ID, Neuron_ID, Model, R²_train, R²_test].
    """
    import pandas as pd

    # Initialize a list to hold extracted data
    extracted_data = []

    # Loop through each time lag and its corresponding results
    for time_lag, results_dict in results_per_lag.items():
        all_results = results_dict["results"]

        for result in all_results:
            if result is None:  # Skip if the result is None
                continue

            mouse_id = result['mouse_id']
            neuron_id = result['dependent_var']
            models = result['results']  # Access the models dictionary

            for model_name, model_data in models.items():
                # Extract R²_train and R²_test
                r2_train = model_data.get('best_mean_r_squared', None)
                r2_test = model_data.get('r2_test', None)

                # Append extracted values to the data list
                extracted_data.append({
                    'time_lag': time_lag,
                    'Mouse_ID': mouse_id,
                    'Neuron_ID': neuron_id,
                    'Model': model_name,
                    'R²_train': r2_train,
                    'R²_test': r2_test
                })

    # Convert the extracted data into a DataFrame
    r2_dataframe = pd.DataFrame(extracted_data)

    return r2_dataframe


def plot_mean_r2_vs_time_lag(results_per_lag, r2_type='train'):
    """
    Plots the mean R² (train or test) values across mice and neurons for each model type as a function of time lag.

    Parameters:
    - results_per_lag (dict): Dictionary containing results for each time lag.
    - r2_type (str): Either 'train' or 'test' to plot R²_train or R²_test values. Default is 'train'.

    Returns:
    - None: Displays the plot.
    """
    import pandas as pd
    import matplotlib.pyplot as plt
    import numpy as np

    # Validate r2_type input
    if r2_type not in ['train', 'test']:
        raise ValueError("Invalid r2_type. Choose either 'train' or 'test'.")

    # Initialize a list to hold extracted data
    extracted_data = []

    # Loop through each time lag and extract R² values
    for time_lag, results_dict in results_per_lag.items():
        all_results = results_dict["results"]

        for result in all_results:
            if result is None:  # Skip if the result is None
                continue

            models = result['results']

            for model_name, model_data in models.items():
                r2_value = model_data.get('best_mean_r_squared' if r2_type == 'train' else 'r2_test', None)

                if r2_value is not None:
                    extracted_data.append({
                        'time_lag': time_lag,
                        'Model': model_name,
                        'R²': r2_value
                    })

    # Convert the extracted data into a DataFrame
    r2_dataframe = pd.DataFrame(extracted_data)

    # Group by time lag and model, then compute mean R²
    summary_stats = r2_dataframe.groupby(['time_lag', 'Model'])['R²'].mean().reset_index()

    # Get unique models for plotting
    models = summary_stats['Model'].unique()
    colors = plt.cm.tab10(np.linspace(0, 1, len(models)))  # Generate distinct colors

    # Plot mean R² values as a function of time lag for each model
    plt.figure(figsize=(12, 8))
    for model, color in zip(models, colors):
        model_data = summary_stats[summary_stats['Model'] == model]
        plt.plot(model_data['time_lag'], model_data['R²'], label=model, color=color, marker='o')

    # Add plot labels and legend
    plt.xlabel('Time Lag', fontsize=14)
    plt.ylabel(f'Mean R² ({r2_type.capitalize()})', fontsize=14)
    plt.title(f'Mean R² ({r2_type.capitalize()}) vs. Time Lag for Each Model', fontsize=16)
    plt.grid(True, linestyle="--", linewidth=0.5)
    plt.legend(title="Model", fontsize=12)

    # Show the plot
    plt.tight_layout()
    plt.show()


