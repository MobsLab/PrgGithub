#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 14 17:30:25 2025

@author: gruffalo
"""

from fit_linear_model_r2 import FeatureTransformer
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
              - All variables used in prediction
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
        required_raw_features = set(independent_vars)
        # Add raw features required for transformations (ignore if they are not in the dataset)
        required_raw_features.update([col for col in ["Position", "Global Time"] if "Position_sig_Global_Time" in independent_vars])
        required_raw_features.update(["Time since last shock"] if "neg_exp_Time_since_last_shock" in independent_vars else [])

        # Extract relevant raw features
        existing_raw_features = list(required_raw_features & set(df.columns))

        if not existing_raw_features:
            print(f"Skipping {mouse_id}: No required raw features found in dataset.")
            continue

        X_raw = df[existing_raw_features]  # Extract all necessary raw features

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

        # Build prediction dataframe with all transformed features and predictions
        predictions_df = X_transformed.copy()
        predictions_df["Predicted Respiratory Frequency"] = predictions
        predictions_df["OB frequency"] = df["OB frequency"].values  # Add actual target values
        predictions_df["Position"] = df["Position"].values
        
        # Store in dictionary
        predictions_dict[mouse_id] = predictions_df
        
    print(X_transformed.columns)

    return predictions_dict


from scipy.stats import pearsonr
import pandas as pd

def analyze_predictions_by_zone(predictions_dict, exclude_mice=None):
    """
    Splits prediction results into 'shock' and 'safe' zones based on Position,
    and compares predicted vs actual OB frequency using Pearson correlation,
    mean values, and difference between shock and safe means.

    Parameters:
        predictions_dict (dict): Dictionary of DataFrames per mouse, each containing:
                                 - 'Position'
                                 - 'Predicted Respiratory Frequency'
                                 - 'OB frequency'
        exclude_mice (list, optional): List of mouse IDs to exclude from analysis.

    Returns:
        pd.DataFrame: Summary per mouse with:
                      - Pearson correlation
                      - Mean predicted and actual OB frequency for shock/safe
                      - Difference between shock and safe (Predicted and Target)
    """
    summary = []

    for mouse_id, df in predictions_dict.items():
        if exclude_mice and mouse_id in exclude_mice:
            continue

        # Drop missing values
        df = df.dropna(subset=["Position", "Predicted Respiratory Frequency", "OB frequency"])

        # Pearson correlation
        try:
            pearson_corr, _ = pearsonr(df["Predicted Respiratory Frequency"], df["OB frequency"])
        except ValueError:
            pearson_corr = np.nan

        # Split into zones
        shock_df = df[df["Position"] < 0.5]
        safe_df = df[df["Position"] >= 0.5]

        # Compute means
        shock_mean_pred = shock_df["Predicted Respiratory Frequency"].mean()
        shock_mean_target = shock_df["OB frequency"].mean()
        safe_mean_pred = safe_df["Predicted Respiratory Frequency"].mean()
        safe_mean_target = safe_df["OB frequency"].mean()

        # Differences
        diff_pred = shock_mean_pred - safe_mean_pred
        diff_target = shock_mean_target - safe_mean_target

        summary.append({
            "Mouse": mouse_id,
            "Pearson Correlation": pearson_corr,
            "Shock Mean Predicted": shock_mean_pred,
            "Shock Mean Target": shock_mean_target,
            "Safe Mean Predicted": safe_mean_pred,
            "Safe Mean Target": safe_mean_target,
            "Predicted Shock-Safe Difference": diff_pred,
            "Target Shock-Safe Difference": diff_target
        })

    return pd.DataFrame(summary)


import matplotlib.pyplot as plt
import itertools
import seaborn as sns
from scipy import stats

def plot_shock_safe_differences(difference_dfs, xtick_labels):
    """
    Plots box plots comparing shock-safe differences (Predicted and Target) across mice.
    Performs paired Wilcoxon signed-rank tests and prints statistical results.

    Parameters:
        difference_dfs (list): List of DataFrames, each containing:
                               - 'Mouse'
                               - 'Predicted Shock-Safe Difference'
                               - 'Target Shock-Safe Difference'
        xtick_labels (list): Labels to use for each dataframe/model (only for predictions).

    Returns:
        pd.DataFrame: DataFrame of Wilcoxon test statistics and significance.
    """
    assert len(difference_dfs) == len(xtick_labels), "Mismatch between dataframes and xtick labels."

    # Separate the predicted values and extract target from the first dataframe (assumes target is the same)
    predicted_combined = pd.concat(
        [df[["Mouse", "Predicted Shock-Safe Difference"]].assign(Model=label)
         for df, label in zip(difference_dfs, xtick_labels)],
        ignore_index=True
    )
    predicted_combined.rename(columns={"Predicted Shock-Safe Difference": "Shock-Safe Difference"}, inplace=True)
    predicted_combined["Type"] = "Predicted"

    target_df = difference_dfs[0][["Mouse", "Target Shock-Safe Difference"]].copy()
    target_df["Model"] = "Target Difference"
    target_df.rename(columns={"Target Shock-Safe Difference": "Shock-Safe Difference"}, inplace=True)
    target_df["Type"] = "Target"

    # Combine
    melted = pd.concat([predicted_combined, target_df], ignore_index=True)

    # Plot
    fig = plt.figure(figsize=(12, 6))
    order = ["Target Difference"] + xtick_labels  # Target first
    sns.boxplot(
        data=melted,
        x="Model",
        y="Shock-Safe Difference",
        order=order,
        width=0.3,
        boxprops={"facecolor": "lightgray"},
        showfliers=False
    )


    # Overlay individual points with jitter
    all_labels = xtick_labels + ["Target Difference"]
    for i, model in enumerate(order):
        model_data = melted[melted["Model"] == model]["Shock-Safe Difference"].values
        x_jittered = np.full(len(model_data), i) + np.random.uniform(-0.05, 0.05, len(model_data))
        plt.scatter(x_jittered, model_data, color="black", alpha=0.7, zorder=2)

    # Wilcoxon tests
    stat_results = []
    for label in xtick_labels:
        df_pred = difference_dfs[xtick_labels.index(label)]
        target_vals = difference_dfs[0]["Target Shock-Safe Difference"].values
        try:
            stat, p_value = stats.wilcoxon(df_pred["Predicted Shock-Safe Difference"].values, target_vals)
        except ValueError:
            stat, p_value = np.nan, np.nan

        if p_value < 0.001:
            significance = "***"
        elif p_value < 0.01:
            significance = "**"
        elif p_value < 0.05:
            significance = "*"
        else:
            significance = ""

        stat_results.append({
            "Comparison": f"{label}: Predicted vs Target",
            "Statistic": stat,
            "p-value": p_value,
            "Significance Level": significance
        })
    
    # Pairwise comparisons between predicted models
    for model1, model2 in itertools.combinations(xtick_labels, 2):
        df1 = difference_dfs[xtick_labels.index(model1)]
        df2 = difference_dfs[xtick_labels.index(model2)]
    
        # Match mouse
        common_mice = set(df1["Mouse"]).intersection(set(df2["Mouse"]))
        data1 = df1[df1["Mouse"].isin(common_mice)]["Predicted Shock-Safe Difference"].values
        data2 = df2[df2["Mouse"].isin(common_mice)]["Predicted Shock-Safe Difference"].values
    
        try:
            stat, p_value = stats.wilcoxon(data1, data2)
        except ValueError:
            stat, p_value = np.nan, np.nan
    
        if p_value < 0.001:
            significance = "***"
        elif p_value < 0.01:
            significance = "**"
        elif p_value < 0.05:
            significance = "*"
        else:
            significance = ""
    
        stat_results.append({
            "Comparison": f"{model1} vs {model2} (Predicted)",
            "Statistic": stat,
            "p-value": p_value,
            "Significance Level": significance
        })
    
    # Compare each to zero
    for label in all_labels:
        data = melted[melted["Model"] == label]["Shock-Safe Difference"].values
        try:
            stat, p_value = stats.wilcoxon(data)
        except ValueError:
            stat, p_value = np.nan, np.nan

        if p_value < 0.001:
            significance = "***"
        elif p_value < 0.01:
            significance = "**"
        elif p_value < 0.05:
            significance = "*"
        else:
            significance = ""

        stat_results.append({
            "Comparison": f"{label} vs Zero",
            "Statistic": stat,
            "p-value": p_value,
            "Significance Level": significance
        })

    plt.xticks(rotation=15, fontsize=12)
    plt.ylabel("Shock - Safe Difference", fontsize=14)
    plt.title("Shock-Safe Mean Differences Across Mice", fontsize=14)
    plt.grid(axis="y", linestyle="--", alpha=0.6)
    plt.tight_layout()
    plt.show()

    return pd.DataFrame(stat_results), fig