#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 19 10:33:01 2024

@author: gruffalo
"""

def filter_neurons_by_mean_firing_rate(loaded_results, spike_counts, firing_rate_threshold, above_threshold=True):
    """
    Filters neurons based on a threshold in their mean firing rate and returns the results for the sorted neurons.

    Parameters:
    - loaded_results (dict): Loaded results containing R² values and other metrics for different models.
    - spike_counts (dict): Dictionary where keys are Mouse_IDs and values are DataFrames of neurons' spike counts.
    - firing_rate_threshold (float): Threshold for the mean firing rate.
    - above_threshold (bool): If True, keeps neurons above the threshold. If False, keeps neurons below the threshold.

    Returns:
    - filtered_results (list): Results of the neurons meeting the threshold criterion.
    """
    import pandas as pd

    # Compute mean firing rates for all neurons
    mean_firing_rates = []
    for mouse_id, df in spike_counts.items():
        # Calculate mean firing rates for each neuron
        mouse_means = df.mean(axis=0).reset_index()
        mouse_means.columns = ['Neuron_ID', 'Mean_Firing_Rate']
        mouse_means['Mouse_ID'] = mouse_id
        mean_firing_rates.append(mouse_means)

    # Combine all mean firing rates into a single DataFrame
    mean_firing_rates = pd.concat(mean_firing_rates, axis=0)

    # Filter neurons based on the threshold
    if above_threshold:
        filtered_neurons = mean_firing_rates[mean_firing_rates['Mean_Firing_Rate'] >= firing_rate_threshold]
    else:
        filtered_neurons = mean_firing_rates[mean_firing_rates['Mean_Firing_Rate'] < firing_rate_threshold]

    # Extract neuron identifiers
    filtered_neuron_ids = set(
        zip(filtered_neurons['Mouse_ID'], filtered_neurons['Neuron_ID'])
    )

    # Filter loaded_results for the selected neurons
    filtered_results = [
        result for result in loaded_results
        if (result['mouse_id'], result['dependent_var']) in filtered_neuron_ids
    ]

    return filtered_results
