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
    data,
    mouse_id,
    variable,
    dates,
    smooth=False,
    smooth_window=100,
    colors=None,
    legends=None
):
    """
    Plots a given variable over time for one or more dates for a given mouse across multiple data dictionaries.

    INPUTS:
        data (list): List of data dictionaries {mouse_id -> {YYYYMMDD -> {variable -> tsd_data}}}
        mouse_id (int): Mouse identifier (e.g., 1690)
        variable (str): Variable to plot (e.g., 'Heartrate')
        dates (str or list): Dates in 'YYMMDD' format to plot
        smooth (bool): Whether to apply moving average smoothing
        smooth_window (int): Window size for smoothing
        colors (str or list): Colors to use for each trace
        legends (str or list): Legends to display

    OUTPUT:
        A time series plot.
    """

    if isinstance(dates, str):
        dates = [dates]
    full_dates = [f"20{d}" for d in dates]

    n = len(full_dates)

    # Handle colors and legends
    if isinstance(colors, str):
        colors = [colors] * n
    if isinstance(colors, list) and len(colors) == 1:
        colors = colors * n
    if isinstance(legends, str):
        legends = [legends] * n
    if isinstance(legends, list) and len(legends) == 1:
        legends = legends * n

    fig, ax = plt.subplots(figsize=(10, 5))

    plotted_any = False
    date_index = 0

    for data in data:
        if mouse_id not in data:
            continue

        for session_date in data[mouse_id]:
            if session_date in full_dates:
                if variable not in data[mouse_id][session_date]:
                    print(f"Warning: Variable '{variable}' not found for Mouse {mouse_id} on {session_date}.")
                    continue

                tsd_data = data[mouse_id][session_date][variable]
                time = tsd_data.t
                values = tsd_data.data()

                if smooth:
                    values = apply_smoothing(values, smooth_window)

                color = colors[date_index] if colors else 'brown'
                label = legends[date_index] if legends else session_date[2:]
                ax.plot(time, values, color=color, label=label, linewidth=2)
                plotted_any = True
                date_index += 1

    if not plotted_any:
        print(f"No data plotted for Mouse {mouse_id} and variable '{variable}'.")
        return

    ax.set_title(f"{variable} over Time (Mouse {mouse_id})", fontsize=16, fontweight="bold")
    ax.set_xlabel("Time (s)", fontsize=14, fontweight="bold")
    ax.set_ylabel(variable, fontsize=14, fontweight="bold")

    if date_index > 1 or legends:
        ax.legend(loc="upper right", fontsize=12)

    make_pretty_plot(ax)
    plt.show()


def apply_smoothing(signal, window_size):
    kernel = np.ones(window_size) / window_size
    smoothed = np.convolve(signal, kernel, mode='same')
    half_window = window_size // 2
    smoothed[:half_window] = np.nan
    smoothed[-half_window:] = np.nan
    return smoothed


def plot_multiple_variables_over_time(data_list, mouse_id, variables, date, smooth=True, smooth_window_dict=None, colors=None, legend=None):
    full_date = f"20{date}"
    n_vars = len(variables)
    fig, axs = plt.subplots(n_vars, 1, figsize=(15, 4 * n_vars), sharex=True)

    if n_vars == 1:
        axs = [axs]

    for i, variable in enumerate(variables):
        ax = axs[i]
        for data in data_list:
            if mouse_id not in data or full_date not in data[mouse_id] or variable not in data[mouse_id][full_date]:
                continue
            tsd_data = data[mouse_id][full_date][variable]
            time = tsd_data.t
            values = tsd_data.data()

            if smooth and smooth_window_dict and variable in smooth_window_dict:
                values = apply_smoothing(values, smooth_window_dict[variable])

            color = colors[variable] if colors and variable in colors else 'brown'
            ax.plot(time, values, label=legend if legend else variable, color=color, linewidth=2)

        ax.set_title(f"{variable} (Mouse {mouse_id}, {date})")
        ax.set_ylabel(variable)
        make_pretty_plot(ax)

    axs[-1].set_xlabel("Time (s)")
    plt.tight_layout()
    plt.show()


# plot_multiple_variables_over_time_by_date(
#     [data_hab], 
#     mouse_id=1690, 
#     variables=['Heartrate', 'OBGamma'], 
#     date='250130',
#     smooth=True,
#     smooth_window={'Heartrate': 100, 'OBGamma': 200},
#     colors={'Heartrate': 'darkred', 'OBGamma': 'navy'},
#     legend='Habituation'
# )


