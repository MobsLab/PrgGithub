#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 19 19:00:02 2025

@author: gruffalo
"""

import matplotlib.pyplot as plt
from make_pretty_plot import make_pretty_plot
import numpy as np

def plot_variable_over_time(
    datasets,
    mouse_id,
    variable,
    dates=None,
    experiment_keys=None,
    smooth=False,
    smooth_window=100,
    ylim=None
):
    """
    Plots a variable over time across different sessions and experiments for a given mouse.

    INPUTS:
        datasets (dict): Dictionary of experiment configurations. Each config must include:
                         - "data": nested dict {mouse_id -> {YYYYMMDD -> {variable -> Tsd}}}
                         - "color": plot color
                         - "legend": experiment name shown in legend
        mouse_id (int): Mouse number to plot (e.g., 1690)
        variable (str): Name of the variable to plot (e.g., 'Heartrate')
        dates (list of str, optional): List of dates to include (YYMMDD format). If None, all dates are used.
        experiment_keys (list of str, optional): Subset of keys from datasets to include. If None, all keys are used.
        smooth (bool): Whether to apply a moving average filter
        smooth_window (int): Window size for smoothing
        ylim (tuple, optional): y-axis limits for the plot

    OUTPUT:
        A matplotlib time series plot showing the variable across sessions.
    """
    if isinstance(dates, str):
        dates = [dates]
    full_dates = [f"20{d}" for d in dates] if dates else None

    if experiment_keys is None:
        experiment_keys = list(datasets.keys())

    fig, ax = plt.subplots(figsize=(10, 5))
    plotted_any = False

    for key in experiment_keys:
        cfg = datasets[key]
        data = cfg["data"]
        color = cfg["color"]
        legend = cfg.get("legend", key)

        if mouse_id not in data:
            continue

        for session_date in data[mouse_id]:
            if session_date == "experiment":
                continue
            if full_dates is not None and session_date not in full_dates:
                continue
            if variable not in data[mouse_id][session_date]:
                continue

            tsd_data = data[mouse_id][session_date][variable]
            time = tsd_data.t
            values = tsd_data.data()

            if smooth:
                values = apply_smoothing(values, smooth_window)

            label = f"{legend} ({session_date[2:]})"
            ax.plot(time, values, color=color, linewidth=2, label=label)
            plotted_any = True

    if not plotted_any:
        print(f"No data available for Mouse {mouse_id} and variable '{variable}'")
        return

    ax.set_title(f"{variable} over Time (Mouse {mouse_id})", fontsize=16, fontweight="bold")
    ax.set_xlabel("Time (s)", fontsize=14)
    ax.set_ylabel(variable, fontsize=14)
    if ylim:
        ax.set_ylim(ylim)
    ax.legend(fontsize=10, frameon=False)
    make_pretty_plot(ax)
    plt.tight_layout()
    plt.show()

def apply_smoothing(signal, window_size):
    kernel = np.ones(window_size) / window_size
    smoothed = np.convolve(signal, kernel, mode='same')
    half_window = window_size // 2
    smoothed[:half_window] = np.nan
    smoothed[-half_window:] = np.nan
    return smoothed

def plot_multiple_variables_over_time(
    datasets,
    mouse_id,
    variables,
    date,
    experiment_keys=None,
    smooth=True,
    smooth_window_dict=None,
):
    """
    Plots multiple variables over time for a given date and mouse across different datasets.

    INPUTS:
        datasets (dict): Dictionary of experiment configurations. Each config must include:
                         - "data": nested dict {mouse_id -> {YYYYMMDD -> {variable -> Tsd}}}
                         - "color": used for plotting
                         - "legend": label used in the plot
        mouse_id (int): Mouse number (e.g., 1690)
        variables (list): List of variable names to plot (e.g., ['Heartrate', 'OBGamma'])
        date (str): Date to plot in 'YYMMDD' format
        experiment_keys (list of str, optional): Subset of experiments to include
        smooth (bool): Whether to apply moving average smoothing
        smooth_window_dict (dict, optional): Dict specifying smoothing window per variable

    OUTPUT:
        A multi-panel time series plot of the variables for the specified session.
    """
    full_date = f"20{date}"
    n_vars = len(variables)
    fig, axs = plt.subplots(n_vars, 1, figsize=(12, 4 * n_vars), sharex=True)

    if experiment_keys is None:
        experiment_keys = list(datasets.keys())
    if n_vars == 1:
        axs = [axs]

    # Define consistent colors for variables
    default_colors = ['#EF9651', '#B82132', '#3D8D7A']
    variable_colors = {var: default_colors[i % len(default_colors)] for i, var in enumerate(variables)}

    for i, variable in enumerate(variables):
        ax = axs[i]
        for key in experiment_keys:
            cfg = datasets[key]
            data = cfg["data"]
            legend = cfg.get("legend", key)

            if mouse_id not in data or full_date not in data[mouse_id]:
                continue
            if variable not in data[mouse_id][full_date]:
                continue

            tsd_data = data[mouse_id][full_date][variable]
            time = tsd_data.t
            values = tsd_data.data()

            if smooth and smooth_window_dict and variable in smooth_window_dict:
                values = apply_smoothing(values, smooth_window_dict[variable])

            ax.plot(time, values, label=legend, color=variable_colors[variable], linewidth=2)

        ax.set_ylabel(variable, fontsize=12, fontweight="bold")
        ax.set_title(f"{variable} (Mouse {mouse_id}, {date})", fontsize=14)
        make_pretty_plot(ax)

    axs[-1].set_xlabel("Time (s)", fontsize=12, fontweight="bold")
    axs[0].legend(loc="upper right", fontsize=10, frameon=False)
    plt.tight_layout()
    plt.show()


import pandas as pd
import seaborn as sns
from matplotlib.patches import Patch

def plot_variable_distribution(
    datasets,
    mouse_id,
    variable,
    experiment_keys=None,
    dates=None,
    ylim=None,
    log_scale=False
):
    """
    Plots a violin plot to visualize the distribution of a variable across datasets.

    INPUTS:
        datasets (dict): Dictionary of experiment configs. Each config must include:
                         - "data": nested dict of {mouse_id -> {date -> {variable -> Tsd}}}
                         - "color": hex or RGB color
                         - "legend": string label to show in legend
        mouse_id (int): Mouse number to plot (e.g., 1690)
        variable (str): Name of the variable (e.g., 'Heartrate')
        experiment_keys (list of str, optional): Experiments to include from datasets.
        dates (list of str, optional): Subset of dates (in YYMMDD format) to plot.
        ylim (tuple, optional): Custom y-axis limits.
        log_scale (bool): Use log scale for y-axis.
    """

    if experiment_keys is None:
        experiment_keys = list(datasets.keys())
    selected_datasets = {k: datasets[k] for k in experiment_keys}

    all_data = []
    all_xlabels = []
    all_legends = []
    all_colors = []

    full_dates = [f"20{d}" for d in dates] if dates else None

    for key, cfg in selected_datasets.items():
        data = cfg["data"]
        color = cfg["color"]
        legend = cfg.get("legend", key)

        if mouse_id not in data:
            continue

        for date, session_data in data[mouse_id].items():
            if date == "experiment":
                continue
            short_date = date[2:]

            if full_dates is not None and date not in full_dates:
                continue

            if variable in session_data:
                values = session_data[variable].data()
                session_label = f"{short_date}_{legend}"
                all_data.extend(values)
                all_xlabels.extend([session_label] * len(values))
                all_legends.extend([legend] * len(values))
                all_colors.extend([color] * len(values))

    if not all_data:
        print(f"Error: No data available for Mouse {mouse_id} and variable '{variable}'.")
        return

    df = pd.DataFrame({
        "value": all_data,
        "session": all_xlabels,
        "experiment": all_legends,
        "color": all_colors
    })

    unique_sessions = list(dict.fromkeys(df["session"]))  # preserve order
    palette = {s: df[df["session"] == s]["color"].iloc[0] for s in unique_sessions}

    fig_width = max(4, 0.9* len(unique_sessions))
    fig, ax = plt.subplots(figsize=(fig_width, 6))

    sns.violinplot(
        data=df,
        x="session",
        y="value",
        hue="session",
        palette=palette,
        inner="box",
        dodge=False,
        ax=ax,
        legend=False
    )

    ax.set_xlabel("Session Date", fontsize=14, fontweight="bold")
    ax.set_ylabel(variable, fontsize=14, fontweight="bold")
    # ax.set_title(f"Distribution of {variable} (Mouse {mouse_id})", fontsize=16, fontweight="bold")
    ax.set_title(f"(Mouse {mouse_id})", fontsize=16, fontweight="bold")

    # Clean x-axis labels to only show the short date (before "_")
    ax.set_xticks(range(len(unique_sessions)))
    ax.set_xticklabels([s.split("_")[0] for s in unique_sessions], rotation=45)

    if log_scale:
        ax.set_yscale("log")

    default_ylim = {"Heartrate": (1.5, 14), "BreathFreq": (0, 9), "OBGamma": (100, 900)}
    if ylim:
        ax.set_ylim(ylim)
    elif variable in default_ylim:
        ax.set_ylim(default_ylim[variable])

    # Legend: one entry per experiment
    handles = []
    for exp in sorted(set(df["experiment"])):
        color = df[df["experiment"] == exp]["color"].iloc[0]
        handles.append(Patch(facecolor=color, label=exp))
    ax.legend(handles=handles, loc='best', fontsize=10, frameon=False)

    make_pretty_plot(ax)
    plt.tight_layout()
    plt.show()
    
# plot_variable_distribution(datasets, 1690, 'Heartrate', 
#                            dates=['250227', '250305'],
#                            experiment_keys=["HabHeadFixed", 
#                                             "Injection_Ivabradine_20mgkg"])


def plot_variable_joyplot(
    datasets,
    mouse_id,
    variable,
    experiment_keys=None,
    dates=None,
    ylim=None,
    log_scale=False
):
    """
    Plots a joyplot to visualize the distribution of a variable across experiments.
    
    INPUTS:
        datasets (dict): Dictionary of dataset configurations. Each must have:
                         - "data": nested dict of {mouse_id -> {date -> {variable -> Tsd}}}
                         - "color": hex color
                         - "legend": label name
        mouse_id (int): Mouse number (e.g., 1690)
        variable (str): Variable name (e.g., 'Heartrate')
        experiment_keys (list of str, optional): List of dataset keys to include.
        dates (list of str, optional): Dates in YYMMDD format to include (if None, include all).
        ylim (tuple, optional): X-axis (value) range.
        log_scale (bool): If True, apply log scale on the x-axis.
    """
    import joypy
    from matplotlib.patches import Patch

    if experiment_keys is None:
        experiment_keys = list(datasets.keys())
    selected_datasets = {k: datasets[k] for k in experiment_keys}

    if isinstance(dates, str):
        dates = [dates]
    full_dates = {f"20{d}" for d in dates} if dates else None

    all_data = []
    session_labels = []
    experiment_labels = []
    color_list = []

    for key, cfg in selected_datasets.items():
        data = cfg["data"]
        color = cfg["color"]
        legend = cfg.get("legend", key)

        if mouse_id not in data:
            continue

        for session_date, session_data in data[mouse_id].items():
            if session_date == "experiment":
                continue

            if full_dates and session_date not in full_dates:
                continue

            if variable in session_data:
                values = session_data[variable].data()
                short_date = session_date[2:]  # YYMMDD
                all_data.extend(values)
                session_labels.extend([short_date] * len(values))
                experiment_labels.extend([legend] * len(values))
                color_list.append(color)

    if not all_data:
        print(f"Error: No data available for Mouse {mouse_id} and variable '{variable}'.")
        return

    import pandas as pd

    df = pd.DataFrame({
        "value": all_data,
        "date": session_labels,
        "experiment": experiment_labels
    })

    # Pivot data for joyplot
    session_order = sorted(set(session_labels), key=session_labels.index)
    df_sorted = df[df["date"].isin(session_order)]
    df_pivot = df_sorted.pivot(columns="date", values="value")

    # Setup joyplot
    fig_width = max(6, 0.5 * len(session_order))
    fig, axes = joypy.joyplot(
        df_pivot,
        overlap=0.5,
        figsize=(fig_width, 6),
        kind="kde",
        fade=True,
        x_range=ylim,
        colormap=None,
        color=color_list,
        linewidth=1.2
    )

    # Apply log scale if needed
    if log_scale:
        for axis in axes:
            axis.set_xscale("log")

    # Title & label
    axes[-1].set_xlabel(variable, fontsize=14, fontweight="bold")
    # axes[0].set_title(f"Distribution of {variable} (Mouse {mouse_id})", fontsize=16, fontweight="bold")

    # Build legend using unique experiment names
    legend_map = {label: color for label, color in zip(experiment_labels, color_list)}
    handles = [Patch(facecolor=c, label=l) for l, c in legend_map.items()]
    plt.legend(handles=handles, loc="best", frameon=False, fontsize=12)

    plt.tight_layout()
    plt.show()


from scipy.stats import pearsonr


def synchronize_tsd(tsd1, tsd2):
    """Synchronize two TSDs by keeping only shared timestamps using boolean indexing."""
    common_times = np.intersect1d(tsd1.index.values, tsd2.index.values)
    print(len(common_times))
    # Get boolean masks
    mask1 = np.isin(tsd1.index.values, common_times)
    mask2 = np.isin(tsd2.index.values, common_times)

    # Apply masks
    tsd1_sync = tsd1[mask1]
    tsd2_sync = tsd2[mask2]

    return tsd1_sync, tsd2_sync


from matplotlib.cm import tab10

def compute_and_plot_variable_correlations(
    datasets,
    mouse_id,
    variable_x,
    variable_y,
    experiment_keys=None,
    dates=None
):
    """
    Computes and plots Pearson correlation coefficients between two synchronized variables
    across multiple datasets for a specific mouse.

    Synchronization is done by intersecting timestamps between the two TSDs.
    If `experiment_keys` is provided, only those datasets will be included.
    If `dates` is provided, only data from those YYMMDD dates will be used.
    Each experiment is plotted as a group on the x-axis.
    """
    from matplotlib.cm import tab10

    # Select subset of datasets if needed
    if experiment_keys is None:
        experiment_keys = list(datasets.keys())
    selected_datasets = {k: datasets[k] for k in experiment_keys}

    full_dates = [f"20{d}" for d in dates] if dates else None

    all_r = []
    all_groups = []
    all_colors = []

    for key in experiment_keys:
        cfg = datasets[key]
        data = cfg["data"]
        color = cfg["color"]
        legend = cfg["legend"]

        if mouse_id not in data:
            continue

        for date in data[mouse_id]:
            if date == "experiment":
                continue
            if full_dates and date not in full_dates:
                continue

            session = data[mouse_id][date]
            if variable_x in session and variable_y in session:
                tsd_x, tsd_y = synchronize_tsd(session[variable_x], session[variable_y])
                x_vals, y_vals = tsd_x.values, tsd_y.values
                mask = ~np.isnan(x_vals) & ~np.isnan(y_vals)
                x_vals = x_vals[mask]
                y_vals = y_vals[mask]

                if len(x_vals) < 2 or len(y_vals) < 2 or len(x_vals) != len(y_vals):
                    print(f"Skipping {date}: insufficient or mismatched data.")
                    continue

                r, _ = pearsonr(x_vals, y_vals)
                all_r.append(r)
                all_groups.append(legend)
                all_colors.append(color)

    if not all_r:
        print("No valid correlations computed.")
        return

    df = pd.DataFrame({
        "Correlation": all_r,
        "Group": all_groups,
        "Color": all_colors
    })

    # Plotting
    fig, ax = plt.subplots(figsize=(6, 6))
    unique_groups = df["Group"].unique()

    for i, group in enumerate(unique_groups):
        subset = df[df["Group"] == group]
        ax.scatter(
            x=[i] * len(subset),
            y=subset["Correlation"],
            color=subset["Color"].iloc[0],
            edgecolors='black',
            s=100,
            alpha=0.9
        )

    ax.set_xticks(range(len(unique_groups)))
    ax.set_xticklabels(unique_groups, rotation=45)

    ax.set_ylabel(f"Correlation ({variable_x} vs {variable_y})", fontsize=14, fontweight="bold")
    ax.set_xlabel("Experiment", fontsize=14, fontweight="bold")
    ax.set_title(f"Pearson Correlation (Mouse {mouse_id})", fontsize=16, fontweight="bold")
    ax.set_ylim(-0.5, 0.85)

    make_pretty_plot(ax)
    ax.grid(True, linestyle="--", alpha=0.5)
    plt.tight_layout()
    plt.show()


# def compute_and_plot_variable_correlations(
#     data_list,
#     mouse_id,
#     variable_x,
#     variable_y,
#     dates=None,
#     colors=None,
#     legends=None
# ):
#     """
#     Computes and plots Pearson correlation coefficients between two synchronized variables 
#     across one or multiple nested dictionaries for a given mouse.

