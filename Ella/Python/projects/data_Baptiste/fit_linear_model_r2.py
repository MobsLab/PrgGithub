#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  3 18:13:18 2025

@author: gruffalo
"""

import numpy as np
import pandas as pd

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
    def __init__(self, slope=1, op_point=0.5, tau=1, selected_vars=None):
        """
        Parameters:
        - slope (float): Steepness of the sigmoid transformation.
        - op_point (float): Fraction of the range to set the sigmoid center.
        - tau (float): Time constant for the exponential transformation.
        - selected_vars (list): List of variables to transform. If None, all transformations are applied.
        """
        self.slope = slope
        self.op_point = op_point  # Fraction of range
        self.tau = tau
        self.global_time_range = None  # Store range for later use
        self.selected_vars = selected_vars  # Variables to include in transformation

    def fit(self, X, y=None):
        """Compute range of Global Time and store it."""
        if "Global Time" in X.columns:
            self.global_time_min = X["Global Time"].min()
            self.global_time_max = X["Global Time"].max()
            self.global_time_range = self.global_time_max - self.global_time_min
        return self  # Nothing else to fit

    def sigmoid_transform(self, x):
        """Apply sigmoid transformation with op_point as a fraction of the range."""
        if self.global_time_range is None:
            raise ValueError("FeatureTransformer must be fitted before transformation.")
        op_value = self.op_point * self.global_time_range + self.global_time_min
        return 1 / (1 + np.exp(-self.slope * (x - op_value)))

    def exponential_transform(self, x):
        """Apply negative exponential transformation."""
        return np.exp(-x / self.tau)

    def transform(self, X):
        """Apply transformations based on the selected variables."""
        X = X.copy()
        transformed_features = {}

        # Ensure raw features are present if required for transformations
        required_raw_features = set()
        if "Position_sig_Global_Time" in self.selected_vars:
            required_raw_features.update(["Position", "Global Time"])
        if "neg_exp_Time_since_last_shock" in self.selected_vars:
            required_raw_features.add("Time since last shock")

        # Ensure X contains all required raw features
        for col in required_raw_features:
            if col not in X.columns:
                raise KeyError(f"Required raw feature '{col}' is missing from the dataset.")

        # Apply transformations
        if "sig_Global_Time" in self.selected_vars:
            transformed_features["sig_Global_Time"] = self.sigmoid_transform(X["Global Time"])
        
        if "Position_sig_Global_Time" in self.selected_vars:
            transformed_features["Position_sig_Global_Time"] = X["Position"] * self.sigmoid_transform(X["Global Time"])
        
        if "neg_exp_Time_since_last_shock" in self.selected_vars:
            transformed_features["neg_exp_Time_since_last_shock"] = self.exponential_transform(X["Time since last shock"])

        # Add raw variables if included in selected_vars
        for col in self.selected_vars:
            if col in X.columns:
                transformed_features[col] = X[col]

        return pd.DataFrame(transformed_features)


def find_best_linear_model(df, param_grid, independent_vars, k_folds=5):
    """
    Performs grid search with k-fold cross-validation to find the best hyperparameters
    for a multiple linear regression model and retrieves model coefficients.

    Parameters:
        df (pd.DataFrame): Input dataframe containing the raw features and target variable.
        param_grid (dict): Dictionary specifying the hyperparameter values to search over.
        independent_vars (list): List of predictor variables to use in the model. 
                                 Can include transformed names if needed.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary containing:
              - best_params: Best hyperparameters from grid search.
              - best_score: Mean R² from cross-validation using cross_val_score.
              - best_model: Best fitted model.
              - coefficients: Dictionary of fitted beta coefficients for independent variables.
              - intercept: Intercept term of the best model.
    """

    # Identify the raw features required for transformation
    required_raw_features = set()
    if "Position_sig_Global_Time" in independent_vars:
        required_raw_features.update(["Position", "Global Time"])
    if "neg_exp_Time_since_last_shock" in independent_vars:
        required_raw_features.add("Time since last shock")

    # Extract only raw features from df (transformed features are created later)
    existing_raw_features = list(required_raw_features & set(df.columns))
    missing_raw_features = required_raw_features - set(df.columns)

    if missing_raw_features:
        raise KeyError(f"The dataframe is missing required raw features: {missing_raw_features}")

    X_raw = df[existing_raw_features]  # Only raw features needed for transformation
    y = df["OB frequency"]  # Target variable

    pipeline = Pipeline([
        ("feature_transform", FeatureTransformer(selected_vars=independent_vars)),  # Apply transformations
        ("regressor", LinearRegression())  # Fit linear regression
    ])

    # Set up K-Fold cross-validation
    kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)

    # Set up GridSearchCV
    grid_search = GridSearchCV(estimator=pipeline, param_grid=param_grid, cv=kf, scoring="r2", n_jobs=-1)

    # Run the grid search
    grid_search.fit(X_raw, y)  # Pass raw data; transformer will generate independent_vars

    # Extract the best model from grid search
    best_pipeline = grid_search.best_estimator_
    best_model = best_pipeline.named_steps["regressor"]  # Extract LinearRegression model
    feature_transformer = best_pipeline.named_steps["feature_transform"]

    # Validate the best model using cross_val_score
    best_score_cv = cross_val_score(best_pipeline, X_raw, y, cv=kf, scoring="r2")
    mean_r2 = best_score_cv.mean()  # Mean R² across folds

    # Store coefficients
    coefficients = dict(zip(independent_vars, best_model.coef_))

    # **Convert Global Time coefficient to fraction**
    if "Global Time" in coefficients and feature_transformer.global_time_range is not None:
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


def fit_all_predictors_model(df, best_params, independent_vars, k_folds=5):
    """
    Fits a multiple linear regression model using all specified predictors.
    Handles transformed features dynamically based on the `independent_vars` list.

    Parameters:
        df (pd.DataFrame): Dataframe containing the raw features and target variable.
        best_params (dict): Dictionary of best hyperparameters obtained from grid search.
        independent_vars (list): List of predictors to use in the model (raw or transformed).
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

    # Identify raw features required for transformations
    required_raw_features = set()
    if "Position_sig_Global_Time" in independent_vars:
        required_raw_features.update(["Position", "Global Time"])
    if "neg_exp_Time_since_last_shock" in independent_vars:
        required_raw_features.add("Time since last shock")
    
    # Extract only raw features from df (transformed ones are created inside the transformer)
    existing_raw_features = list(required_raw_features & set(df.columns))
    missing_raw_features = required_raw_features - set(df.columns)

    if missing_raw_features:
        raise KeyError(f"The dataframe is missing required raw features: {missing_raw_features}")

    X_raw = df[existing_raw_features]  # Only required raw features
    y = df["OB frequency"]  # Target variable

    # Apply feature transformation using best hyperparameters
    feature_transformer = FeatureTransformer(selected_vars=independent_vars, **cleaned_params)
    X_transformed = feature_transformer.fit_transform(X_raw)

    # Define cross-validation
    kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)

    # Define pipeline (No feature transformation inside, as it's already done)
    pipeline = Pipeline([
        ("regressor", LinearRegression())  # Fit linear regression
    ])

    # Compute cross-validated scores BEFORE fitting on full data
    r2_scores = cross_val_score(pipeline, X_transformed, y, cv=kf, scoring="r2")
    mean_r2 = np.mean(r2_scores)

    mae_scores = cross_val_score(pipeline, X_transformed, y, cv=kf, scoring="neg_mean_absolute_error")
    mean_mae = -np.mean(mae_scores)  # Convert to positive MAE

    # Fit the model using all transformed predictors
    pipeline.fit(X_transformed, y)

    # Extract fitted model
    fitted_model = pipeline.named_steps["regressor"]

    # Store coefficients
    coefficients = dict(zip(X_transformed.columns, fitted_model.coef_))
    intercept = fitted_model.intercept_

    # Return results
    return {
        "coefficients": coefficients,
        "intercept": intercept,
        "mean_r2": mean_r2,  # Matches GridSearchCV
        "mean_mae": mean_mae
    }



