#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  3 18:13:18 2025

@author: gruffalo
"""

import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.model_selection import GridSearchCV, KFold
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LinearRegression   

class FeatureTransformer(BaseEstimator, TransformerMixin):
    """
    Custom transformer to apply sigmoid and exponential transformations 
    and compute interaction features for multiple linear regression.
    """
    def __init__(self, slope=1, op_point=0, tau=1):
        self.slope = slope
        self.op_point = op_point
        self.tau = tau

    def sigmoid_transform(self, x):
        """Apply sigmoid transformation."""
        return 1 / (1 + np.exp(-self.slope * (x - self.op_point)))

    def exponential_transform(self, x):
        """Apply negative exponential transformation."""
        return -np.exp(-x / self.tau)

    def fit(self, X, y=None):
        return self  # Nothing to fit, just transformation

    def transform(self, X):
        """Apply transformations to the dataframe."""
        X = X.copy()
        X["sig_Global_Time"] = self.sigmoid_transform(X["Global Time"])
        X["Position_sig_Global_Time"] = X["Position"] * X["sig_Global_Time"]
        X["neg_exp_Time_since_last_shock"] = self.exponential_transform(X["Time since last shock"])
        
        return X[["Position", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]]



def find_best_linear_model(df, param_grid, k_folds=5):
    """
    Performs grid search with k-fold cross-validation to find the best hyperparameters
    for a multiple linear regression model.

    Parameters:
        df (pd.DataFrame): Input dataframe containing the raw features and target variable.
        param_grid (dict): Dictionary specifying the hyperparameter values to search over.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary containing the best hyperparameters, best R² score, and best model.
    """
    # Define the pipeline
    pipeline = Pipeline([
        ("feature_transform", FeatureTransformer()),  # Custom feature transformation
        ("regressor", LinearRegression())  # Linear regression model
    ])

    # Extract the features (X) and target variable (y)
    X = df[["Position", "Global Time", "Time since last shock"]]  # Independent variables
    y = df["OB frequency"]  # Target variable

    # Set up K-Fold cross-validation
    kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)

    # Set up GridSearchCV
    grid_search = GridSearchCV(estimator=pipeline, param_grid=param_grid, cv=kf, scoring="r2", n_jobs=-1)

    # Run the grid search
    grid_search.fit(X, y)

    # Return results
    return {
        "best_params": grid_search.best_params_,
        "best_score": grid_search.best_score_,
        "best_model": grid_search.best_estimator_
    }
