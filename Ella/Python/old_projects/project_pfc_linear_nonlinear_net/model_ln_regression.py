#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 09:45:24 2024

@author: gruffalo
"""

import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import KFold, cross_val_score
from preprocess_linear_model import (
    combine_mouse_data
    )


def k_fold_cross_validation_sklearn(data, dependent_var, independent_vars, k=5):
    """
    Perform K-Fold Cross Validation using scikit-learn's Linear Regression, with NaN values dropping.
    
    Parameters:
    data (pd.DataFrame): The dataset containing the variables.
    dependent_var (str): The dependent variable (target) for the regression.
    independent_vars (list of str): A list of independent variables (predictors) for the model.
    k (int): Number of folds for K-Fold Cross Validation. Default is 5.
    
    Returns:
    float: Mean R-squared across the K folds.
    """
    # Drop rows with NaN values in the dependent or independent variables
    data_clean = data.dropna(subset=[dependent_var] + independent_vars)

    # Extract the features (X) and the target (y)
    X = data_clean[independent_vars]
    y = data_clean[dependent_var]

    # Initialize the Linear Regression model
    model = LinearRegression()

    # Set up K-Fold cross-validation
    kf = KFold(n_splits=k, shuffle=True, random_state=42)

    # Perform cross-validation and compute R-squared for each fold
    r_squared_scores = cross_val_score(model, X, y, cv=kf, scoring='r2')

    # Calculate the mean R-squared across all folds
    mean_r_squared = np.mean(r_squared_scores)
    
    print(f"Mean R-squared across {k} folds: {mean_r_squared}")
    
    return mean_r_squared


def cross_validate_multiple_neurons(data, independent_vars, k=5):
    """
    Fit one cross-validated model for each dependent variable (columns starting with 'Neuron_'),
    and return the mean R-squared for each dependent variable.

    Parameters:
    data (pd.DataFrame): The dataset containing the variables.
    independent_vars (list of str): A list of independent variables (predictors) for the models.
    k (int): Number of folds for K-Fold Cross Validation. Default is 5.
    
    Returns:
    dict: A dictionary with dependent variables (Neuron columns) as keys and mean R-squared as values.
    """
    # Find all columns starting with 'Neuron_'
    neuron_columns = [col for col in data.columns if col.startswith('Neuron_')]
    
    # Dictionary to store the mean R-squared for each dependent variable
    results = {}
    
    # Loop through each dependent variable (Neuron column)
    for dependent_var in neuron_columns:
        print(f"Fitting model for {dependent_var}...")
        
        # Use the existing k_fold_cross_validation_sklearn function for each dependent variable
        mean_r2 = k_fold_cross_validation_sklearn(data, dependent_var, independent_vars, k=k)
        
        # Store the result
        results[dependent_var] = mean_r2
    
    return results


def cross_validate_neurons_per_mouse(spike_counts, mice_data, mice_list, independent_vars, k=5):
    """
    Fit cross-validated models for neurons of each mouse and return the mean R-squared values for each neuron.

    Parameters:
    - spike_counts (dict): Dictionary containing DataFrames of neural data (spike counts) for each mouse.
    - mice_data (dict): Dictionary containing DataFrames of physiological data for each mouse.
    - mice_list (list): List of mice to run the models for.
    - independent_vars (list of str): List of independent variables to use in the models.
    - k (int): Number of folds for K-Fold Cross Validation. Default is 5.

    Returns:
    - results (dict): Dictionary with mice as keys, each containing a dictionary of neuron mean R-squared values.
    """
    # Combine the data for each mouse
    combined_data = combine_mouse_data(spike_counts, mice_data, mice_list)
    
    results = {}
    
    # Loop over each mouse
    for mouse in mice_list:
        print(f"Fitting models for mouse {mouse}...")
        results[mouse] = {}
        
        # Get the combined DataFrame for the current mouse
        data = combined_data[mouse]
        
        # Find all neuron columns
        neuron_columns = [col for col in data.columns if col.startswith('Neuron_')]
        
        # Loop through each neuron and fit the model
        for neuron in neuron_columns:
            print(f"  Fitting model for {neuron}...")
            
            # Use the existing k_fold_cross_validation_sklearn function
            mean_r2 = k_fold_cross_validation_sklearn(data, neuron, independent_vars, k=k)
            
            # Store the result
            results[mouse][neuron] = mean_r2
    
    return results
