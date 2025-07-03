#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 14 16:21:13 2025

@author: gruffalo
"""

def print_maze_variable_data(datasets, variable, experiment_key=None,):
    """
    Print mouse ID and variable data for a given experiment key from maze dataset.

    Parameters
    ----------
    datasets : dict
        The full dataset dictionary containing 'data' for each experiment key.
    experiment_key : str
        The key identifying the experiment to inspect (e.g., 'TestEPM').
    variable : str
        One of: 'MeanSpeed', 'SessionTime', 'TotalTimeAllZones',
                'NumZoneEntries', 'ZoneOccupation', or 'DurationZoneEntries'.
    """
    assert variable in [
        'MeanSpeed', 'SessionTime', 'TotalTimeAllZones',
        'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'
    ], (
        "Variable must be one of: 'MeanSpeed', 'SessionTime', 'TotalTimeAllZones', "
        "'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'"
    )
    
    if experiment_key not in datasets:
        print(f"Experiment key '{experiment_key}' not found in datasets.")
        return

    data_dict = datasets[experiment_key].get('data', {})
    if not data_dict:
        print(f"No data found for experiment key '{experiment_key}'.")
        return

    print(f"\n--- {variable} Data for Experiment '{experiment_key}' ---")
    for mouse_id, session_dict in data_dict.items():
        for date, session_data in session_dict.items():
            if variable in ['MeanSpeed', 'SessionTime', 'TotalTimeAllZones']:
                value = session_data.get(variable, np.nan)
                print(f"Mouse {mouse_id} | Date {date} | {variable}: {value:.3f}")
            else:
                print(f"Mouse {mouse_id} | Date {date}")
                for zone, zone_data in session_data.get('Zones', {}).items():
                    if variable == 'NumZoneEntries':
                        value = zone_data.get('NumEntries', np.nan)
                    elif variable == 'ZoneOccupation':
                        value = zone_data.get('TotalTime', np.nan)
                    elif variable == 'DurationZoneEntries':
                        value = zone_data.get('MeanDuration', np.nan)
                    print(f"  Zone '{zone}': {value:.3f}")
                    

def plot_centered_maze_trajectories(datasets, list_of_experiment_key_groups, maze_type='EPM', legend=False, mouse_list=None):
    """
    Plot centered maze trajectories for each group of experiment keys separately.

    Parameters:
    - datasets: dict containing maze data with structure [experiment_key]['data'][mouse_id][date]
    - list_of_experiment_key_groups: list of lists of experiment keys
      Example: [['TestEPM1', 'TestEPM2'], ['ControlEPM']]
    - maze_type : str that can be either 'EPM' or 'OF' to adjust plot limits
    - legend : whether to show legends
    - mouse_list : optional list of mouse IDs to include
    """
    for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
        plt.figure(figsize=(6, 6))
        color_cycle = plt.cm.tab10.colors
        i = 0

        for exp_key in experiment_keys:
            if exp_key not in datasets:
                print(f"Experiment key '{exp_key}' not found in datasets.")
                continue

            data = datasets[exp_key]['data']
            for mouse_id in data:
                if mouse_list is not None and mouse_id not in mouse_list:
                    continue

                for date in data[mouse_id]:
                    entry = data[mouse_id][date]
                    x = entry.get('CenteredXtsd', None)
                    y = entry.get('CenteredYtsd', None)

                    if x is None or y is None:
                        print(f"Missing centered data for mouse {mouse_id} on {date} in {exp_key}.")
                        continue

                    try:
                        x_vals = x.data
                        y_vals = y.data
                    except AttributeError:
                        x_vals = x
                        y_vals = y

                    label = f"{exp_key} - {mouse_id} - {date}"
                    color = color_cycle[i % len(color_cycle)]
                    plt.plot(np.asarray(y_vals), np.asarray(x_vals), markersize=1, alpha=0.6, label=label, color=color)
                    # plt.plot(y_vals, x_vals, markersize=1, alpha=0.6, label=label, color=color)
                    i += 1

        plt.axhline(0, linestyle='--', color='gray')
        plt.axvline(0, linestyle='--', color='gray')
        plt.xlabel('Y (centered)', weight='bold')
        plt.ylabel('X (centered)', weight='bold')

        if maze_type == 'EPM':
            plt.xlim(-100, 100)
            plt.ylim(-100, 100)
        elif maze_type == 'OF':
            plt.xlim(-40, 40)
            plt.ylim(-40, 40)
        else:
            print("maze_type should be 'EPM' or 'OF'")

        group_label = ', '.join(experiment_keys)
        plt.title(f'Centered {maze_type} Trajectories - Group {group_index + 1} ({group_label})', weight='bold', fontsize=8)
        plt.grid(True)
        if legend:
            plt.legend(fontsize='small', markerscale=4, loc='best')
        plt.tight_layout()
        plt.show()


import matplotlib.pyplot as plt
import numpy as np

def plot_centered_maze_density(datasets, list_of_experiment_key_groups, maze_type='EPM', 
                               bins=100, pad=10, log_scale=True, normalize=True, same_scale=True):
    """
    Plot a 2D histogram (density heatmap) of centered maze trajectories for each group of experiment keys,
    using dynamic plot limits based on actual data.

    Parameters:
    - datasets: dict containing maze data with structure [experiment_key]['data'][mouse_id][date]
    - list_of_experiment_key_groups: list of lists of experiment keys
    - maze_type : 'EPM' or 'OF' to annotate the plot (no longer used for axis limits)
    - bins: number of bins for the 2D histogram
    - pad: number of units to pad around min/max of data for axis limits
    - log_scale: if True, apply log(1 + density) transform
    - normalize: if True, apply min-max normalization to density values
    - same_scale: if True, use global min and max across all groups for normalization
    """
    group_data = []
    global_min = np.inf
    global_max = -np.inf

    # First pass: gather data and optionally compute global min/max
    for experiment_keys in list_of_experiment_key_groups:
        all_x = []
        all_y = []

        for exp_key in experiment_keys:
            if exp_key not in datasets:
                print(f"Experiment key '{exp_key}' not found in datasets.")
                continue

            data = datasets[exp_key]['data']
            for mouse_id in data:
                for date in data[mouse_id]:
                    entry = data[mouse_id][date]
                    x = entry.get('CenteredXtsd', None)
                    y = entry.get('CenteredYtsd', None)

                    if x is None or y is None:
                        print(f"Missing centered data for mouse {mouse_id} on {date} in {exp_key}.")
                        continue

                    all_x.append(np.asarray(x))
                    all_y.append(np.asarray(y))

        if not all_x or not all_y:
            group_data.append(None)
            continue

        all_x = np.concatenate(all_x)
        all_y = np.concatenate(all_y)

        valid_mask = np.isfinite(all_x) & np.isfinite(all_y)
        all_x = all_x[valid_mask]
        all_y = all_y[valid_mask]

        if all_x.size == 0 or all_y.size == 0:
            group_data.append(None)
            continue

        x_min, x_max = all_x.min() - pad, all_x.max() + pad
        y_min, y_max = all_y.min() - pad, all_y.max() + pad

        heatmap, xedges, yedges = np.histogram2d(all_x, all_y, bins=bins, range=[[x_min, x_max], [y_min, y_max]])

        if log_scale:
            heatmap = np.log1p(heatmap)

        if same_scale:
            global_min = min(global_min, heatmap.min())
            global_max = max(global_max, heatmap.max())

        group_data.append((heatmap, xedges, yedges, experiment_keys))


    # Second pass: plotting
    for group_index, data in enumerate(group_data):
        if data is None:
            print(f"No data found for group {group_index + 1}.")
            continue

        heatmap, xedges, yedges, experiment_keys = data

        if normalize:
            if same_scale:
                heatmap = (heatmap - global_min)
                if global_max > global_min:
                    heatmap /= (global_max - global_min)
            else:
                heatmap = (heatmap - heatmap.min())
                if heatmap.max() > 0:
                    heatmap /= heatmap.max()

        plt.figure(figsize=(8, 8))
        extent = [yedges[0], yedges[-1], xedges[0], xedges[-1]]
        plt.imshow(
            heatmap,
            extent=extent,
            origin='lower',
            cmap='YlOrRd',
            interpolation='nearest',
            aspect='equal',
            vmin=0 if normalize and same_scale else None,
            vmax=1 if normalize and same_scale else None
        )

        plt.axhline(0, linestyle='--', color='gray')
        plt.axvline(0, linestyle='--', color='gray')
        plt.xlabel('Y (centered)')
        plt.ylabel('X (centered)')
        group_label = ', '.join(experiment_keys)
        # plt.title(f'Centered {maze_type} Density - Group {group_index + 1} ({group_label})')
        plt.title(f'{group_label}')
        plt.colorbar(label='Exploration Density')
        plt.grid(False)
        plt.tight_layout()
        plt.show()

import matplotlib.pyplot as plt
import numpy as np

def plot_mean_distance_over_time(datasets, list_of_experiment_key_groups,
                                 legend=None, mouse_list=None,
                                 plot_together=False):
    """
    Plot the mean distance from center over time for each group of experiments.

    Parameters
    ----------
    datasets : dict
        Dataset containing behavioral data with 'DistanceTsd' fields.
    list_of_experiment_key_groups : list of list of str
        Each sublist contains experiment keys for one group.
    legend : None or list of str, optional
        If a list is provided (length equal to number of groups), 
        uses it as legend labels for each group. If None, no legend is shown.
    mouse_list : list or None
        If provided, only plots mice in this list.
    plot_together : bool
        If True, plots all group means in one plot.
    """
    color_cycle = plt.cm.tab10.colors
    group_means = []
    group_stds = []
    group_times = []

    for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
        all_time = []
        all_distances = []

        for exp_key in experiment_keys:
            if exp_key not in datasets:
                print(f"[Warning] Experiment key '{exp_key}' not in datasets.")
                continue

            data = datasets[exp_key].get('data', {})
            for mouse_id in data:
                if mouse_list and mouse_id not in mouse_list:
                    continue
                for date in data[mouse_id]:
                    entry = data[mouse_id][date]
                    tsd = entry.get('DistanceTsd', None)
                    if tsd is None:
                        continue
                    try:
                        time = np.asarray(tsd.t)  # Convert to seconds
                        values = np.asarray(tsd.values)
                    except AttributeError:
                        continue

                    all_time.append(time)
                    all_distances.append(values)

        if all_distances:
            min_end = min([t[-1] for t in all_time])
            max_start = max([t[0] for t in all_time])
            common_time = np.linspace(max_start, min_end, 1000)

            interp_dists = []
            for t, d in zip(all_time, all_distances):
                valid = ~np.isnan(d)
                if valid.sum() > 10:
                    interp = np.interp(common_time, t[valid], d[valid])
                    interp_dists.append(interp)

            if interp_dists:
                interp_dists = np.array(interp_dists)
                mean_dist = np.nanmean(interp_dists, axis=0)
                std_dist = np.nanstd(interp_dists, axis=0)

                group_means.append(mean_dist)
                group_stds.append(std_dist)
                group_times.append(common_time)
            else:
                print(f"[Warning] No valid data for group {group_index + 1}.")
        else:
            print(f"[Warning] No data found for group {group_index + 1}.")

    # Plotting
    if plot_together:
        fig, ax = plt.subplots(figsize=(10, 5))
        for i, (time, mean, std) in enumerate(zip(group_times, group_means, group_stds)):
            # label = f"Group {i+1}" if legend else None
            label = legend[i] if isinstance(legend, list) and i < len(legend) else None
            color = color_cycle[i % len(color_cycle)]
            ax.plot(time, mean, color=color, linewidth=2, label=label)
            ax.fill_between(time, mean - std, mean + std, color=color, alpha=0.3)
        ax.set_title("Mean Distance from Center Over Time (All Groups)")
        ax.set_xlabel("Time (s)", weight='bold')
        ax.set_ylabel("Distance from center", weight='bold')
        ax.set_ylim(0, 40)
        ax.grid(True)
        # if legend:
        #     ax.legend()
        if isinstance(legend, list):
            ax.legend()
        plt.tight_layout()
        plt.show()
    else:
        for i, (time, mean, std) in enumerate(zip(group_times, group_means, group_stds)):
            fig, ax = plt.subplots(figsize=(10, 4))
            color = color_cycle[i % len(color_cycle)]
            label = legend[i] if isinstance(legend, list) and i < len(legend) else None
            ax.plot(time, mean, color=color, linewidth=2, label=label)
            # ax.plot(time, mean, color=color, linewidth=2, label=f'Group {i+1}' if legend else None)
            ax.fill_between(time, mean - std, mean + std, color=color, alpha=0.3)
            ax.set_title(f"Mean Distance from Center Over Time - Group {i+1}")
            ax.set_xlabel("Time (s)", weight='bold')
            ax.set_ylabel("Distance from center", weight='bold')
            ax.set_ylim(0, 40)
            ax.grid(True)
            # if legend:
            #     ax.legend()
            if isinstance(legend, list):
                ax.legend()
            plt.tight_layout()
            plt.show()


import matplotlib.pyplot as plt
import numpy as np

def plot_mean_speed_over_time(datasets, list_of_experiment_key_groups,
                              legend=None, mouse_list=None,
                              plot_together=False):
    """
    Plot the mean speed over time for each group of experiments.

    Parameters
    ----------
    datasets : dict
        Dataset containing behavioral data with 'Speed' fields.
    list_of_experiment_key_groups : list of list of str
        Each sublist contains experiment keys for one group.
    legend : None or list of str, optional
        If a list is provided (length equal to number of groups), 
        uses it as legend labels for each group. If None, no legend is shown.
    mouse_list : list or None
        If provided, only plots mice in this list.
    plot_together : bool
        If True, plots all group means in one plot.
    """
    color_cycle = plt.cm.tab10.colors
    group_means = []
    group_stds = []
    group_times = []

    for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
        all_time = []
        all_speeds = []

        for exp_key in experiment_keys:
            if exp_key not in datasets:
                print(f"[Warning] Experiment key '{exp_key}' not in datasets.")
                continue

            data = datasets[exp_key].get('data', {})
            for mouse_id in data:
                if mouse_list and mouse_id not in mouse_list:
                    continue
                for date in data[mouse_id]:
                    entry = data[mouse_id][date]
                    tsd = entry.get('Speed', None)
                    if tsd is None:
                        continue
                    try:
                        time = np.asarray(tsd.t) / 1e4  # Convert to seconds
                        values = np.asarray(tsd.data)
                    except AttributeError:
                        continue

                    all_time.append(time)
                    all_speeds.append(values)

        if all_speeds:
            min_end = min([t[-1] for t in all_time])
            max_start = max([t[0] for t in all_time])
            common_time = np.linspace(max_start, min_end, 10000)

            interp_speeds = []
            for t, s in zip(all_time, all_speeds):
                valid = ~np.isnan(s)
                if valid.sum() > 10:
                    interp = np.interp(common_time, t[valid], s[valid])
                    interp_speeds.append(interp)

            if interp_speeds:
                interp_speeds = np.array(interp_speeds)
                mean_speed = np.nanmean(interp_speeds, axis=0)
                std_speed = np.nanstd(interp_speeds, axis=0)

                group_means.append(mean_speed)
                group_stds.append(std_speed)
                group_times.append(common_time)
            else:
                print(f"[Warning] No valid data for group {group_index + 1}.")
        else:
            print(f"[Warning] No data found for group {group_index + 1}.")

    # Plotting
    if plot_together:
        fig, ax = plt.subplots(figsize=(10, 5))
        for i, (time, mean, std) in enumerate(zip(group_times, group_means, group_stds)):
            label = legend[i] if isinstance(legend, list) and i < len(legend) else None
            color = color_cycle[i % len(color_cycle)]
            ax.plot(time, mean, color=color, linewidth=2, label=label)
            ax.fill_between(time, mean - std, mean + std, color=color, alpha=0.3)
        ax.set_title("Mean Speed Over Time (All Groups)")
        ax.set_xlabel("Time (s)", weight='bold')
        ax.set_ylabel("Speed (cm/s)", weight='bold')
        ax.set_ylim(0, 30)
        ax.grid(True)
        if isinstance(legend, list):
            ax.legend()
        plt.tight_layout()
        plt.show()
    else:
        for i, (time, mean, std) in enumerate(zip(group_times, group_means, group_stds)):
            fig, ax = plt.subplots(figsize=(10, 4))
            color = color_cycle[i % len(color_cycle)]
            label = legend[i] if isinstance(legend, list) and i < len(legend) else None
            ax.plot(time, mean, color=color, linewidth=2, label=label)
            ax.fill_between(time, mean - std, mean + std, color=color, alpha=0.3)
            ax.set_title(f"Mean Speed Over Time - Group {i+1}")
            ax.set_xlabel("Time (s)", weight='bold')
            ax.set_ylabel("Speed (cm/s)", weight='bold')
            ax.set_ylim(0, 90)
            ax.grid(True)
            if isinstance(legend, list):
                ax.legend()
            plt.tight_layout()
            plt.show()


import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

def plot_distribution_speed(datasets, list_of_experiment_key_groups, mouse_list=None):
    """
    Plot the horizontal distribution of Speed (from Tsd) for each group of experiment keys.

    Parameters:
    - datasets: dict with structure [experiment_key]['data'][mouse_id][date]
    - list_of_experiment_key_groups: list of lists of experiment keys
    - mouse_list : optional list of mouse IDs to include
    - kde: whether to use KDE (True) or histogram (False)
    """
    group_speeds = []

    for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
        group_label = f'Group {group_index + 1}'
        group_data = []

        for exp_key in experiment_keys:
            if exp_key not in datasets:
                print(f"Experiment key '{exp_key}' not found.")
                continue

            data = datasets[exp_key]['data']
            for mouse_id in data:
                if mouse_list is not None and mouse_id not in mouse_list:
                    continue

                for date in data[mouse_id]:
                    entry = data[mouse_id][date]
                    speed = entry.get('Speed', None)

                    if speed is None:
                        print(f"Missing Speed for {mouse_id} on {date} in {exp_key}.")
                        continue

                    try:
                        speed_values = np.asarray(speed.data)
                    except AttributeError:
                        print(f"Invalid Speed format for {mouse_id} on {date} in {exp_key}.")
                        continue

                    group_data.extend(speed_values)

        if group_data:
            group_speeds.append((group_label, np.array(group_data)))

    if not group_speeds:
        print("No speed data found.")
        return

    # Plotting
    plt.figure(figsize=(6, 1.5 * len(group_speeds)))

    for idx, (label, speeds) in enumerate(group_speeds):
        ax = plt.subplot(len(group_speeds), 1, idx + 1)
        
        sns.kdeplot(speeds, ax=ax, fill=True, linewidth=2, color=f"C{idx}")
       
        ax.set_ylabel(label, weight='bold')
        ax.set_xlim(0, 10)
        ax.grid(True, axis='x', linestyle='--', alpha=0.5)
        ax.tick_params(axis='both', direction='out', length=6, width=2)
        ax.spines['left'].set_linewidth(2)
        ax.spines['bottom'].set_linewidth(2)
        ax.spines['top'].set_visible(False)
        ax.spines['right'].set_visible(False)
        ax.set_yticks([])

        if idx == len(group_speeds) - 1:
            ax.set_xlabel('Speed (cm/s)', weight='bold')
        else:
            ax.set_xticklabels([])

    plt.suptitle('Speed Distribution by Group', weight='bold', fontsize=14)
    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    plt.show()
    

import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from scipy.stats import wilcoxon, mannwhitneyu
from collections import defaultdict
import matplotlib.cm as cm

def compare_threshold_speed(datasets, experiment_key_groups, threshold, 
                              legend=False, mouse_list=None, paired=False, groups=None):
    """
    Compare the amount of time mice spend below a speed threshold across different groups.

    Parameters
    ----------
    datasets : dict
        Dataset containing behavioral data with 'SmoothedSpeed' fields.
    experiment_key_groups : list of list of str
        Each sublist contains experiment keys for one group.
    threshold : float
        Speed threshold to compare (e.g., 2.0 cm/s).
    legend : bool
        Whether to show mouse IDs 
    mouse_list : list of int or None
        If provided, only includes data from these mice.
    paired : bool
        Whether to perform paired statistical tests.
    """
    grouped_data = defaultdict(lambda: defaultdict(list))
    all_mouse_ids = set()

    for group_id, experiment_keys in enumerate(experiment_key_groups):
        for exp_key in experiment_keys:
            if exp_key not in datasets:
                print(f"[Warning] Experiment key '{exp_key}' not in datasets.")
                continue

            data = datasets[exp_key].get('data', {})
            for mouse_id in data:
                if mouse_list and mouse_id not in mouse_list:
                    continue
                for date in data[mouse_id]:
                    entry = data[mouse_id][date]
                    speed_tsd = entry.get('SmoothedSpeed', None)
                    if speed_tsd is None:
                        continue

                    smoothed_speed_data = np.asarray(speed_tsd.values)
                    smoothed_speed_time = np.asarray(speed_tsd.t)
                    if smoothed_speed_data.size == 0:
                        continue

                    # time_below_thresh = np.sum(smoothed_speed_data < threshold)
                    dt = np.median(np.diff(smoothed_speed_time)) / 1e4  # time step in seconds
                    time_below_thresh = np.sum(smoothed_speed_data < threshold) * dt
                    grouped_data['BelowThresholdTime'][group_id].append((mouse_id, time_below_thresh))
                    all_mouse_ids.add(mouse_id)

    # Assign consistent colors per mouse
    cmap = plt.colormaps.get_cmap('tab20')
    colors = [cmap(i % 20) for i in range(len(all_mouse_ids))]
    mouse_color_map = {mouse_id: colors[i] for i, mouse_id in enumerate(all_mouse_ids)}

    # Plotting
    variable = f'Time Below {threshold} cm/s'
    num_zones = len(grouped_data)
    fig, axes = plt.subplots(1, num_zones, figsize=(6 * num_zones, 6), squeeze=False)

    for idx, (zone, group_values) in enumerate(grouped_data.items()):
        ax = axes[0, idx]
        group_data = []
        labels = []

        if paired:
            paired_data = {}
            for group_id, values in group_values.items():
                mouse_dict = dict(values)
                for mouse_id, val in mouse_dict.items():
                    if mouse_id not in paired_data:
                        paired_data[mouse_id] = {}
                    paired_data[mouse_id][group_id] = val

            aligned = []
            mouse_ids = []
            for mouse_id, group_vals in paired_data.items():
                if len(group_vals) == len(experiment_key_groups):
                    aligned.append([group_vals[g] for g in range(len(experiment_key_groups))])
                    mouse_ids.append(mouse_id)
            aligned = np.array(aligned)

            if paired and aligned.size == 0:
                print(f"[Warning] No shared mice found across all groups for zone: {zone}")

            if aligned.size == 0:
                ax.set_title(f"{zone} (No shared mice)")
                continue

            for g in range(len(experiment_key_groups)):
                group_data.append(aligned[:, g])
                labels.append(f'Group {g + 1}') if legend else None

            sns.boxplot(data=group_data, ax=ax, palette="pastel")
            for g in range(len(group_data)):
                for i, val in enumerate(group_data[g]):
                    mouse_id = mouse_ids[i]
                    color = 'k' if not legend else mouse_color_map.get(mouse_id, 'k')
                    ax.plot(g, val, 'o', color=color, alpha=0.6, label=str(mouse_id) if legend else None)

            if legend:
                handles = []
                seen = set()
                for mouse_id in mouse_ids:
                    if mouse_id not in seen:
                        handles.append(plt.Line2D([0], [0], marker='o', linestyle='', color=mouse_color_map[mouse_id], label=str(mouse_id)))
                        seen.add(mouse_id)
                ax.legend(handles=handles, title='Mouse ID', bbox_to_anchor=(1.05, 1), loc='upper left')

            # Use custom group names if provided
            if groups and len(groups) == len(experiment_key_groups):
                labels = groups
            else:
                labels = [f'Group {g + 1}' for g in range(len(experiment_key_groups))]
    
            # Clean up axes for a minimalist look
            ax.spines['right'].set_visible(False)
            ax.spines['top'].set_visible(False)
            ax.yaxis.set_tick_params(labelsize=12)
            ax.xaxis.set_tick_params(labelsize=12)

            ax.set_xticks(range(len(labels)))
            ax.set_xticklabels(labels)
            ax.set_ylabel("Timepoints below threshold")
            ax.set_title(f"{variable} (Paired)")

            for g in range(1, len(experiment_key_groups)):
                stat, p = wilcoxon(aligned[:, 0], aligned[:, g])
                ax.text(g, np.nanmax(aligned) * 0.95, f'p={p:.3f}', ha='center', fontsize=10, color='red')

        else:
            all_data = []
            mouse_ids_all = []
            for group_id in range(len(experiment_key_groups)):
                values = [(mouse_id, val) for mouse_id, val in group_values[group_id] if not np.isnan(val)]
                group_data.append([val for _, val in values])
                mouse_ids_all.append([mouse_id for mouse_id, _ in values])
                labels.append(f'Group {group_id + 1}') if legend else None
                all_data.append([val for _, val in values])

            sns.boxplot(data=group_data, ax=ax, palette='pastel')
            for g in range(len(group_data)):
                for i, val in enumerate(group_data[g]):
                    mouse_id = mouse_ids_all[g][i]
                    color = 'k' if not legend else mouse_color_map.get(mouse_id, 'k')
                    ax.plot(g, val, 'o', color=color, alpha=0.6, label=str(mouse_id) if legend else None)

            if legend:
                handles = []
                seen = set()
                for group_mice in mouse_ids_all:
                    for mouse_id in group_mice:
                        if mouse_id not in seen:
                            handles.append(plt.Line2D([0], [0], marker='o', linestyle='', color=mouse_color_map[mouse_id], label=str(mouse_id)))
                            seen.add(mouse_id)
                ax.legend(handles=handles, title='Mouse ID', bbox_to_anchor=(1.05, 1), loc='upper left')

            # Use custom group names if provided
            if groups and len(groups) == len(experiment_key_groups):
                labels = groups
            else:
                labels = [f'Group {g + 1}' for g in range(len(experiment_key_groups))]

            # Clean up axes for a minimalist look
            ax.spines['right'].set_visible(False)
            ax.spines['top'].set_visible(False)
            ax.yaxis.set_tick_params(labelsize=12)
            ax.xaxis.set_tick_params(labelsize=12)

            ax.set_xticks(range(len(labels)))
            ax.set_xticklabels(labels)
            ax.set_ylabel("Timepoints below threshold")
            ax.set_title(f"{variable} (Unpaired)")

            for g in range(1, len(experiment_key_groups)):
                try:
                    stat, p = mannwhitneyu(all_data[0], all_data[g], alternative='two-sided')
                    ax.text(g, np.nanmax(np.concatenate(all_data)) * 0.95, f'p={p:.3f}', ha='center', fontsize=10, color='blue')
                except ValueError:
                    ax.text(g, 0.5, 'No data', ha='center', fontsize=10, color='gray')

    plt.tight_layout()
    plt.show()
    

import numpy as np
# import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import wilcoxon, mannwhitneyu
from collections import defaultdict

def plot_compare_maze_results(datasets, experiment_key_groups, variable, 
                                 paired=False, legend=False, groups=None):
    """
    Plot comparisons of behavioral variables between groups of experiment keys from maze data.

    Parameters
    ----------
    datasets : dict
        The full dataset dictionary containing 'data' fields for each experiment key.
    experiment_key_groups : list of list of str
        Each sublist contains experiment keys that form one group for comparison.
    variable : str
        Variable to compare: 'MeanSpeed', 'MeanDistance', 'TraveledDistance', 'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'.
    paired : bool, optional
        If True, performs paired Wilcoxon test (default). If False, performs unpaired Mann-Whitney U test.
    legend : bool, optional
        If True, adds a legend linking each dot to a mouse ID.
    """
    # assert variable in ['MeanSpeed', 'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'], \
    #     "Variable must be one of: 'MeanSpeed', 'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'"
    assert variable in ['MeanSpeed', 'MeanDistance', 'TraveledDistance', 'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'], \
        "Variable must be one of: 'MeanSpeed', 'MeanDistance', 'TraveledDistance', 'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'"

    grouped_data = defaultdict(lambda: defaultdict(list))  # {zone -> {group_id -> [(mouse_id, value)]}}

    for group_id, keys in enumerate(experiment_key_groups):
        for key in keys:
            if key not in datasets:
                raise KeyError(f"[Warning] Experiment key '{key}' not in datasets.")
                continue
            data_dict = datasets[key].get('data', {})
            for mouse_id, date_dict in data_dict.items():
                for session_data in date_dict.values():
                    # if variable == 'MeanSpeed':
                    #     grouped_data['MeanSpeed'][group_id].append((mouse_id, session_data['MeanSpeed']))
                    if variable in ['MeanSpeed', 'MeanDistance', 'TraveledDistance']:
                        val = session_data.get(variable, np.nan)
                        grouped_data[variable][group_id].append((mouse_id, val))
                    else:
                        total_entries= []
                        for zone, zone_data in session_data['Zones'].items():
                            # Raw data
                            if variable == 'NumZoneEntries':
                                value = zone_data['NumEntries']
                            elif variable == 'ZoneOccupation':
                                value = zone_data['TotalTime']
                            elif variable == 'DurationZoneEntries':
                                value = zone_data['MeanDuration']
                            # Proportions
                            # if variable == 'NumZoneEntries': #proportion of entries
                            #     total_entries = sum(z['NumEntries'] for z in session_data['Zones'].values())
                            #     value = zone_data['NumEntries']/total_entries
                            # elif variable == 'ZoneOccupation':
                            #     total_time_all_zones = session_data.get('TotalTimeAllZones', np.nan)
                            #     zone_time = zone_data.get('TotalTime', np.nan)
                            #     value = (zone_time / total_time_all_zones * 100) if total_time_all_zones and not np.isnan(zone_time) else np.nan
                            # elif variable == 'DurationZoneEntries':
                            #     total_time_all_zones = session_data.get('TotalTimeAllZones', np.nan)
                            #     mean_duration = zone_data.get('MeanDuration', np.nan)
                            #     value = (mean_duration / total_time_all_zones * 100) if total_time_all_zones and not np.isnan(mean_duration) else np.nan
                            
                            grouped_data[zone][group_id].append((mouse_id, value))

    # Build global color map of unique mouse IDs
    all_mouse_ids = set()
    for zone_data in grouped_data.values():
        for group_values in zone_data.values():
            all_mouse_ids.update([mouse_id for mouse_id, _ in group_values])
    all_mouse_ids = sorted(all_mouse_ids)
    color_palette = sns.color_palette("tab20", len(all_mouse_ids))
    mouse_color_map = {mouse_id: color_palette[i] for i, mouse_id in enumerate(all_mouse_ids)}

    # Plotting
    num_zones = len(grouped_data) if variable not in ['MeanSpeed', 'MeanDistance', 'TraveledDistance'] else 1
    fig, axes = plt.subplots(1, num_zones, figsize=(4 * num_zones, 5), squeeze=False)

    for idx, (zone, group_values) in enumerate(grouped_data.items()):
        ax = axes[0, idx]
        group_data = []
        labels = []

        if paired:
            paired_data = {}
            for group_id, values in group_values.items():
                mouse_dict = dict(values)
                for mouse_id, val in mouse_dict.items():
                    if mouse_id not in paired_data:
                        paired_data[mouse_id] = {}
                    paired_data[mouse_id][group_id] = val

            aligned = []
            mouse_ids = []
            for mouse_id, group_vals in paired_data.items():
                if len(group_vals) == len(experiment_key_groups):
                    aligned.append([group_vals[g] for g in range(len(experiment_key_groups))])
                    mouse_ids.append(mouse_id)
            aligned = np.array(aligned)
            
            if paired and aligned.size == 0:
                print(f"[Warning] No shared mice found across all groups for zone: {zone}")

            if aligned.size == 0:
                ax.set_title(f"{zone} (No shared mice)")
                continue

            for g in range(len(experiment_key_groups)):
                group_data.append(aligned[:, g])
                labels.append(f'Group {g + 1}')

            # Plot box and individual mouse dots
            sns.boxplot(data=group_data, ax=ax, palette="pastel")
            for g in range(len(group_data)):
                for i, val in enumerate(group_data[g]):
                    mouse_id = mouse_ids[i]
                    # color = mouse_color_map.get(mouse_id, 'k')
                    color = 'k' if not legend else mouse_color_map.get(mouse_id, 'k')
                    ax.plot(g, val, 'o', color=color, alpha=0.6, label=str(mouse_id) if legend else None)

            if legend:
                handles = []
                seen = set()
                for mouse_id in mouse_ids:
                    if mouse_id not in seen:
                        handles.append(plt.Line2D([0], [0], marker='o', linestyle='', color=mouse_color_map[mouse_id], label=str(mouse_id)))
                        seen.add(mouse_id)
                ax.legend(handles=handles, title='Mouse ID', bbox_to_anchor=(1.05, 1), loc='upper left')

            # Use custom group names if provided
            if groups and len(groups) == len(experiment_key_groups):
                labels = groups
            else:
                labels = [f'Group {g + 1}' for g in range(len(experiment_key_groups))]

            # Clean up axes for a minimalist look
            ax.spines['right'].set_visible(False)
            ax.spines['top'].set_visible(False)
            ax.yaxis.set_tick_params(labelsize=12)
            ax.xaxis.set_tick_params(labelsize=12)
            ax.set_xticks(range(len(labels)))
            ax.set_xticklabels(labels)
            ax.set_ylabel(variable)
            # ax.set_title(f"{zone if variable != 'MeanSpeed' else 'MeanSpeed'} (Paired)")
            ax.set_title(f"{zone if variable not in ['MeanSpeed', 'MeanDistance', 'TraveledDistance'] else variable} (Paired)")

            for g in range(1, len(experiment_key_groups)):
                stat, p = wilcoxon(aligned[:, 0], aligned[:, g])
                ax.text(g, np.nanmax(aligned) * 0.95, f'p={p:.3f}', ha='center', fontsize=10, color='red')

        else:
            all_data = []
            mouse_ids_all = []
            for group_id in range(len(experiment_key_groups)):
                values = [(mouse_id, val) for mouse_id, val in group_values[group_id] if not np.isnan(val)]
                group_data.append([val for _, val in values])
                mouse_ids_all.append([mouse_id for mouse_id, _ in values])
                labels.append(f'Group {group_id + 1}')
                all_data.append([val for _, val in values])

            sns.boxplot(data=group_data, ax=ax, palette="pastel")
            for g in range(len(group_data)):
                for i, val in enumerate(group_data[g]):
                    mouse_id = mouse_ids_all[g][i]
                    # color = mouse_color_map.get(mouse_id, 'k')
                    color = 'k' if not legend else mouse_color_map.get(mouse_id, 'k')
                    ax.plot(g, val, 'o', color=color, alpha=0.6, label=str(mouse_id) if legend else None)

            if legend:
                handles = []
                seen = set()
                for group_mice in mouse_ids_all:
                    for mouse_id in group_mice:
                        if mouse_id not in seen:
                            handles.append(plt.Line2D([0], [0], marker='o', linestyle='', color=mouse_color_map[mouse_id], label=str(mouse_id)))
                            seen.add(mouse_id)
                ax.legend(handles=handles, title='Mouse ID', bbox_to_anchor=(1.05, 1), loc='upper left')

            # Use custom group names if provided
            if groups and len(groups) == len(experiment_key_groups):
                labels = groups
            else:
                labels = [f'Group {g + 1}' for g in range(len(experiment_key_groups))]

            # Clean up axes for a minimalist look
            ax.spines['right'].set_visible(False)
            ax.spines['top'].set_visible(False)
            ax.yaxis.set_tick_params(labelsize=12)
            ax.xaxis.set_tick_params(labelsize=12)
            ax.set_xticks(range(len(labels)))
            ax.set_xticklabels(labels)
            ax.set_ylabel(variable)
            # ax.set_title(f"{zone if variable != 'MeanSpeed' else 'MeanSpeed'} (Unpaired)")
            ax.set_title(f"{zone if variable not in ['MeanSpeed', 'MeanDistance', 'TraveledDistance'] else variable} (Unpaired)")

            for g in range(1, len(experiment_key_groups)):
                try:
                    stat, p = mannwhitneyu(all_data[0], all_data[g], alternative='two-sided')
                    ax.text(g, np.nanmax(np.concatenate(all_data)) * 0.95, f'p={p:.3f}', ha='center', fontsize=10, color='blue')
                except ValueError:
                    ax.text(g, 0.5, 'No data', ha='center', fontsize=10, color='gray')

    plt.tight_layout()
    plt.show()


# import numpy as np
# import matplotlib.pyplot as plt
# import seaborn as sns
# from scipy.stats import wilcoxon, mannwhitneyu
# from collections import defaultdict

# def plot_compare_maze_results(datasets, experiment_key_groups, variable, paired=True):
#     """
#     Plot comparisons of behavioral variables between groups of experiment keys from maze data.