#     Synchronization is performed by intersecting the timestamps of the two TSDs: only values 
#     with matching time points are included in the correlation calculation.

#     Each entry in `data_list` is treated as a separate group and plotted at one unique x-axis
#     position (as labeled by `legends`). If colors are given, all points in a group are colored 
#     the same, with a dark edge for visibility. No legend is shown — groups are distinguished by 
#     x-axis labels.
#     """
#     all_r = []
#     all_groups = []
#     all_colors = []

#     # Prepare full_dates
#     if dates is not None:
#         full_dates = [f"20{d}" for d in dates]
#     else:
#         # Use all dates found in all dictionaries
#         full_dates = sorted(set(
#             date for data in data_list if mouse_id in data for date in data[mouse_id]
#         ))

#     n_groups = len(data_list)

#     # Default legends and colors
#     if legends is None:
#         legends = [f"Group {i+1}" for i in range(n_groups)]
#     if colors is None:
#         colors = [tab10(i % 10) for i in range(n_groups)]

#     for group_idx, data in enumerate(data_list):
#         legend = legends[group_idx]
#         color = colors[group_idx]

#         if mouse_id not in data:
#             continue

#         for session_date in full_dates:
#             if session_date not in data[mouse_id]:
#                 continue

#             session = data[mouse_id][session_date]
#             if variable_x in session and variable_y in session:
#                 tsd_x, tsd_y = synchronize_tsd(session[variable_x], session[variable_y])
#                 x_vals, y_vals = tsd_x.values, tsd_y.values
#                 mask = ~np.isnan(x_vals) & ~np.isnan(y_vals)
#                 x_vals = x_vals[mask]
#                 y_vals = y_vals[mask]

