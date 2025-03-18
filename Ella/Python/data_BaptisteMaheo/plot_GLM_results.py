#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  6 18:12:23 2025

@author: gruffalo
"""

import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import pandas as pd


def plot_full_model_r2(results_df, exclude_mice=None, color_excluded=True, ylim=(-0.5, 0.8)):
    """
    Plots a box plot of the R² scores obtained by the Full Model.
    Includes error bars for SEM and overlays individual data points.
    Excluded mice can optionally be shown in light red.

    Parameters:
    - results_df (pd.DataFrame): DataFrame containing model results with columns:
        - 'Mouse': Mouse ID
        - 'Model': Model type ('Full Model')
        - 'R²': R² score of the full model
    - exclude_mice (list, optional): List of mouse IDs to exclude from the main analysis.
                                      Their points will still be plotted but optionally colored differently.
    - color_excluded (bool, optional): Whether to color excluded mice differently (default: True).
    - ylim (tuple, optional): Limits for the y-axis. Default is (-0.5, 0.8).

    Returns:
    - None (Displays the plot)
    """
    # Filter for full model R² scores
    full_model_df = results_df[results_df["Model"] == "Full Model"].copy()

    # Compute mean and SEM using only the included mice
    full_model_df[~full_model_df["Mouse"].isin(exclude_mice)] if exclude_mice else full_model_df

    # Create figure
    fig = plt.figure(figsize=(6, 6))

    # Boxplot
    sns.boxplot(data=full_model_df, y="R²", color="lightgray", width=0.1, showfliers=False)

    # Generate jitter for each individual point
    jitter = np.random.uniform(-0.1, 0.1, size=len(full_model_df))

    # Plot individual points
    for i, (index, row) in enumerate(full_model_df.iterrows()):
        mouse = row["Mouse"]
        y_value = row["R²"]
        x_pos = jitter[i]  # Add slight jitter to x position

        # Define color based on exclusion
        if exclude_mice and mouse in exclude_mice and color_excluded:
            color = "lightcoral"  # Different color for excluded mice
        else:
            color = "black"  # Standard color for all other mice

        plt.scatter(x_pos, y_value, color=color, alpha=0.8, zorder=2)

    # Customize plot
    plt.xticks([])  # Remove x-axis ticks since we only have one category
    plt.xlim((-0.5,0.5))
    plt.ylim(ylim)
    plt.ylabel("R² Score", fontsize=14)
    plt.title("R² of the Full Model", fontsize=14)
    plt.grid(axis="y", linestyle="--", alpha=0.6)

    plt.show()
    
    return fig



# def plot_full_model_r2(results_df, exclude_mice=None, color_excluded=True, ylim=(-0.5, 0.8)):
#     """
#     Plots a bar plot of the R² scores obtained by the Full Model.
#     Includes error bars for SEM and overlays individual data points.
#     Excluded mice can optionally be shown in light red.

#     Parameters:
#     - results_df (pd.DataFrame): DataFrame containing model results with columns:
#         - 'Mouse': Mouse ID
#         - 'Model': Model type ('Full Model')
#         - 'R²': R² score of the full model
#     - exclude_mice (list, optional): List of mouse IDs to exclude from the main analysis.
#                                       Their points will still be plotted but optionally colored differently.
#     - color_excluded (bool, optional): Whether to color excluded mice differently (default: True).
#     - ylim (tuple, optional): Limits for the y-axis. Default is (-0.5, 0.8).

#     Returns:
#     - None (Displays the plot)
#     """
#     # Filter for full model R² scores
#     full_model_df = results_df[results_df["Model"] == "Full Model"].copy()

#     # Compute mean and SEM using only the included mice
#     included_df = full_model_df[~full_model_df["Mouse"].isin(exclude_mice)] if exclude_mice else full_model_df
#     mean_r2 = included_df["R²"].mean()
#     sem_r2 = included_df["R²"].sem()

#     # Extract mice for plotting
#     mice = full_model_df["Mouse"].unique()
    
#     # Create figure
#     plt.figure(figsize=(6, 6))

