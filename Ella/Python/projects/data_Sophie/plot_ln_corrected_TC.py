#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 27 16:47:24 2025

@author: gruffalo
"""

import matplotlib.pyplot as plt
import numpy as np
from scipy.ndimage import gaussian_filter


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
    

# def plot_tuning_curve_heatmap(
#     mouse_list, physiological_var, min_val, max_val, step, combined_data, 
#     model_results, model_types, cmap='viridis', vmin=-2, vmax=2, 
#     smooth_sigma=0, global_zscore=False
# ):
#     """
#     Plot heatmaps of z-scored tuning curves for neurons using different models, combining all mice,
#     and ordering neurons by their preferred frequency.

#     Parameters:
#     - mouse_list (list): List of mouse IDs.
#     - physiological_var (str): The physiological variable to use for tuning.
#     - min_val (float): Minimum value of the physiological variable for binning.
#     - max_val (float): Maximum value of the physiological variable for binning.
#     - step (float): Step size for binning the physiological variable.
#     - combined_data (dict): Combined data containing spike counts and physiological variables.
#     - model_results (list): List of dictionaries containing model predictions.
#     - model_types (list): List of model types to include in the heatmap (e.g., ['original', 'corrected']).
#     - cmap (str, optional): Colormap for the heatmap. Default is 'viridis'.
#     - vmin (float, optional): Minimum value for color normalization. Default is -2.
#     - vmax (float, optional): Maximum value for color normalization. Default is 2.
#     - smooth_sigma (float, optional): Standard deviation for Gaussian smoothing. Default is 0.
#     - global_zscore (bool, optional): Whether to z-score all models together. Default is False.

#     Returns:
#     - None: Displays the heatmap.
#     """

#     num_models = len(model_types)

#     # Define bins for physiological variable
#     bins = np.arange(min_val, max_val, step)
#     bin_centers = bins[:-1] + step / 2

#     # Store tuning curves for all neurons across all mice
#     all_tuning_curves = {model_type: {} for model_type in model_types}
#     neuron_ids = set()  # Store all neuron IDs to maintain order

#     # Collect tuning curves from all mice
#     for mouse_id in mouse_list:
#         if mouse_id not in combined_data:
#             print(f"Skipping {mouse_id}: Not found in combined data.")
#             continue

#         mouse_data = combined_data[mouse_id]

#         if physiological_var not in mouse_data.columns:
#             print(f"Skipping {mouse_id}: {physiological_var} not found in combined data.")
#             continue

#         # Compute bin indices for physiological variable
#         bin_indices = np.digitize(mouse_data[physiological_var], bins)

#         for neuron_id in mouse_data.columns:
#             if neuron_id == physiological_var:
#                 continue  # Skip the physiological variable itself

#             neuron_ids.add(neuron_id)  # Track all unique neurons

#             for model_type in model_types:
#                 if model_type == "original":
#                     neural_activity = mouse_data[neuron_id]
#                 else:
#                     # Extract corrected predictions
#                     correction_entry = next(
#                         (entry for entry in model_results if entry['Mouse_ID'] == mouse_id and entry['Neuron_ID'] == neuron_id and entry['Model_Type'] == model_type),
#                         None
#                     )
#                     if correction_entry is None:
#                         continue
#                     neural_activity = correction_entry['Correction']

#                 # Compute mean spike rate for each bin
#                 tuning_curve = [np.nanmean(neural_activity[bin_indices == i]) for i in range(1, len(bins))]

#                 if neuron_id not in all_tuning_curves[model_type]:
#                     all_tuning_curves[model_type][neuron_id] = []

#                 all_tuning_curves[model_type][neuron_id].append(tuning_curve)

#     # Convert neuron_ids set to a sorted list for consistent order
#     neuron_ids = sorted(list(neuron_ids))

