#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 22 17:30:13 2025

@author: gruffalo
"""

from scipy.stats import pearsonr
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from make_pretty_plot import make_pretty_plot
from manipulate_tsd import interpolate_tsd
from pynapple import Tsd

def synchronize_tsd(tsd1, tsd2):
    """Synchronize two TSDs by keeping only shared timestamps using boolean indexing."""
    common_times = np.intersect1d(tsd1.index.values, tsd2.index.values)
    # Get boolean masks
    mask1 = np.isin(tsd1.index.values, common_times)
    mask2 = np.isin(tsd2.index.values, common_times)

    # Apply masks
    tsd1_sync = tsd1[mask1]
    tsd2_sync = tsd2[mask2]

    return tsd1_sync, tsd2_sync


def plot_variable_correlations(
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
    fig, ax = plt.subplots(figsize=(8, 6))
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
    

from scipy.signal import correlate
import matplotlib.colors as mcolors

def plot_cross_correlation_between_variables(
    datasets,
    mouse_id,
    var1,
    var2,
    dates=None,
    experiment_keys=None,
    bin_size=0.01,
    max_lag_seconds=10,
    normalize=True
):
    """
    Compute and plot cross-correlation between two Tsd variables across sessions/experiments.

    Parameters:
    - datasets (dict): Experiment configs with keys "data", "legend", "color".
    - mouse_id (int): Mouse to analyze.
    - var1, var2 (str): Names of variables to correlate.
    - dates (list of str, optional): Session dates in YYMMDD format.
    - experiment_keys (list of str, optional): Experiments to include.
    - bin_size (float): Bin size in seconds for interpolation.
    - max_lag_seconds (float): Maximum lag shown on x-axis.
    - normalize (bool): Whether to normalize the cross-correlation.

    Returns:
    - None. Displays a plot.
    """
    if isinstance(dates, str):
        dates = [dates]
    full_dates = [f"20{d}" for d in dates] if dates else None
    if experiment_keys is None:
        experiment_keys = list(datasets.keys())

    fig, ax = plt.subplots(figsize=(10, 5))
    plotted_any = False

    # Build labels
    all_labels = []
    for key in experiment_keys:
        cfg = datasets[key]
        if mouse_id in cfg["data"]:
            for session_date in cfg["data"][mouse_id]:
                if session_date == "experiment":
                    continue
                if full_dates and session_date not in full_dates:
                    continue
                session = cfg["data"][mouse_id][session_date]
                if var1 in session and var2 in session:
                    all_labels.append(f"{cfg.get('legend', key)} ({session_date[2:]})")

    color_map = plt.get_cmap("Set1", len(all_labels))
    auto_colors = {label: mcolors.to_hex(color_map(i)) for i, label in enumerate(all_labels)}
    used_labels = set()

    # Loop through sessions
    for key in experiment_keys:
        cfg = datasets[key]
        data = cfg["data"]
        legend = cfg.get("legend", key)

        if mouse_id not in data:
            continue

        for session_date in data[mouse_id]:
            if session_date == "experiment":
                continue
            if full_dates and session_date not in full_dates:
                continue

            session = data[mouse_id][session_date]
            if var1 not in session or var2 not in session:
                continue

            tsd1 = session[var1]
            tsd2 = session[var2]

            # Compute shared timebase
            t_min = max(tsd1.t[0], tsd2.t[0])
            t_max = min(tsd1.t[-1], tsd2.t[-1])
            if t_max <= t_min:
                continue

            common_t = np.arange(t_min, t_max, bin_size)
            if len(common_t) == 0:
                continue
            common_tsd = Tsd(t=common_t, d=np.zeros_like(common_t))

            # Interpolate both tsds to common time base
            try:
                interp1 = interpolate_tsd(tsd1, common_tsd)
                interp2 = interpolate_tsd(tsd2, common_tsd)
            except Exception as e:
                print(f"Interpolation failed for {session_date} ({key}): {e}")
                continue

            x = interp1.values
            y = interp2.values

            if len(x) == 0 or len(x) != len(y):
                continue

            # Demean
            x = x - np.mean(x)
            y = y - np.mean(y)

            # Cross-correlation
            corr = correlate(x, y, mode="full", method="direct")
            if normalize:
                corr /= (np.std(x) * np.std(y) * len(x))

            dt = np.median(np.diff(common_t))  # time step in seconds
            lags = np.arange(-len(x) + 1, len(x)) * dt
            valid = np.abs(lags) <= max_lag_seconds

            label = f"{legend} ({session_date[2:]})"
            color = auto_colors.get(label, cfg["color"])
            if label not in used_labels:
                ax.plot(lags[valid], corr[valid], color=color, linewidth=2, label=label)
                used_labels.add(label)
            else:
                ax.plot(lags[valid], corr[valid], color=color, linewidth=2)

            plotted_any = True

    if not plotted_any:
        print(f"No valid data for Mouse {mouse_id} and variables '{var1}' / '{var2}'")
        return

    ax.set_title(f"Cross-Correlation: {var1} vs {var2} (Mouse {mouse_id})", fontsize=16, fontweight="bold")
    ax.set_xlabel(f"Lag (s) — {var2} relative to {var1}", fontsize=14)
    ax.set_ylabel("Cross-correlation", fontsize=14)
    ax.set_ylim(-1,1)
    ax.axvline(0, color='k', linestyle='--', linewidth=1)
    ax.legend(fontsize=10, frameon=False)
    make_pretty_plot(ax)
    plt.tight_layout()
    plt.show()