#     # Plot bar for mean value
#     plt.bar(["Full Model"], [mean_r2], yerr=[sem_r2], capsize=5, 
#             color="lightgray", alpha=0.8, label="Mean ± SEM")

#     # Add jitter to avoid overlapping points
#     jitter = np.random.uniform(-0.05, 0.05, size=len(mice))

#     # Plot individual points
#     for i, mouse in enumerate(mice):
#         y_value = full_model_df[full_model_df["Mouse"] == mouse]["R²"].values[0]
#         if exclude_mice and mouse in exclude_mice and color_excluded:
#             color = "lightcoral"  # Different color for excluded mice
#         else:
#             color = "black"  # Standard color for all other mice
#         plt.scatter(0 + jitter[i], y_value, color=color, alpha=0.8)

#     # Customize plot
#     plt.xticks(fontsize=12)
#     plt.ylim(ylim)
#     plt.ylabel("R² Score", fontsize=14)
#     plt.title("R² of the Full Model", fontsize=14)
#     plt.grid(axis="y", linestyle="--", alpha=0.6)

#     plt.show()


def plot_full_vs_all_predictors_boxplot(r2_results_df):
    """
    Plots the R² scores of the Full Model vs. All Predictors Model for all mice using boxplots.

    Parameters:
    - r2_results_df (pd.DataFrame): DataFrame containing R² scores from `fit_models_for_all_mice`.

    Returns:
    - None (displays the plot).
    """
    # Filter only the Full Model and All Predictors Model results
    filtered_df = r2_results_df[
        r2_results_df["Model"].isin(["Full Model", "All Predictors Model"])
    ]

    # Pivot the data to have one row per mouse with columns for both models
    pivot_df = filtered_df.pivot(index="Mouse", columns="Model", values="R²")

    # Extract values
    full_model_r2 = pivot_df["Full Model"]
    all_predictors_r2 = pivot_df["All Predictors Model"]

    # Compute means and standard deviations
    mean_full = np.mean(full_model_r2)
    mean_all = np.mean(all_predictors_r2)
    std_full = np.std(full_model_r2, ddof=1)  # Sample standard deviation
    std_all = np.std(all_predictors_r2, ddof=1)

    # Create figure
    plt.figure(figsize=(8, 6))

    # Boxplot
    plt.boxplot([full_model_r2, all_predictors_r2], positions=[1, 2], widths=0.5, showfliers=False)

    # Scatter points for individual mice
    for i, (mouse, row) in enumerate(pivot_df.iterrows()):
        plt.scatter([1, 2], [row["Full Model"], row["All Predictors Model"]], color="brown", alpha=0.7)
        plt.plot([1, 2], [row["Full Model"], row["All Predictors Model"]], color="black", alpha=0.5, linestyle="dashed")

    # Error bars (standard deviation)
    plt.errorbar([1, 2], [mean_full, mean_all], yerr=[std_full, std_all], fmt='o', color="black", capsize=5, label="Mean ± STD")

    # Labels and title
    plt.xticks([1, 2], ["Full Model", "All Predictors Model"])
    plt.ylim((-0.5,0.8))
    plt.ylabel("R² Score")
    plt.title("Comparison of Full Model vs. All Predictors Model R²")
    plt.legend()
    plt.grid(True)

    plt.show()
    
    
