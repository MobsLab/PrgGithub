#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 14 17:17:36 2025

@author: gruffalo
"""

# %% Import necessary modules 

import os 
os.chdir('/home/gruffalo/PrgGithub/Ella/Python/data_BaptisteMaheo/')

from load_data_GLM import load_mat_data
from preprocess_data import filter_columns
from transform_data import apply_sigmoid
from save_load_data import ( 
    # save_variable_to_json, 
    load_variable_from_json
    )
from predict_results import predict_respiratory_frequency

# %% Load data

mat_folder = r'/media/nas7/ProjetEmbReact/DataEmbReact/Data_Model_Ella'
mat_filename = r'Data_Model_Ella_mvt.mat'

mice_data_original = load_mat_data(mat_folder, mat_filename)

figrues_path = '/home/gruffalo/Dropbox/Mobs_member/EllaCallas/Figures/2025_GLM_Maheo_Bagur'

# %% Keep needed columns and z-score

# columns_list = ['OB frequency', 'Position', 'Global Time', 'Time since last shock', 'Time spent freezing']
columns_list = ['OB frequency', 'Position', 'Global Time', 
                'Time since last shock', 'Time spent freezing', 'Movement quantity']

mice_data = filter_columns(mice_data_original, columns_list, drop_na=True)

# %% Apply transformation to position (no need to be fitted, same transformation)

transformed_mice_data = apply_sigmoid(mice_data, mouse_id='all', column_name='Position', slope=20, op_point=0.5)

# %% Load results

results = load_variable_from_json(mat_folder + '/all_results_TF_GTxSigPos_expTLS_GT_MV_Posalone_df.json')
parameters = load_variable_from_json(mat_folder + '/all_parameters_TF_GTxSigPos_expTLS_GT_MV_Posalone_dict.json')
coefficients = load_variable_from_json(mat_folder + '/all_coefficients_TF_GTxSigPos_expTLS_GT_MV_Posalone_dict.json')

# %% Predict respiratory frequency

independent_vars = ["Time spent freezing", "Position_sig_Global_Time", 
                    "neg_exp_Time_since_last_shock", "Global Time", "Movement quantity"]


predictions = predict_respiratory_frequency(transformed_mice_data, parameters, 
                                            independent_vars, coefficients)