def fit_single_predictor_models(df, best_params, independent_vars, raw_predictors=None, k_folds=5):
    """
    Fits separate linear regression models using each independent variable alone.

    Parameters:
        df (pd.DataFrame): Dataframe containing raw features and target variable.
        best_params (dict): Dictionary of best hyperparameters obtained from grid search.
        independent_vars (list): List of predictor variables to use in the model (raw or transformed).
        raw_predictors (list, optional): List of raw predictors that are used directly in the model.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary where keys are predictor names and values contain:
              - 'coefficient': Beta coefficient of the predictor.
              - 'intercept': Intercept of the model.
              - 'mean_r2': Mean R² score from cross-validation.
              - 'mean_mae': Mean MAE score from cross-validation.
    """

    # Ensure raw_predictors is a list (avoid TypeError if None)
    raw_predictors = raw_predictors if raw_predictors else []

    # Clean best_params keys by removing "feature_transform__" prefix
    cleaned_params = {key.replace("feature_transform__", ""): value for key, value in best_params.items()}

    # Ensure the DataFrame contains all raw features (for transformation & model fitting)
    required_raw_features = ["Position", "Global Time", "Time since last shock", "Time spent freezing"]
    raw_features_needed = list(set(required_raw_features) & set(df.columns))  # Only keep available columns

    # Separate transformed features from raw predictors
    transformed_vars = [var for var in independent_vars if var not in raw_predictors]
    raw_vars = [var for var in independent_vars if var in raw_predictors]

    # Apply feature transformation only if needed
    feature_transformer = FeatureTransformer(**cleaned_params, selected_vars=transformed_vars)
    df_transformed = feature_transformer.fit_transform(df[raw_features_needed]) if transformed_vars else pd.DataFrame()

    # Include raw predictors
    if raw_vars:
        df_transformed[raw_vars] = df[raw_vars]

    results = {}

    for feature in independent_vars:
        if feature not in df_transformed.columns:
            print(f"Warning: Feature '{feature}' is missing. Skipping.")
            continue

        try:
            # Define pipeline
            pipeline = Pipeline([
                ("regressor", LinearRegression())  # Fit linear regression
            ])

            # Extract target variable
            y = df["OB frequency"]
            X_selected = df_transformed[[feature]]

            # Cross-validation
            kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)
            r2_scores = cross_val_score(pipeline, X_selected, y, cv=kf, scoring="r2")
            mean_r2 = np.mean(r2_scores)

            mae_scores = cross_val_score(pipeline, X_selected, y, cv=kf, scoring="neg_mean_absolute_error")
            mean_mae = -np.mean(mae_scores)  # Convert to positive MAE

            # Fit model
            pipeline.fit(X_selected, y)
            fitted_model = pipeline.named_steps["regressor"]

            # Store results
            results[feature] = {
                "coefficient": fitted_model.coef_[0],
                "intercept": fitted_model.intercept_,
                "mean_r2": mean_r2,
                "mean_mae": mean_mae
            }

        except Exception as e:
            print(f"Error processing feature '{feature}': {e}")

    return results