def plot_r2_single_predictor_models(results, excluded_mice=None):
    """
    Plots R² values for each single predictor model using box plots, 
    displaying individual mouse values with error bars.

    Parameters:
        results (pd.DataFrame): DataFrame containing model fitting results with columns:
            - 'Mouse': Mouse ID
            - 'Model': Model type (should be "Single Predictor")
            - 'R²': R² score
            - 'Predictor': Name of the predictor used in the model
        exclude_mice (list, optional): List of mouse IDs to exclude from the plot.

    Returns:
        None (Displays the plot)
    """
    # Filter results to keep only Single Predictor models
    single_predictor_results = results[results["Model"] == "Single Predictor"].copy()

    # Exclude specified mice
    if excluded_mice:
        single_predictor_results = single_predictor_results[~single_predictor_results["Mouse"].isin(excluded_mice)]
        print("Excluded mice:", ", ".join(excluded_mice))

    # Extract unique predictors
    predictors = single_predictor_results["Predictor"].unique()

    # Create the figure
    plt.figure(figsize=(10, 6))

    # Boxplot for R² scores by predictor
    sns.boxplot(data=single_predictor_results, x="Predictor", y="R²", width=0.6,
                showfliers=False, whis=False, boxprops=dict(facecolor="lightgray"))

    # Compute means and standard deviations
    means = single_predictor_results.groupby("Predictor")["R²"].mean()
    stds = single_predictor_results.groupby("Predictor")["R²"].std()

    # Overlay individual points and connect mouse data points
    for mouse in single_predictor_results["Mouse"].unique():
        mouse_data = single_predictor_results[single_predictor_results["Mouse"] == mouse]
        x_positions = [np.where(predictors == predictor)[0][0] for predictor in mouse_data["Predictor"]]
        
        # Scatter plot for individual mouse data points
        plt.scatter(x_positions, mouse_data["R²"], color="brown", alpha=0.7, zorder=3)

        # Connect the same mouse's data points across predictors
        if len(mouse_data) > 1:
            plt.plot(x_positions, mouse_data["R²"], color="gray", alpha=0.5)

    # Error bars (Mean ± STD)
    x_positions = np.arange(len(predictors))
    plt.errorbar(x_positions, means, yerr=stds, fmt='o', color='black', label="Mean ± STD")

    # Labels and title
    plt.xticks(x_positions, predictors, rotation=15)
    plt.ylabel("R² Score")
    plt.title("R² Scores for Single Predictor Models")
    plt.grid(axis="y", linestyle="--", alpha=0.6)
    plt.legend()
    
    plt.show()


def plot_r2_leave_one_out_models(results, excluded_mice=None):
    """
    Plots the R² values for leave-one-out models, grouped by omitted predictor.
    Each omitted predictor gets its own box plot, with individual points and error bars.

    Parameters:
    - results (pd.DataFrame): DataFrame containing R² values from the leave-one-out models.
    - excluded_mice (list, optional): List of mice to exclude from the plot.

    Returns:
    - None (displays the plot).
    """
    # Filter for leave-one-out models
    loo_results = results[results["Model"] == "Leave-One-Out"].copy()

    # Exclude specified mice if any
    if excluded_mice:
        loo_results = loo_results[~loo_results["Mouse"].isin(excluded_mice)]
        print("Excluded mice:", ", ".join(excluded_mice))

    # Extract unique omitted predictors
    omitted_predictors = loo_results["Omitted Predictor"].unique()

    # Create the figure
    plt.figure(figsize=(10, 6))

    # Boxplot for R² scores by omitted predictor
    sns.boxplot(data=loo_results, x="Omitted Predictor", y="R²", width=0.6, 
                showfliers=False, whis=False, boxprops=dict(facecolor="lightgray"))

    # Compute means and standard deviations
    means = loo_results.groupby("Omitted Predictor")["R²"].mean()
    stds = loo_results.groupby("Omitted Predictor")["R²"].std()

    # Overlay individual points and connect mouse data points
    for mouse in loo_results["Mouse"].unique():
        mouse_data = loo_results[loo_results["Mouse"] == mouse]
        x_positions = [np.where(omitted_predictors == predictor)[0][0] for predictor in mouse_data["Omitted Predictor"]]
        
        # Scatter plot for individual mouse data points
        plt.scatter(x_positions, mouse_data["R²"], color="brown", alpha=0.7, zorder=3)

        # Connect the same mouse's data points across omitted predictors
        if len(mouse_data) > 1:
            plt.plot(x_positions, mouse_data["R²"], color="gray", alpha=0.5)

    # Error bars (Mean ± STD)
    x_positions = np.arange(len(omitted_predictors))
    plt.errorbar(x_positions, means, yerr=stds, fmt='o', color='black', label="Mean ± STD")

    # Labels and title
    plt.xticks(x_positions, omitted_predictors, rotation=15)
    plt.ylabel("R² Score")
    plt.title("R² Scores for Leave-One-Out Models")
    plt.grid(axis="y", linestyle="--", alpha=0.6)
    plt.legend()
    
    plt.show()
    
