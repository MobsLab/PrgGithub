#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 10 16:23:20 2025

@author: gruffalo
"""

def prop_explained_variance(results_df, exclude_mice=None):
    """
    Computes the proportion of explained variance for each omitted predictor in the leave-one-out models.
    
    Formula:
        gain_predictor = (R²_full - R²_leave_one_out) / R²_full

    Parameters:
    - results_df (pd.DataFrame): DataFrame containing R² scores for each mouse and model type.
      The DataFrame must include:
        - 'Mouse': Mouse ID
        - 'Model': Model type ('Full Model' and 'Leave-One-Out')
        - 'Omitted Predictor': Name of the omitted predictor (only for 'Leave-One-Out' models)
        - 'R²': R² score of the model
    - exclude_mice (list, optional): List of mouse IDs to exclude from the analysis. Default is None.

    Returns:
    - pd.DataFrame: A new dataframe containing:
        - 'Mouse': Mouse ID
        - 'Omitted Predictor': The predictor that was left out
        - 'R² Full Model': R² score of the full model
        - 'R² Leave-One-Out': R² score of the leave-one-out model
        - 'Prop Explained Variance': Proportional gain of the predictor
    """
    results_filtered = results_df.copy()

    # Exclude specified mice if provided
    if exclude_mice:
        results_filtered = results_filtered[~results_filtered["Mouse"].isin(exclude_mice)]

    # Extract full model R² scores
    full_model_r2 = results_filtered[results_filtered["Model"] == "Full Model"].set_index("Mouse")["R²"]

    # Extract leave-one-out model R² scores
    leave_one_out_r2 = results_filtered[results_filtered["Model"] == "Leave-One-Out"].copy()

    # Merge with full model R² to compute the explained variance
    leave_one_out_r2["R² Full Model"] = leave_one_out_r2["Mouse"].map(full_model_r2)
    leave_one_out_r2["R² Leave-One-Out"] = leave_one_out_r2["R²"]

    # Compute proportional explained variance 
    leave_one_out_r2["Prop Explained Variance"] = (
        (leave_one_out_r2["R² Full Model"] - leave_one_out_r2["R² Leave-One-Out"]) / leave_one_out_r2["R² Full Model"]
    )

    # Select relevant columns
    explained_variance_df = leave_one_out_r2[
        ["Mouse", "Omitted Predictor", "R² Full Model", "R² Leave-One-Out", "Prop Explained Variance"]
    ]

    return explained_variance_df

def extract_explained_variance_per_predictor(explained_variance_df):
    """
    Extracts the explained variance for each omitted predictor and organizes it into a dictionary.
    Each predictor gets a separate DataFrame, formatted for plotting.

    Parameters:
    - explained_variance_df (pd.DataFrame): DataFrame output from `prop_explained_variance`, containing:
        - 'Mouse': Mouse ID
        - 'Omitted Predictor': The predictor that was left out
        - 'Prop Explained Variance': Proportional gain of the predictor

    Returns:
    - dict: Dictionary where keys are omitted predictors and values are DataFrames containing:
        - 'Mouse': Mouse ID
        - 'Prop Explained Variance': Proportional explained variance for that predictor
    """

    explained_variance_dict = {}

    for predictor in explained_variance_df["Omitted Predictor"].unique():
        predictor_df = explained_variance_df[explained_variance_df["Omitted Predictor"] == predictor].copy()
        predictor_df = predictor_df[["Mouse", "Prop Explained Variance"]]  # Keep only necessary columns
        explained_variance_dict[predictor] = predictor_df

    return explained_variance_dict


def compare_without_learning_term(results_df, exclude_mice=None):
    """
    Computes the difference in explained variance between the full model 
    and the 'Without Learning Term' model.

    Formula:
        gain_without_learning = (R²_full - R²_without_learning) / R²_full

    Parameters:
    - results_df (pd.DataFrame): DataFrame containing R² scores for each mouse and model type.
      The DataFrame must include:
        - 'Mouse': Mouse ID
        - 'Model': Model type ('Full Model' and 'Without Learning Term')
        - 'R²': R² score of the model
    - exclude_mice (list, optional): List of mouse IDs to exclude from the analysis. Default is None.

    Returns:
    - pd.DataFrame: A new dataframe containing:
        - 'Mouse': Mouse ID
        - 'R² Full Model': R² score of the full model
        - 'R² Without Learning Term': R² score of the model without learning term
        - 'Prop Explained Variance': Proportional gain of the learning term
    """
    results_filtered = results_df.copy()

    # Exclude specified mice if provided
    if exclude_mice:
        results_filtered = results_filtered[~results_filtered["Mouse"].isin(exclude_mice)]

    # Extract R² for the Full Model
    full_model_r2 = results_filtered[results_filtered["Model"] == "Full Model"].set_index("Mouse")["R²"]

    # Extract R² for the model without learning term
    without_learning_r2 = results_filtered[results_filtered["Predictor"] == "Without Learning Term"].copy()

    # Merge with full model R² to compute the explained variance
    without_learning_r2["R² Full Model"] = without_learning_r2["Mouse"].map(full_model_r2)
    without_learning_r2["R² Without Learning Term"] = without_learning_r2["R²"]

    # Compute proportional explained variance 
    without_learning_r2["Prop Explained Variance"] = (
        (without_learning_r2["R² Full Model"] - without_learning_r2["R² Without Learning Term"])
        / without_learning_r2["R² Full Model"]
    )

    # Select relevant columns
    explained_variance_df = without_learning_r2[
        ["Mouse", "R² Full Model", "R² Without Learning Term", "Prop Explained Variance"]
    ]

    return explained_variance_df