#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 11:21:09 2024

@author: gruffalo
"""

import matplotlib.pyplot as plt
import os
import gc


from matplotlib.gridspec import GridSpec
import numpy as np
import pandas as pd
from scipy.interpolate import interp1d
from preprocess_linear_model import ( 
    combine_dataframes_on_timebins, 
    create_time_shifted_features
    )
from preprocess_ln_model import (
    zscore_columns
    )
from save_plots import save_plot_as_svg



def plot_spike_rate_histogram(spike_count_dict, mouse_id, neurons=None, bins=30, ax=None):
    """
    Plot the histogram of spike rates for specified neurons of a given mouse and display the mean in the legend.

    Parameters:
    - spike_count_dict (dict): Output of the spike_count_all_mice function containing spike counts for each mouse.
    - mouse_id (str): The ID of the mouse whose spike rates will be plotted.
    - neurons (list of str, optional): List of neuron names to plot. If None, plots all neurons.
    - bins (int): Number of bins for the histogram. Default is 30.
    - ax (matplotlib.axes.Axes): Matplotlib axis to plot on. Default is None.
    """
    
    if ax is None:
        ax = plt.gca()
    
    # Ensure the mouse ID is present in the spike_count_dict
    if mouse_id not in spike_count_dict:
        ax.text(0.5, 0.5, f"Mouse ID '{mouse_id}' not found in the spike count data.", ha='center')
        return
    
    # Access the spike count DataFrame for the specified mouse
    spike_count_data = spike_count_dict[mouse_id]
    if neurons is None:
        neurons = spike_count_data.columns

    # Plot histograms for the specified neurons
    for neuron in neurons:
        neuron_data = spike_count_data[neuron].dropna()
        mean_spike_rate = neuron_data.mean()
        ax.hist(
            neuron_data,
            bins=bins,
            color='brown',
            alpha=0.7,
            edgecolor='black',
            label=f"Mean: {mean_spike_rate:.2f} spikes/bin"
        )
        ax.set_title(f"Spike Rates for {neuron} (Mouse {mouse_id})")
        ax.set_xlabel("Spike Rate")
        ax.set_ylabel("Frequency")
        ax.legend()


def plot_neuron_tuning_curve(
    mice_data, 
    mouse_id, 
    spike_times_data, 
    variable, 
    neuron_key, 
    interval_step=0.2, 
    min_value=None, 
    max_value=None, 
    ax=None
):
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
    - ax (matplotlib.axes.Axes, optional): Matplotlib axis to plot on. If None, creates a new plot.

    Returns:
    - None: Displays the plot.
    """
    
    # Use the provided axis or create a new one
    if ax is None:
        ax = plt.gca()

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
    ax.errorbar(
        time_intervals, 
        mean_spikes, 
        yerr=sem_spikes, 
        color='royalblue', 
        linewidth=3, 
        ecolor='royalblue', 
        elinewidth=3, 
        capsize=4, 
        label=f'{neuron_key}'
    )
    ax.set_title(f"Tuning Curve for {neuron_key} ({variable})", fontsize=12, fontweight='bold')
    ax.set_xlabel(f"{variable} (binned intervals)", fontsize=12, fontweight='bold')
    ax.set_ylabel("Spike Count (Mean ± SEM)", fontsize=12, fontweight='bold')
    ax.grid(alpha=0.7)
    ax.legend()