import random
import matplotlib.colors as mcolors

def plot_model_parameters(parameters_dict, name=None):
    """
    Plots scatter points of model parameters for each mouse.
    Each mouse's parameters are connected with a line.

    Parameters:
        parameters_dict (dict): Dictionary where keys are mouse IDs and values are dictionaries of model parameters.
                                Expected format:
                                {
                                    "Mouse_1": {"slope": value, "op_point": value, "tau": value},
                                    "Mouse_2": {"slope": value, "op_point": value, "tau": value},
                                    ...
                                }
        name (list, optional): List of parameter names to plot (e.g., ["slope", "tau"]).
                               If None, all parameters are plotted.

    Returns:
        dict: Mapping of colors to mouse names for the legend.
    """
    # Clean parameter names (remove potential "feature_transform__" prefix)
    cleaned_parameters_dict = {
        mouse: {key.replace("feature_transform__", ""): val for key, val in params.items()}
        for mouse, params in parameters_dict.items()
    }

    # Convert dictionary to DataFrame
    param_df = pd.DataFrame.from_dict(cleaned_parameters_dict, orient="index")

    # Convert to long format
    param_df = param_df.reset_index().melt(id_vars=["index"], var_name="Parameter", value_name="Value")
    param_df.rename(columns={"index": "Mouse"}, inplace=True)

    # Extract unique mice and parameters
    mice = param_df["Mouse"].unique()
    all_parameters = ["slope", "op_point", "tau"]

    # Determine which parameters to plot
    parameters = name if name else all_parameters

    # Filter dataframe to keep only selected parameters
    param_df = param_df[param_df["Parameter"].isin(parameters)]

    # Generate distinct colors
    available_colors = list(mcolors.TABLEAU_COLORS.values())  # Predefined distinct colors
    random.shuffle(available_colors)  # Shuffle to assign colors randomly

    mouse_colors = {mouse: available_colors[i % len(available_colors)] for i, mouse in enumerate(mice)}

    # Create scatter plot with lines
    plt.figure(figsize=(8, 10))
    mouse_legend = {}

    for i, mouse in enumerate(mice):
        mouse_data = param_df[param_df["Mouse"] == mouse]
        
        # Ensure correct order of parameters before plotting
        mouse_data = mouse_data.set_index("Parameter").reindex(parameters).reset_index()

        # Jitter x positions to avoid overlap
        x_positions = np.arange(len(parameters)) + np.random.uniform(-0.01, 0.01, size=len(parameters))

        # Assign color
        color = mouse_colors[mouse]
        plt.scatter(x_positions, mouse_data["Value"], color=color, alpha=0.8, label=mouse)
        plt.plot(x_positions, mouse_data["Value"], color=color, linestyle="dashed", alpha=0.6)

        # Store mouse color for legend
        mouse_legend[mouse] = color

    # Configure x-axis ticks
    plt.xticks(np.arange(len(parameters)), parameters, rotation=15, fontsize=12)
    plt.xlabel("Parameter", fontsize=14)
    plt.ylabel("Value", fontsize=14)

    # Add legend outside the plot
    handles = [plt.Line2D([0], [0], color=color, marker="o", linestyle="", label=mouse) for mouse, color in mouse_legend.items()]
    plt.legend(handles=handles, title="Mice", bbox_to_anchor=(1.05, 1), loc="upper left")

    plt.title("Model Parameters Across Mice", fontsize=14)
    plt.grid(True, linestyle="--", alpha=0.6)
    
    plt.show()



