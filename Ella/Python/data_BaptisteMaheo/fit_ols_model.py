#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  6 14:31:12 2025

@author: gruffalo
"""

import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score, KFold
import numpy as np
import pandas as pd


def multiple_linear_regression(df, independent_vars, dependent_var):
    """
    Performs multiple linear regression.
    
    Parameters:
    df (pd.DataFrame): Input DataFrame containing the data.
    independent_vars (list): List of column names to be used as independent variables.
    dependent_var (str): Column name of the dependent variable.
    
    Returns:
    statsmodels.regression.linear_model.RegressionResults: Regression results object.
    """
    X = df[independent_vars]  # Independent variables
    y = df[dependent_var]      # Dependent variable
    X = sm.add_constant(X)     # Add intercept term
    
    model = sm.OLS(y, X).fit() # Fit the model
    # print(model.rsquared_adj)
    
    return model


def linear_regression_cross_val(df, independent_vars, dependent_var, cv=5):
    """
    Performs multiple linear regression using scikit-learn with cross-validation.
    
    Parameters:
    df (pd.DataFrame): Input DataFrame containing the data.
    independent_vars (list): List of column names to be used as independent variables.
    dependent_var (str): Column name of the dependent variable.
    cv (int): Number of cross-validation folds (default is 5).
    
    Returns:
    dict: Dictionary containing mean R-squared score and standard deviation.
    """
    X = df[independent_vars].values  # Convert to NumPy array
    y = df[dependent_var].values
    
    model = LinearRegression()
    kf = KFold(n_splits=cv, shuffle=True, random_state=42)  # Enable shuffling
    scores = cross_val_score(model, X, y, cv=kf, scoring='r2')
    
    # print({"mean_r2": np.mean(scores)})
    
    return {"mean_r2": np.mean(scores), "std_r2": np.std(scores)}


def fit_models_for_all_mice(mice_data, dependent_var='OB frequency', cv=5):
    """
    Fits multiple linear regression models for each mouse in mice_data and returns R² values.
    
    Parameters:
    mice_data (dict): Dictionary where keys are mouse IDs and values are DataFrames.
    dependent_var (str): Name of the dependent variable.
    cv (int): Number of cross-validation folds (default is 5).
    
    Returns:
    pd.DataFrame: DataFrame containing mean R² values for each mouse and each model.
    """
    models = [
        ['Position'],
        ['Time since last shock'],
        ['Global Time'],
        ['PositionxGlobal Time'],
        ['PositionxTime since last shock'],
        ['Time since last shock', 'Global Time'],
        ['Position', 'Time since last shock', 'Global Time'],
        ['PositionxGlobal Time', 'Time since last shock', 'Global Time']
    ]
    
    results = []
    for mouse, df in mice_data.items():
        for model in models:
            r2_scores = linear_regression_cross_val(df, model, dependent_var, cv)
            results.append({
                'Mouse': mouse,
                'Model': ' + '.join(model),
                'Mean R²': r2_scores["mean_r2"],
                'Std R²': r2_scores["std_r2"]
            })
    
    return pd.DataFrame(results)
