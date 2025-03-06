#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 11:02:29 2025

@author: gruffalo
"""

# %% Import necessary modules 

import numpy as np
from load_data import load_mat_data
from preprocess_data import filter_columns, normalize_data
from transform_data import apply_sigmoid
from visualize_data import plot_exp_transform, plot_sigmoid_transform, plot_mouse_column
from fit_linear_model_r2 import ( 
    find_best_linear_model, 
    fit_all_predictors_model,
    fit_single_predictor_models, 
    fit_leave_one_out_models
    )

# %% Load data

mat_folder = r'/media/nas7/ProjetEmbReact/DataEmbReact/Data_Model_Ella'
mat_filename = r'Data_Model_Ella.mat'

mice_data_original = load_mat_data(mat_folder, mat_filename)

# %% Keep needed columns and z-score

columns_list = ['OB frequency', 'Position', 'Global Time', 'Time since last shock', 'Time spent freezing']

mice_data = filter_columns(mice_data_original, columns_list, drop_na=True)

# normalized_data = normalize_data(mice_data, ['Position', 'Global Time', 'Time since last shock', 'Time spent freezing'])

# %% Apply transformation to position (no need to be fitted, same transformation)

plot_sigmoid_transform(mice_data['M1225'], 'Position', slope=20, op_point=0.5, range=True)

transformed_mice_data = apply_sigmoid(mice_data, mouse_id='all', column_name='Position', slope=20, op_point=0.5)

# %% Visualize transformed data

df = transformed_mice_data['M1225']

plot_sigmoid_transform(df, 'Global Time', slope=0.05, op_point=0.5*max(df['Global Time']))

plot_exp_transform(df, 'Time since last shock', tau=10)

# %% Define the parameter grid for hyperparameter search

param_grid = {
    "feature_transform__slope": np.arange(0.001, 0.05, 0.001),  # Values for sigmoid slope
    "feature_transform__op_point": np.arange(0, 1.1, 0.1),
    "feature_transform__tau": [0.5, 1, 2, 3, 4, 5, 10, 15, 20, 30, 50, 75, 100, 125, 150]  # Values for exp tau
}
param_grid = {}

plot_mouse_column(transformed_mice_data, 'M1225', 'Time since last shock')

# %% Fit the different models

df = transformed_mice_data['M1225']

# Full model
best_results = find_best_linear_model(df, param_grid)

# Display results
print("Best Hyperparameters:", best_results["best_params"])
print("Best R² Score:", best_results["best_score"])
# print("Mean MAE:", best_results["best_score"])

all_results = fit_all_predictors_model(df, best_results["best_params"])
print("Best R² Score:", all_results["mean_r2"])


# Fit single-predictor models
single_predictor_results = fit_single_predictor_models(df, best_results["best_params"])

# Display results
for predictor, metrics in single_predictor_results.items():
    print(f"Predictor: {predictor}")
    # print(f"  Coefficient: {metrics['coefficient']:.4f}")
    # print(f"  Intercept: {metrics['intercept']:.4f}")
    print(f"  Mean R²: {metrics['mean_r2']:.4f}\n")
    
# for predictor, metrics in single_predictor_results.items():
#     print(f"Predictor: {predictor}")
#     print(f"  Mae: {metrics['mean_mae']:.4f}\n")
    
# Leave-one-out models
leave_one_out_results = fit_leave_one_out_models(df, best_results["best_params"])

# Display results
for omitted_predictor, metrics in leave_one_out_results.items():
    print(f"\nModel without predictor: {omitted_predictor}")
    # print(f"  Intercept: {metrics['intercept']:.4f}")
    print(f"  Mean R²: {metrics['mean_r2']:.4f}")
    print("  Coefficients:")
    for pred, coef in metrics["coefficients"].items():
        print(f"    {pred}: {coef:.4f}")
    
# for omitted_predictor, metrics in leave_one_out_results.items():
#     print(f"\nModel without predictor: {omitted_predictor}")
#     print(f"  Mae: {metrics['mean_mae']:.4f}")