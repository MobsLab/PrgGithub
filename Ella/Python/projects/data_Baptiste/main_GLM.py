#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 11:02:29 2025

@author: gruffalo
"""

# %% Import necessary modules 

from load_data import load_mat_data
from preprocess_data import filter_columns
from transform_data import apply_sigmoid
from visualize_data import plot_exp_transform, plot_sigmoid_transform
from fit_linear_model import ( 
    find_best_linear_model, 
    fit_single_predictor_models, 
    fit_leave_one_out_models
    )

# %% Load data

mat_folder = r'/media/nas7/ProjetEmbReact/DataEmbReact/Data_Model_Ella'
mat_filename = r'Data_Model_Ella.mat'

mice_data_original = load_mat_data(mat_folder, mat_filename)

# %% Keep needed columns

columns_list = ['OB frequency', 'Position', 'Global Time', 'Time since last shock', 'Time spent freezing']

mice_data = filter_columns(mice_data_original, columns_list, drop_na=True)

# %% Apply transformation to position (no need to be fitted, same transformation)

transformed_mice_data = apply_sigmoid(mice_data, mouse_id='all', column_name='Position', slope=20, op_point=0.5)

# %% Visualize transformed data

df = transformed_mice_data['M1144']

plot_sigmoid_transform(df, 'Global Time', slope=0.001, op_point=0.5*max(df['Global Time']))

plot_exp_transform(df, 'Time since last shock', tau=10)

# %% Define the parameter grid for hyperparameter search

param_grid = {
    "feature_transform__slope": [0.5, 1, 2],   # Values for sigmoid slope
    "feature_transform__op_point": [0, 50, 100],  # Values for sigmoid op_point
    "feature_transform__tau": [10, 50, 100]  # Values for exp tau
}

# %% Fit the different models

# Full model
best_results = find_best_linear_model(df, param_grid)

# Display results
print("Best Hyperparameters:", best_results["best_params"])
print("Best R² Score:", best_results["best_score"])

# Fit single-predictor models
single_predictor_results = fit_single_predictor_models(df, best_results["best_params"])

# Display results
for predictor, metrics in single_predictor_results.items():
    print(f"Predictor: {predictor}")
    print(f"  Coefficient: {metrics['coefficient']:.4f}")
    print(f"  Intercept: {metrics['intercept']:.4f}")
    print(f"  Mean R²: {metrics['mean_r2']:.4f}\n")
    
# Leave-one-out models
leave_one_out_results = fit_leave_one_out_models(df, best_results["best_params"])

# Display results
for omitted_predictor, metrics in leave_one_out_results.items():
    print(f"\nModel without predictor: {omitted_predictor}")
    print(f"  Intercept: {metrics['intercept']:.4f}")
    print(f"  Mean R²: {metrics['mean_r2']:.4f}")
    print("  Coefficients:")
    for pred, coef in metrics["coefficients"].items():
        print(f"    {pred}: {coef:.4f}")
    