#     Parameters
#     ----------
#     datasets : dict
#         The full dataset dictionary containing 'data' fields for each experiment key.
#     experiment_key_groups : list of list of str
#         Each sublist contains experiment keys that form one group for comparison.
#     variable : str
#         Variable to compare: 'MeanSpeed', 'NumZoneEntries', 'ZoneOccupation', or 'DurationZoneEntries'.
#     paired : bool, optional
#         If True, performs paired Wilcoxon test (default). If False, performs unpaired Mann-Whitney U test.
#     """
#     assert variable in ['MeanSpeed', 'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'], \
#         "Variable must be one of: 'MeanSpeed', 'NumZoneEntries', 'ZoneOccupation', 'DurationZoneEntries'"

#     grouped_data = defaultdict(lambda: defaultdict(list))  # {zone -> {group_id -> [(mouse_id, value)]}}

#     for group_id, keys in enumerate(experiment_key_groups):
#         for key in keys:
#             if key not in datasets:
#                 continue
#             data_dict = datasets[key].get('data', {})
#             for mouse_id, date_dict in data_dict.items():
#                 for session_data in date_dict.values():
#                     if variable == 'MeanSpeed':
#                         grouped_data['MeanSpeed'][group_id].append((mouse_id, session_data['MeanSpeed']))
#                     else:
#                         for zone, zone_data in session_data['Zones'].items():
#                             if variable == 'NumZoneEntries':
#                                 value = zone_data['NumEntries']
#                             elif variable == 'ZoneOccupation':
#                                 value = zone_data['TotalTime']
#                             elif variable == 'DurationZoneEntries':
#                                 value = zone_data['MeanDuration']
#                             grouped_data[zone][group_id].append((mouse_id, value))