#     # Determine preferred frequency ordering using the first available model
#     preferred_order_model = model_types[0]  # Use the first model in the list for ordering
#     if preferred_order_model in all_tuning_curves:
#         ref_tuning_curves = all_tuning_curves[preferred_order_model]
#         max_indices = {
#             neuron_id: np.nanargmax(np.nanmean(ref_tuning_curves[neuron_id], axis=0))
#             for neuron_id in ref_tuning_curves if ref_tuning_curves[neuron_id]
#         }
#         ordered_neurons = sorted(max_indices, key=max_indices.get)  # Order by preferred frequency
#     else:
#         ordered_neurons = neuron_ids  # Default order if no valid model is found

    # # Perform global z-scoring if required
    # global_mean, global_std = None, None
    # if global_zscore:
    #     # Concatenate all tuning matrices from all models horizontally
    #     all_tuning_matrices = []
    #     for model_type in model_types:
    #         tuning_matrix = [np.nanmean(all_tuning_curves[model_type][neuron_id], axis=0) for neuron_id in ordered_neurons if neuron_id in all_tuning_curves[model_type]]
    #         if tuning_matrix:
    #             all_tuning_matrices.append(np.array(tuning_matrix))
    #     if all_tuning_matrices:
    #         concatenated_matrix = np.hstack(all_tuning_matrices)
    #         global_mean = np.nanmean(concatenated_matrix, axis=1, keepdims=True)
    #         global_std = np.nanstd(concatenated_matrix, axis=1, keepdims=True)

#     # Prepare figure for subplots
#     fig, axes = plt.subplots(1, num_models, figsize=(5 * num_models, 6), sharex=True, sharey=True)

#     if num_models == 1:
#         axes = [axes]  # Ensure axes is always iterable

#     for ax, model_type in zip(axes, model_types):
#         if model_type in all_tuning_curves and all_tuning_curves[model_type]:
#             tuning_matrix = [np.nanmean(all_tuning_curves[model_type][neuron_id], axis=0) for neuron_id in ordered_neurons if neuron_id in all_tuning_curves[model_type]]

#             if tuning_matrix:
#                 tuning_matrix = np.array(tuning_matrix)

#                 # Z-score normalization
#                 if global_zscore:
#                     z_scored_matrix = np.clip((tuning_matrix - global_mean) / global_std, vmin, vmax)
#                 else:
#                     row_means = np.nanmean(tuning_matrix, axis=1, keepdims=True)
#                     row_stds = np.nanstd(tuning_matrix, axis=1, keepdims=True)
#                     z_scored_matrix = np.clip((tuning_matrix - row_means) / row_stds, vmin, vmax)

#                 # Apply Gaussian smoothing if required
#                 if smooth_sigma > 0:
#                     z_scored_matrix = gaussian_filter(z_scored_matrix, sigma=smooth_sigma)

#                 # Plot heatmap
#                 im = ax.imshow(z_scored_matrix, aspect='auto', cmap=cmap, origin='upper', vmin=vmin, vmax=vmax)
#                 ax.set_title(f"Model: {model_type}")
#                 ax.set_xlabel(physiological_var)

#                 # Set x-axis ticks
#                 xtick_labels = np.round(bin_centers[::5], 1)
#                 ax.set_xticks(np.arange(0, len(bin_centers), 5))
#                 ax.set_xticklabels(xtick_labels.astype(str), rotation=0)

#         else:
#             ax.set_title(f"Model: {model_type} (No Data)")

#     # Set shared y-axis label
#     axes[0].set_ylabel("Neurons (Ordered by Preferred Frequency)")

#     # Add colorbar
#     fig.colorbar(im, ax=axes, orientation='vertical', label='Z-scored Firing Rate')

#     plt.show()

# def plot_tuning_curve_heatmap(mouse_list, physiological_var, min_val, max_val, step, combined_data, model_results, model_types, cmap='viridis', vmin=-2, vmax=2, smooth_sigma=1, global_zscore=False):
#     """
#     Plot heatmaps of z-scored tuning curves for neurons using different models, combining all mice,
#     and ordering neurons by their preferred frequency.

