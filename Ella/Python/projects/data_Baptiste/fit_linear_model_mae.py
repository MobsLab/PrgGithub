#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  3 18:13:18 2025

@author: gruffalo
"""

import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score, KFold, GridSearchCV
   

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
        return np.exp(-x / self.tau)

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
    for a multiple linear regression model using Mean Absolute Error (MAE).

    Parameters:
        df (pd.DataFrame): Input dataframe containing the raw features and target variable.
        param_grid (dict): Dictionary specifying the hyperparameter values to search over.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary containing:
              - best_params: Best hyperparameters from grid search.
              - best_score: Mean MAE (lower is better).
              - best_model: Best fitted model.
              - coefficients: Dictionary of fitted beta coefficients for independent variables.
              - intercept: Intercept term of the best model.
    """
    # Define the pipeline with normalization
    pipeline = Pipeline([
        ("feature_transform", FeatureTransformer()),  # Apply transformations
        ("scaler", StandardScaler()),  # Normalize transformed features
        ("regressor", LinearRegression())  # Fit linear regression
    ])

    # Extract the features (X) and target variable (y)
    X = df[["Position", "Global Time", "Time since last shock"]]  # Independent variables
    y = df["OB frequency"]  # Target variable

    # Set up K-Fold cross-validation
    kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)

    # Set up GridSearchCV with MAE instead of R²
    grid_search = GridSearchCV(estimator=pipeline, param_grid=param_grid, cv=kf, scoring="neg_mean_absolute_error", n_jobs=-1)

    # Run the grid search
    grid_search.fit(X, y)

    # Extract the best model from grid search
    best_pipeline = grid_search.best_estimator_
    best_model = best_pipeline.named_steps["regressor"]  # Extract LinearRegression model

    # Validate the best model using cross_val_score
    best_score_cv = cross_val_score(best_pipeline, X, y, cv=kf, scoring="neg_mean_absolute_error")
    mean_mae = -best_score_cv.mean()  # Convert to positive MAE

    # Retrieve feature names after transformation
    transformed_feature_names = ["Position", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]

    # Store coefficients
    coefficients = dict(zip(transformed_feature_names, best_model.coef_))
    intercept = best_model.intercept_

    # Return results
    return {
        "best_params": grid_search.best_params_,
        "best_score": mean_mae,  # MAE from cross_val_score
        "best_model": best_pipeline,
        "coefficients": coefficients,
        "intercept": intercept
    }


def fit_single_predictor_models(df, best_params):
    """
    Fits separate linear regression models using each transformed independent variable alone.

    Parameters:
        df (pd.DataFrame): Dataframe containing the raw features and target variable.
        best_params (dict): Dictionary of best hyperparameters obtained from grid search.

    Returns:
        dict: A dictionary where keys are transformed feature names and values contain:
              - 'coefficient': Beta coefficient of the predictor.
              - 'intercept': Intercept of the model.
              - 'mean_mae': Mean MAE score from cross-validation.
    """
    # Clean best_params keys by removing "feature_transform__" prefix
    cleaned_params = {
        key.replace("feature_transform__", ""): value
        for key, value in best_params.items()
    }

    transformed_features = ["Position", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]
    results = {}

    # Ensure the dataframe contains required raw features
    required_raw_features = ["Position", "Global Time", "Time since last shock"]
    missing_columns = [col for col in required_raw_features if col not in df.columns]
    if missing_columns:
        raise KeyError(f"The dataframe is missing required columns: {missing_columns}")

    # Apply feature transformation on full dataframe before selecting predictors
    feature_transformer = FeatureTransformer(**cleaned_params)
    df_transformed = feature_transformer.fit_transform(df[required_raw_features])  # Apply transformation

    for feature in transformed_features:
        try:
            if feature not in df_transformed.columns:
                raise KeyError(f"Feature '{feature}' is missing after transformation.")

            # Define a pipeline with normalization and regression
            pipeline = Pipeline([
                ("scaler", StandardScaler()),  # Normalize the single feature
                ("regressor", LinearRegression())  # Fit linear regression
            ])

            # Extract target variable
            y = df["OB frequency"]

            # Use only the selected transformed feature
            X_selected = df_transformed[[feature]]

            # Perform cross-validation to get mean MAE
            mae_scores = cross_val_score(pipeline, X_selected, y, cv=5, scoring="neg_mean_absolute_error")
            mean_mae = -np.mean(mae_scores)  # Convert to positive MAE

            # Fit the model
            pipeline.fit(X_selected, y)

            # Extract fitted model
            fitted_model = pipeline.named_steps["regressor"]

            # Store results
            results[feature] = {
                "coefficient": fitted_model.coef_[0],
                "intercept": fitted_model.intercept_,
                "mean_mae": mean_mae
            }

        except KeyError as e:
            print(f"Error processing feature '{feature}': {e}")

    return results


def fit_leave_one_out_models(df, best_params):
    """
    Fits multiple linear regression models, each leaving out one predictor.

    Parameters:
        df (pd.DataFrame): Dataframe containing the raw features and target variable.
        best_params (dict): Dictionary of best hyperparameters obtained from grid search.

    Returns:
        dict: A dictionary where keys are omitted predictor names and values contain:
              - 'coefficients': Dictionary of beta coefficients for remaining predictors.
              - 'intercept': Intercept of the model.
              - 'mean_mae': Mean MAE score from cross-validation.
    """
    # Clean best_params keys by removing "feature_transform__" prefix
    cleaned_params = {
        key.replace("feature_transform__", ""): value
        for key, value in best_params.items()
    }

    transformed_features = ["Position", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]
    results = {}

    # Ensure the dataframe contains required raw features
    required_raw_features = ["Position", "Global Time", "Time since last shock"]
    missing_columns = [col for col in required_raw_features if col not in df.columns]
    if missing_columns:
        raise KeyError(f"The dataframe is missing required columns: {missing_columns}")

    # Apply feature transformation on the full dataframe before dropping features
    feature_transformer = FeatureTransformer(**cleaned_params)
    df_transformed = feature_transformer.fit_transform(df[required_raw_features])  # Apply transformation

    for feature_to_remove in transformed_features:
        try:
            # Ensure the transformed feature exists
            if feature_to_remove not in df_transformed.columns:
                raise KeyError(f"Feature '{feature_to_remove}' is missing after transformation.")

            # Select all features except the one being removed
            selected_features = [f for f in transformed_features if f != feature_to_remove]
            X_selected = df_transformed[selected_features]
            y = df["OB frequency"]

            # Define pipeline with normalization and regression
            pipeline = Pipeline([
                ("scaler", StandardScaler()),  # Normalize features
                ("regressor", LinearRegression())  # Fit linear regression
            ])

            # Perform cross-validation to get mean MAE
            mae_scores = cross_val_score(pipeline, X_selected, y, cv=5, scoring="neg_mean_absolute_error")
            mean_mae = -np.mean(mae_scores)  # Convert to positive MAE

            # Fit the model
            pipeline.fit(X_selected, y)

            # Extract fitted model
            fitted_model = pipeline.named_steps["regressor"]

            # Store results
            results[feature_to_remove] = {
                "coefficients": dict(zip(selected_features, fitted_model.coef_)),
                "intercept": fitted_model.intercept_,
                "mean_mae": mean_mae
            }

        except KeyError as e:
            print(f"Error processing feature '{feature_to_remove}': {e}")

    return results