def plot_explained_variance(explained_variance_df, connect_mice=True):
    """
    Plots a bar plot of the proportional explained variance for different omitted predictors.
    Includes error bars for SEM and overlays individual data points with optional lines connecting points from the same mouse.

    Parameters:
    - explained_variance_df (pd.DataFrame): DataFrame containing:
        - 'Mouse': Mouse ID
        - 'Omitted Predictor': Predictor that was left out
        - 'Prop Explained Variance': Computed gain in explained variance
    - connect_mice (bool, optional): Whether to connect data points from the same mouse with a line (default: True).

    Returns:
    - None (Displays the plot)
    """
    # Compute mean and SEM for each predictor
    mean_variance = explained_variance_df.groupby("Omitted Predictor")["Prop Explained Variance"].mean()
    sem_variance = explained_variance_df.groupby("Omitted Predictor")["Prop Explained Variance"].sem()

    # Extract unique predictors and mice
    predictors = mean_variance.index
    mice = explained_variance_df["Mouse"].unique()

    # Assign colors
    num_mice = len(mice)
    if connect_mice:
        colors = plt.cm.get_cmap("tab10", num_mice)  # Different colors per mouse
    else:
        colors = "black"  # Uniform color for all points

    # Create figure
    plt.figure(figsize=(10, 6))

    # Plot bars for mean values
    x_positions = np.arange(len(predictors))
    plt.bar(x_positions, mean_variance, yerr=sem_variance, capsize=5, color="lightgray", alpha=0.8, label="Mean ± SEM")

    # Overlay individual points and connect same-mouse values
    for i, mouse in enumerate(mice):
        mouse_data = explained_variance_df[explained_variance_df["Mouse"] == mouse]
        x_mouse = np.array([np.where(predictors == predictor)[0][0] for predictor in mouse_data["Omitted Predictor"]])
        y_mouse = mouse_data["Prop Explained Variance"].values

        # Add jitter to x-axis positions
        jitter = np.random.uniform(-0.05, 0.05, size=len(x_mouse))
        x_mouse_jittered = x_mouse + jitter  # Add small random offset

        # Plot points
        plt.scatter(x_mouse_jittered, y_mouse, color=colors(i) if connect_mice else "black", alpha=0.8)

        # Connect points only if connect_mice is True
        if connect_mice and len(x_mouse) > 1:
            plt.plot(x_mouse_jittered, y_mouse, color=colors(i), linestyle="dashed", alpha=0.6)

    # Customize x-axis
    plt.xticks(x_positions, predictors, rotation=15, fontsize=12)
    plt.xlabel("Omitted Predictor", fontsize=14)
    plt.ylabel("Proportional Explained Variance", fontsize=14)
    plt.title("Explained Variance by Omitted Predictor", fontsize=14)

    # Show legend only if connect_mice is True
    if connect_mice:
        handles = [plt.Line2D([0], [0], color=colors(i), marker="o", linestyle="", label=mouse) for i, mouse in enumerate(mice)]
        plt.legend(handles=handles, title="Mice", bbox_to_anchor=(1.05, 1), loc="upper left")

    plt.grid(axis="y", linestyle="--", alpha=0.6)
    plt.show()
    

def plot_learning_gain(explained_variance_df):
    """
    Plots a bar plot of the proportional explained variance for the 'Without Learning Term' model.
    Includes error bars for SEM and overlays individual data points (no connection between mice).

    Parameters:
    - explained_variance_df (pd.DataFrame): DataFrame containing:
        - 'Mouse': Mouse ID
        - 'Prop Explained Variance': Computed gain in explained variance
        - 'R² Full Model': R² score of the full model
        - 'R² Without Learning Term': R² score of the model without learning term

    Returns:
    - None (Displays the plot)
    """
    # Compute mean and SEM
    mean_variance = explained_variance_df["Prop Explained Variance"].mean()
    sem_variance = explained_variance_df["Prop Explained Variance"].sem()

    # Extract mice for plotting
    mice = explained_variance_df["Mouse"].unique()

    # Create figure
    plt.figure(figsize=(6, 6))

    # Plot bar for mean value
    plt.bar(["Without Learning Term"], [mean_variance], yerr=[sem_variance], capsize=5, 
            color="lightgray", alpha=0.8, label="Mean ± SEM")

    # Add jitter to avoid overlapping points
    jitter = np.random.uniform(-0.05, 0.05, size=len(mice))

    # Plot individual points
    for i, mouse in enumerate(mice):
        y_value = explained_variance_df[explained_variance_df["Mouse"] == mouse]["Prop Explained Variance"].values[0]
        plt.scatter(0 + jitter[i], y_value, color="black", alpha=0.8)  # Uniform color

    # Customize plot
    plt.xticks(fontsize=12)
    plt.ylabel("Proportional Explained Variance", fontsize=14)
    plt.title("Explained Variance by Learning Term", fontsize=14)
    plt.grid(axis="y", linestyle="--", alpha=0.6)

    plt.show()