#     # Plotting
#     num_zones = len(grouped_data) if variable != 'MeanSpeed' else 1
#     fig, axes = plt.subplots(1, num_zones, figsize=(6 * num_zones, 6), squeeze=False)

#     for idx, (zone, group_values) in enumerate(grouped_data.items()):
#         ax = axes[0, idx]
#         group_data = []
#         labels = []

#         if paired:
#             # Prepare aligned data per mouse across groups
#             paired_data = {}
#             for group_id, values in group_values.items():
#                 mouse_dict = dict(values)
#                 for mouse_id, val in mouse_dict.items():
#                     if mouse_id not in paired_data:
#                         paired_data[mouse_id] = {}
#                     paired_data[mouse_id][group_id] = val

#             aligned = []
#             for mouse_id, group_vals in paired_data.items():
#                 if len(group_vals) == len(experiment_key_groups):  # Only mice present in all groups
#                     aligned.append([group_vals[g] for g in range(len(experiment_key_groups))])
#             aligned = np.array(aligned)

#             if aligned.size == 0:
#                 ax.set_title(f"{zone} (No shared mice)")
#                 continue

#             for g in range(len(experiment_key_groups)):
#                 group_data.append(aligned[:, g])
#                 labels.append(f'Group {g + 1}')

#             # Plot
#             sns.boxplot(data=group_data, ax=ax, palette="pastel")
#             sns.swarmplot(data=group_data, ax=ax, color='k', alpha=0.6)
#             ax.set_xticks(range(len(labels)))
#             ax.set_xticklabels(labels)
#             ax.set_ylabel(variable)
#             ax.set_title(f"{zone if variable != 'MeanSpeed' else 'MeanSpeed'} (Paired)")