#     Parameters:
#     - mouse_list (list): List of mouse IDs.
#     - physiological_var (str): The physiological variable to use for tuning.
#     - min_val (float): Minimum value of the physiological variable for binning.
#     - max_val (float): Maximum value of the physiological variable for binning.
#     - step (float): Step size for binning the physiological variable.
#     - combined_data (dict): Combined data containing spike counts and physiological variables.
#     - model_results (list): List of dictionaries containing model predictions.
#     - model_types (list): List of model types to include in the heatmap (e.g., ['original', 'corrected']).
#     - cmap (str, optional): Colormap for the heatmap. Default is 'viridis'.
#     - vmin (float, optional): Minimum value for color normalization. Default is -2.
#     - vmax (float, optional): Maximum value for color normalization. Default is 2.
#     - smooth_sigma (float, optional): Standard deviation for Gaussian smoothing. Default is 1.
#     - global_zscore (bool, optional): If True, z-score all models together. Default is False.

#     Returns:
#     - None: Displays the heatmap.
#     """

#     num_models = len(model_types)

#     # Define bins for physiological variable
#     bins = np.arange(min_val, max_val, step)
#     bin_centers = bins[:-1] + step / 2

#     # Store tuning curves for all neurons across all mice
#     all_tuning_curves = {model_type: {} for model_type in model_types}
#     all_neurons = set()  # Store all unique neuron IDs to maintain order

#     # Collect tuning curves from all mice
#     for mouse_id in mouse_list:
#         if mouse_id not in combined_data:
#             print(f"Skipping {mouse_id}: Not found in combined data.")
#             continue

#         mouse_data = combined_data[mouse_id]

#         if physiological_var not in mouse_data.columns:
#             print(f"Skipping {mouse_id}: {physiological_var} not found in combined data.")
#             continue

#         # Compute bin indices for physiological variable
#         bin_indices = np.digitize(mouse_data[physiological_var], bins)

#         for neuron_id in mouse_data.columns:
#             if neuron_id == physiological_var:
#                 continue  # Skip the physiological variable itself

#             # Create a unique ID for the neuron
#             unique_neuron_id = f"{mouse_id}_{neuron_id}"
#             all_neurons.add(unique_neuron_id)  # Track all unique neurons

#             for model_type in model_types:
#                 if model_type == "original":
#                     neural_activity = mouse_data[neuron_id]
#                 else:
#                     # Extract corrected predictions
#                     correction_entry = next(
#                         (entry for entry in model_results if entry['Mouse_ID'] == mouse_id and entry['Neuron_ID'] == neuron_id and entry['Model_Type'] == model_type),
#                         None
#                     )
#                     if correction_entry is None:
#                         continue
#                     neural_activity = correction_entry['Correction']

#                 # Compute mean spike rate for each bin
#                 tuning_curve = [np.nanmean(neural_activity[bin_indices == i]) for i in range(1, len(bins))]

#                 if unique_neuron_id not in all_tuning_curves[model_type]:
#                     all_tuning_curves[model_type][unique_neuron_id] = []

#                 all_tuning_curves[model_type][unique_neuron_id].append(tuning_curve)

#     # Convert neuron_ids set to a sorted list for consistent order
#     all_neurons = sorted(list(all_neurons))

#     # Determine preferred frequency ordering using the first available model
#     preferred_order_model = model_types[0]  # Use the first model in the list for ordering
#     if preferred_order_model in all_tuning_curves:
#         ref_tuning_curves = all_tuning_curves[preferred_order_model]
#         max_indices = {
#             neuron_id: np.nanargmax(np.nanmean(ref_tuning_curves[neuron_id], axis=0))
#             for neuron_id in ref_tuning_curves if ref_tuning_curves[neuron_id]
#         }
#         ordered_neurons = sorted(max_indices, key=max_indices.get)  # Order by preferred frequency
#     else:
#         ordered_neurons = all_neurons  # Default order if no valid model is found

#     # Prepare figure for subplots
#     fig, axes = plt.subplots(1, num_models, figsize=(5 * num_models, 6), sharex=True, sharey=True)

#     if num_models == 1:
#         axes = [axes]  # Ensure axes is always iterable

#     for ax, model_type in zip(axes, model_types):
#         if model_type in all_tuning_curves and all_tuning_curves[model_type]:
#             tuning_matrix = [np.nanmean(all_tuning_curves[model_type][neuron_id], axis=0) for neuron_id in ordered_neurons if neuron_id in all_tuning_curves[model_type]]

