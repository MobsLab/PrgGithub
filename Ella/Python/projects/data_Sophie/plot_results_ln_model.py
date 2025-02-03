#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 11:21:09 2024

@author: gruffalo
"""

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.interpolate import interp1d
from preprocess_linear_model import create_time_shifted_features


def plot_neuron_tuning_curve(mice_data, mouse_id, spike_times_data, variable, neuron_key, interval_step=0.2, min_value=None, max_value=None):
    """
    Plot the tuning curve of a specified neuron with mean spike counts and SEM for specified variable intervals.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - spike_times_data (dict): Dictionary containing spike times data for each neuron.
    - variable (str): Name of the variable for which the tuning curve is computed.
    - neuron_key (str): The neuron to plot the tuning curve for.
    - interval_step (float): Step size for the variable interval.
    - min_value (float, optional): Minimum value of the variable range. Defaults to the min value in the data.
    - max_value (float, optional): Maximum value of the variable range. Defaults to the max value in the data.

    Returns:
    - None: Displays the plot.
    """
    # Check if data is available for the specified mouse
    if mice_data[mouse_id][variable].isna().all():
        raise ValueError(f"No variable data available for mouse {mouse_id}.")
    
    if neuron_key not in spike_times_data[mouse_id].columns:
        raise ValueError(f"Neuron '{neuron_key}' not found in spike times data for mouse {mouse_id}.")
    
    # Extract data for the specified mouse
    variable_data = mice_data[mouse_id][variable]

    # Set min and max values based on user input or data defaults
    min_value = min_value if min_value is not None else min(variable_data)
    max_value = max_value if max_value is not None else max(variable_data)

    # Initialize the time interval values
    time_intervals = np.arange(min_value, max_value, step=interval_step)

    # Extract spike times for the specified neuron
    neuron_data = spike_times_data[mouse_id][neuron_key].dropna()

    # Compute spike counts using np.histogram
    spike_counts, _ = np.histogram(neuron_data, bins=mice_data[mouse_id]['timebins'], density=False)
    spike_counts = np.append(spike_counts, 0)  # Padding the spike counts array

    # Initialize lists to store mean and SEM values
    mean_spikes = []
    sem_spikes = []

    # Loop through data intervals and compute spike activity
    for threshold in time_intervals:
        # Use boolean indexing to select spike counts within the specified threshold interval
        interval_spikes = spike_counts[(variable_data >= threshold) & (variable_data < threshold + interval_step)]

        # Compute mean and SEM for the interval
        mean_activity = np.mean(interval_spikes) if len(interval_spikes) > 0 else 0
        sem_activity = np.std(interval_spikes) / np.sqrt(len(interval_spikes)) if len(interval_spikes) > 1 else 0

        mean_spikes.append(mean_activity)
        sem_spikes.append(sem_activity)

    # Plot the tuning curve
    plt.figure(figsize=(10, 6))
    plt.errorbar(time_intervals, mean_spikes, yerr=sem_spikes, color='royalblue', linewidth=3, ecolor='royalblue', elinewidth=3, capsize=4, label=f'{neuron_key}')
    plt.title(f"Tuning Curve for {neuron_key} ({variable})", fontsize=14, fontweight='bold')
    plt.xlabel(f"{variable} (binned intervals)", fontsize=14, fontweight='bold')
    plt.ylabel("Spike Count (Mean ± SEM)", fontsize=14, fontweight='bold')
    plt.grid(alpha=0.7)
    plt.tight_layout()
    plt.show()



def plot_interpolated_coefficients(coefficients, variable, interpolation_kind='linear'):
    """
    Plots interpolated values of fitted coefficients for a lagged variable, with the oldest lag on the left.

    Parameters:
    - coefficients (dict): Dictionary of fitted coefficients with lagged variable names as keys.
    - variable (str): The base name of the variable (e.g., 'Heartrate').
    - interpolation_kind (str): Type of interpolation (default is 'linear').

    Returns:
    - None: Displays the plot.
    """
    # Extract negative lags and coefficients for the specified variable
    lags = []
    coef_values = []
    
    for lag_name, coef in coefficients.items():
        # Match variable names that follow the 'variable_t_minus_X' pattern
        if lag_name.startswith(f"{variable}_t_minus") or lag_name == f"{variable}_t_plus_0":
            # Extract the lag value (e.g., -3, -2, etc.)
            lag = -int(lag_name.split('_')[-1].replace('minus', '').replace('plus', '0'))
            lags.append(lag)
            coef_values.append(coef)

    # Sort the lags and associated coefficients from oldest to most recent
    sorted_lags, sorted_coefs = zip(*sorted(zip(lags, coef_values)))
    
    # Check if cubic interpolation is possible with the number of data points
    if interpolation_kind == 'cubic' and len(sorted_lags) < 4:
        print("Insufficient data points for cubic interpolation. Switching to linear interpolation.")
        interpolation_kind = 'linear'
   
    
    # Set up the interpolation on the negative lags
    interp_function = interp1d(sorted_lags, sorted_coefs, kind=interpolation_kind, fill_value="extrapolate")
    dense_lags = np.linspace(min(sorted_lags), max(sorted_lags), 200)
    interpolated_coefs = interp_function(dense_lags)
    
    # Plot
    plt.figure(figsize=(8, 6))
    plt.scatter(sorted_lags, sorted_coefs, color='brown', marker='o', label='Original Coefficients')
    plt.plot(dense_lags, interpolated_coefs, 'brown', linewidth=3, label='Interpolated Curve')
    
    plt.xlabel('Lag')
    plt.ylabel('Coefficient Value')
    plt.title(f'Interpolated Coefficients for {variable} Across Lags')
    plt.legend()
    plt.grid(True)
    
    # Adjust xlim based on lags and limit ylim to [0, 1.2]
    plt.xlim(min(sorted_lags)-0.1, max(sorted_lags)+0.1)
    # plt.ylim(0, 1.2)
    
    plt.show()
    
    
def plot_predictions(test_data, model, independent_vars, dependent_var, variables_shifts):
    """
    Plot the actual spike rates (test data) against the model's predicted spike rates.

    Parameters:
    - test_data (pd.DataFrame): Test dataset containing the independent variables and the dependent variable.
    - model (Pipeline): Trained LN model with ReLU prediction wrapper.
    - independent_vars (list of str): List of independent variable names used for predictions.
    - dependent_var (str): The name of the dependent variable (target).
    - variables_shifts (dict): Shift configuration used during training.

    Returns:
    - None: Displays the plot.
    """
    # Create shifted features for the test data
    X_test_shifted = create_time_shifted_features(test_data[independent_vars], variables_shifts)
    
    # Align X_test_shifted and y_test by dropping NaNs
    y_test = test_data[dependent_var].reset_index(drop=True)
    aligned_data = pd.concat([X_test_shifted, y_test], axis=1).dropna()
    if aligned_data.empty:
        print("No aligned data available after applying shifts. Check your input data.")
        return

    X_test = aligned_data[X_test_shifted.columns]
    y_test = aligned_data[dependent_var]

    # Generate predictions
    y_pred = model.predict(X_test)

    # Format the independent variables for the legend
    independent_vars_str = ", ".join(independent_vars)

    # Plot the actual vs predicted values
    plt.figure(figsize=(10, 6))
    plt.plot(y_test.values, label="Actual Spike Rates", color='royalblue', alpha=0.7, linewidth=2)
    plt.plot(y_pred, label=f"Predicted Spike Rates (Variables: {independent_vars_str})", 
             color='crimson', alpha=0.7, linewidth=2)
    
    # Adding titles and labels
    plt.title("Comparison of Actual and Predicted Spike Rates", fontsize=14)
    plt.xlabel("Sample Index", fontsize=12)
    plt.ylabel("Spike Rate", fontsize=12)
    plt.legend(fontsize=12)
    plt.grid(alpha=0.4)
    plt.tight_layout()
    plt.show()


def plot_accelerometer(test_data, accelerometer_column='Accelero'):
    """
    Plot the accelerometer data from the test dataset.

    Parameters:
    - test_data (pd.DataFrame): Test dataset containing the accelerometer data.
    - accelerometer_column (str): Name of the column in the dataset representing accelerometer data.

    Returns:
    - None: Displays the plot.
    """
    # Check if the accelerometer column exists in the dataset
    if accelerometer_column not in test_data.columns:
        print(f"Column '{accelerometer_column}' not found in the test dataset.")
        return

    # Extract the accelerometer data
    accel_data = test_data[accelerometer_column].reset_index(drop=True)

    # Plot the accelerometer data
    plt.figure(figsize=(10, 6))
    plt.plot(accel_data, color='brown', alpha=0.8, linewidth=2, label='Accelerometer Data')
    
    # Adding titles and labels
    plt.title("Accelerometer Data from Test Dataset", fontsize=14)
    plt.xlabel("Sample Index", fontsize=12)
    plt.ylabel("Acceleration", fontsize=12)
    plt.legend(fontsize=12)
    plt.grid(alpha=0.4)
    plt.tight_layout()
    plt.show()