#             for g in range(1, len(experiment_key_groups)):
#                 stat, p = wilcoxon(aligned[:, 0], aligned[:, g])
#                 ax.text(g, np.nanmax(aligned) * 0.95, f'p={p:.3f}', ha='center', fontsize=10, color='red')

#         else:
#             # Unpaired mode — directly collect values per group
#             all_data = []
#             for group_id in range(len(experiment_key_groups)):
#                 values = [val for _, val in group_values[group_id] if not np.isnan(val)]
#                 group_data.append(values)
#                 labels.append(f'Group {group_id + 1}')
#                 all_data.append(values)

#             # Plot
#             sns.boxplot(data=group_data, ax=ax, palette="pastel")
#             sns.swarmplot(data=group_data, ax=ax, color='k', alpha=0.6)
#             ax.set_xticks(range(len(labels)))
#             ax.set_xticklabels(labels)
#             ax.set_ylabel(variable)
#             ax.set_title(f"{zone if variable != 'MeanSpeed' else 'MeanSpeed'} (Unpaired)")

#             for g in range(1, len(experiment_key_groups)):
#                 try:
#                     stat, p = mannwhitneyu(all_data[0], all_data[g], alternative='two-sided')
#                     ax.text(g, np.nanmax(np.concatenate(all_data)) * 0.95, f'p={p:.3f}', ha='center', fontsize=10, color='blue')
#                 except ValueError:
#                     ax.text(g, 0.5, f'No data', ha='center', fontsize=10, color='gray')

