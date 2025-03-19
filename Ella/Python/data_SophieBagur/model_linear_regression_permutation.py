#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 17:10:36 2024

@author: gruffalo
"""

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import KFold, cross_val_score
import numpy as np
import statsmodels.stats.multitest as smm
from joblib import Parallel, delayed
from preprocess_linear_model import (
    combine_mouse_data
)

def k_fold_cross_validation_sklearn_pval(data, dependent_var, independent_vars, k=5, n_permutations=1000, n_jobs=-1):
    """
    Perform K-Fold Cross Validation using scikit-learn's Linear Regression, with NaN values dropping and permutation testing,
    with parallel processing to speed up the permutation testing step.

    Parameters:
    data (pd.DataFrame): The dataset containing the variables.
    dependent_var (str): The dependent variable (target) for the regression.
    independent_vars (list of str): A list of independent variables (predictors) for the model.
    k (int): Number of folds for K-Fold Cross Validation. Default is 5.
    n_permutations (int): Number of permutations to perform. Default is 1000.
    n_jobs (int): Number of CPU cores to use for parallel processing. Default is -1 (use all available cores).
    
    Returns:
    float: Mean observed R-squared across the K folds.
    float: P-value from permutation testing.
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

    # 1. Calculate the observed R² using cross-validation
    r_squared_scores = cross_val_score(model, X, y, cv=kf, scoring='r2')
    mean_r_squared_observed = np.mean(r_squared_scores)

    # 2. Perform permutation testing with parallel processing
    def permuted_r2(i):
        # Shuffle the dependent variable (y)
        y_permuted = np.random.permutation(y)
        # Compute R² for the permuted data
        perm_r_squared_scores = cross_val_score(model, X, y_permuted, cv=kf, scoring='r2')
        return np.mean(perm_r_squared_scores)

    # Run permutations in parallel
    perm_r_squared_values = Parallel(n_jobs=n_jobs)(delayed(permuted_r2)(i) for i in range(n_permutations))

    # 3. Compute p-value
    perm_r_squared_values = np.array(perm_r_squared_values)
    p_value = np.mean(perm_r_squared_values >= mean_r_squared_observed)

    print(f"Mean observed R-squared: {mean_r_squared_observed}")
    print(f"Permutation test p-value: {p_value}")

    return mean_r_squared_observed, p_value


def cross_validate_multiple_neurons_permutation(data, independent_vars, k=5, n_permutations=1000):
    """
    Fit one cross-validated model for each dependent variable (columns starting with 'Neuron_'),
    and return the mean R-squared and permutation p-value for each dependent variable.

    Parameters:
    data (pd.DataFrame): The dataset containing the variables.
    independent_vars (list of str): A list of independent variables (predictors) for the models.
    k (int): Number of folds for K-Fold Cross Validation. Default is 5.
    n_permutations (int): Number of permutations for permutation testing. Default is 1000.
    
    Returns:
    dict: A dictionary with dependent variables (Neuron columns) as keys, and a tuple (mean R-squared, p-value) as values.
    """
    # Find all columns starting with 'Neuron_'
    neuron_columns = [col for col in data.columns if col.startswith('Neuron_')]
    
    # Dictionary to store the mean R-squared and p-value for each dependent variable
    results = {}
    
    # Loop through each dependent variable (Neuron column)
    for dependent_var in neuron_columns:
        print(f"Fitting model for {dependent_var}...")
        
        # Use the updated k_fold_cross_validation_sklearn with permutation testing
        mean_r2, p_value = k_fold_cross_validation_sklearn_pval(data, dependent_var, independent_vars, k=k, n_permutations=n_permutations)
        
        # Store the result
        results[dependent_var] = (mean_r2, p_value)
    
    return results


