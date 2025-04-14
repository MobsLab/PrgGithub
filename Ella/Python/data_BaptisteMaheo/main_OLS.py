#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  6 14:30:33 2025

@author: gruffalo
"""

# %% Import necessary modules 
import os 
os.chdir('/home/gruffalo/PrgGithub/Ella/Python/data_BaptisteMaheo/')

from load_data_GLM import load_mat_data
from preprocess_data import filter_columns, filter_mice, normalize_data, add_interaction_term
from transform_data import apply_sigmoid
from visualize_data import plot_exp_transform, plot_sigmoid_transform, plot_mouse_column
from fit_ols_model import ( 
    multiple_linear_regression,
    linear_regression_cross_val,
    fit_models_for_all_mice
    )
from plot_OLS_results import plot_r2_boxplot

# %% Load data

mat_folder = r'/media/nas7/ProjetEmbReact/DataEmbReact/Data_Model_Ella'
mat_filename = r'Data_Model_Ella.mat'

mice_data_original = load_mat_data(mat_folder, mat_filename)

# %% Keep needed columns and z-score

columns_list = ['OB frequency', 'Position', 'Global Time', 'Time since last shock', 'Time spent freezing']

mice_data = filter_columns(mice_data_original, columns_list, drop_na=True)

mice_data = add_interaction_term(mice_data, 'Position', 'Time since last shock', 'PositionxTime since last shock')
mice_data = add_interaction_term(mice_data, 'Position', 'Global Time', 'PositionxGlobal Time')

normalized_data = normalize_data(mice_data, ['Position', 'Global Time', 'Time since last shock', 'Time spent freezing'])

# %% Apply transformation to position (no need to be fitted, same transformation)

# plot_sigmoid_transform(normalized_data['M568'], 'Position', slope=20, op_point=0.5, range=True)

transformed_mice_data = apply_sigmoid(normalized_data, mouse_id='all', column_name='Position', slope=20, op_point=0.5)
# transformed_mice_data = apply_sigmoid(normalized_data, mouse_id='all', column_name='Global Time', slope=5, op_point=0.5)

# %% Visualize transformed data

df = normalized_data['M568']

plot_sigmoid_transform(df, 'Global Time', slope=5, op_point=0.5, range=True)

plot_exp_transform(df, 'Time since last shock', tau=0.1)

plot_mouse_column(normalized_data, 'M568', 'Position')
plot_mouse_column(normalized_data, 'M568', 'Global Time')

plot_mouse_column(transformed_mice_data, 'M568', 'Position')
plot_mouse_column(transformed_mice_data, 'M568', 'Global Time')

# %% Run model

df = transformed_mice_data['M568']

model = multiple_linear_regression(df, ['Position'], 'OB frequency')

model = multiple_linear_regression(df, ['Time since last shock'], 'OB frequency')

model = multiple_linear_regression(df, ['Global Time'], 'OB frequency')

model = multiple_linear_regression(df, ['PositionxGlobal Time'], 'OB frequency')

model = multiple_linear_regression(df, ['PositionxTime since last shock'], 'OB frequency')

model = multiple_linear_regression(df, ['Position', 'Time since last shock', 'Global Time'], 'OB frequency')

# %% With scikit

df = transformed_mice_data['M1225']

linear_regression_cross_val(df, ['Position'], 'OB frequency')

linear_regression_cross_val(df, ['Time since last shock'], 'OB frequency')

linear_regression_cross_val(df, ['Global Time'], 'OB frequency')

linear_regression_cross_val(df, ['PositionxGlobal Time'], 'OB frequency')

linear_regression_cross_val(df, ['PositionxTime since last shock'], 'OB frequency')

linear_regression_cross_val(df, ['Position', 'Time since last shock', 'Global Time'], 'OB frequency')

# %% Automate for all mice

transformed_mice_data = filter_mice(transformed_mice_data, n=100)


results = fit_models_for_all_mice(transformed_mice_data, 'OB frequency', cv=7)
plot_r2_boxplot(results)

results2 = fit_models_for_all_mice(mice_data, 'OB frequency', cv=5)
plot_r2_boxplot(results2)

results3 = fit_models_for_all_mice(mice_data, 'OB frequency', cv=7)
plot_r2_boxplot(results3)










