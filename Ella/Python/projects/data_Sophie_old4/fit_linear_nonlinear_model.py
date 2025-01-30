#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  7 14:43:01 2024

@author: gruffalo
"""

from preprocess_linear_model import (
    combine_dataframes_on_timebins
    )
from preprocess_ln_model import (
    zscore_columns,
    calculate_amplitude_thresholds,
    generate_variable_shift_combinations,
    extract_random_bouts
    )
from model_ln_regression import (
    ln_grid_cv
    )
from joblib import Parallel, delayed



def process_neuron(mouse_id, dependent_var, spike_counts, maze_rebinned_data):
    """
    Fit LN models for a specific neuron of a given mouse.
    
    Parameters:
    - mouse_id (str): The ID of the mouse.
    - dependent_var (str): The dependent variable (neuron).
    - spike_counts (dict): Dictionary of spike counts for all mice.
    - maze_rebinned_data (dict): Dictionary of rebinned data for all mice.
    
    Returns:
    - dict: A dictionary containing results for all models and configurations.
    """
    try:
        # Preprocess data
        maze_rebinned_normalized_data = zscore_columns(
            maze_rebinned_data[mouse_id],
            ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos']
        )
        model_all_df = combine_dataframes_on_timebins(spike_counts[mouse_id], maze_rebinned_normalized_data)
        
        # Split the data
        train_data, test_data = extract_random_bouts(model_all_df, bout_length=10, percent=10, random_state=30)
        
        # Calculate thresholds
        percentages = [0, 0.001, 0.002, 0.003, 0.005, 0.01, 0.02, 0.03, 0.04, 0.05]
        threshold_values = calculate_amplitude_thresholds(model_all_df, dependent_var, percentages)
        
        # Define configurations
        configs = {
            "motion": (['LinPos', 'Speed', 'Accelero'], {}),
            "HR": (['Heartrate'], {'Heartrate': 5}),
            "HRmotion": (['Heartrate', 'LinPos', 'Speed', 'Accelero'], {'Heartrate': 5}),
            "BF": (['BreathFreq'], {'BreathFreq': 5}),
            "BFmotion": (['BreathFreq', 'LinPos', 'Speed', 'Accelero'], {'BreathFreq': 5}),
            "all": (['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'], {'BreathFreq': 5, 'Heartrate': 5})
        }
        
        results = {}
        
        # Fit models for each configuration
        for name, (independent_vars, shifts) in configs.items():
            variables_shifts = generate_variable_shift_combinations(independent_vars, shifts)
            results[name] = ln_grid_cv(
                data=train_data,
                dependent_var=dependent_var,
                independent_vars=independent_vars,
                threshold_values=threshold_values,
                variables_shifts=variables_shifts,
                intercept_options=[True, False],
                k=5
            )
        
        return {
            "mouse_id": mouse_id,
            "dependent_var": dependent_var,
            "results": results,
            "train_data": train_data,
            "test_data": test_data
        }
    except KeyError as ke:
        print(f"KeyError processing {mouse_id} - {dependent_var}: {ke}")
    except ValueError as ve:
        print(f"ValueError processing {mouse_id} - {dependent_var}: {ve}")
    except Exception as e:
        print(f"Unexpected error processing {mouse_id} - {dependent_var}: {e}")
    return None



def process_all_neurons(mouse_id, dependent_vars, spike_counts, maze_rebinned_data):
    """
    Process all neurons for a given mouse using parallelization.
    
    Parameters:
    - mouse_id (str): The ID of the mouse.
    - dependent_vars (list): List of dependent variables (neurons) for the mouse.
    - spike_counts (dict): Spike counts dictionary for all mice.
    - maze_rebinned_data (dict): Rebinned physiological data for all mice.
    
    Returns:
    - list: Results for all neurons of the mouse.
    """
    return Parallel(n_jobs=-1, verbose=10)(
        delayed(process_neuron)(mouse_id, dependent_var, spike_counts, maze_rebinned_data)
        for dependent_var in dependent_vars
    )