import scipy.stats as stats
import itertools


def plot_all_explained_variance(explained_variance_dfs):
    """
    Plots multiple box plots comparing different explained variance models.
    Performs paired Wilcoxon signed-rank tests between all model comparisons 
    and prints statistical results with significance levels.
    Additionally, performs Wilcoxon tests to compare each model's median against zero.

    Parameters:
    - explained_variance_dfs (dict): Dictionary where keys are model names, and values are DataFrames
                                     with 'Mouse' and 'Prop Explained Variance' columns.

    Returns:
    - pd.DataFrame: Wilcoxon test statistics with p-values and significance levels.
    """

    models = list(explained_variance_dfs.keys())

    # Combine data from all models into a single DataFrame
    combined_df = pd.concat(
        [df.assign(Model=model) for model, df in explained_variance_dfs.items()], ignore_index=True
    )

    # Create figure
    fig = plt.figure(figsize=(12, 6))

    # Boxplot without outliers
    sns.boxplot(
        data=combined_df,
        x="Model",
        y="Prop Explained Variance",
        width=0.2,
        boxprops={"facecolor": "lightgray"},  # Box color
        # flierprops={"marker": "o", "color": "black", "markersize": 5, "alpha": 0.8},  # Explicitly set outlier color
        showfliers=False  # Do not plot outliers
    )

    # Overlay individual points with jitter
    for i, model in enumerate(models):
        model_data = combined_df[combined_df["Model"] == model]
        x_jittered = np.full(len(model_data), i) + np.random.uniform(-0.05, 0.05, len(model_data))
        plt.scatter(x_jittered, model_data["Prop Explained Variance"], color="black", alpha=0.8, zorder=2)

    # Perform Wilcoxon signed-rank tests for model comparisons
    stat_results = []
    comparisons = list(itertools.combinations(models, 2))  # All possible model pairs
    
    for model1, model2 in comparisons:
        df1 = explained_variance_dfs[model1]
        df2 = explained_variance_dfs[model2]

        # Find common mice
        common_mice = set(df1["Mouse"]).intersection(set(df2["Mouse"]))
        data1 = df1[df1["Mouse"].isin(common_mice)]["Prop Explained Variance"].values
        data2 = df2[df2["Mouse"].isin(common_mice)]["Prop Explained Variance"].values

        if len(data1) != len(data2):
            print(f"Skipping comparison {model1} vs {model2} due to mismatched sample sizes.")
            continue

        # Wilcoxon test
        stat, p_value = stats.wilcoxon(data1, data2)

        # Determine significance level
        if p_value < 0.001:
            significance = "***"
        elif p_value < 0.01:
            significance = "**"
        elif p_value < 0.05:
            significance = "*"
        else:
            significance = ""

        # Store results
        stat_results.append({
            "Comparison": f"{model1} vs {model2}",
            "Statistic": stat,
            "p-value": p_value,
            "Significance Level": significance
        })
    
    # Perform Wilcoxon signed-rank tests for each model vs zero
    for model in models:
        data = combined_df[combined_df["Model"] == model]["Prop Explained Variance"].values
        stat, p_value = stats.wilcoxon(data)

        # Determine significance level
        if p_value < 0.001:
            significance = "***"
        elif p_value < 0.01:
            significance = "**"
        elif p_value < 0.05:
            significance = "*"
        else:
            significance = ""
                
        stat_results.append({
            "Comparison": f"{model} vs Zero",
            "Statistic": stat,
            "p-value": p_value,
            "Significance Level": significance
        })

    # Labels and title
    plt.xticks(range(len(models)), models, rotation=15, fontsize=12)
    plt.ylabel("GLM Gain", fontsize=14)
    plt.title("Explained Variance Across Models", fontsize=14)
    plt.grid(axis="y", linestyle="--", alpha=0.6)

    plt.show()

    return pd.DataFrame(stat_results), fig