def cross_validate_neurons_per_mouse_permutation(spike_counts, mice_data, mice_list, independent_vars, k=5, n_permutations=1000):
    """
    Fit cross-validated models for neurons of each mouse and return the mean R-squared values and permutation p-values for each neuron.

    Parameters:
    - spike_counts (dict): Dictionary containing DataFrames of neural data (spike counts) for each mouse.
    - mice_data (dict): Dictionary containing DataFrames of physiological data for each mouse.
    - mice_list (list): List of mice to run the models for.
    - independent_vars (list of str): List of independent variables to use in the models.
    - k (int): Number of folds for K-Fold Cross Validation. Default is 5.
    - n_permutations (int): Number of permutations for permutation testing. Default is 1000.

    Returns:
    - results (dict): Dictionary with mice as keys, each containing a dictionary of neuron results (mean R-squared and p-value).
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
            
            # Use the updated k_fold_cross_validation_sklearn with permutation testing
            mean_r2, p_value = k_fold_cross_validation_sklearn_pval(data, neuron, independent_vars, k=k, n_permutations=n_permutations)
            
            # Store the result (mean R-squared and p-value) for this neuron
            results[mouse][neuron] = {'mean_r2': mean_r2, 'p_value': p_value}
    
    return results


def filter_neurons_by_p_value_multiple(results, p_value_threshold, correction=False, correction_method='fdr_bh'):
    """
    Filter neurons based on p-value for the results from cross_validate_multiple_neurons_permutation,
    with an option to apply multiple testing correction (Benjamini-Hochberg, Bonferroni, etc.).

    Parameters:
    - results (dict): Dictionary where keys are neuron names and values are tuples (mean R-squared, p-value).
    - p_value_threshold (float): The p-value threshold for significance.
    - fdr_correction (bool): Whether to apply multiple testing correction. Default is False.
    - correction_method (str): The correction method to apply. Default is 'fdr_bh'.
    
    Returns:
    - filtered_results (dict): Dictionary of neurons where the p-value is below the threshold (after optional correction).
    """
    filtered_results = {}
    neurons = list(results.keys())
    p_values = [results[neuron][1] for neuron in neurons]  # Extract the p-values

    # Apply multiple testing correction if requested
    if correction:
        reject, pvals_corrected, _, _ = smm.multipletests(p_values, alpha=p_value_threshold, method=correction_method)
        p_values = pvals_corrected
    else:
        reject = [p <= p_value_threshold for p in p_values]

    # Filter based on the corrected or uncorrected p-values
    for i, neuron in enumerate(neurons):
        if reject[i]:  # If the neuron passes the significance test
            filtered_results[neuron] = results[neuron][0]  # Store the mean R²
    
    return filtered_results


def filter_neurons_by_p_value_per_mouse(results, p_value_threshold=None, correction=False, correction_method='fdr_bh'):
    """
    Filter neurons based on p-value for the results from cross_validate_neurons_per_mouse_permutation,
    with an option to apply multiple testing correction (Benjamini-Hochberg, Bonferroni, etc.). If
    p_value_threshold is None, the function will return all neurons without filtering.

    Parameters:
    - results (dict): Dictionary with mice as keys, each containing a dictionary of neuron results (mean R-squared and p-value).
    - p_value_threshold (float, optional): The p-value threshold for significance. If None, return all neurons.
    - correction (bool): Whether to apply multiple testing correction. Default is False.
    - correction_method (str): The correction method to apply. Default is 'fdr_bh'.
    
    Returns:
    - filtered_results (dict): Dictionary with mice as keys, containing neurons' mean R² values based on the p-value threshold.
    """
    filtered_results = {}
    
    for mouse, neuron_data in results.items():
        mouse_filtered = {}
        neurons = list(neuron_data.keys())
        p_values = [neuron_data[neuron]['p_value'] for neuron in neurons]  # Extract the p-values

        # If no p-value threshold is specified, return all neurons
        if p_value_threshold is None:
            for neuron in neurons:
                mouse_filtered[neuron] = neuron_data[neuron]['mean_r2']
        else:
            # Apply multiple testing correction if requested
            if correction:
                reject, pvals_corrected, _, _ = smm.multipletests(p_values, alpha=p_value_threshold, method=correction_method)
                p_values = pvals_corrected
            else:
                reject = [p <= p_value_threshold for p in p_values]

            # Filter based on the corrected or uncorrected p-values
            for i, neuron in enumerate(neurons):
                if reject[i]:  # If the neuron passes the significance test
                    mouse_filtered[neuron] = neuron_data[neuron]['mean_r2']
        
        if mouse_filtered:
            filtered_results[mouse] = mouse_filtered
    
    return filtered_results



def count_significant_neurons_per_model(models_r2_results, model_labels, p_value_threshold=0.05, correction=False, correction_method='fdr_bh'):
    """
    Calculate the proportion of significant neurons for each model based on a p-value threshold, with an optional correction.

    Parameters:
    - models_r2_results (list of dicts): List of R² results for each model, each structured by mouse and neuron.
    - model_labels (list of str): List of labels corresponding to each model.
    - p_value_threshold (float): The p-value threshold for significance. Default is 0.05.
    - correction (bool): Whether to apply multiple testing correction. Default is False.
    - correction_method (str): The correction method to apply. Default is 'fdr_bh'.

    Returns:
    - significant_proportions (dict): Dictionary with model labels as keys and the proportion of significant neurons (in %) as values.
    """
    significant_proportions = {}

    # Loop through each model and calculate the proportion of significant neurons
    for i, model_r2_result in enumerate(models_r2_results):
        total_neurons = 0
        total_significant_neurons = 0
        
        for mouse, neuron_data in model_r2_result.items():
            neurons = list(neuron_data.keys())
            
            # Ensure that each neuron data is a dictionary with a 'p_value' key
            p_values = []
            valid_neurons = []
            for neuron in neurons:
                if isinstance(neuron_data[neuron], dict) and 'p_value' in neuron_data[neuron]:
                    p_values.append(neuron_data[neuron]['p_value'])
                    valid_neurons.append(neuron)  # Keep track of valid neurons
                else:
                    print(f"Warning: Unexpected structure for neuron {neuron} in mouse {mouse}. Skipping.")
                    continue

            # Apply multiple testing correction if requested
            if correction and p_values:
                reject, pvals_corrected, _, _ = smm.multipletests(p_values, alpha=p_value_threshold, method=correction_method)
            else:
                reject = [p <= p_value_threshold for p in p_values]

            # Count significant neurons for this mouse
            total_significant_neurons += sum(reject)
            total_neurons += len(valid_neurons)
        
        # Calculate the proportion of significant neurons as a percentage
        if total_neurons > 0:
            significant_proportion = (total_significant_neurons / total_neurons) * 100
        else:
            significant_proportion = 0  # Avoid division by zero

        # Store the proportion of significant neurons for this model
        significant_proportions[model_labels[i]] = significant_proportion

    return significant_proportions


