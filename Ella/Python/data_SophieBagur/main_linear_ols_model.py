#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 20 15:27:58 2024

@author: gruffalo
"""

# %%

# Set working directory
import os
os.chdir(r'/home/gruffalo/PrgGithub/Ella/Python/data_SophieBagur')

# Import necessary packages and modules
import pandas as pd
from load_save_results import load_results
from preprocess_sort_data import (
    rebin_mice_data
    )
from analyse_data import (
    spike_count
    )
from plot_neural_data import (
    plot_scatter_neuron
    )
from sklearn.linear_model import LinearRegression
import statsmodels.formula.api as smf
import statsmodels.stats.api as sms
from preprocess_linear_model import (
    combine_dataframes_on_timebins
    )
from plot_data_linear_model import (
    df_col_corr_heatmap
    )

# %% Load data

load_path = r'/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/'

maze_denoised_data = load_results(load_path + 'maze_denoised_data.pkl')
maze_spike_times_data = load_results(load_path + 'maze_spike_times_data.pkl')

# Rebin data
new_bin_size = 0.8
maze_rebinned_data = rebin_mice_data(maze_denoised_data, ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'], new_bin_size)


# %% Linear regression

# Vizualize data before regression
spike_count_df = spike_count(maze_denoised_data, 'Mouse508', maze_spike_times_data)
plot_scatter_neuron(maze_denoised_data['Mouse508']['Heartrate'].values, spike_count_df['Neuron_16'].values, 'Heartrate', title='Neuron 16 vs HR M508')

# Create dataframe for regression
physiological_df = pd.DataFrame(maze_denoised_data['Mouse508'][['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos', 'timebins']])
model_all_df = combine_dataframes_on_timebins(spike_count_df, physiological_df)
df_col_corr_heatmap(model_all_df)
# model_df.dropna(inplace=True)

# %%

# Basic model with SciKit Learn
model = LinearRegression()
model.fit(model_all_df[['Heartrate','BreathFreq']].values, model_all_df['Neuron_16'].values)
model.coef_
model.intercept_

# Basic model with StatsModels
# All the variables
model_all = smf.ols('Neuron_16 ~ Heartrate + BreathFreq + LinPos + Speed + Accelero', model_all_df).fit()
model_all.params
model_all.summary()
model_all.rsquared

model1_all = smf.ols('Neuron_16 ~ BreathFreq + LinPos + Heartrate', model_all_df).fit()
model1_all.params
model1_all.summary()
model1_all.rsquared

model2_all = smf.ols('Neuron_16 ~ LinPos', model_all_df).fit()
model2_all.params
model2_all.summary()
model2_all.rsquared

model3_all = smf.ols('Neuron_16 ~ Speed', model_all_df).fit()
model3_all.params
model3_all.summary()
model3_all.rsquared

model4_all = smf.ols('Neuron_16 ~ Accelero', model_all_df).fit()
model4_all.params
model4_all.summary()
model4_all.rsquared

# Physiological variables

model1 = smf.ols('Neuron_16 ~ Heartrate + BreathFreq', model_all_df).fit()
model1.params
model1.summary()
model1.rsquared

model2 = smf.ols('Neuron_16 ~ Heartrate', model_all_df).fit()
model2.params
model2.rsquared

model3 = smf.ols('Neuron_16 ~ BreathFreq', model_all_df).fit()
model3.params
model3.rsquared

# Assumptions test
sms.jarque_bera(model1.resid) # Normality residuals
sms.het_breuschpagan(model1.resid, model1.model.exog) # Heteroskedasticity
sms.linear_harvey_collier(model1) # Linearity



