#     plt.tight_layout()
#     plt.show()




# import numpy as np
# import matplotlib.pyplot as plt
# from mpl_toolkits.mplot3d import Axes3D  # Required for 3D plotting

# def plot_centered_maze_surface(datasets, list_of_experiment_key_groups, maze_type='EPM', bins=100, pad=10):
#     """
#     Plot a 3D surface of the 2D histogram (density) of centered maze trajectories for each group of experiment keys.

#     Parameters:
#     - datasets: dict with structure [experiment_key]['data'][mouse_id][date]
#     - list_of_experiment_key_groups: list of lists of experiment keys
#     - maze_type: str ('EPM' or 'OF') for annotation
#     - bins: number of bins for the histogram
#     - pad: padding around the coordinate range
#     """
#     for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
#         all_x, all_y = [], []

#         for exp_key in experiment_keys:
#             if exp_key not in datasets:
#                 print(f"Experiment key '{exp_key}' not found.")
#                 continue

#             for mouse_id, dates in datasets[exp_key]['data'].items():
#                 for date, entry in dates.items():
#                     x = entry.get('CenteredXtsd', None)
#                     y = entry.get('CenteredYtsd', None)

#                     if x is None or y is None:
#                         print(f"Missing centered data for mouse {mouse_id} on {date} in {exp_key}.")
#                         continue

