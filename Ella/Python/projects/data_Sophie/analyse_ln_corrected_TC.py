#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 17:03:12 2025

@author: gruffalo
"""

from preprocess_linear_model import (  
    create_time_shifted_features
    )

def extract_model_data(results_ln, neuron_index, model_type):
    """
    Extract data required for predictions for a specific neuron and model type.

    Parameters:
    - results_ln (list): List of dictionaries containing model results for neurons.
    - neuron_index (int): Index of the neuron in the results list.
    - model_type (str): Model type to extract (e.g., 'motion').

    Returns:
    - dict: Dictionary containing the model, independent variables, and variable shifts.
    """
    neuron_data = results_ln[neuron_index]
    model_data = neuron_data['results'].get(model_type, None)

    if model_data is None:
        raise ValueError(f"Model type '{model_type}' not found for neuron {neuron_index}.")

    # Extract independent variables from the best_shift_config
    best_shift_config = model_data.get('best_shift_config', {})
    independent_vars = list(best_shift_config.keys())

    return {
        'model': model_data['best_model'],
        'independent_vars': independent_vars,
        'variables_shifts': best_shift_config
    }


def predict_all_neurons(results_ln, combined_data, model_types):
    """
    Generate and store predictions for all neurons and specified model types using pre-combined data.

    Parameters:
    - results_ln (list): List of dictionaries containing model results for neurons.
    - combined_data (dict): Dictionary containing pre-combined DataFrames of spike counts and physiological data for each mouse.
    - model_types (list): List of model types to generate predictions for.

    Returns:
    - list: List of dictionaries containing predictions, mouse_id, neuron_id, and Test_Data for each model type.
    """
    import pandas as pd

    predictions_all = []

    for neuron_index, neuron_data in enumerate(results_ln):
        mouse_id = neuron_data.get('mouse_id')
        neuron_id = neuron_data.get('dependent_var', f'Neuron_{neuron_index}')

        for model_type in model_types:
            try:
                # Get the pre-combined data for the current mouse
                if mouse_id not in combined_data:
                    print(f"Mouse ID {mouse_id} not found in combined data. Skipping neuron {neuron_id}.")
                    continue

                model_all_df = combined_data[mouse_id]

                # Extract model data
                model_info = extract_model_data(results_ln, neuron_index, model_type)
                model = model_info['model']
                independent_vars = model_info['independent_vars']
                variables_shifts = model_info['variables_shifts']

                # Create shifted features for the data
                X_test_shifted = create_time_shifted_features(model_all_df[independent_vars], variables_shifts)

                # Align X_test_shifted and Test_Data
                Test_Data = model_all_df[neuron_id].reset_index(drop=True)
                aligned_data = pd.concat([X_test_shifted, Test_Data], axis=1).dropna()

                if aligned_data.empty:
                    print(f"No aligned data available after applying shifts for neuron {neuron_id}, model {model_type}.")
                    continue

                X_test = aligned_data[X_test_shifted.columns]
                Test_Data = aligned_data[neuron_id]

                # Generate predictions
                y_pred = model.predict(X_test)

                # Store predictions and test data
                predictions_entry = {
                    'Mouse_ID': mouse_id,
                    'Neuron_ID': neuron_id,
                    'Model_Type': model_type,
                    'Predictions': y_pred,
                    'Test_Data': Test_Data.values
                }
                predictions_all.append(predictions_entry)

            except Exception as e:
                print(f"Error processing neuron {neuron_id} with model '{model_type}' for mouse {mouse_id}: {e}")

    return predictions_all



def correct_predictions(predictions_all, model_type):
    """
    Correct predictions by subtracting Predictions from Test_Data for a specified model type.

    Parameters:
    - predictions_all (list): Output of the predict_all_neurons function.
    - model_type (str): Model type to apply the correction to (e.g., 'motion').

    Returns:
    - corrected_results (list): List of dictionaries with the corrected values for each mouse and neuron.
    """
    corrected_results = []

    for entry in predictions_all:
        if entry['Model_Type'] == model_type:
            try:
                mouse_id = entry['Mouse_ID']
                neuron_id = entry['Neuron_ID']
                predictions = entry['Predictions']
                test_data = entry['Test_Data']

                # Subtract predictions from test data
                correction = test_data - predictions

                # Store the corrected results
                corrected_entry = {
                    'Mouse_ID': mouse_id,
                    'Neuron_ID': neuron_id,
                    'Model_Type': model_type,
                    'Correction': correction
                }
                corrected_results.append(corrected_entry)

            except Exception as e:
                print(f"Error processing Mouse_ID: {mouse_id}, Neuron_ID: {neuron_id}, Model_Type: {model_type}: {e}")

    return corrected_results