#                 if len(x_vals) < 2 or len(y_vals) < 2 or len(x_vals) != len(y_vals):
#                     print(f"Skipping {session_date}: insufficient or mismatched data.")
#                     continue

#                 r, _ = pearsonr(x_vals, y_vals)
#                 all_r.append(r)
#                 all_groups.append(legend)
#                 all_colors.append(color)

#     if not all_r:
#         print("No valid correlations computed.")
#         return

#     df = pd.DataFrame({
#         "Correlation": all_r,
#         "Group": all_groups,
#         "Color": all_colors
#     })

#     # Plotting
#     fig, ax = plt.subplots(figsize=(5, 6))

#     for group in df["Group"].unique():
#         subset = df[df["Group"] == group]
#         # ax.scatter(
#         #     x=[group] * len(subset),
#         #     y=subset["Correlation"],
#         #     color=subset["Color"].iloc[0],
#         #     edgecolors='black',
#         #     s=100,
#         #     alpha=0.9
#         # )
#         x_pos = list(df["Group"].unique()).index(group)
#         ax.scatter(
#             x=[x_pos] * len(subset),
#             y=subset["Correlation"],
#             color=subset["Color"].iloc[0],
#             edgecolors='black',
#             s=100,
#             alpha=0.9
#         )

#     group_labels = list(df["Group"].unique())
#     ax.set_xticks(range(len(group_labels)))
#     ax.set_xticklabels(group_labels, rotation=45)

#     ax.set_ylabel(f"Correlation ({variable_x} vs {variable_y})", fontsize=14, fontweight="bold")
#     ax.set_xlabel("Group", fontsize=14, fontweight="bold")
#     ax.set_title(f"Pearson Correlation (Mouse {mouse_id})", fontsize=16, fontweight="bold")
#     ax.set_ylim(-0.5, 0.85)

#     # Styling
#     ax.spines["top"].set_visible(False)
#     ax.spines["right"].set_visible(False)
#     ax.spines["left"].set_linewidth(2)
#     ax.spines["bottom"].set_linewidth(2)
#     ax.tick_params(width=2, labelsize=12)
#     ax.grid(True, linestyle="--", alpha=0.5)
#     plt.tight_layout()
#     plt.show()


