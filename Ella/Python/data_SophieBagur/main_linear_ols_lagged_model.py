#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 20 15:27:58 2024

@author: gruffalo
"""

# %%

# Set working directory
# import os
# os.chdir(r'/home/gruffalo/PrgGithub/Ella/Python/projects/data_Sophie')

# Import necessary packages and modules
from load_save_results import load_results
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
    compute_cross_correlation
    )

# %% Load data

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'
figures_directory = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/figures/visualize_data'

maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')

maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')

# %% Data visualization

# Vizualize data before regression
spike_count_df = spike_count(maze_denoised_data, 'Mouse508', maze_spike_times_data)
plot_scatter_neuron(maze_denoised_data['Mouse508']['Heartrate'].values, 
                    spike_count_df['Neuron_16'].values, 'Heartrate', 
                    title='Neuron 16 vs HR M508')

# Basic model with StatsModels

# Physiological variables
model_df = combine_dataframes_on_timebins(spike_count_df, maze_denoised_data['Mouse508'][['Heartrate','BreathFreq','timebins']])
df_col_corr_heatmap(model_df)

# model_df.dropna(inplace=True)

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

cross_corr_values = compute_cross_correlation(maze_denoised_data, 'Mouse508', 'Heartrate', 'BreathFreq', max_lag=10, time_step=0.2)


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









