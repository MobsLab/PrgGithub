#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  6 17:38:37 2025

@author: gruffalo
"""

# %% Import necessary modules 

import numpy as np
from load_data import load_mat_data
from preprocess_data import filter_columns
from transform_data import apply_sigmoid
from fit_linear_model_r2 import ( 
    fit_models_for_all_mice
    )
from plot_GLM_results import ( 
    plot_full_vs_all_predictors_boxplot, 
    plot_r2_single_predictor_models,
    plot_r2_leave_one_out_models,
    plot_model_parameters
    )
from save_load_data import save_variable_to_json, load_variable_from_json

# %% Load data

mat_folder = r'/media/nas7/ProjetEmbReact/DataEmbReact/Data_Model_Ella'
mat_filename = r'Data_Model_Ella.mat'

mice_data_original = load_mat_data(mat_folder, mat_filename)

# %% Keep needed columns and z-score

columns_list = ['OB frequency', 'Position', 'Global Time', 'Time since last shock', 'Time spent freezing']

mice_data = filter_columns(mice_data_original, columns_list, drop_na=True)

# %% Apply transformation to position (no need to be fitted, same transformation)

transformed_mice_data = apply_sigmoid(mice_data, mouse_id='all', column_name='Position', slope=20, op_point=0.5)

# %% Define the parameter grid for hyperparameter search

param_grid = {
    "feature_transform__slope": np.arange(0.001, 0.05, 0.001),  # Values for sigmoid slope
    "feature_transform__op_point": np.arange(0, 1.1, 0.1),
    "feature_transform__tau": [0.5, 1, 2, 3, 4, 5, 10, 15, 20, 30, 50, 75, 100, 125, 150]  # Values for exp tau
}

# %% Fit models

independent_vars = ["Time spent freezing", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]

results, parameters = fit_models_for_all_mice(transformed_mice_data, param_grid, independent_vars)

excluded_mice = [mouse for mouse, df in mice_data.items() if len(df) < 100]

plot_full_vs_all_predictors_boxplot(results)

plot_r2_single_predictor_models(results, excluded_mice=['M669', 'M1147', 'M1171', 'M1205', 'M1251', 'M779', 'M9205'])

plot_r2_leave_one_out_models(results, excluded_mice=['M669', 'M1147', 'M1171', 'M1205', 'M1251', 'M779', 'M9205'])

plot_model_parameters(parameters)

# %% Save

save_variable_to_json(results, mat_folder + '/results_SigPos_GTxSigPos_expTLS_GT_df.json')

save_variable_to_json(parameters, mat_folder + '/parameters_SigPos_GTxSigPos_expTLS_GT_dict.json')