def plot_r2_values(results_list, model_names, ax=None):
    """
    Plot a barplot of the R² values for different models.

    Parameters:
    - results_list (list of dict): A list of results dictionaries.
    - model_names (list of str): A list of model names corresponding to the results.
    - ax (matplotlib.axes._axes.Axes, optional): Matplotlib axis object. If None, a new figure is created.

    Returns:
    - None: Displays the plot.
    """
    if len(results_list) != len(model_names):
        raise ValueError("The length of results_list and model_names must be the same.")

    if ax is None:
        fig, ax = plt.subplots(figsize=(8, 6))

    # Extract R² values
    r2_values = [result['best_mean_r_squared'] for result in results_list]

    # Create a bar plot
    ax.bar(model_names, r2_values, color='brown', alpha=0.7)

    # Add titles and labels
    ax.set_title("R² Values for Different Models", fontsize=14)
    ax.set_xlabel("Models", fontsize=12)
    ax.set_ylabel("Mean R²", fontsize=12)
    ax.set_ylim(0, 1)  # Assuming R² values are between 0 and 1
    ax.grid(alpha=0.3, linestyle='--', axis='y')

    # Add value annotations on top of bars
    for i, r2 in enumerate(r2_values):
        ax.text(i, r2 + 0.02, f"{r2:.2f}", ha='center', fontsize=10, color='black')

    plt.tight_layout()



def plot_coefficients(results, ax=None):
    """
    Plot the coefficients from a given model as a bar plot.

    Parameters:
    - results (dict): The results dictionary containing model information, including 'coefficients_with_names'.
    - ax (matplotlib.axes.Axes, optional): Matplotlib axis to plot on. If None, creates a new plot.

    Returns:
    - None: Displays the bar plot.
    """
    import matplotlib.pyplot as plt

    # Use the provided axis or create a new one
    if ax is None:
        ax = plt.gca()

    # Extract coefficients from the results
    coefficients = results.get('coefficients_with_names', None)
    if coefficients is None:
        ax.text(0.5, 0.5, "No coefficients found in the results.", ha='center', va='center', fontsize=12)
        ax.set_title("No Coefficients Available", fontsize=14)
        ax.axis('off')
        return

    # Prepare data for the bar plot
    names = [key[:-9] for key in coefficients.keys()]
    values = list(coefficients.values())

    # Plot the coefficients as a bar plot
    ax.bar(names, values, color='brown', alpha=0.8)
    ax.set_title("Coefficients of the Model", fontsize=14)
    ax.set_xlabel("Predictor Names", fontsize=12)
    ax.set_ylabel("Coefficient Values", fontsize=12)
    ax.grid(alpha=0.4, axis='y')
    ax.set_xticks(range(len(names)))
    ax.set_xticklabels(names, rotation=0, fontsize=10)


def plot_interpolated_coefficients(coefficients, variable, interpolation_kind='linear', ax=None):
    """
    Plots interpolated values of fitted coefficients for a lagged variable, with the oldest lag on the left.

    Parameters:
    - coefficients (dict): Dictionary of fitted coefficients with lagged variable names as keys.
    - variable (str): The base name of the variable (e.g., 'Heartrate').
    - interpolation_kind (str): Type of interpolation (default is 'linear').
    - ax (matplotlib.axes.Axes, optional): Matplotlib axis to plot on. If None, creates a new plot.

    Returns:
    - None: Displays the plot.
    """

    # Use the provided axis or create a new one
    if ax is None:
        ax = plt.gca()

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

    # Handle case where only one coefficient is available
    if len(lags) == 1:
        ax.bar(0, coef_values[0], color='brown', alpha=0.8)
        ax.set_title(f"Single Coefficient for {variable}", fontsize=14)
        ax.set_xlabel("Lag")
        ax.set_ylabel("Coefficient Value")
        ax.grid(alpha=0.4)
        ax.set_xticks([0])
        ax.set_xticklabels([f"{variable}_t_plus_0"])
        return

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

    # Plot the interpolated coefficients
    ax.scatter(sorted_lags, sorted_coefs, color='brown', marker='o', label='Original Coefficients')
    ax.plot(dense_lags, interpolated_coefs, color='brown', linewidth=3, label='Interpolated Curve')

    # Add titles and labels
    ax.set_xlabel('Lag', fontsize=12)
    ax.set_ylabel('Coefficient Value', fontsize=12)
    ax.set_title(f'Interpolated Coefficients for {variable} Across Lags', fontsize=14)
    ax.legend(fontsize=10)
    ax.grid(alpha=0.4)


    
