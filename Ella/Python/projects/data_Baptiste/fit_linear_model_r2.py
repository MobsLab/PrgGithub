#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  3 18:13:18 2025

@author: gruffalo
"""

import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.model_selection import GridSearchCV, KFold, cross_val_score
from sklearn.pipeline import Pipeline
# from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
   
class FeatureTransformer(BaseEstimator, TransformerMixin):
    """
    Custom transformer to apply sigmoid and exponential transformations 
    and compute interaction features for multiple linear regression.
    """
    def __init__(self, slope=1, op_point=0.5, tau=1):
        self.slope = slope
        self.op_point = op_point  # Fraction of range
        self.tau = tau
        self.global_time_range = None  # Store range for later use

    def fit(self, X, y=None):
        """Compute range of Global Time and store it."""
        self.global_time_min = X["Global Time"].min()
        self.global_time_max = X["Global Time"].max()
        self.global_time_range = self.global_time_max - self.global_time_min
        return self  # Nothing else to fit

    def sigmoid_transform(self, x):
        """Apply sigmoid transformation with op_point as a fraction of the range."""
        op_value = self.op_point * self.global_time_range + self.global_time_min
        return 1 / (1 + np.exp(-self.slope * (x - op_value)))

    def exponential_transform(self, x):
        """Apply negative exponential transformation."""
        return np.exp(-x / self.tau)

    def transform(self, X):
        """Apply transformations to the dataframe."""
        X = X.copy()
        X["sig_Global_Time"] = self.sigmoid_transform(X["Global Time"])
        X["Position_sig_Global_Time"] = X["Position"] * X["sig_Global_Time"]
        X["neg_exp_Time_since_last_shock"] = self.exponential_transform(X["Time since last shock"])

        return X[["Position", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]]

# class FeatureTransformer(BaseEstimator, TransformerMixin):
#     """
#     Custom transformer to apply sigmoid and exponential transformations 
#     and compute interaction features for multiple linear regression.
#     """
#     def __init__(self, slope=1, op_point=0, tau=1):
#         self.slope = slope
#         self.op_point = op_point
#         self.tau = tau

#     def sigmoid_transform(self, x):
#         """Apply sigmoid transformation."""
#         return 1 / (1 + np.exp(-self.slope * (x - self.op_point)))

#     def exponential_transform(self, x):
#         """Apply negative exponential transformation."""
#         return np.exp(-x / self.tau)

#     def fit(self, X, y=None):
#         return self  # Nothing to fit, just transformation

#     def transform(self, X):
#         """Apply transformations to the dataframe."""
#         X = X.copy()
#         X["sig_Global_Time"] = self.sigmoid_transform(X["Global Time"])
#         X["Position_sig_Global_Time"] = X["Position"] * X["sig_Global_Time"]
#         X["neg_exp_Time_since_last_shock"] = self.exponential_transform(X["Time since last shock"])
        
#         return X[["Position", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]]


