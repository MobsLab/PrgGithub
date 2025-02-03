#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 27 16:47:24 2025

@author: gruffalo
"""

import matplotlib.pyplot as plt
import numpy as np

def plot_predictions_trace(predictions_all, mouse_id, neuron_id, model_type):
    """
    Plot the trace of Predictions and Test_Data for a specific model type and neuron.

    Parameters:
    - predictions_all (list): Output of the predict_all_neurons function.
    - mouse_id (str): Identifier for the mouse.
    - neuron_id (str): Identifier for the neuron.
    - model_type (str): Type of model to visualize (e.g., 'motion').

    Returns:
    - None: Displays the plot.
    """
    # Filter the predictions for the given mouse, neuron, and model type
    filtered_data = [entry for entry in predictions_all 
                     if entry['Mouse_ID'] == mouse_id 
                     and entry['Neuron_ID'] == neuron_id 
                     and entry['Model_Type'] == model_type]

    if not filtered_data:
        print(f"No data found for Mouse_ID: {mouse_id}, Neuron_ID: {neuron_id}, Model_Type: {model_type}.")
        return

    # Extract Predictions and Test_Data
    predictions = filtered_data[0]['Predictions']
    test_data = filtered_data[0]['Test_Data']

    # Plot the traces
    plt.figure(figsize=(12, 6))
    plt.plot(test_data, label="Test Data", color='blue', alpha=0.7, linewidth=2)
    plt.plot(predictions, label="Predictions", color='red', alpha=0.7, linewidth=2)

    # Add titles and labels
    plt.title(f"Predictions vs Test Data\nMouse: {mouse_id}, Neuron: {neuron_id}, Model: {model_type}", fontsize=14)
    plt.xlabel("Time (Sample Index)", fontsize=12)
    plt.ylabel("Spike Rate", fontsize=12)
    plt.legend(fontsize=12)
    plt.grid(alpha=0.4)

    # Display the plot
    plt.tight_layout()
    plt.show()


def plot_tuning_curve(neuron_id, mouse_id, physiological_var, min_val, max_val, step, combined_data, corrected_results):
    """
    Plot the original and corrected tuning curves for a specific neuron and mouse.

    Parameters:
    - neuron_id (str): The ID of the neuron.
    - mouse_id (str): The ID of the mouse.
    - physiological_var (str): The physiological variable to use for tuning.
    - min_val (float): Minimum value of the physiological variable for binning.
    - max_val (float): Maximum value of the physiological variable for binning.
    - step (float): Step size for binning the physiological variable.
    - combined_data (dict): Combined data containing spike counts and physiological variables.
    - corrected_results (list): Output from the correct_predictions function containing corrected values.

    Returns:
    - None: Displays the plot.
    """
    # Extract the combined data for the specified mouse
    if mouse_id not in combined_data:
        raise ValueError(f"Mouse ID {mouse_id} not found in combined data.")

    mouse_data = combined_data[mouse_id]

    if neuron_id not in mouse_data.columns:
        raise ValueError(f"Neuron ID {neuron_id} not found in the combined data for mouse {mouse_id}.")

    if physiological_var not in mouse_data.columns:
        raise ValueError(f"Physiological variable {physiological_var} not found in the combined data for mouse {mouse_id}.")

    # Extract physiological variable and neural activity
    physiological_data = mouse_data[physiological_var]
    neural_activity = mouse_data[neuron_id]

    # Bin the physiological variable
    bins = np.arange(min_val, max_val, step)
    bin_indices = np.digitize(physiological_data, bins)

    # Compute the mean spike rate for each bin (original tuning curve)
    tuning_curve_original = []
    for i in range(1, len(bins)):
        in_bin = bin_indices == i
        tuning_curve_original.append(neural_activity[in_bin].mean())

    # Extract corrected predictions
    correction_entry = next((entry for entry in corrected_results if entry['Mouse_ID'] == mouse_id and entry['Neuron_ID'] == neuron_id), None)
    if correction_entry is None:
        raise ValueError(f"No corrected predictions found for {neuron_id} in {mouse_id}.")

    corrected_activity = correction_entry['Correction']

    # Compute the mean corrected spike rate for each bin (corrected tuning curve)
    tuning_curve_corrected = []
    for i in range(1, len(bins)):
        in_bin = bin_indices == i
        tuning_curve_corrected.append(corrected_activity[in_bin].mean())

    # Plot the tuning curves
    plt.figure(figsize=(10, 6))

    bin_centers = bins[:-1] + step / 2

    plt.plot(bin_centers, tuning_curve_original - np.mean(tuning_curve_original), label="Original Tuning Curve", marker='o', color='blue', alpha=0.7)
    plt.plot(bin_centers, tuning_curve_corrected - np.mean(tuning_curve_corrected), label="Corrected Tuning Curve", marker='o', color='red', alpha=0.7)

    plt.xlabel(physiological_var, fontsize=14)
    plt.ylabel("Mean Spike Rate", fontsize=14)
    plt.ylim([-1, 1])
    plt.title(f"Tuning Curve for Neuron {neuron_id} (Mouse {mouse_id})", fontsize=16)
    plt.legend(fontsize=12)
    plt.grid(alpha=0.4)
    plt.tight_layout()
    plt.show()