def plot_predictions(data, result, independent_vars, dependent_var, variables_shifts, ax=None):
    """
    Plot the actual spike rates (data) against the model's predicted spike rates and show the best threshold.

    Parameters:
    - data (pd.DataFrame): Test dataset containing the independent variables and the dependent variable.
    - result (dict): Results dictionary containing the best model and best threshold.
    - independent_vars (list of str): List of independent variable names used for predictions.
    - dependent_var (str): The name of the dependent variable (target).
    - variables_shifts (dict): Shift configuration used during training.
    - ax (matplotlib.axes.Axes, optional): Matplotlib axis to plot on. If None, creates a new figure and axis.

    Returns:
    - None: Displays the plot if no `ax` is provided.
    """
    import matplotlib.pyplot as plt

    # Extract the best model and threshold from the result
    model = result['best_model']
    best_threshold = result.get('best_threshold', None)

    # Clean the data by dropping rows with NaN values
    data_cleaned = data.dropna(subset=[dependent_var] + independent_vars)

    # Create shifted features for the cleaned data
    X_test_shifted = create_time_shifted_features(data_cleaned[independent_vars], variables_shifts)
    
    # Align X_test_shifted and y_test by dropping NaNs
    y_test = data_cleaned[dependent_var].reset_index(drop=True)
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

    # Use the provided ax or create a new one
    if ax is None:
        fig, ax = plt.subplots(figsize=(10, 6))

    # Plot the actual vs predicted values
    ax.plot(y_test.values, label="Actual", color='royalblue', alpha=0.7, linewidth=2)
    ax.plot(y_pred, label="Predicted", color='crimson', alpha=0.7, linewidth=2)

    # Plot the horizontal line for the best threshold if available
    if best_threshold is not None:
        ax.axhline(y=best_threshold, color='gray', linestyle='--', linewidth=1.5, label=f"Threshold: {best_threshold:.2f}")

    # Adding titles and labels
    ax.set_title(f"Variables: {independent_vars_str}", fontsize=14)
    ax.set_xlabel("Sample Index", fontsize=12)
    ax.set_ylabel("Spike Rate", fontsize=12)
    ax.set_xlim(-0.05 * len(y_pred), 1.05 * len(y_pred))
    ax.legend(fontsize=12)
    ax.grid(alpha=0.4)

    # Display the plot if no ax was provided
    if ax is None:
        plt.tight_layout()
        plt.show()




def plot_variable(data, variable_column, ax=None, color='brown'):
    """
    Plot a specified physiological variable from a given dataset, with NaN values removed.

    Parameters:
    - data (pd.DataFrame): Dataset containing the variable to be plotted.
    - variable_column (str): Name of the column in the dataset representing the variable.
    - ax (matplotlib.axes.Axes, optional): Matplotlib axis to plot on. If None, creates a new figure and axis.
    - color (str): Color of the plot line. Default is 'brown'.

    Returns:
    - None: Displays the plot if no `ax` is provided.
    """
    import matplotlib.pyplot as plt

    # Check if the variable column exists in the dataset
    if variable_column not in data.columns:
        print(f"Column '{variable_column}' not found in the dataset.")
        return

    # Clean the data by dropping NaN values from the column and reindexing
    data_cleaned = data.dropna()
    variable_data = data_cleaned[variable_column].reset_index(drop=True)

    # Use the provided ax or create a new one
    if ax is None:
        fig, ax = plt.subplots(figsize=(10, 6))

    # Plot the variable data
    ax.plot(variable_data, color=color, alpha=0.8, linewidth=2, label=variable_column)
    
    # Adding titles and labels
    ax.set_title(f"{variable_column} Data", fontsize=14)
    ax.set_xlabel("Sample Index", fontsize=12)
    ax.set_ylabel(variable_column, fontsize=12)
    ax.set_xlim(-0.05 * len(variable_data), 1.05 * len(variable_data))
    ax.legend(fontsize=12)
    ax.grid(alpha=0.4)

    # Display the plot if no ax was provided
    if ax is None:
        plt.tight_layout()
        plt.show()




