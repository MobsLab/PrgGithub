#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  6 15:59:57 2025

@author: gruffalo
"""

import matplotlib.pyplot as plt
import numpy as np

def plot_r2_boxplot(results_df):
    """
    Plots a bar chart of the mean R² values across mice for different models,
    with manually added error bars representing the standard deviation across mice.
    Additionally, it overlays individual R² values as points and connects points
    from the same mouse across different models with unique colors.
    
    Parameters:
    results_df (pd.DataFrame): DataFrame containing columns ['Mouse', 'Model', 'Mean R²', 'Std R²'].
    """
    plt.figure(figsize=(10, 6))
    
    models = results_df['Model'].unique()
    means = [results_df[results_df['Model'] == model]['Mean R²'].mean() for model in models]
    stds = [results_df[results_df['Model'] == model]['Mean R²'].std() for model in models]
    
    # Bar plot with error bars
    plt.bar(models, means, yerr=stds, capsize=5, color='lightblue', edgecolor='black')
    
    # Scatter plot of individual R² values and connecting points for each mouse with unique colors
    mouse_ids = results_df['Mouse'].unique()
    np.random.seed(100)  # For reproducibility
    colors = np.random.rand(len(mouse_ids), 3)  # Generate unique RGB colors for each mouse
    
    for i, mouse in enumerate(mouse_ids):
        mouse_data = results_df[results_df['Mouse'] == mouse]
        x_positions = [list(models).index(model) for model in mouse_data['Model']]
        y_values = mouse_data['Mean R²'].values
        plt.scatter(x_positions, y_values, label=f'Mouse {mouse}', color=colors[i], alpha=0.8)
        plt.plot(x_positions, y_values, linestyle='dashed', color=colors[i], alpha=0.6)
    
    plt.xticks(rotation=45, ha='right')
    plt.xlabel("Model")
    plt.ylabel("Mean R²")
    plt.title("Mean R² Across Mice for Different Models (with Error Bars and Unique Colors)")
    plt.legend(loc='upper left', bbox_to_anchor=(1, 1), fontsize='small', frameon=True)
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    plt.show()

