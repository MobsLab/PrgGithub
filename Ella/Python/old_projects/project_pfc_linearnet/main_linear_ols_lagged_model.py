#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 20 15:27:58 2024

@author: gruffalo
"""

# %%

# Set working directory
import os
# os.chdir(r'/home/gruffalo/Dropbox/Mobs_member/EllaCallas/ADA_project/submitted')
os.chdir(r'/home/gruffalo/Documents/Python/project_pfc_linearnet')

# Import necessary packages and modules
from load_data import load_dataframes
from preprocess_sort_data import (
    denoise_mice_data,
    create_sorted_column_replace_zeros
    )
from analyse_data import (
    spike_count
    )
from plot_neural_data import (
    plot_scatter_neuron
    )
import statsmodels.formula.api as smf
import statsmodels.stats.api as sms
from preprocess_linear_model import (
    combine_dataframes_on_timebins,
    create_time_shifted_features,
    )
from plot_data_linear_model import (
    df_col_corr_heatmap,
    compute_autocorrelation,
    compute_cross_correlation
    )

# %% Load data

# Load data and needed modules
all_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/alldata'
maze_mat_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/justmaze'
figures_directory = r'/home/gruffalo/Documents/Python/project_pfc_linearnet/figures'

# Load variables and spike times for all mice during all recording sessions
all_mice_data, all_spike_times_data = load_dataframes(all_mat_directory)

# Load variables and spike times for all mice during the U-Maze session
maze_mice_data, maze_spike_times_data = load_dataframes(maze_mat_directory)


# %% Preprocess data

# Denoise data
all_denoised_data = denoise_mice_data(all_mice_data, ['BreathFreq', 'Heartrate', 'timebins', 'Accelero', 'LinPos'])
maze_denoised_data = denoise_mice_data(maze_mice_data, ['BreathFreq', 'Heartrate', 'timebins', 'Accelero', 'Speed', 'LinPos'])

# Scaling problems between sleep and UMaze
create_sorted_column_replace_zeros(all_denoised_data, 'Mouse514', 'Accelero', replace=True)
create_sorted_column_replace_zeros(maze_denoised_data, 'Mouse514', 'Accelero', replace=True)


# %% Data visualization

# Vizualize data before regression
spike_count_df = spike_count(maze_mice_data, 'Mouse508', maze_spike_times_data)
plot_scatter_neuron(maze_mice_data['Mouse508']['Heartrate'].values, spike_count_df['Neuron_16'].values, 'Heartrate', title='Neuron 16 vs HR M508')

# Basic model with StatsModels

# Physiological variables
model_df = combine_dataframes_on_timebins(spike_count_df['Neuron_16'], maze_mice_data['Mouse508'][['Heartrate','BreathFreq','timebins']])
df_col_corr_heatmap(model_df)

# %% Linear regression

model1 = smf.ols('Neuron_16 ~ Heartrate + BreathFreq', model_df).fit()
model1.params
model1.summary()
model1.rsquared

model2 = smf.ols('Neuron_16 ~ Heartrate', model_df).fit()
model2.params
model2.rsquared

model3 = smf.ols('Neuron_16 ~ BreathFreq', model_df).fit()
model3.params
model3.rsquared

# Assumptions test : linear model does not seem appropriate
sms.jarque_bera(model1.resid) # Normality residuals
sms.het_breuschpagan(model1.resid, model1.model.exog) # Heteroskedasticity
sms.linear_harvey_collier(model1) # Linearity


# %% Auto-correlations and Cross-correlations

autocorr_values = compute_autocorrelation(maze_mice_data, 'Mouse508', 'Heartrate', max_lag=500, time_step=0.2)
autocorr_values = compute_autocorrelation(maze_mice_data, 'Mouse508', 'BreathFreq', max_lag=500, time_step=0.2)

cross_corr_values = compute_cross_correlation(maze_mice_data, 'Mouse510', 'Heartrate', 'BreathFreq', max_lag=10, time_step=0.2)


# %% Linear regression with lagged features

# t-1
variables_shifts = {'Neuron_16': [0], 'Heartrate': [0, -1], 'BreathFreq': [0, -1]}
shifted_df = create_time_shifted_features(model_df, variables_shifts, include_original=False)
df_col_corr_heatmap(shifted_df)

model_lagged_1 = smf.ols('Neuron_16_t_plus_0 ~ Heartrate_t_minus_1 + BreathFreq_t_minus_1', shifted_df).fit()
model_lagged_1.params
model_lagged_1.rsquared

# t-2
variables_shifts2 = {'Neuron_16': [0], 'Heartrate': [-1, -2], 'BreathFreq': [-1, -2]}
shifted2_df = create_time_shifted_features(model_df, variables_shifts2, include_original=False)
df_col_corr_heatmap(shifted2_df)

model_lagged_2 = smf.ols('Neuron_16_t_plus_0 ~ Heartrate_t_minus_2 + BreathFreq_t_minus_2', 
                         shifted2_df).fit()
model_lagged_2.params
model_lagged_2.rsquared

# t-1 and t-2
model_lagged_3 = smf.ols('Neuron_16_t_plus_0 ~ Heartrate_t_minus_1 + BreathFreq_t_minus_1 + Heartrate_t_minus_2 + BreathFreq_t_minus_2', 
                         shifted2_df).fit()
model_lagged_3.params
model_lagged_3.rsquared

# t, t-1, t-2 
variables_shifts3 = {'Neuron_16': [0], 'Heartrate': [0, -1, -2], 'BreathFreq': [0, -1, -2]}
shifted4_df = create_time_shifted_features(model_df, variables_shifts3, include_original=False)
df_col_corr_heatmap(shifted4_df)

model_lagged_4 = smf.ols('Neuron_16_t_plus_0 ~ Heartrate_t_plus_0 + BreathFreq_t_plus_0 + Heartrate_t_minus_1 + BreathFreq_t_minus_1 + Heartrate_t_minus_2 + BreathFreq_t_minus_2', 
                         shifted4_df).fit()
model_lagged_4.params
model_lagged_4.rsquared

# t, t-1 
model_lagged_5 = smf.ols('Neuron_16_t_plus_0 ~ Heartrate_t_plus_0 + BreathFreq_t_plus_0 + Heartrate_t_minus_1 + BreathFreq_t_minus_1', 
                         shifted4_df).fit()
model_lagged_5.params
model_lagged_5.rsquared

# with lots of lagged timepoints
variables_shifts6 = {'Neuron_16': [0], 'Heartrate': list(range(0, -201, -1)), 'BreathFreq': list(range(0, -201, -1))}
shifted6_df = create_time_shifted_features(model_df, variables_shifts6, include_original=False)
df_col_corr_heatmap(shifted6_df)


variables = ['Heartrate', 'BreathFreq']
time_shifts = list(range(0, -201, -1))
rhs_expression = ' + '.join([f'{var}_t_{"plus" if shift >= 0 else "minus"}_{abs(shift)}' for shift in time_shifts for var in variables])
formula = f'Neuron_16_t_plus_0 ~ {rhs_expression}'

model_lagged_6 = smf.ols(formula, shifted6_df).fit()
model_lagged_6.params
model_lagged_6.rsquared

# Assumptions test : linear lagged model does not seem appropriate
sms.jarque_bera(model_lagged_5.resid) # Normality residuals
sms.het_breuschpagan(model_lagged_5.resid, model_lagged_5.model.exog) # Heteroskedasticity
sms.linear_harvey_collier(model_lagged_5) # Linearity









