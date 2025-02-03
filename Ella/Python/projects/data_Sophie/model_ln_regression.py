#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 09:45:24 2024

@author: gruffalo
"""

from sklearn.base import BaseEstimator, RegressorMixin
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import Pipeline
from sklearn.model_selection import GridSearchCV, KFold
import numpy as np
import pandas as pd
from preprocess_linear_model import create_time_shifted_features


class ReLUPredictionWrapper(BaseEstimator, RegressorMixin):
    def __init__(self, threshold=0.0, fit_intercept=True):
        self.threshold = threshold
        self.fit_intercept = fit_intercept
        self.model = LinearRegression(fit_intercept=self.fit_intercept)

    def fit(self, X, y):
        # Adjust the model’s intercept setting if needed before fitting
        self.model = LinearRegression(fit_intercept=self.fit_intercept)
        self.model.fit(X, y)
        return self

    def predict(self, X):
        # Apply linear regression prediction followed by ReLU transformation on predictions
        linear_pred = self.model.predict(X)
        relu_pred = np.maximum(0, linear_pred - self.threshold)
        return relu_pred


def ln_grid_cv(data, dependent_var, independent_vars, threshold_values=[0], variables_shifts=None, intercept_options=[True, False], k=5):
    """
    Perform Grid Search Cross Validation for a Linear-Nonlinear (LN) model with a tunable ReLU threshold, shift configurations, and intercept options.

    Parameters:
    - data (pd.DataFrame): The dataset containing variables.
    - dependent_var (str): The dependent variable (target) for regression.
    - independent_vars (list of str): List of independent variables (predictors).
    - threshold_values (list of float): Threshold values for the ReLU function.
    - variables_shifts (list of dict): List of shift configurations for independent variables.
    - k (int): Number of folds for cross-validation. Default is 5.
    - intercept_options (list of bool): List of boolean values to include or exclude intercept in model.

    Returns:
    dict: Best model, best threshold, best shift configuration, intercept option, best mean R-squared score, intercept, and coefficients with predictor names.
    """
    # Clean the data by dropping NaN rows in dependent and independent variables
    data_clean = data.dropna(subset=[dependent_var] + independent_vars)
    y = data_clean[dependent_var].reset_index(drop=True)

    best_score = -np.inf
    best_model = None
    best_threshold = None
    best_shift_config = None
    best_intercept_option = None
    best_intercept = None
    best_coefficients_with_names = None

    # Iterate over each shift configuration in variables_shifts
    for shift_config in variables_shifts:
        # Apply the time shifts to create shifted features
        X_shifted = create_time_shifted_features(data_clean[independent_vars], shift_config)
        
        # Align X and y by dropping NaNs after shifting
        aligned_data = pd.concat([X_shifted, y], axis=1).dropna()
        if aligned_data.empty:
            print(f"Skipping shift configuration {shift_config} due to lack of aligned data.")
            continue
        
        X_aligned = aligned_data[X_shifted.columns]
        y_aligned = aligned_data[dependent_var]
        
        # Ensure there are enough samples for cross-validation
        if len(y_aligned) < k:
            print(f"Skipping shift configuration {shift_config} due to insufficient data points for {k}-fold cross-validation.")
            continue

        # Define the pipeline for the LN model with ReLU on predictions
        pipeline = Pipeline([
            ('ln_model_with_relu', ReLUPredictionWrapper())
        ])

        # Define the parameter grid for GridSearchCV on threshold values and intercept options
        if not threshold_values or not intercept_options:
            raise ValueError("Threshold values and intercept options cannot be empty.")

        
        param_grid = {
            'ln_model_with_relu__threshold': threshold_values,
            'ln_model_with_relu__fit_intercept': intercept_options
        }

        # Set up GridSearchCV with K-Fold cross-validation
        kf = KFold(n_splits=k, shuffle=True, random_state=42)
        grid_search = GridSearchCV(estimator=pipeline, param_grid=param_grid, cv=kf, scoring='r2')

        try:
            # Fit GridSearchCV with current shift configuration and threshold values
            grid_search.fit(X_aligned, y_aligned)
        except ValueError as e:
            print(f"Skipping shift configuration {shift_config} due to error: {e}")
            continue

        # Get best score and parameters for the current shift configuration
        if grid_search.best_score_ > best_score:
            best_score = grid_search.best_score_
            best_model = grid_search.best_estimator_
            best_threshold = grid_search.best_params_['ln_model_with_relu__threshold']
            best_intercept_option = grid_search.best_params_['ln_model_with_relu__fit_intercept']
            best_shift_config = shift_config
            
            # Retrieve intercept and coefficients with predictor names
            linear_model = best_model.named_steps['ln_model_with_relu'].model
            best_intercept = linear_model.intercept_
            best_coefficients_with_names = dict(zip(X_aligned.columns, linear_model.coef_))

    # Output the results
    print(f"Best threshold for ReLU: {best_threshold}")
    print(f"Best shift configuration: {best_shift_config}")
    print(f"Intercept included in best model: {best_intercept_option}")
    print(f"Best mean R-squared score across {k} folds: {best_score}")
    print(f"Intercept of Best Model: {best_intercept}")
    print(f"Coefficients of Best Model with Predictor Names: {best_coefficients_with_names}")

    return {
        'best_model': best_model,
        'best_threshold': best_threshold,
        'best_shift_config': best_shift_config,
        'best_intercept_option': best_intercept_option,
        'best_mean_r_squared': best_score,
        'intercept': best_intercept,
        'coefficients_with_names': best_coefficients_with_names
    }




# class ReLUPredictionWrapper(BaseEstimator, RegressorMixin):
#     def __init__(self, threshold=0.0):
#         self.threshold = threshold
#         self.model = LinearRegression()

#     def fit(self, X, y):
#         self.model.fit(X, y)
#         return self

#     def predict(self, X):
#         # Apply linear regression prediction followed by ReLU transformation on predictions
#         linear_pred = self.model.predict(X)
#         relu_pred = np.maximum(0, linear_pred - self.threshold)
#         return relu_pred


# def ln_grid_cv(data, dependent_var, independent_vars, threshold_values=[0], variables_shifts=None, k=5):
#     """
#     Perform Grid Search Cross Validation for a Linear-Nonlinear (LN) model with a tunable ReLU threshold and shift configurations.