#                     x = np.asarray(x)
#                     y = np.asarray(y)
#                     if x.size == 0 or y.size == 0:
#                         continue

#                     all_x.append(x)
#                     all_y.append(y)

#         if not all_x or not all_y:
#             print(f"No data for group {group_index + 1}")
#             continue

#         all_x = np.concatenate(all_x)
#         all_y = np.concatenate(all_y)

#         valid = np.isfinite(all_x) & np.isfinite(all_y)
#         all_x = all_x[valid]
#         all_y = all_y[valid]

#         if all_x.size == 0:
#             print(f"No valid data for group {group_index + 1}")
#             continue

#         # Define histogram range with padding
#         x_min, x_max = all_x.min() - pad, all_x.max() + pad
#         y_min, y_max = all_y.min() - pad, all_y.max() + pad

#         # Compute 2D histogram
#         heatmap, xedges, yedges = np.histogram2d(all_x, all_y, bins=bins, range=[[x_min, x_max], [y_min, y_max]])
#         # heatmap = (heatmap - heatmap.mean()) / heatmap.std() # z-score
#         # heatmap = (heatmap - heatmap.min()) / (heatmap.max() - heatmap.min()) # min max norm
#         heatmap = np.log1p(heatmap)

#         # Create grid for 3D surface
#         X, Y = np.meshgrid((yedges[:-1] + yedges[1:]) / 2,
#                            (xedges[:-1] + xedges[1:]) / 2)