#             if tuning_matrix:
#                 tuning_matrix = np.array(tuning_matrix)

                # # Z-score normalization
                # row_means = np.nanmean(tuning_matrix, axis=1, keepdims=True)
                # row_stds = np.nanstd(tuning_matrix, axis=1, keepdims=True)
                # z_scored_matrix = np.clip((tuning_matrix - row_means) / row_stds, vmin, vmax)

#                 # Apply Gaussian smoothing
#                 if smooth_sigma > 0:
#                     z_scored_matrix = gaussian_filter(z_scored_matrix, sigma=smooth_sigma)

#                 # Plot heatmap
#                 im = ax.imshow(z_scored_matrix, aspect='auto', cmap=cmap, origin='upper', vmin=vmin, vmax=vmax)
#                 ax.set_title(f"Model: {model_type}")
#                 ax.set_xlabel(physiological_var)

#                 # Set x-axis ticks
#                 xtick_labels = np.round(bin_centers[::5], 1)
#                 ax.set_xticks(np.arange(0, len(bin_centers), 5))
#                 ax.set_xticklabels(xtick_labels.astype(str), rotation=0)

#         else:
#             ax.set_title(f"Model: {model_type} (No Data)")

#     # Set shared y-axis label
#     axes[0].set_ylabel("Neurons (Ordered by Preferred Frequency)")

#     # Add colorbar
#     fig.colorbar(im, ax=axes, orientation='vertical', label='Z-scored Firing Rate')

#     plt.show()


# def plot_tuning_curve_heatmap(mouse_list, physiological_var, min_val, max_val, step, combined_data, model_results, model_types, cmap='viridis', vmin=-2, vmax=2, smooth_sigma=1, global_zscore=False):
#     """
#     Plot heatmaps of z-scored tuning curves for neurons using different models, combining all mice,
#     and ordering neurons by their preferred frequency.

#     Parameters:
#     - mouse_list (list): List of mouse IDs.
#     - physiological_var (str): The physiological variable to use for tuning.
#     - min_val (float): Minimum value of the physiological variable for binning.
#     - max_val (float): Maximum value of the physiological variable for binning.
#     - step (float): Step size for binning the physiological variable.
#     - combined_data (dict): Combined data containing spike counts and physiological variables.
#     - model_results (list): List of dictionaries containing model predictions.
#     - model_types (list): List of model types to include in the heatmap (e.g., ['original', 'corrected']).
#     - cmap (str, optional): Colormap for the heatmap. Default is 'viridis'.
#     - vmin (float, optional): Minimum value for color normalization. Default is -2.
#     - vmax (float, optional): Maximum value for color normalization. Default is 2.
#     - smooth_sigma (float, optional): Standard deviation for Gaussian smoothing. Default is 1.
#     - global_zscore (bool, optional): If True, z-score all models together. Default is False.

#     Returns:
#     - None: Displays the heatmap.
#     """

#     num_models = len(model_types)

#     # Define bins for physiological variable
#     bins = np.arange(min_val, max_val, step)
#     bin_centers = bins[:-1] + step / 2

#     # Store tuning curves for all neurons across all mice
#     all_tuning_curves = {model_type: {} for model_type in model_types}
#     all_neurons = set()  # Store all unique neuron IDs to maintain order

#     # Collect tuning curves from all mice
#     for mouse_id in mouse_list:
#         if mouse_id not in combined_data:
#             print(f"Skipping {mouse_id}: Not found in combined data.")
#             continue

#         mouse_data = combined_data[mouse_id]

#         if physiological_var not in mouse_data.columns:
#             print(f"Skipping {mouse_id}: {physiological_var} not found in combined data.")
#             continue

#         # Compute bin indices for physiological variable
#         bin_indices = np.digitize(mouse_data[physiological_var], bins)

#         for neuron_id in mouse_data.columns:
#             if neuron_id == physiological_var:
#                 continue  # Skip the physiological variable itself