def create_recapitulatory_figure(
    mouse_id,
    dependent_var,
    spike_count_dict,
    maze_rebinned_data,
    maze_spike_times_data,
    test_data,
    resultsmotion,
    resultsHR,
    resultsHRmotion,
    resultsBF,
    resultsBFmotion,
    resultsall,
    independent_vars_motion,
    independent_vars_HR,
    independent_vars_HRmotion,
    independent_vars_BF,
    independent_vars_BFmotion,
    independent_vars_all,
    variable_column='Accelero'
):
    """
    Create a recapitulative figure for a given neuron of a given mouse, displaying spike rate histograms,
    tuning curves, R² values, coefficients, and predictions.

    Parameters:
    - mouse_id (str): Identifier for the mouse.
    - dependent_var (str): The dependent variable (neuron).
    - spike_count_dict (dict): Output of spike_count_all_mice for spike rate histograms.
    - maze_rebinned_data (dict): Dictionary containing rebinned data for each mouse.
    - maze_spike_times_data (dict): Dictionary containing spike times data for each neuron.
    - test_data (pd.DataFrame): Test dataset used for predictions.
    - resultsmotion, resultsHR, ...: Results dictionaries for the models.
    - independent_vars_motion, ...: Lists of independent variables for each model.
    - variable_column (str): Name of the variable column. Default is 'Accelero'.

    Returns:
    - None: Displays the recapitulative figure.
    """

    # Create figure and grid layout
    fig = plt.figure(figsize=(18, 42))
    grid = GridSpec(11, 3, figure=fig, width_ratios=[1, 1, 1], height_ratios=[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])

    # Left Column
    ax1 = fig.add_subplot(grid[0, 0])
    plot_spike_rate_histogram(spike_count_dict, mouse_id, neurons=[dependent_var], bins=25, ax=ax1)

    ax2 = fig.add_subplot(grid[1, 0])
    plot_r2_values(
        results_list=[resultsmotion, resultsHR, resultsHRmotion, resultsBF, resultsBFmotion, resultsall],
        model_names=["Motion", "HR", "HR+Motion", "BF", "BF+Motion", "All"],
        ax=ax2,
    )
    ax2.set_title("R² Values Across Models")

    ax3 = fig.add_subplot(grid[2, 0])
    plot_neuron_tuning_curve(
        mice_data=maze_rebinned_data,
        mouse_id=mouse_id,
        spike_times_data=maze_spike_times_data,
        variable='Heartrate',
        neuron_key=dependent_var,
        interval_step=0.3,
        min_value=8,
        max_value=13,
        ax=ax3
    )

    ax4 = fig.add_subplot(grid[3, 0])
    plot_neuron_tuning_curve(
        mice_data=maze_rebinned_data,
        mouse_id=mouse_id,
        spike_times_data=maze_spike_times_data,
        variable='BreathFreq',
        neuron_key=dependent_var,
        interval_step=0.3,
        min_value=2.5,
        max_value=11,
        ax=ax4
    )

    # Center Column
    ax5 = fig.add_subplot(grid[0, 1])
    plot_coefficients(resultsmotion, ax=ax5)
    ax5.set_title('Motion Variables')

    ax6 = fig.add_subplot(grid[1, 1])
    plot_interpolated_coefficients(resultsHR['coefficients_with_names'], 'Heartrate', interpolation_kind='cubic', ax=ax6)
    ax6.set_title('Heartrate')

    ax7 = fig.add_subplot(grid[2, 1])
    plot_interpolated_coefficients(resultsHRmotion['coefficients_with_names'], 'Heartrate', interpolation_kind='cubic', ax=ax7)
    ax7.set_title('Heartrate + Motion Variables')

    ax8 = fig.add_subplot(grid[3, 1])
    plot_interpolated_coefficients(resultsBF['coefficients_with_names'], 'BreathFreq', interpolation_kind='cubic', ax=ax8)
    ax8.set_title('Breathing Rate')

    ax9 = fig.add_subplot(grid[4, 1])
    plot_interpolated_coefficients(resultsBFmotion['coefficients_with_names'], 'BreathFreq', interpolation_kind='cubic', ax=ax9)
    ax9.set_title('Breathing Rate + Motion Variables')

    ax10 = fig.add_subplot(grid[5, 1])
    plot_interpolated_coefficients(resultsall['coefficients_with_names'], 'Heartrate', interpolation_kind='cubic', ax=ax10)
    ax10.set_title('All Variables, Heart Rate')

    ax11 = fig.add_subplot(grid[6, 1])
    plot_interpolated_coefficients(resultsall['coefficients_with_names'], 'BreathFreq', interpolation_kind='cubic', ax=ax11)
    ax11.set_title('All Variables, Breathing Rate')

    # Right Column
    ax12 = fig.add_subplot(grid[0, 2])
    plot_predictions(test_data, resultsmotion, independent_vars_motion, dependent_var, resultsmotion['best_shift_config'], ax=ax12)

    ax13 = fig.add_subplot(grid[1, 2])
    plot_predictions(test_data, resultsHR, independent_vars_HR, dependent_var, resultsHR['best_shift_config'], ax=ax13)

    ax14 = fig.add_subplot(grid[2, 2])
    plot_predictions(test_data, resultsHRmotion, independent_vars_HRmotion, dependent_var, resultsHRmotion['best_shift_config'], ax=ax14)

    ax15 = fig.add_subplot(grid[3, 2])
    plot_predictions(test_data, resultsBF, independent_vars_BF, dependent_var, resultsBF['best_shift_config'], ax=ax15)

    ax16 = fig.add_subplot(grid[4, 2])
    plot_predictions(test_data, resultsBFmotion, independent_vars_BFmotion, dependent_var, resultsBFmotion['best_shift_config'], ax=ax16)

    ax17 = fig.add_subplot(grid[5, 2])
    plot_predictions(test_data, resultsall, independent_vars_all, dependent_var, resultsall['best_shift_config'], ax=ax17)

    ax18 = fig.add_subplot(grid[6, 2])
    plot_variable(test_data, variable_column=variable_column, ax=ax18)

    # Add title
    fig.suptitle(f"Recapitulatory Figure for {dependent_var} (Mouse {mouse_id})", fontsize=18, fontweight='bold')
    plt.tight_layout(rect=[0, 0, 1, 0.95])
    plt.show()
    
    return fig
    