#         fig = plt.figure(figsize=(10, 8))
#         ax = fig.add_subplot(111, projection='3d')

#         surf = ax.plot_surface(
#             X, Y, heatmap,
#             cmap='YlOrRd',
#             edgecolor='none',
#             rstride=1,
#             cstride=1,
#             antialiased=True
#         )

#         ax.set_xlabel('Y (centered)')
#         ax.set_ylabel('X (centered)')
#         ax.set_zlabel('Visit Count')
#         ax.set_title(f'{maze_type} 3D Density Surface - Group {group_index + 1}')
#         fig.colorbar(surf, ax=ax, shrink=0.5, aspect=10, label='Visit Count')
#         plt.tight_layout()
#         plt.show()



# import matplotlib.pyplot as plt

# def plot_centered_maze_trajectories(datasets, list_of_experiment_key_groups, maze_type='EPM', legend=False):
#     """
#     Plot centered maze trajectories for each group of experiment keys separately.

#     Parameters:
#     - datasets: dict containing maze data with structure [experiment_key]['data'][mouse_id][date]
#     - list_of_experiment_key_groups: list of lists of experiment keys
#       Example: [['TestEPM1', 'TestEPM2'], ['ControlEPM']]
#     - maze_type : str that can be either EPM or OF to adjust plot limits
#     """
#     for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
#         plt.figure(figsize=(8, 8))
#         color_cycle = plt.cm.tab10.colors
#         i = 0