#     Parameters:
#     - data (pd.DataFrame): The dataset containing variables.
#     - dependent_var (str): The dependent variable (target) for regression.
#     - independent_vars (list of str): List of independent variables (predictors).
#     - threshold_values (list of float): Threshold values for the ReLU function.
#     - variables_shifts (list of dict): List of shift configurations for independent variables.
#     - k (int): Number of folds for cross-validation. Default is 5.

#     Returns:
#     dict: Best model, best threshold, best shift configuration, best mean R-squared score, intercept, and coefficients with predictor names.
#     """
#     # Clean the data by dropping NaN rows in dependent and independent variables
#     data_clean = data.dropna(subset=[dependent_var] + independent_vars)
#     y = data_clean[dependent_var].reset_index(drop=True)

#     best_score = -np.inf
#     best_model = None
#     best_threshold = None
#     best_shift_config = None
#     best_intercept = None
#     best_coefficients_with_names = None

#     # Iterate over each shift configuration in variables_shifts
#     for shift_config in variables_shifts:
#         # Apply the time shifts to create shifted features
#         X_shifted = create_time_shifted_features(data_clean[independent_vars], shift_config)
        
#         # Align X and y by dropping NaNs after shifting
#         aligned_data = pd.concat([X_shifted, y], axis=1).dropna()
#         X_aligned = aligned_data[X_shifted.columns]
#         y_aligned = aligned_data[dependent_var]

#         # Define the pipeline for the LN model with ReLU on predictions
#         pipeline = Pipeline([
#             ('ln_model_with_relu', ReLUPredictionWrapper())
#         ])

#         # Define the parameter grid for GridSearchCV on threshold values
#         param_grid = {
#             'ln_model_with_relu__threshold': threshold_values
#         }

#         # Set up GridSearchCV with K-Fold cross-validation
#         kf = KFold(n_splits=k, shuffle=True, random_state=42)
#         grid_search = GridSearchCV(estimator=pipeline, param_grid=param_grid, cv=kf, scoring='r2')

#         # Fit GridSearchCV with current shift configuration and threshold values
#         grid_search.fit(X_aligned, y_aligned)

#         # Get best score and parameters for the current shift configuration
#         if grid_search.best_score_ > best_score:
#             best_score = grid_search.best_score_
#             best_model = grid_search.best_estimator_
#             best_threshold = grid_search.best_params_['ln_model_with_relu__threshold']
#             best_shift_config = shift_config
            
#             # Retrieve intercept and coefficients with predictor names
#             linear_model = best_model.named_steps['ln_model_with_relu'].model
#             best_intercept = linear_model.intercept_
#             best_coefficients_with_names = dict(zip(X_aligned.columns, linear_model.coef_))

#     # Output the results
#     print(f"Best threshold for ReLU: {best_threshold}")
#     print(f"Best shift configuration: {best_shift_config}")
#     print(f"Best mean R-squared score across {k} folds: {best_score}")
#     print(f"Intercept of Best Model: {best_intercept}")
#     print(f"Coefficients of Best Model with Predictor Names: {best_coefficients_with_names}")

#     return {
#         'best_model': best_model,
#         'best_threshold': best_threshold,
#         'best_shift_config': best_shift_config,
#         'best_mean_r_squared': best_score,
#         'intercept': best_intercept,
#         'coefficients_with_names': best_coefficients_with_names
#     }





