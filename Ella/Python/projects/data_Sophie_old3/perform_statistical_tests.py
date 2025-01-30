#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 10 10:53:59 2024

@author: gruffalo
"""

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.stats.multitest as smm
from scipy.stats import wilcoxon, skew, shapiro
from scipy.stats import binomtest
from itertools import combinations



def compare_r2_sign_test_all(model_1_r2, model_2_r2):
    """
    Compare R² values between two models using the Sign Test, aggregated across all mice.
    
    Parameters:
    - model_1_r2 (dict of dicts): R² values for the first model, structured by mouse and neuron.
    - model_2_r2 (dict of dicts): R² values for the second model, structured by mouse and neuron.
    
    Returns:
    - p-value: The p-value from the Sign Test.
    """
    aggregated_model_1_r2 = []
    aggregated_model_2_r2 = []
    
    # Loop through each mouse and aggregate R² values across all mice and common neurons
    for mouse in model_1_r2:
        if mouse in model_2_r2:  # Ensure the mouse is in both models
            common_neurons = set(model_1_r2[mouse].keys()).intersection(model_2_r2[mouse].keys())
            
            # Append paired R² values to the aggregated lists
            aggregated_model_1_r2.extend([model_1_r2[mouse][neuron] for neuron in common_neurons])
            aggregated_model_2_r2.extend([model_2_r2[mouse][neuron] for neuron in common_neurons])

    # Perform the Sign Test on the aggregated data
    if len(aggregated_model_1_r2) > 0 and len(aggregated_model_2_r2) > 0:
        diff = [m1 > m2 for m1, m2 in zip(aggregated_model_1_r2, aggregated_model_2_r2)]
        n_positive = sum(diff)
        n = len(diff)
        
        # Perform the Binomial test for the sign test
        p_value = binomtest(n_positive, n, 0.5, alternative='two-sided').pvalue
        return n_positive, n, p_value
    else:
        return None, None, None  # Return None if no common neurons are found



def compare_r2_wilcoxon_all(model_1_r2, model_2_r2, showplot=False):
    """
    Compare R² values between two models using the Wilcoxon Signed-Rank Test, aggregated across all mice,
    and check the symmetry assumption for the distribution of differences.
    
    Parameters:
    - model_1_r2 (dict of dicts): R² values for the first model, structured by mouse and neuron.
    - model_2_r2 (dict of dicts): R² values for the second model, structured by mouse and neuron.
    - showplot (bool): Whether to show the plot of differences. Default is True.
    
    Returns:
    - stat: Wilcoxon test statistic.
    - p-value: The p-value from the Wilcoxon Signed-Rank Test.
    - skewness: The skewness value for the distribution of differences.
    - shapiro_p_value: The p-value from the Shapiro-Wilk test for normality of the differences.
    """
    aggregated_model_1_r2 = []
    aggregated_model_2_r2 = []
    
    # Loop through each mouse and aggregate R² values across all mice and common neurons
    for mouse in model_1_r2:
        if mouse in model_2_r2:  # Ensure the mouse is in both models
            # Find common neurons
            common_neurons = set(model_1_r2[mouse].keys()).intersection(model_2_r2[mouse].keys())
            
            # Extract paired R² values for common neurons and aggregate them
            model_1_neuron_r2 = [model_1_r2[mouse][neuron]['mean_r2'] for neuron in common_neurons]
            model_2_neuron_r2 = [model_2_r2[mouse][neuron]['mean_r2'] for neuron in common_neurons]
            
            aggregated_model_1_r2.extend(model_1_neuron_r2)
            aggregated_model_2_r2.extend(model_2_neuron_r2)
    
    # Calculate differences between paired R² values
    differences = np.array(aggregated_model_1_r2) - np.array(aggregated_model_2_r2)
    
    # 1. Plot the distribution of differences (visual check for symmetry) if showplot is True
    if showplot:
        plt.figure(figsize=(8, 6))
        sns.histplot(differences, kde=True)
        plt.title("Distribution of Differences (Model 1 R² - Model 2 R²)")
        plt.xlabel("Difference")
        plt.ylabel("Frequency")
        plt.show()

    # 2. Calculate the skewness of the differences
    skewness = skew(differences)
    # print(f"Skewness of the distribution of differences: {skewness:.4f}")

    # 3. Perform the Shapiro-Wilk test for normality (which can also hint at symmetry)
    shapiro_stat, shapiro_p_value = shapiro(differences)
    # print(f"Shapiro-Wilk test p-value for the differences: {shapiro_p_value:.4f}")
    
    # 4. Perform the Wilcoxon Signed-Rank Test on the aggregated R² values
    stat, p_value = wilcoxon(aggregated_model_1_r2, aggregated_model_2_r2)
    
    return stat, p_value, skewness, shapiro_p_value



def compare_all_pairs_wilcoxon(models_r2_results, model_labels, alpha=0.05, correction=False, correction_method='fdr_bh'):
    """
    Perform pairwise Wilcoxon Signed-Rank tests for all pairs of R² results from different models,
    with an option to apply multiple testing correction.
    
    Parameters:
    - models_r2_results (list of dicts): List of R² results for each model, each structured by mouse and neuron.
    - model_labels (list of str): List of labels corresponding to each model.
    - alpha (float): Significance level for the Wilcoxon test. Default is 0.05.
    - correction (bool): Whether to apply multiple testing correction. Default is False.
    - correction_method (str): Method for multiple testing correction. Default is 'fdr_bh'.
    
    Returns:
    - significant_pairs (list of tuples): List of tuples containing pairs of model labels and the corrected p-value for significant tests.
    """
    p_values = []
    pairs = []
    
    # Loop through all pairs of models
    for (i, j) in combinations(range(len(models_r2_results)), 2):
        # Perform Wilcoxon test on the current pair of models
        stat, p_value, _, _ = compare_r2_wilcoxon_all(models_r2_results[i], models_r2_results[j])
        
        # Store the pair of models and their p-value
        p_values.append(p_value)
        pairs.append((model_labels[i], model_labels[j]))
    
    # Apply multiple testing correction if requested
    if correction:
        reject, pvals_corrected, _, _ = smm.multipletests(p_values, alpha=alpha, method=correction_method)
    else:
        pvals_corrected = p_values

    # Collect significant pairs based on the corrected p-values
    significant_pairs = [(pairs[i][0], pairs[i][1], pvals_corrected[i]) for i in range(len(pairs)) if pvals_corrected[i] < alpha]
    
    return significant_pairs




