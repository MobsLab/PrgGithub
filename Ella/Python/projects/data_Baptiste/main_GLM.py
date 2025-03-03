#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 11:02:29 2025

@author: gruffalo
"""

# %% Import necessary modules 

from load_data import load_mat_data
from preprocess_data import ( 
    filter_columns, 
    normalize_data
    )
from transform_data import apply_sigmoid
from fit_linear_model import find_best_linear_model

# %% Load data

mat_folder = r'/media/nas7/ProjetEmbReact/DataEmbReact/Data_Model_Ella'
mat_filename = r'Data_Model_Ella.mat'

mice_data = load_mat_data(mat_folder, mat_filename)

# %% Keep needed columns

columns_list = ['OB frequency', 'Position', 'Global Time', 'Time since last shock', 'Time spent freezing']

mice_data = filter_columns(mice_data, columns_list)

# %% Apply transformation

transformed_mice_data = apply_sigmoid(mice_data, mouse_id='all', column_name='Position', slope=20, op_point=0.5)


mice_normalized_data = normalize_data(transformed_mice_data, columns_list, drop_na=True)

# %% 

# Define the parameter grid for hyperparameter search
param_grid = {
    "feature_transform__slope": [0.5, 1, 2],   # Values for sigmoid slope
    "feature_transform__op_point": [0, 50, 100],  # Values for sigmoid op_point
    "feature_transform__tau": [10, 50, 100]  # Values for exp tau
}

# Run the function
df = mice_normalized_data['M1144']
best_results = find_best_linear_model(df, param_grid)

# Display results
print("Best Hyperparameters:", best_results["best_params"])
print("Best R² Score:", best_results["best_score"])