def create_visualization_figure(
    data_predictions,
    data_variables,
    resultsmotion,
    resultsHR,
    resultsHRmotion,
    resultsBF,
    resultsBFmotion,
    resultsall,
    independent_vars_motion,
    independent_vars_HR,
    independent_vars_HRmotion,
    independent_vars_BF,
    independent_vars_BFmotion,
    independent_vars_all,
    dependent_var
):
    """
    Create a figure with vertically stacked subplots: predictions for all models, Heartrate, BreathFreq, and Accelero.

    Parameters:
    - data_predictions (pd.DataFrame): Dataset used for predictions.
    - data_variables (pd.DataFrame): Dataset containing the physiological variables to plot.
    - resultsmotion, resultsHR, ...: Results dictionaries for the models.
    - independent_vars_motion, ...: Lists of independent variables for each model.
    - dependent_var (str): Name of the dependent variable (target).

    Returns:
    - None: Displays the figure.
    """
    import matplotlib.pyplot as plt
    from matplotlib.gridspec import GridSpec

    # Create figure and GridSpec layout
    fig = plt.figure(figsize=(24, 40))  # Tall figure for vertical stacking
    grid = GridSpec(10, 1, figure=fig, hspace=0.5)  # 9 rows, 1 column, adjusted spacing

    # Predictions plots for all models
    ax1 = fig.add_subplot(grid[0, 0])
    plot_predictions(
        data=data_predictions,
        result=resultsmotion,
        independent_vars=independent_vars_motion,
        dependent_var=dependent_var,
        variables_shifts=resultsmotion['best_shift_config'],
        ax=ax1
    )
    ax1.set_title(f"Predictions (Motion Variables, R²={resultsmotion['best_mean_r_squared']:.2f})", fontsize=14)

    ax2 = fig.add_subplot(grid[1, 0])
    plot_predictions(
        data=data_predictions,
        result=resultsHR,
        independent_vars=independent_vars_HR,
        dependent_var=dependent_var,
        variables_shifts=resultsHR['best_shift_config'],
        ax=ax2
    )
    ax2.set_title(f"Predictions (Heartrate, R²={resultsHR['best_mean_r_squared']:.2f})", fontsize=14)

    ax3 = fig.add_subplot(grid[2, 0])
    plot_predictions(
        data=data_predictions,
        result=resultsHRmotion,
        independent_vars=independent_vars_HRmotion,
        dependent_var=dependent_var,
        variables_shifts=resultsHRmotion['best_shift_config'],
        ax=ax3
    )
    ax3.set_title(f"Predictions (Heartrate + Motion Variables, R²={resultsHRmotion['best_mean_r_squared']:.2f})", fontsize=14)

    ax4 = fig.add_subplot(grid[3, 0])
    plot_predictions(
        data=data_predictions,
        result=resultsBF,
        independent_vars=independent_vars_BF,
        dependent_var=dependent_var,
        variables_shifts=resultsBF['best_shift_config'],
        ax=ax4
    )
    ax4.set_title(f"Predictions (BreathFreq, R²={resultsBF['best_mean_r_squared']:.2f})", fontsize=14)

    ax5 = fig.add_subplot(grid[4, 0])
    plot_predictions(
        data=data_predictions,
        result=resultsBFmotion,
        independent_vars=independent_vars_BFmotion,
        dependent_var=dependent_var,
        variables_shifts=resultsBFmotion['best_shift_config'],
        ax=ax5
    )
    ax5.set_title(f"Predictions (BreathFreq + Motion Variables, R²={resultsBFmotion['best_mean_r_squared']:.2f})", fontsize=14)

    ax6 = fig.add_subplot(grid[5, 0])
    plot_predictions(
        data=data_predictions,
        result=resultsall,
        independent_vars=independent_vars_all,
        dependent_var=dependent_var,
        variables_shifts=resultsall['best_shift_config'],
        ax=ax6
    )
    ax6.set_title(f"Predictions (All Variables, R²={resultsall['best_mean_r_squared']:.2f})", fontsize=14)

    # Heartrate plot
    ax7 = fig.add_subplot(grid[6, 0])
    plot_variable(data=data_variables, variable_column='Heartrate', ax=ax7, color='chocolate')
    ax7.set_title("Heartrate", fontsize=14)
    ax7.legend().remove()

    # BreathFreq plot
    ax8 = fig.add_subplot(grid[7, 0])
    plot_variable(data=data_variables, variable_column='BreathFreq', ax=ax8, color='seagreen')
    ax8.set_title("Breathing Frequency", fontsize=14)
    ax8.legend().remove()

    # Accelero plot
    ax9 = fig.add_subplot(grid[8, 0])
    plot_variable(data=data_variables, variable_column='Accelero', ax=ax9)
    ax9.set_title("Accelerometer", fontsize=14)
    ax9.legend().remove()
    
    # Position plot
    ax10 = fig.add_subplot(grid[9, 0])
    plot_variable(data=data_variables, variable_column='LinPos', ax=ax10)
    ax10.set_title("Linearized Position", fontsize=14)
    ax10.legend().remove()

    # Add a global title
    fig.suptitle(f"Visualization for {dependent_var}", fontsize=16, fontweight='bold', y=0.92)

    plt.show()
    
    return fig



