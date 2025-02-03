#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 24 14:08:46 2024

@author: gruffalo
"""

from itertools import product

def calculate_amplitude_thresholds(spike_counts, neuron_id, percentages):
    """
    Calculate threshold values based on specified percentages of the amplitude
    of spike counts for a given neuron.

    Parameters:
    - spike_counts (pd.DataFrame): Dataframe containing spike counts for multiple neurons.
    - neuron_id (str): The ID of the neuron for which thresholds will be calculated.
    - percentages (list of float): List of percentages to calculate thresholds, in decimal form (e.g., 0.1 for 10%).

    Returns:
    - list of float: Threshold values corresponding to the applied percentages.
    """
    if neuron_id not in spike_counts.columns:
        raise ValueError(f"Neuron '{neuron_id}' not found in the dataframe.")

    # Extract spike counts for the specified neuron
    neuron_data = spike_counts[neuron_id]

    # Calculate amplitude (difference between max and min)
    amplitude = neuron_data.max() - neuron_data.min()

    # Calculate thresholds based on the specified percentages of the amplitude
    thresholds = [amplitude * p for p in percentages]

    return thresholds


def generate_variable_shift_combinations(variables, max_shifts):
    """
    Generate all possible combinations of shift configurations for specified variables.

    Parameters:
    - variables (list of str): List of variable names to generate shifts for.
    - max_shifts (dict): Dictionary where keys are variable names and values are the maximum shift (negative integer).
                          Example: {'BreathFreq': 5, 'Heartrate': 3}

    Returns:
    - variables_shifts (list of dict): List of dictionaries with all combinations of variable shift configurations.
    """
    variables_shifts = []

    # If no shifts are specified, return a single dictionary with just baseline values for non-shifted variables
    if not max_shifts:
        variables_shifts.append({var: [0] for var in variables})
        return variables_shifts

    # Prepare a list of ranges for each variable's shifts
    shift_ranges = {var: [range(0, max_shift + 1) for max_shift in range(max_shifts[var] + 1)] for var in max_shifts}

    # Generate combinations of all specified shift ranges
    for shift_combination in product(*shift_ranges.values()):
        shift_dict = {var: [0] + [-s for s in shifts[1:]] for var, shifts in zip(shift_ranges.keys(), shift_combination)}

        # Add non-shifted variables at baseline
        for var in variables:
            if var not in shift_dict:
                shift_dict[var] = [0]
        
        variables_shifts.append(shift_dict)

    return variables_shifts