#             # Create a unique ID for the neuron
#             unique_neuron_id = f"{mouse_id}_{neuron_id}"
#             all_neurons.add(unique_neuron_id)  # Track all unique neurons

#             for model_type in model_types:
#                 if model_type == "original":
#                     neural_activity = mouse_data[neuron_id]
#                 else:
#                     # Extract corrected predictions
#                     correction_entry = next(
#                         (entry for entry in model_results if entry['Mouse_ID'] == mouse_id and entry['Neuron_ID'] == neuron_id and entry['Model_Type'] == model_type),
#                         None
#                     )
#                     if correction_entry is None:
#                         continue
#                     neural_activity = correction_entry['Correction']

#                 # Compute mean spike rate for each bin
#                 tuning_curve = [np.nanmean(neural_activity[bin_indices == i]) for i in range(1, len(bins))]

#                 if unique_neuron_id not in all_tuning_curves[model_type]:
#                     all_tuning_curves[model_type][unique_neuron_id] = []

#                 all_tuning_curves[model_type][unique_neuron_id].append(tuning_curve)

#     # Convert neuron_ids set to a sorted list for consistent order
#     all_neurons = sorted(list(all_neurons))

#     # Determine preferred frequency ordering using the first available model
#     preferred_order_model = model_types[0]  # Use the first model in the list for ordering
#     if preferred_order_model in all_tuning_curves:
#         ref_tuning_curves = all_tuning_curves[preferred_order_model]
#         max_indices = {
#             neuron_id: np.nanargmax(np.nanmean(ref_tuning_curves[neuron_id], axis=0))
#             for neuron_id in ref_tuning_curves if ref_tuning_curves[neuron_id]
#         }
#         ordered_neurons = sorted(max_indices, key=max_indices.get)  # Order by preferred frequency
#     else:
#         ordered_neurons = all_neurons  # Default order if no valid model is found
        
#     # Perform global z-scoring if required
#     global_mean, global_std = None, None
#     if global_zscore:
#         # Concatenate all tuning matrices from all models horizontally
#         all_tuning_matrices = []
#         for model_type in model_types:
#             tuning_matrix = [np.nanmean(all_tuning_curves[model_type][neuron_id], axis=0) for neuron_id in ordered_neurons if neuron_id in all_tuning_curves[model_type]]
#             if tuning_matrix:
#                 all_tuning_matrices.append(np.array(tuning_matrix))
#         if all_tuning_matrices:
#             concatenated_matrix = np.hstack(all_tuning_matrices)
#             global_mean = np.nanmean(concatenated_matrix, axis=1, keepdims=True)
#             global_std = np.nanstd(concatenated_matrix, axis=1, keepdims=True)

#     # Prepare figure for subplots
#     fig, axes = plt.subplots(1, num_models, figsize=(5 * num_models, 6), sharex=True, sharey=True)

#     if num_models == 1:
#         axes = [axes]  # Ensure axes is always iterable

#     for ax, model_type in zip(axes, model_types):
#         if model_type in all_tuning_curves and all_tuning_curves[model_type]:
#             tuning_matrix = [np.nanmean(all_tuning_curves[model_type][neuron_id], axis=0) for neuron_id in ordered_neurons if neuron_id in all_tuning_curves[model_type]]

#             if tuning_matrix:
#                 tuning_matrix = np.array(tuning_matrix)

#                 # Z-score normalization
#                 if global_zscore:
#                     z_scored_matrix = np.clip((tuning_matrix - global_mean) / global_std, vmin, vmax)
#                 else:
#                     row_means = np.nanmean(tuning_matrix, axis=1, keepdims=True)
#                     row_stds = np.nanstd(tuning_matrix, axis=1, keepdims=True)
#                     z_scored_matrix = np.clip((tuning_matrix - row_means) / row_stds, vmin, vmax)

#                 # Apply Gaussian smoothing
#                 if smooth_sigma > 0:
#                     z_scored_matrix = gaussian_filter(z_scored_matrix, sigma=smooth_sigma)

#                 # Plot heatmap
#                 im = ax.imshow(z_scored_matrix, aspect='auto', cmap=cmap, origin='upper', vmin=vmin, vmax=vmax)
#                 ax.set_title(f"Model: {model_type}")
#                 ax.set_xlabel(physiological_var)

