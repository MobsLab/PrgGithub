#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 14 17:30:25 2025

@author: gruffalo
"""

from fit_linear_model_r2 import FeatureTransformer
import pandas as pd
import numpy as np

def predict_respiratory_frequency(mice_data, best_params_dict, independent_vars, coefficients_dict):
    """
    Predicts respiratory frequency for all mice using the fitted model's coefficients and transformed features.

    Parameters:
        mice_data (dict): Dictionary containing raw feature DataFrames for each mouse.
        best_params_dict (dict): Dictionary of best hyperparameters from grid search for each mouse.
        independent_vars (list): List of predictors (raw or transformed).
        coefficients_dict (dict): Dictionary containing the fitted coefficients and intercept for each mouse.

    Returns:
        dict: Dictionary where keys are mouse IDs and values are DataFrames containing:
              - 'Position': Raw position data
              - 'Predicted Respiratory Frequency': Model predictions
    """
    predictions_dict = {}
    
    for mouse_id, df in mice_data.items():
        if mouse_id not in coefficients_dict or mouse_id not in best_params_dict:
            print(f"Skipping {mouse_id}: Missing coefficients or best parameters.")
            continue

        # Clean best_params keys by removing "feature_transform__" prefix
        cleaned_params = {
            key.replace("feature_transform__", ""): value
            for key, value in best_params_dict[mouse_id].items()
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
            print(f"Skipping {mouse_id}: Missing raw features {missing_raw_features}.")
            continue

        X_raw = df[existing_raw_features]  # Extract only relevant raw features

        # Apply feature transformation using best hyperparameters
        feature_transformer = FeatureTransformer(selected_vars=independent_vars, **cleaned_params)
        X_transformed = feature_transformer.fit_transform(X_raw)

        # Extract coefficients and intercept for the specific mouse
        coefficients = coefficients_dict[mouse_id]["coefficients"]
        intercept = coefficients_dict[mouse_id]["intercept"]

        # Compute predictions manually
        X_transformed_array = X_transformed.to_numpy()  # Convert DataFrame to array
        beta_values = np.array([coefficients[var] for var in X_transformed.columns])  # Ensure correct ordering
        predictions = intercept + np.dot(X_transformed_array, beta_values)

        # Store predictions in DataFrame
        predictions_df = pd.DataFrame({
            "Position": df["Position"].values if "Position" in df.columns else np.nan,
            "Predicted Respiratory Frequency": predictions
        })

        predictions_dict[mouse_id] = predictions_df
    
    return predictions_dict