def find_best_linear_model(df, param_grid, k_folds=5):
    """
    Performs grid search with k-fold cross-validation to find the best hyperparameters
    for a multiple linear regression model and retrieves model coefficients.

    Parameters:
        df (pd.DataFrame): Input dataframe containing the raw features and target variable.
        param_grid (dict): Dictionary specifying the hyperparameter values to search over.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary containing:
              - best_params: Best hyperparameters from grid search.
              - best_score: Mean R² from cross-validation using cross_val_score.
              - best_model: Best fitted model.
              - coefficients: Dictionary of fitted beta coefficients for independent variables.
              - intercept: Intercept term of the best model.
    """
    pipeline = Pipeline([
    # ("scaler", StandardScaler()),  # Scale raw features BEFORE transformation
    ("feature_transform", FeatureTransformer()),  # Apply transformations
    ("regressor", LinearRegression())  # Fit linear regression
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

    # Extract the best model from grid search
    best_pipeline = grid_search.best_estimator_
    best_model = best_pipeline.named_steps["regressor"]  # Extract LinearRegression model
    feature_transformer = best_pipeline.named_steps["feature_transform"]


    # Validate the best model using cross_val_score
    best_score_cv = cross_val_score(best_pipeline, X, y, cv=kf, scoring="r2")
    mean_r2 = best_score_cv.mean()  # Mean R² across folds

    # Retrieve feature names after transformation
    transformed_feature_names = ["Position", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]

    # Store coefficients
    coefficients = dict(zip(transformed_feature_names, best_model.coef_))
    
    # **Convert Global Time coefficient to fraction**
    if "Global Time" in coefficients:
        coefficients["Global Time"] /= feature_transformer.global_time_range  # Normalize coefficient

    intercept = best_model.intercept_

    # Return results
    return {
        "best_params": grid_search.best_params_,
        "best_score": mean_r2,  # R² from cross_val_score
        "best_model": best_pipeline,
        "coefficients": coefficients,
        "intercept": intercept
    }


def fit_all_predictors_model(df, best_params, k_folds=5):
    """
    Fits a multiple linear regression model using all transformed predictors.

    Parameters:
        df (pd.DataFrame): Dataframe containing the raw features and target variable.
        best_params (dict): Dictionary of best hyperparameters obtained from grid search.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary containing:
              - 'coefficients': Dictionary of fitted beta coefficients.
              - 'intercept': Intercept of the model.
              - 'mean_r2': Mean R² score from cross-validation.
              - 'mean_mae': Mean MAE score from cross-validation.
    """
    # Clean best_params keys by removing "feature_transform__" prefix
    cleaned_params = {
        key.replace("feature_transform__", ""): value
        for key, value in best_params.items()
    }
    
    # Ensure the dataframe contains required raw features
    required_raw_features = ["Position", "Global Time", "Time since last shock"]
    missing_columns = [col for col in required_raw_features if col not in df.columns]
    if missing_columns:
        raise KeyError(f"The dataframe is missing required columns: {missing_columns}")   

    # Apply feature transformation using best hyperparameters
    feature_transformer = FeatureTransformer(**cleaned_params)
    df_transformed = feature_transformer.fit_transform(df[required_raw_features])

    # Define cross-validation
    kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)

    # Define pipeline
    pipeline = Pipeline([
        # ("scaler", StandardScaler()),  # Normalize transformed features
        ("regressor", LinearRegression())  # Fit linear regression
    ])

    # Extract target variable
    y = df["OB frequency"]

    # Compute cross-validated scores BEFORE fitting on full data
    r2_scores = cross_val_score(pipeline, df_transformed, y, cv=kf, scoring="r2")
    mean_r2 = np.mean(r2_scores)

    mae_scores = cross_val_score(pipeline, df_transformed, y, cv=kf, scoring="neg_mean_absolute_error")
    mean_mae = -np.mean(mae_scores)  # Convert to positive MAE

    # Fit the model using all transformed predictors
    pipeline.fit(df_transformed, y)

    # Extract fitted model
    fitted_model = pipeline.named_steps["regressor"]

    # Store coefficients
    coefficients = dict(zip(df_transformed.columns, fitted_model.coef_))
    intercept = fitted_model.intercept_

    # Return results
    return {
        "coefficients": coefficients,
        "intercept": intercept,
        "mean_r2": mean_r2,  # Now matches GridSearchCV
        "mean_mae": mean_mae
    }


def fit_single_predictor_models(df, best_params, k_folds=5):
    """
    Fits separate linear regression models using each transformed independent variable alone.

    Parameters:
        df (pd.DataFrame): Dataframe containing the raw features and target variable.
        best_params (dict): Dictionary of best hyperparameters obtained from grid search.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary where keys are transformed feature names and values contain:
              - 'coefficient': Beta coefficient of the predictor.
              - 'intercept': Intercept of the model.
              - 'mean_r2': Mean R² score from cross-validation.
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
    df_transformed = feature_transformer.fit_transform(df[required_raw_features])

    for feature in transformed_features:
        try:
            if feature not in df_transformed.columns:
                raise KeyError(f"Feature '{feature}' is missing after transformation.")

            # Define pipeline
            pipeline = Pipeline([
                # ("scaler", StandardScaler()),  # Normalize the single feature
                ("regressor", LinearRegression())  # Fit linear regression
            ])

            # Extract target variable
            y = df["OB frequency"]
            X_selected = df_transformed[[feature]]  # Use only one predictor at a time

            # Cross-validation before fitting
            kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)
            r2_scores = cross_val_score(pipeline, X_selected, y, cv=kf, scoring="r2")
            mean_r2 = np.mean(r2_scores)

            mae_scores = cross_val_score(pipeline, X_selected, y, cv=k_folds, scoring="neg_mean_absolute_error")
            mean_mae = -np.mean(mae_scores)  # Convert to positive MAE

            # Fit the model on the full dataset
            pipeline.fit(X_selected, y)
            fitted_model = pipeline.named_steps["regressor"]

            # Store results
            results[feature] = {
                "coefficient": fitted_model.coef_[0],
                "intercept": fitted_model.intercept_,
                "mean_r2": mean_r2,
                "mean_mae": mean_mae
            }

        except KeyError as e:
            print(f"Error processing feature '{feature}': {e}")

    return results



def fit_leave_one_out_models(df, best_params, k_folds=5):
    """
    Fits multiple linear regression models, each leaving out one predictor.

    Parameters:
        df (pd.DataFrame): Dataframe containing the raw features and target variable.
        best_params (dict): Dictionary of best hyperparameters obtained from grid search.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary where keys are omitted predictor names and values contain:
              - 'coefficients': Dictionary of beta coefficients for remaining predictors.
              - 'intercept': Intercept of the model.
              - 'mean_r2': Mean R² score from cross-validation.
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
    df_transformed = feature_transformer.fit_transform(df[required_raw_features])

    for feature_to_remove in transformed_features:
        try:
            if feature_to_remove not in df_transformed.columns:
                raise KeyError(f"Feature '{feature_to_remove}' is missing after transformation.")

            # Select all features except the one being removed
            selected_features = [f for f in transformed_features if f != feature_to_remove]
            X_selected = df_transformed[selected_features]
            y = df["OB frequency"]

            # Define pipeline
            pipeline = Pipeline([
                # ("scaler", StandardScaler()),  # Normalize features
                ("regressor", LinearRegression())  # Fit linear regression
            ])

            # Cross-validation before fitting
            kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)
            r2_scores = cross_val_score(pipeline, X_selected, y, cv=kf, scoring="r2")
            mean_r2 = np.mean(r2_scores)

            mae_scores = cross_val_score(pipeline, X_selected, y, cv=k_folds, scoring="neg_mean_absolute_error")
            mean_mae = -np.mean(mae_scores)  # Convert to positive MAE

            # Fit the model on the full dataset
            pipeline.fit(X_selected, y)
            fitted_model = pipeline.named_steps["regressor"]

            # Store results
            results[feature_to_remove] = {
                "coefficients": dict(zip(selected_features, fitted_model.coef_)),
                "intercept": fitted_model.intercept_,
                "mean_r2": mean_r2,
                "mean_mae": mean_mae
            }

        except KeyError as e:
            print(f"Error processing feature '{feature_to_remove}': {e}")

    return results