import seaborn as sns
from matplotlib.patches import Patch
import pandas as pd

def plot_variable_distribution(
    data_list,
    mouse_id,
    variable,
    dates=None,
    ylim=None,
    colors=None,
    legends=None,
    log_scale=False
):
    """
    Plots a violin plot to visualize the distribution of a given variable 
    for a specific mouse across multiple datasets.

    INPUTS:
        data_list (list of dicts): List of nested dictionaries {mouse_id -> {date -> {variable -> tsd_data}}}
        mouse_id (int): Mouse identifier (e.g., 1690)
        variable (str): Name of the variable to plot (e.g., 'Heartrate' or 'BreathFreq')
        dates (list, optional): List of dates (YYMMDD format). If None, plots all dates.
        ylim (tuple, optional): Custom y-axis limits.
        colors (list or str, optional): Colors per date/session.
        legends (list or str, optional): Legend labels per date/session.
        log_scale (bool): If True, y-axis is log-scaled.

    OUTPUT:
        Displays a violin plot of the selected variable's distribution.
    """

    all_data = []
    session_labels = []

    if dates:
        # Keep user-specified order
        full_dates = [f"20{d}" for d in dates]
    else:
        # Collect all available dates
        full_dates = []
        for data in data_list:
            if mouse_id in data:
                full_dates.extend(list(data[mouse_id].keys()))
        full_dates = sorted(set(full_dates))

    for full_date in full_dates:
        values_found = False
        for data in data_list:
            if mouse_id in data and full_date in data[mouse_id]:
                session_data = data[mouse_id][full_date]
                if variable in session_data:
                    values = session_data[variable].data()
                    all_data.extend(values)
                    short_date = full_date[2:]
                    session_labels.extend([short_date] * len(values))
                    values_found = True
                    break  # Stop at first match
        if not values_found:
            print(f"Warning: No data found for Mouse {mouse_id}, Variable '{variable}', Date {full_date}")

    if not all_data:
        print(f"Error: No data available for Mouse {mouse_id} and variable '{variable}'.")
        return

    # Colors
    n = len(set(session_labels))
    if isinstance(colors, str):
        color_list = [colors] * n
    elif isinstance(colors, list) and len(colors) == 1:
        color_list = colors * n
    elif isinstance(colors, list) and len(colors) == len(full_dates):
        color_list = [c for d, c in zip(full_dates, colors) if f"{d[2:]}" in session_labels]
    else:
        color_list = sns.color_palette("muted", n)

    # Legends
    if isinstance(legends, str):
        legend_list = [legends] * n
    elif isinstance(legends, list) and len(legends) == 1:
        legend_list = legends * n
    elif isinstance(legends, list) and len(legends) == len(full_dates):
        legend_list = [l for d, l in zip(full_dates, legends) if f"{d[2:]}" in session_labels]
    else:
        legend_list = [f"Group {i+1}" for i in range(n)]

    # DataFrame for seaborn
    df = pd.DataFrame({
        "value": all_data,
        "session": session_labels
    })

    # Unique session list in order of appearance
    unique_sessions = [s for s in dates] if dates else sorted(set(session_labels), key=session_labels.index)
    palette = {session: color for session, color in zip(unique_sessions, color_list)}

    # Plot
    fig, ax = plt.subplots(figsize=(8, 6))
    sns.violinplot(
        data=df,
        x="session",
        y="value",
        hue="session",
        palette=palette,
        inner="box",
        ax=ax,
        legend=False
    )

    ax.set_xlabel("Session", fontsize=14, fontweight="bold")
    ax.set_ylabel(variable, fontsize=14, fontweight="bold")
    ax.set_title(f"Distribution of {variable} (Mouse {mouse_id})", fontsize=16, fontweight="bold")

    if log_scale:
        ax.set_yscale("log")
        
    default_ylim = {"Heartrate": (6, 14), "BreathFreq": (0, 9), "OBGamma": (100,900)}
    if ylim:
        ax.set_ylim(ylim)
    elif variable in default_ylim:
        ax.set_ylim(default_ylim[variable])
    else:
        ax.set_ylim(auto=True)  # Reset to default autoscaling

    # Legend
    legend_map = {}
    for session, color, label in zip(unique_sessions, color_list, legend_list):
        legend_map[label] = color
    handles = [Patch(facecolor=color, label=label) for label, color in legend_map.items()]
    ax.legend(handles=handles, loc="best", fontsize=8, frameon=False)

    make_pretty_plot(ax)
    plt.show()
    
