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
from predict_results import ( 
    predict_respiratory_frequency,
    analyze_predictions_by_zone,
    plot_shock_safe_differences
    )
from plot_GLM_results import save_plot_as_svg

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

results = load_variable_from_json(mat_folder + '/vf_results_TF_GTxSigPos_expTLS_GT_MV_Posalone_df.json')

parameters = load_variable_from_json(mat_folder + '/vf_parameters_TF_GTxSigPos_expTLS_GT_MV_Posalone_dict.json')

coefficients = load_variable_from_json(mat_folder + '/vf_coefficients_TF_GTxSigPos_expTLS_GT_MV_Posalone_dict.json')

# %% Predict respiratory frequency

all_independent_vars = ["Time spent freezing", "Position_sig_Global_Time", 
                        "neg_exp_Time_since_last_shock", "Global Time", "Movement quantity"]

all_predictions = predict_respiratory_frequency(transformed_mice_data, parameters, 
                                                all_independent_vars, coefficients)

nopos_independent_vars = ["Time spent freezing", "neg_exp_Time_since_last_shock", 
                        "Global Time", "Movement quantity"]

nopos_predictions = predict_respiratory_frequency(transformed_mice_data, parameters, 
                                                  nopos_independent_vars, coefficients)

notls_independent_vars = ["Time spent freezing", "Position_sig_Global_Time", 
                        "Global Time", "Movement quantity"]

notls_predictions = predict_respiratory_frequency(transformed_mice_data, parameters, 
                                                  notls_independent_vars, coefficients)

nomvt_independent_vars = ["Time spent freezing", "Position_sig_Global_Time", 
                        "neg_exp_Time_since_last_shock", "Global Time"]

nomvt_predictions = predict_respiratory_frequency(transformed_mice_data, parameters, 
                                                  nomvt_independent_vars, coefficients)

# %% Analyse predictions

excluded_mice_length = [mouse for mouse, df in mice_data.items() if len(df) < 100]
excluded_mice_value = results[(results["Model"] == "Full Model") & (results["R²"] <= 0)]["Mouse"].tolist()
excluded_mice = list(set(excluded_mice_length + excluded_mice_value + ["M1184"]))

all_results = analyze_predictions_by_zone(all_predictions, exclude_mice=excluded_mice)

nopos_results = analyze_predictions_by_zone(nopos_predictions, exclude_mice=excluded_mice)

notls_results = analyze_predictions_by_zone(notls_predictions, exclude_mice=excluded_mice)

nomvt_results = analyze_predictions_by_zone(nomvt_predictions, exclude_mice=excluded_mice)

stats, fig = plot_shock_safe_differences([all_results, nopos_results, notls_results, nomvt_results],
                                         ['all predictors', 'no sigpositionxsiggt', 
                                          'no timesincelastshock', 'no mouvement quantity'])

save_plot_as_svg(fig, 'shock_safe_difference_predictions', figrues_path)
