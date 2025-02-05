#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 11:02:29 2025

@author: gruffalo
"""

# %% Import necessary modules 

from load_data import load_mat_data
from preprocess_data import normalize_data
from transform_data import apply_sigmoid

# %% Load data

mat_folder = r'/media/nas7/ProjetEmbReact/DataEmbReact/Data_Model_Ella'
mat_filename = r'Data_Model_Ella.mat'

mice_data = load_mat_data(mat_folder, mat_filename)

# %% Apply transformation

transformed_mice_data = apply_sigmoid(mice_data, mouse_id='all', column_name='Position', slope=20, op_point=0.5)

columns_list = ['Position', 'Global Time', 'Time since last shock', 'Time spent freezing',
                'Time spent freezing cumul', 'EyelidNumber', 'ShockZoneNumber']

mice_normalized_data = normalize_data(mice_data, columns_list)

# %% 