def save_results_figures(
    all_results, 
    spike_counts, 
    maze_rebinned_data, 
    maze_spike_times_data, 
    figures_directory
):
    """
    Create and save plotted figures for all results, ensuring memory-efficient processing.

    Parameters:
    - all_results (list): List of results dictionaries for all neurons of all mice.
    - spike_counts (dict): Dictionary containing spike count data for all mice.
    - maze_rebinned_data (dict): Dictionary containing rebinned physiological data for all mice.
    - maze_spike_times_data (dict): Dictionary containing spike times for all mice.
    - figures_directory (str): Path to the directory where figures will be saved.

    Returns:
    - None: Saves figures as SVG files.
    """
    if not os.path.exists(figures_directory):
        os.makedirs(figures_directory)

    for result in all_results:
        if result is None:
            continue

        mouse_id = result['mouse_id']
        dependent_var = result['dependent_var']
        results = result['results']
        test_data = result['test_data']
        maze_rebinned_normalized_data = zscore_columns(
            maze_rebinned_data[mouse_id], 
            ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos']
        )
        model_all_df = combine_dataframes_on_timebins(
            spike_counts[mouse_id], 
            maze_rebinned_normalized_data
        )

        # Extract individual results
        resultsmotion = results['motion']
        resultsHR = results['HR']
        resultsHRmotion = results['HRmotion']
        resultsBF = results['BF']
        resultsBFmotion = results['BFmotion']
        resultsall = results['all']

        # Define independent variables for each configuration
        independent_vars_motion = ['LinPos', 'Speed', 'Accelero']
        independent_vars_HR = ['Heartrate']
        independent_vars_HRmotion = ['Heartrate', 'LinPos', 'Speed', 'Accelero']
        independent_vars_BF = ['BreathFreq']
        independent_vars_BFmotion = ['BreathFreq', 'LinPos', 'Speed', 'Accelero']
        independent_vars_all = ['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero']
        
        # Recapitulative Figure
        recap_fig = create_recapitulatory_figure(
            mouse_id=mouse_id,
            dependent_var=dependent_var,
            spike_count_dict=spike_counts,
            maze_rebinned_data=maze_rebinned_data,
            maze_spike_times_data=maze_spike_times_data,
            test_data=test_data,
            resultsmotion=resultsmotion,
            resultsHR=resultsHR,
            resultsHRmotion=resultsHRmotion,
            resultsBF=resultsBF,
            resultsBFmotion=resultsBFmotion,
            resultsall=resultsall,
            independent_vars_motion=independent_vars_motion,
            independent_vars_HR=independent_vars_HR,
            independent_vars_HRmotion=independent_vars_HRmotion,
            independent_vars_BF=independent_vars_BF,
            independent_vars_BFmotion=independent_vars_BFmotion,
            independent_vars_all=independent_vars_all,
            variable_column="Accelero"
        )
        
        save_plot_as_svg(
            figures_directory + '/ln_recap_figures', 
            f'{mouse_id}_{dependent_var}_ln_recap_figure',
            fig=recap_fig
        )
        plt.close(recap_fig)  # Clear figure from memory
        gc.collect()  # Explicitly invoke garbage collection

        # Visualization Figure
        visu_fig = create_visualization_figure(
            data_predictions=model_all_df,
            data_variables=maze_rebinned_data[mouse_id],
            resultsmotion=resultsmotion,
            resultsHR=resultsHR,
            resultsHRmotion=resultsHRmotion,
            resultsBF=resultsBF,
            resultsBFmotion=resultsBFmotion,
            resultsall=resultsall,
            independent_vars_motion=independent_vars_motion,
            independent_vars_HR=independent_vars_HR,
            independent_vars_HRmotion=independent_vars_HRmotion,
            independent_vars_BF=independent_vars_BF,
            independent_vars_BFmotion=independent_vars_BFmotion,
            independent_vars_all=independent_vars_all,
            dependent_var=dependent_var
        )
        
        save_plot_as_svg(
            figures_directory + '/ln_recap_figures', 
            f'{mouse_id}_{dependent_var}_ln_visualize_figure',
            fig=visu_fig
        )
        plt.close(visu_fig)  # Clear figure from memory
        gc.collect()  # Explicitly invoke garbage collection

    print(f"All figures have been saved in {figures_directory}.")