#         for exp_key in experiment_keys:
#             if exp_key not in datasets:
#                 print(f"Experiment key '{exp_key}' not found in datasets.")
#                 continue

#             data = datasets[exp_key]['data']
#             for mouse_id in data:
#                 for date in data[mouse_id]:
#                     entry = data[mouse_id][date]
#                     x = entry.get('CenteredXtsd', None)
#                     y = entry.get('CenteredYtsd', None)

#                     if x is None or y is None:
#                         print(f"Missing centered data for mouse {mouse_id} on {date} in {exp_key}.")
#                         continue

#                     label = f"{exp_key} - {mouse_id} - {date}"
#                     color = color_cycle[i % len(color_cycle)]
#                     plt.plot(y, x, markersize=1, alpha=0.6, label=label, color=color)
#                     i += 1

#         plt.axhline(0, linestyle='--', color='gray')
#         plt.axvline(0, linestyle='--', color='gray')
#         plt.xlabel('Y (centered)')
#         plt.ylabel('X (centered)')
#         if maze_type == 'EPM':
#             plt.xlim(-100, 100)
#             plt.ylim(-100, 100)
#         elif maze_type == 'OF':
#             plt.xlim(-40, 40)
#             plt.ylim(-40, 40)
#         else:
#             print("maze_type should be 'EPM' or 'OF'")
#         # plt.title(f'Centered {maze_type} Trajectories - {exp_key}')
#         group_label = ', '.join(experiment_keys)
#         plt.title(f'Centered {maze_type} Density - Group {group_index + 1} ({group_label})')
#         plt.grid(True)
#         if legend == True:
#             plt.legend(fontsize='small', markerscale=4, loc='best')
#         plt.tight_layout()
#         plt.show()


# import matplotlib.pyplot as plt
# import numpy as np

# def plot_distance_over_time(datasets, list_of_experiment_key_groups,
#                             legend=False, mouse_list=None,
#                             plot_mean=False):
#     """
#     Plot distance from center over time for each group of experiments.

#     Parameters
#     ----------
#     datasets : dict
#         Dataset containing behavioral data with 'DistanceTsd' fields.
#     list_of_experiment_key_groups : list of list of str
#         Each sublist contains experiment keys for one group.
#     legend : bool
#         If True, shows a legend with mouse IDs.
#     mouse_list : list or None
#         If provided, only plots mice in this list.
#     plot_mean : bool
#         If True, plots the mean distance over time with a shaded area (std).
#     """
#     color_cycle = plt.cm.tab10.colors

#     for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
#         fig, ax = plt.subplots(1, 1, figsize=(10, 4))

#         all_time = []
#         all_distances = []
#         i = 0

#         for exp_key in experiment_keys:
#             if exp_key not in datasets:
#                 print(f"[Warning] Experiment key '{exp_key}' not in datasets.")
#                 continue
#             data = datasets[exp_key].get('data', {})
#             for mouse_id in data:
#                 if mouse_list and mouse_id not in mouse_list:
#                     continue
#                 for date in data[mouse_id]:
#                     entry = data[mouse_id][date]
#                     tsd = entry.get('DistanceTsd', None)
#                     if tsd is None:
#                         continue
#                     try:
#                         time = np.asarray(tsd.t) / 1e4  # Convert to seconds
#                         values = np.asarray(tsd.values)
#                     except AttributeError:
#                         continue

#                     if plot_mean:
#                         all_time.append(time)
#                         all_distances.append(values)
#                     else:
#                         label = f"{mouse_id}" if legend else None
#                         ax.plot(time, values,
#                                 color=color_cycle[i % len(color_cycle)],
#                                 linewidth=1.5, alpha=0.8,
#                                 label=label)
#                         i += 1

#         if plot_mean and all_distances:
#             # Interpolate to common time vector
#             min_end = min([t[-1] for t in all_time])
#             max_start = max([t[0] for t in all_time])
#             common_time = np.linspace(max_start, min_end, 1000)
#             interp_dists = []
#             for t, d in zip(all_time, all_distances):
#                 valid = ~np.isnan(d)
#                 if valid.sum() > 10:
#                     interp = np.interp(common_time, t[valid], d[valid])
#                     interp_dists.append(interp)
#             if interp_dists:
#                 interp_dists = np.array(interp_dists)
#                 mean_dist = np.nanmean(interp_dists, axis=0)
#                 std_dist = np.nanstd(interp_dists, axis=0)
#                 ax.plot(common_time, mean_dist, color='black', linewidth=2, label='Mean Distance')
#                 ax.fill_between(common_time, mean_dist - std_dist, mean_dist + std_dist,
#                                 color='gray', alpha=0.3, label='±1 SD')

#         ax.set_ylabel("Distance from center", weight='bold')
#         ax.set_ylim(0, 40)
#         ax.set_xlabel("Time (s)", weight='bold')
#         group_label = ', '.join(experiment_keys)
#         ax.set_title(f"Distance from Center Over Time - Group {group_index + 1} ({group_label})")
#         ax.grid(True)
#         if legend:
#             ax.legend(fontsize='small')
#         plt.tight_layout()
#         plt.show()