def fit_leave_one_out_models(df, best_params, independent_vars, raw_predictors=None, k_folds=5):
    """
    Fits multiple linear regression models, each leaving out one predictor.

    Parameters:
        df (pd.DataFrame): Dataframe containing the raw features and target variable.
        best_params (dict): Dictionary of best hyperparameters obtained from grid search.
        independent_vars (list): List of predictor variables to use in the model (raw or transformed).
        raw_predictors (list, optional): List of raw predictors that are used directly in the model.
        k_folds (int, optional): Number of folds for cross-validation (default: 5).

    Returns:
        dict: A dictionary where keys are omitted predictor names and values contain:
              - 'coefficients': Dictionary of beta coefficients for remaining predictors.
              - 'intercept': Intercept of the model.
              - 'mean_r2': Mean R² score from cross-validation.
              - 'mean_mae': Mean MAE score from cross-validation.
    """

    # Ensure raw_predictors is a list (avoid TypeError if None)
    raw_predictors = raw_predictors if raw_predictors else []

    # Clean best_params keys by removing "feature_transform__" prefix
    cleaned_params = {key.replace("feature_transform__", ""): value for key, value in best_params.items()}

    # Ensure the DataFrame contains all raw features (for transformation & model fitting)
    required_raw_features = ["Position", "Global Time", "Time since last shock", "Time spent freezing"]
    raw_features_needed = list(set(required_raw_features) & set(df.columns))  # Only keep available columns

    # Separate transformed features from raw predictors
    transformed_vars = [var for var in independent_vars if var not in raw_predictors]
    raw_vars = [var for var in independent_vars if var in raw_predictors]

    # Apply feature transformation only if needed
    feature_transformer = FeatureTransformer(**cleaned_params, selected_vars=transformed_vars)
    df_transformed = feature_transformer.fit_transform(df[raw_features_needed]) if transformed_vars else pd.DataFrame()

    # Include raw predictors
    if raw_vars:
        df_transformed[raw_vars] = df[raw_vars]

    results = {}

    for feature_to_remove in independent_vars:
        try:
            if feature_to_remove not in df_transformed.columns:
                print(f"Warning: Feature '{feature_to_remove}' is missing. Skipping.")
                continue

            # Select all features except the one being removed
            selected_features = [f for f in independent_vars if f != feature_to_remove]
            X_selected = df_transformed[selected_features]
            y = df["OB frequency"]

            # Define pipeline
            pipeline = Pipeline([
                ("regressor", LinearRegression())  # Fit linear regression
            ])

            # Cross-validation before fitting
            kf = KFold(n_splits=k_folds, shuffle=True, random_state=42)
            r2_scores = cross_val_score(pipeline, X_selected, y, cv=kf, scoring="r2")
            mean_r2 = np.mean(r2_scores)

            mae_scores = cross_val_score(pipeline, X_selected, y, cv=kf, scoring="neg_mean_absolute_error")
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

        except Exception as e:
            print(f"Error processing feature '{feature_to_remove}': {e}")

    return results