#                 # Set x-axis ticks
#                 xtick_labels = np.round(bin_centers[::5], 1)
#                 ax.set_xticks(np.arange(0, len(bin_centers), 5))
#                 ax.set_xticklabels(xtick_labels.astype(str), rotation=0)

#         else:
#             ax.set_title(f"Model: {model_type} (No Data)")

#     # Set shared y-axis label
#     axes[0].set_ylabel("Neurons (Ordered by Preferred Frequency)")

#     # Add colorbar
#     fig.colorbar(im, ax=axes, orientation='vertical', label='Z-scored Firing Rate')

#     plt.show()


def plot_tuning_curve_heatmap(
    mouse_list, physiological_var, min_val, max_val, step, 
    combined_data, model_results, model_types, cmap='viridis', 
    vmin=-2, vmax=2, smooth_sigma=1, global_zscore=False
):
    """
    Plot heatmaps of z-scored tuning curves for neurons using different models, combining all mice,
    and ordering neurons by their preferred frequency.

    Parameters:
    - mouse_list (list): List of mouse IDs.
    - physiological_var (str): The physiological variable to use for tuning.
    - min_val (float): Minimum value of the physiological variable for binning.
    - max_val (float): Maximum value of the physiological variable for binning.
    - step (float): Step size for binning the physiological variable.
    - combined_data (dict): Combined data containing spike counts and physiological variables.
    - model_results (list): List of dictionaries containing model predictions.
    - model_types (list): List of model types to include in the heatmap (e.g., ['original', 'corrected']).
    - cmap (str, optional): Colormap for the heatmap. Default is 'viridis'.
    - vmin (float, optional): Minimum value for color normalization. Default is -2.
    - vmax (float, optional): Maximum value for color normalization. Default is 2.
    - smooth_sigma (float, optional): Standard deviation for Gaussian smoothing. Default is 1.
    - global_zscore (bool, optional): If True, z-score all models together. Default is False.

    Returns:
    - None: Displays the heatmap.
    """

    num_models = len(model_types)

    # Define bins for physiological variable
    bins = np.arange(min_val, max_val, step)
    bin_centers = bins[:-1] + step / 2

    # Store tuning curves for all neurons across all mice
    all_tuning_curves = {model_type: {} for model_type in model_types}
    all_neurons = set()  # Store all unique neuron IDs to maintain order

    # Collect tuning curves from all mice
    for mouse_id in mouse_list:
        if mouse_id not in combined_data:
            print(f"Skipping {mouse_id}: Not found in combined data.")
            continue

        mouse_data = combined_data[mouse_id]

        if physiological_var not in mouse_data.columns:
            print(f"Skipping {mouse_id}: {physiological_var} not found in combined data.")
            continue

        # Compute bin indices for physiological variable
        bin_indices = np.digitize(mouse_data[physiological_var], bins)
        for neuron_id in [col for col in mouse_data.columns if col.startswith('Neuron')]:
            # Create a unique ID for the neuron
            unique_neuron_id = f"{mouse_id}_{neuron_id}"
            all_neurons.add(unique_neuron_id)  # Track all unique neurons
        
            for model_type in model_types:
                if model_type == "original":
                    neural_activity = mouse_data[neuron_id]
                else:
                    # Extract corrected predictions
                    correction_entry = next(
                        (entry for entry in model_results if entry['Mouse_ID'] == mouse_id and entry['Neuron_ID'] == neuron_id and entry['Model_Type'] == model_type),
                        None
                    )
                    if correction_entry is None:
                        continue
                    neural_activity = correction_entry['Correction']
        
                # Compute mean spike rate for each bin
                tuning_curve = [np.nanmean(neural_activity[bin_indices == i]) for i in range(1, len(bins))]
        
                if unique_neuron_id not in all_tuning_curves[model_type]:
                    all_tuning_curves[model_type][unique_neuron_id] = []
        
                all_tuning_curves[model_type][unique_neuron_id].append(tuning_curve)

    # Convert neuron_ids set to a sorted list for consistent order
    all_neurons = sorted(list(all_neurons))

    # Ensure all neurons are present across all models for global z-scoring
    if global_zscore:
        valid_neurons = set(all_neurons)
        for model_type in model_types:
            model_neurons = set(all_tuning_curves[model_type].keys())
            valid_neurons &= model_neurons
        valid_neurons = sorted(valid_neurons)
    else:
        valid_neurons = all_neurons

    # Determine preferred frequency ordering using the first available model
    preferred_order_model = model_types[0]  # Use the first model in the list for ordering
    if preferred_order_model in all_tuning_curves:
        ref_tuning_curves = all_tuning_curves[preferred_order_model]
        max_indices = {
            neuron_id: np.nanargmax(np.nanmean(ref_tuning_curves[neuron_id], axis=0))
            for neuron_id in ref_tuning_curves if ref_tuning_curves[neuron_id]
        }
        ordered_neurons = sorted(valid_neurons, key=max_indices.get)
    else:
        ordered_neurons = valid_neurons

    # Perform global z-scoring if required
    global_mean, global_std = None, None
    if global_zscore:
        all_tuning_matrices = []
        for model_type in model_types:
            tuning_matrix = [np.nanmean(all_tuning_curves[model_type][neuron_id], axis=0) for neuron_id in ordered_neurons if neuron_id in all_tuning_curves[model_type]]
            if tuning_matrix:
                all_tuning_matrices.append(np.array(tuning_matrix))
        if all_tuning_matrices:
            concatenated_matrix = np.hstack(all_tuning_matrices)
            global_mean = np.nanmean(concatenated_matrix, axis=1, keepdims=True)
            global_std = np.nanstd(concatenated_matrix, axis=1, keepdims=True)

    # Prepare figure for subplots
    fig, axes = plt.subplots(1, num_models, figsize=(5 * num_models, 6), sharex=True, sharey=True)

    if num_models == 1:
        axes = [axes]  # Ensure axes is always iterable

    for ax, model_type in zip(axes, model_types):
        if model_type in all_tuning_curves and all_tuning_curves[model_type]:
            tuning_matrix = [np.nanmean(all_tuning_curves[model_type][neuron_id], axis=0) for neuron_id in ordered_neurons if neuron_id in all_tuning_curves[model_type]]

            if tuning_matrix:
                tuning_matrix = np.array(tuning_matrix)

                # Z-score normalization
                if global_zscore:
                    z_scored_matrix = np.clip((tuning_matrix - global_mean) / global_std, vmin, vmax)
                else:
                    row_means = np.nanmean(tuning_matrix, axis=1, keepdims=True)
                    row_stds = np.nanstd(tuning_matrix, axis=1, keepdims=True)
                    z_scored_matrix = np.clip((tuning_matrix - row_means) / row_stds, vmin, vmax)

                # Apply Gaussian smoothing
                if smooth_sigma > 0:
                    z_scored_matrix = gaussian_filter(z_scored_matrix, sigma=smooth_sigma)

                # Plot heatmap
                im = ax.imshow(z_scored_matrix, aspect='auto', cmap=cmap, origin='upper', vmin=vmin, vmax=vmax)
                ax.set_title(f"Model: {model_type}")
                ax.set_xlabel(physiological_var)

                xtick_labels = np.round(bin_centers[::5], 1)
                ax.set_xticks(np.arange(0, len(bin_centers), 5))
                ax.set_xticklabels(xtick_labels.astype(str), rotation=0)

        else:
            ax.set_title(f"Model: {model_type} (No Data)")

    # Set shared y-axis label
    axes[0].set_ylabel("Neurons (Ordered by Preferred Frequency)")

    # Add colorbar
    fig.colorbar(im, ax=axes, orientation='vertical', label='Z-scored Firing Rate')

    plt.show()


# plot_tuning_curve_heatmap(
#     mouse_id="Mouse509",
#     physiological_var="Heartrate",
#     min_val=8,
#     max_val=13,
#     step=0.5,
#     combined_data=combined_data_raw,
#     model_results=corrected_motion,
#     model_types=['original','motion']
# )