# Example Usage:
# plot_variable_distribution(
#     [data1, data2],
#     mouse_id=1690,
#     variable="Heartrate",
#     dates=["240221", "240222", "240223"],
#     colors=["#d62728", "#2ca02c", "#2ca02c"],
#     legends=["Control", "Treated", "Treated"]
# )


import joypy

def plot_variable_joyplot(
    data_list,
    mouse_id,
    variable,
    dates=None,
    ylim=None,
    colors=None,
    legends=None,
    log_scale=False
):
    """
    Plots a joyplot (ridge plot) to visualize the distribution of a variable 
    for a specific mouse across multiple datasets.

    INPUTS:
        data_list (list of dicts): Each dict is {mouse_id -> {YYYYMMDD -> {variable -> tsd_data}}}
        mouse_id (int): Mouse identifier
        variable (str): Variable name (e.g., 'Heartrate', 'OBGamma')
        dates (list of str, optional): List of dates in 'YYMMDD' format
        ylim (tuple, optional): y-axis limits
        colors (str or list, optional): Custom color(s)
        legends (str or list, optional): Legend labels
        log_scale (bool): Apply log scale to the x-axis (value axis)

    OUTPUT:
        A joyplot displaying the distributions.
    """

    all_data = []
    session_labels = []
    
    if isinstance(dates, str):
        dates = [dates]

    full_dates = {f"20{d}" for d in dates} if dates else None

    for data in data_list:
        if mouse_id not in data:
            continue

        for session_date, session_data in data[mouse_id].items():
            if full_dates is None or session_date in full_dates:
                if variable in session_data:
                    values = session_data[variable].data()
                    short_date = session_date[2:]  # YYMMDD
                    all_data.extend(values)
                    session_labels.extend([short_date] * len(values))

    if not all_data:
        print(f"Error: No data available for Mouse {mouse_id} and variable '{variable}'.")
        return

    n_sessions = len(set(session_labels))

    # Process colors
    if isinstance(colors, str):
        color_list = [colors] * n_sessions
    elif isinstance(colors, list) and len(colors) == 1:
        color_list = colors * n_sessions
    elif isinstance(colors, list) and len(colors) == n_sessions:
        color_list = colors
    else:
        color_list = sns.color_palette("muted", n_sessions)

    # Process legends
    if isinstance(legends, str):
        legend_list = [legends] * n_sessions
    elif isinstance(legends, list) and len(legends) == 1:
        legend_list = legends * n_sessions
    elif isinstance(legends, list) and len(legends) == n_sessions:
        legend_list = legends
    else:
        legend_list = [f"Group {i+1}" for i in range(n_sessions)]

    # Create DataFrame
    df = pd.DataFrame({"value": all_data, "session": session_labels})

    # Sort sessions in original appearance order
    session_order = sorted(set(session_labels), key=session_labels.index)

    # Pivot for joypy
    df_sorted = df[df["session"].isin(session_order)]
    df_pivot = df_sorted.pivot(columns="session", values="value")

    # Create joyplot
    fig, ax = joypy.joyplot(
        df_pivot,
        overlap=0.5,
        colormap=plt.cm.get_cmap("tab10") if colors is None else None,
        color=color_list,
        linewidth=1.2,
        figsize=(10, 6),
        kind="kde",
        fade=True,
        x_range=ylim
    )
    
    # Optional: Apply log scale manually if needed
    if log_scale:
        for axis in ax:
            axis.set_xscale("log")

    # Title and labels
    ax[-1].set_xlabel(variable, fontsize=14, fontweight="bold")
    ax[0].set_title(f"Distribution of {variable} (Mouse {mouse_id})", fontsize=16, fontweight="bold")

    # Legend (if needed)
    legend_map = {}
    for session, label, color in zip(session_order, legend_list, color_list):
        legend_map[label] = color

    handles = [Patch(facecolor=color, label=label) for label, color in legend_map.items()]
    plt.legend(handles=handles, loc="lower left", frameon=False, fontsize=12)

    plt.tight_layout()
    plt.show()