def fit_models_for_all_mice(mice_data, param_grid, independent_vars):
    """
    Fits multiple linear regression models for each mouse in the dataset:
    - Full model (all predictors)
    - Single predictor models (one at a time)
    - Leave-one-out models (all but one predictor)

    Parameters:
    - mice_data (dict): Dictionary containing mouse IDs as keys and their dataframes as values.
    - param_grid (dict): Grid search parameters for hyperparameter tuning.
    - independent_vars (list): List of predictor variables to use in the model (raw or transformed).

    Returns:
    - pd.DataFrame: DataFrame containing R² scores for each mouse and model type.
    - dict: Dictionary containing the best parameters of the full model for each mouse.
    """

    results = []
    best_params_dict = {}  # Store best parameters for each mouse

    for mouse_id, df in mice_data.items():
        print(f"\nProcessing Mouse: {mouse_id}")

        if df.empty:
            print(f"  Warning: Mouse {mouse_id} has an empty dataframe. Skipping.")
            continue

        # Fit the full model
        best_results = find_best_linear_model(df, param_grid, independent_vars)
        best_r2 = best_results["best_score"]

        # Store best parameters
        best_params_dict[mouse_id] = best_results["best_params"]

        # Fit all predictors model
        all_results = fit_all_predictors_model(df, best_results["best_params"], independent_vars)
        all_r2 = all_results["mean_r2"]

        # Fit single predictor models
        single_predictor_results = fit_single_predictor_models(df, best_results["best_params"], independent_vars)

        for predictor, metrics in single_predictor_results.items():
            results.append({
                "Mouse": mouse_id,
                "Model": "Single Predictor",
                "Predictor": predictor,
                "R²": metrics["mean_r2"]
            })

        # Fit leave-one-out models
        leave_one_out_results = fit_leave_one_out_models(df, best_results["best_params"], independent_vars)

        for omitted_predictor, metrics in leave_one_out_results.items():
            results.append({
                "Mouse": mouse_id,
                "Model": "Leave-One-Out",
                "Omitted Predictor": omitted_predictor,
                "R²": metrics["mean_r2"]
            })

        # Store the results for the full and all-predictor models
        results.append({
            "Mouse": mouse_id,
            "Model": "Full Model",
            "Predictor": "All Predictors",
            "R²": best_r2
        })

        results.append({
            "Mouse": mouse_id,
            "Model": "All Predictors Model",
            "Predictor": "All Predictors",
            "R²": all_r2
        })

    # Convert results to a Pandas DataFrame
    results_df = pd.DataFrame(results)

    return results_df, best_params_dict  # Return both results and best parameters