# def plot_all_explained_variance(explained_variance_dfs):
#     """
#     Plots multiple box plots comparing different explained variance models.
#     Performs paired Wilcoxon signed-rank tests between all model comparisons 
#     and prints statistical results with significance levels.

#     Parameters:
#     - explained_variance_dfs (dict): Dictionary where keys are model names, and values are DataFrames
#                                      with 'Mouse' and 'Prop Explained Variance' columns.

#     Returns:
#     - pd.DataFrame: Wilcoxon test statistics with p-values and significance levels.
#     """

#     models = list(explained_variance_dfs.keys())

#     # Combine data from all models into a single DataFrame
#     combined_df = pd.concat(
#         [df.assign(Model=model) for model, df in explained_variance_dfs.items()], ignore_index=True
#     )

#     # Create figure
#     fig = plt.figure(figsize=(12, 6))

#     # Boxplot
#     sns.boxplot(
#         data=combined_df,
#         x="Model",
#         y="Prop Explained Variance",
#         width=0.2,
#         boxprops={"facecolor": "lightgray"},  # Box color
#         showfliers=False  # Do not plot outliers
#     )

#     # Overlay individual points with jitter
#     for i, model in enumerate(models):
#         model_data = combined_df[combined_df["Model"] == model]
#         x_jittered = np.full(len(model_data), i) + np.random.uniform(-0.05, 0.05, len(model_data))
#         plt.scatter(x_jittered, model_data["Prop Explained Variance"], color="black", alpha=0.8, zorder=2)

#     # Perform Wilcoxon signed-rank tests and store results
#     stat_results = []
#     comparisons = list(itertools.combinations(models, 2))  # All possible model pairs
    
#     for model1, model2 in comparisons:
#         df1 = explained_variance_dfs[model1]
#         df2 = explained_variance_dfs[model2]

#         # Find common mice
#         common_mice = set(df1["Mouse"]).intersection(set(df2["Mouse"]))
#         data1 = df1[df1["Mouse"].isin(common_mice)]["Prop Explained Variance"].values
#         data2 = df2[df2["Mouse"].isin(common_mice)]["Prop Explained Variance"].values

#         if len(data1) != len(data2):
#             print(f"Skipping comparison {model1} vs {model2} due to mismatched sample sizes.")
#             continue

#         # Wilcoxon test
#         stat, p_value = stats.wilcoxon(data1, data2)

#         # Determine significance level
#         if p_value < 0.001:
#             significance = "***"
#         elif p_value < 0.01:
#             significance = "**"
#         elif p_value < 0.05:
#             significance = "*"
#         else:
#             significance = ""

#         # Store results
#         stat_results.append({
#             "Comparison": f"{model1} vs {model2}",
#             "Statistic": stat,
#             "p-value": p_value,
#             "Significance Level": significance
#         })

#     # Labels and title
#     plt.xticks(range(len(models)), models, rotation=15, fontsize=12)
#     plt.ylabel("GLM Gain", fontsize=14)
#     plt.title("Explained Variance Across Models", fontsize=14)
#     plt.grid(axis="y", linestyle="--", alpha=0.6)

#     plt.show()

#     return pd.DataFrame(stat_results), fig


import os

def save_plot_as_svg(fig, filename, save_dir, dpi=300):
    """
    Saves a specified matplotlib figure as an SVG file in a given directory.

    Parameters:
    - fig (matplotlib.figure.Figure): The figure object to save.
    - filename (str): Name of the file (without extension).
    - save_dir (str): Path to the directory where the plot should be saved.
    - dpi (int, optional): Resolution of the saved figure (default: 300).

    Returns:
    - None (Saves the figure as an SVG file).
    """
    # Ensure the directory exists
    os.makedirs(save_dir, exist_ok=True)

    # Construct the full file path
    file_path = os.path.join(save_dir, f"{filename}.svg")

    # Save the specified figure
    fig.savefig(file_path, format="svg", dpi=dpi, bbox_inches="tight")

    print(f"Plot saved: {file_path}")