# plot_variable_joyplot(
#     data_list=[data_hab, data_ivab],
#     mouse_id=1690,
#     variable='OBGamma',
#     dates=['250221', '250224'],
#     legends=['Habituation', 'Ivabradine'],
#     colors=['#e41a1c', '#377eb8'],
#     log_scale=False
# )


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import pearsonr
from matplotlib.patches import Patch

def synchronize_tsd(tsd1, tsd2):
    """Synchronize two TSDs based on their time vector."""
    t1, t2 = tsd1.t, tsd2.t
    common_times = np.intersect1d(t1, t2)
    mask1 = np.isin(t1, common_times)
    mask2 = np.isin(t2, common_times)
    tsd1_sync = type(tsd1)(t=t1[mask1], d=tsd1.data[mask1])
    tsd2_sync = type(tsd2)(t=t2[mask2], d=tsd2.data[mask2])
    return tsd1_sync, tsd2_sync

def compute_and_plot_variable_correlations(
    data_list,
    mouse_id,
    variable_x,
    variable_y,
    dates=None,
    colors=None,
    legends=None
):
    """
    Computes and plots Pearson correlation coefficients between two variables
    across different sessions for a specific mouse.

    If no dates are provided, all available ones across datasets are used.

    Inputs:
    - data_list: list of nested dicts {mouse_id -> {date -> {variable -> tsd}}}
    - mouse_id: int, mouse number
    - variable_x, variable_y: str, variables to correlate
    - dates: list of str ('YYMMDD' format), optional
    - colors: list of colors or None
    - legends: list of group names or None
    """
    from matplotlib.cm import tab10

    # Gather all matching sessions
    all_r = []
    all_legend_labels = []
    used_colors = []

    # Determine dates if not provided
    if dates is None:
        full_dates = set()
        for data in data_list:
            if mouse_id in data:
                full_dates.update(data[mouse_id].keys())
        full_dates = sorted(full_dates)
    else:
        full_dates = [f"20{d}" for d in dates]

    # Assign colors if not provided
    if colors is None:
        colors = [tab10(i % 10) for i in range(len(full_dates))]

    # Legends default to dates if not provided
    if legends is None:
        legends = [d[2:] for d in full_dates]  # use YYMMDD

    for i, session_date in enumerate(full_dates):
        found = False
        for data in data_list:
            if mouse_id in data and session_date in data[mouse_id]:
                session = data[mouse_id][session_date]
                if variable_x in session and variable_y in session:
                    tsd_x, tsd_y = synchronize_tsd(session[variable_x], session[variable_y])
                    x_vals, y_vals = np.asarray(tsd_x.data).flatten(), np.asarray(tsd_y.data).flatten()

                    if len(x_vals) < 2 or len(y_vals) < 2 or len(x_vals) != len(y_vals):
                        print(f"Skipping {session_date}: insufficient or mismatched data.")
                        continue

                    r, _ = pearsonr(x_vals, y_vals)
                    all_r.append(r)
                    all_legend_labels.append(legends[i])
                    used_colors.append(colors[i])
                    found = True
                    break
        if not found:
            print(f"No data found for Mouse {mouse_id} on {session_date}")

    if not all_r:
        print("No valid correlations computed.")
        return

    # Prepare DataFrame for plotting
    df = pd.DataFrame({
        "Correlation": all_r,
        "Legend": all_legend_labels,
        "Color": used_colors
    })

    # Plot
    fig, ax = plt.subplots(figsize=(8, 6))
    for legend_label in df["Legend"].unique():
        subset = df[df["Legend"] == legend_label]
        ax.scatter(
            x=[legend_label] * len(subset),
            y=subset["Correlation"],
            color=subset["Color"].iloc[0],
            s=100,
            alpha=0.8,
            label=legend_label
        )

    ax.set_ylabel(f"Correlation ({variable_x} vs {variable_y})", fontsize=14, fontweight="bold")
    ax.set_xlabel("Session/Group", fontsize=14, fontweight="bold")
    ax.set_title(f"Pearson Correlation (Mouse {mouse_id})", fontsize=16, fontweight="bold")
    ax.set_ylim(-1, 1)

    # Pretty formatting
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_linewidth(2)
    ax.spines["bottom"].set_linewidth(2)
    ax.tick_params(width=2, labelsize=12)
    ax.legend(title="Legend", fontsize=12, title_fontsize=13, frameon=False)

    ax.grid(True, linestyle="--", alpha=0.5)
    plt.tight_layout()
    plt.show()
