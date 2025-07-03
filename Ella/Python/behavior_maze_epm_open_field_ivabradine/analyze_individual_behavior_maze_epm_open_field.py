#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 18 11:00:42 2025

@author: gruffalo
"""

import matplotlib.pyplot as plt
import numpy as np

def plot_position_maze_across_time(datasets, list_of_experiment_key_groups,
                                   legend=False, mouse_list=None, axs=None):
    for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
        if axs is None:
            fig, axs = plt.subplots(3, 1, figsize=(10, 7), sharex=True)

        color_cycle = plt.cm.tab10.colors
        i = 0
        for exp_key in experiment_keys:
            if exp_key not in datasets:
                continue
            data = datasets[exp_key]['data']
            for mouse_id in data:
                if mouse_list and mouse_id not in mouse_list:
                    continue
                for date in data[mouse_id]:
                    entry = data[mouse_id][date]
                    speed_tsd = entry.get('Speed', None)
                    if speed_tsd is None:
                        continue
                    try:
                        time = np.asarray(speed_tsd.t) / 1e4
                        speed_values = np.asarray(speed_tsd.data)
                    except AttributeError:
                        continue
                    axs[2].plot(time, speed_values, color=color_cycle[i % len(color_cycle)], linewidth=1.5, alpha=0.8)

                    for idx, axis in enumerate(['X', 'Y']):
                        tsd = entry.get(f'Centered{axis}tsd')
                        if tsd is None:
                            continue
                        values = np.asarray(tsd)
                        if len(values) != len(time) + 1:
                            continue
                        aligned_values = values[:-1]
                        axs[idx].plot(time, aligned_values, color=color_cycle[i % len(color_cycle)], linewidth=1.5, alpha=0.8)

                    i += 1

        for j, label in enumerate(['X (centered)', 'Y (centered)', 'Speed (cm/s)']):
            axs[j].set_ylabel(label, weight='bold')
            axs[j].grid(True)
        axs[2].set_xlabel('Time (s)', weight='bold')
        axs[0].set_ylim(-100,100)
        axs[1].set_ylim(-100,100)
        axs[2].set_ylim(0,90)
        if legend:
            axs[0].legend(fontsize='small')

import matplotlib.pyplot as plt
import numpy as np
from scipy.ndimage import uniform_filter1d

def plot_distance_and_speed_over_time(datasets, list_of_experiment_key_groups,
                                      legend=False, mouse_list=None, axs=None,
                                      smoothing_window_s=None):
    """
    Plot distance from center and speed over time for one or more mice in each group.

    Parameters
    ----------
    datasets : dict
        Dataset containing behavioral data with 'DistanceTsd' and 'SpeedTsd' fields.
    list_of_experiment_key_groups : list of list of str
        Each sublist contains experiment keys for one group.
    legend : bool
        If True, shows a legend with mouse IDs.
    mouse_list : list or None
        If provided, only plots mice in this list.
    axs : tuple of matplotlib axes or None
        If provided, plots on these axes instead of creating new ones.
    smoothing_window_s : float or None
        Smoothing window in seconds. If provided, smooths the distance and speed traces.
    """
    color_cycle = plt.cm.tab10.colors

    for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
        if axs is None:
            fig, axs_group = plt.subplots(2, 1, figsize=(12, 6), sharex=True)
        else:
            axs_group = axs

        ax_dist, ax_speed = axs_group
        color_index = 0

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
                    dist_tsd = entry.get('DistanceTsd', None)
                    speed_tsd = entry.get('Speed', None)

                    if dist_tsd is None or speed_tsd is None:
                        continue

                    try:
                        time_d = np.asarray(dist_tsd.t)
                        dist_values = np.asarray(dist_tsd.values)
                        time_s = np.asarray(speed_tsd.t) / 1e4
                        speed_values = np.asarray(speed_tsd.data)
                    except AttributeError:
                        continue

                    # Apply smoothing if requested
                    if smoothing_window_s is not None:
                        # Estimate sampling intervals
                        dt_dist = np.median(np.diff(time_d))
                        dt_speed = np.median(np.diff(time_s))

                        # Convert window in seconds to number of samples
                        win_dist = max(1, int(smoothing_window_s / dt_dist))
                        win_speed = max(1, int(smoothing_window_s / dt_speed))

                        dist_values = uniform_filter1d(dist_values, size=win_dist)
                        speed_values = uniform_filter1d(speed_values, size=win_speed)

                    label = f"{mouse_id}" if legend else None
                    color = color_cycle[color_index % len(color_cycle)]
                    color_index += 1

                    ax_dist.plot(time_d, dist_values, color=color, linewidth=1.5, alpha=0.8, label=label)
                    ax_speed.plot(time_s, speed_values, color=color, linewidth=1.5, alpha=0.8)

        if axs is None:
            ax_dist.set_title(f"Distance Trace - Group {group_index + 1}")
            ax_speed.set_title(f"Speed Trace - Group {group_index + 1}")
            fig.suptitle(f"Distance and Speed Over Time - Group {group_index + 1}", weight='bold')
            plt.tight_layout()
            plt.show()

        ax_dist.set_ylabel("Distance from center", weight='bold')
        ax_speed.set_ylabel("Speed (cm/s)", weight='bold')
        ax_speed.set_xlabel("Time (s)", weight='bold')
        ax_dist.set_ylim(0, 40)
        ax_speed.set_ylim(0, 20) if smoothing_window_s else ax_speed.set_ylim(0, 90)
        ax_dist.grid(True)
        ax_speed.grid(True)
        if legend:
            ax_dist.legend(fontsize='small')


# import matplotlib.pyplot as plt
# import numpy as np

# def plot_distance_and_speed_over_time(datasets, list_of_experiment_key_groups,
#                                       legend=False, mouse_list=None, axs=None):
#     """
#     Plot distance from center and speed over time for one or more mice in each group.

#     Parameters
#     ----------
#     datasets : dict
#         Dataset containing behavioral data with 'DistanceTsd' and 'SpeedTsd' fields.
#     list_of_experiment_key_groups : list of list of str
#         Each sublist contains experiment keys for one group.
#     legend : bool
#         If True, shows a legend with mouse IDs.
#     mouse_list : list or None
#         If provided, only plots mice in this list.
#     """
#     color_cycle = plt.cm.tab10.colors

#     for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
#         if axs is None:
#             fig, axs_group = plt.subplots(2, 1, figsize=(12, 6), sharex=True)
#         else:
#             axs_group = axs

#         ax_dist, ax_speed = axs_group
#         color_index = 0

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
#                     dist_tsd = entry.get('DistanceTsd', None)
#                     speed_tsd = entry.get('Speed', None)

#                     if dist_tsd is None or speed_tsd is None:
#                         continue

#                     try:
#                         time_d = np.asarray(dist_tsd.t)
#                         dist_values = np.asarray(dist_tsd.values)
#                         time_s = np.asarray(speed_tsd.t) / 1e4
#                         speed_values = np.asarray(speed_tsd.data)
#                     except AttributeError:
#                         continue

#                     label = f"{mouse_id}" if legend else None
#                     color = color_cycle[color_index % len(color_cycle)]
#                     color_index += 1

#                     ax_dist.plot(time_d, dist_values, color=color, linewidth=1.5, alpha=0.8, label=label)
#                     ax_speed.plot(time_s, speed_values, color=color, linewidth=1.5, alpha=0.8)

#         if axs is None:
#             ax_dist.set_title(f"Distance Trace - Group {group_index + 1}")
#             ax_speed.set_title(f"Speed Trace - Group {group_index + 1}")
#             fig.suptitle(f"Distance and Speed Over Time - Group {group_index + 1}", weight='bold')
#             plt.tight_layout()
#             plt.show()

#         ax_dist.set_ylabel("Distance from center", weight='bold')
#         ax_speed.set_ylabel("Speed (cm/s)", weight='bold')
#         ax_speed.set_xlabel("Time (s)", weight='bold')
#         ax_dist.set_ylim(0, 40)
#         ax_speed.set_ylim(0, 90)
#         ax_dist.grid(True)
#         ax_speed.grid(True)
#         if legend:
#             ax_dist.legend(fontsize='small')


import matplotlib.pyplot as plt

def plot_centered_maze_trajectories(datasets, list_of_experiment_key_groups,
                                    maze_type='EPM', legend=False, mouse_list=None, ax=None):
    for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
        if ax is None:
            fig, ax = plt.subplots(figsize=(6, 6))  # fallback to new figure
        color_cycle = plt.cm.tab10.colors
        i = 0
        for exp_key in experiment_keys:
            if exp_key not in datasets:
                continue
            data = datasets[exp_key]['data']
            for mouse_id in data:
                if mouse_list and mouse_id not in mouse_list:
                    continue
                for date in data[mouse_id]:
                    entry = data[mouse_id][date]
                    x = entry.get('CenteredXtsd')
                    y = entry.get('CenteredYtsd')
                    if x is None or y is None:
                        continue
                    try:
                        x_vals = np.asarray(x.data)
                        y_vals = np.asarray(y.data)
                    except AttributeError:
                        x_vals = np.asarray(x)
                        y_vals = np.asarray(y)
                    label = f"{exp_key} - {mouse_id} - {date}"
                    color = color_cycle[i % len(color_cycle)]
                    ax.plot(y_vals, x_vals, alpha=0.6, color=color, label=label)
                    i += 1

        # ax.axhline(0, linestyle='--', color='gray')
        # ax.axvline(0, linestyle='--', color='gray')
        ax.set_xlabel('Y (centered)', weight='bold')
        ax.set_ylabel('X (centered)', weight='bold')
        ax.set_xlim(-100, 100) if maze_type == 'EPM' else ax.set_xlim(-40, 40)
        ax.set_ylim(-100, 100) if maze_type == 'EPM' else ax.set_ylim(-40, 40)
        ax.grid(True)
        if legend:
            ax.legend(fontsize='small', markerscale=2)


import os

def plot_recap_behavior_mouse(datasets, mouse_id, maze_type='EPM', save_path=None):
    import matplotlib.pyplot as plt

    if maze_type not in ['EPM', 'OF']:
        print("Maze type should be 'EPM' or 'OF'")
        return

    if maze_type == 'EPM':
        fig, axs = plt.subplots(4, 2, figsize=(14, 10), sharex='row')
    else:
        fig, axs = plt.subplots(3, 2, figsize=(14, 10), sharex='row')  # For OF: traj + dist + speed


    # Define experiment groups
    if maze_type == 'EPM':
        saline_keys = [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition']]
        ivabradine_keys = [['EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']]
    else:  # OF
        saline_keys = [['OF_Saline_Exposition', 'OF_Saline_Reexposition']]
        ivabradine_keys = [['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']]

    # Plot Saline
    plot_centered_maze_trajectories(
        datasets, saline_keys, maze_type=maze_type, mouse_list=[mouse_id],
        ax=axs[0, 0]
    )

    if maze_type == 'EPM':
        plot_position_maze_across_time(
            datasets, saline_keys, mouse_list=[mouse_id],
            axs=[axs[1, 0], axs[2, 0], axs[3, 0]]
        )
    else:
        plot_distance_and_speed_over_time(
            datasets, saline_keys, mouse_list=[mouse_id],
            axs=[axs[1, 0], axs[2, 0]]
        )

    # Plot Ivabradine
    plot_centered_maze_trajectories(
        datasets, ivabradine_keys, maze_type=maze_type, mouse_list=[mouse_id],
        ax=axs[0, 1] 
    )

    if maze_type == 'EPM':
        plot_position_maze_across_time(
            datasets, ivabradine_keys, mouse_list=[mouse_id],
            axs=[axs[1, 1], axs[2, 1], axs[3, 1]]
        )
    else:
        plot_distance_and_speed_over_time(
            datasets, ivabradine_keys, mouse_list=[mouse_id],
            axs=[axs[1, 1], axs[2, 1]]
        )

    # Add titles and labels
    for col, (label, keys) in enumerate(zip(['Saline', 'Ivabradine'], [saline_keys, ivabradine_keys])):
        date = None
        for key in keys[0]:
            if key in datasets and mouse_id in datasets[key]['data']:
                date = list(datasets[key]['data'][mouse_id].keys())[0]
                break
        if date:
            axs[0, col].set_title(f"{mouse_id} {label} - {date}", fontsize=14, weight='bold')

    if maze_type == 'EPM':
        for row, ylabel in enumerate(['X (centered)', 'Y (centered)', 'Speed (cm/s)']):
            axs[row + 1, 0].set_ylabel(ylabel, weight='bold')
    else:
        axs[1, 0].set_ylabel("Dist. from center", weight='bold')
        axs[2, 0].set_ylabel("Speed (cm/s)", weight='bold')

    axs[-1, 0].set_xlabel("Time (s)", weight='bold')
    axs[-1, 1].set_xlabel("Time (s)", weight='bold')

    plt.tight_layout()
    plt.show()
    
    if save_path:
        filename = f"{mouse_id}_{maze_type}.png"
        full_path = os.path.join(save_path, filename)
        plt.savefig(full_path, dpi=300)
        plt.close()



# def plot_position_maze_across_time(datasets, list_of_experiment_key_groups, legend=False, mouse_list=None):
#     """
#     Plot X(t), Y(t), and Speed(t) trajectories over time for each group of experiment keys.

#     Parameters:
#     - datasets: dict with structure [experiment_key]['data'][mouse_id][date]
#     - list_of_experiment_key_groups: list of lists of experiment keys
#     - legend : whether to show legends
#     - mouse_list : optional list of mouse IDs to include
#     """
#     for group_index, experiment_keys in enumerate(list_of_experiment_key_groups):
#         fig, axs = plt.subplots(3, 1, figsize=(10, 7), sharex=True)
#         color_cycle = plt.cm.tab10.colors
#         i = 0

#         for exp_key in experiment_keys:
#             if exp_key not in datasets:
#                 print(f"Experiment key '{exp_key}' not found in datasets.")
#                 continue

#             data = datasets[exp_key]['data']
#             for mouse_id in data:
#                 if mouse_list is not None and mouse_id not in mouse_list:
#                     continue

#                 for date in data[mouse_id]:
#                     entry = data[mouse_id][date]
#                     color = color_cycle[i % len(color_cycle)]
#                     label = f"{exp_key} - {mouse_id} - {date}"

#                     speed_tsd = entry.get('Speed', None)
#                     if speed_tsd is None:
#                         print(f"Missing Speed data for {mouse_id} on {date} in {exp_key}.")
#                         continue

#                     try:
#                         time = np.asarray(speed_tsd.t)/1e4
#                         speed_values = np.asarray(speed_tsd.data)
#                     except AttributeError:
#                         print(f"Invalid Speed format for {mouse_id} on {date} in {exp_key}.")
#                         continue

#                     axs[2].plot(time, speed_values, label=label, color=color, linewidth=2, alpha=0.8)

#                     for ax_idx, axis_label in enumerate(['X', 'Y']):
#                         tsd = entry.get(f'Centered{axis_label}tsd', None)
#                         if tsd is None:
#                             print(f"Missing centered {axis_label} data for {mouse_id} on {date} in {exp_key}.")
#                             continue

#                         try:
#                             values = np.asarray(tsd)
#                         except:
#                             print(f"Invalid {axis_label} data format for {mouse_id} on {date} in {exp_key}.")
#                             continue

#                         # Align length with Speed
#                         if len(values) != len(time) + 1:
#                             print(f"Length mismatch in {axis_label} data for {mouse_id} on {date} in {exp_key}.")
#                             continue

#                         aligned_values = values[:-1]  # Trim last point to match Speed time
#                         axs[ax_idx].plot(time, aligned_values, label=label, color=color, linewidth=2, alpha=0.8)

#                     i += 1

#         # Styling
#         axis_labels = ['X (centered)', 'Y (centered)', 'Speed (cm/s)']
#         for ax, label in zip(axs, axis_labels):
#             ax.set_ylabel(label, weight='bold')
#             ax.grid(True)
#             ax.tick_params(direction='out', length=6, width=2)
#             ax.spines['left'].set_linewidth(2)
#             ax.spines['bottom'].set_linewidth(2)
#             ax.spines['top'].set_visible(False)
#             ax.spines['right'].set_visible(False)
#             ax.tick_params(labelsize=10)

#         axs[0].set_ylim(-100, 100)
#         axs[1].set_ylim(-100, 100)
#         axs[2].set_xlabel('Time (s)', weight='bold')

#         group_label = ', '.join(experiment_keys)
#         fig.suptitle(f'X(t), Y(t), Speed(t) - Group {group_index + 1} ({group_label})', weight='bold', fontsize=11)
#         if legend:
#             axs[0].legend(fontsize='small', markerscale=2, loc='best')
#         plt.tight_layout(rect=[0, 0.03, 1, 0.95])
#         plt.show()


# def plot_recap_behavior_mouse(datasets, mouse_id, maze_type='EPM'):
#     import matplotlib.pyplot as plt

#     fig, axs = plt.subplots(4, 2, figsize=(14, 10), sharex='row')

#     # Subplot layout:
#     # axs[0, 0] = Saline trajectory
#     # axs[1, 0] = Saline X(t)
#     # axs[2, 0] = Saline Y(t)
#     # axs[3, 0] = Saline Speed(t)
#     # axs[0, 1] = Ivabradine trajectory
#     # axs[1, 1] = Ivabradine X(t)
#     # axs[2, 1] = Ivabradine Y(t)
#     # axs[3, 1] = Ivabradine Speed(t)

#     if maze_type =='EPM':
#         saline_keys = [['EPM_Saline_Exposition', 'EPM_Saline_Reexposition']]
#         ivabradine_keys = [['EPM_Ivabradine_Exposition', 'EPM_Ivabradine_Reexposition']]
#     elif maze_type == 'OF':
#         saline_keys = [['OF_Saline_Exposition', 'OF_Saline_Reexposition']]
#         ivabradine_keys = [['OF_Ivabradine_Exposition', 'OF_Ivabradine_Reexposition']]
#     else:
#         print("Maze type should be 'EPM' or 'OF'")

#     # Plot Saline
#     plot_centered_maze_trajectories(
#         datasets, saline_keys, maze_type=maze_type, mouse_list=[mouse_id], ax=axs[0, 0]
#     )
#     plot_position_maze_across_time(
#         datasets, saline_keys, mouse_list=[mouse_id],
#         axs=[axs[1, 0], axs[2, 0], axs[3, 0]]
#     )

#     # Plot Ivabradine
#     plot_centered_maze_trajectories(
#         datasets, ivabradine_keys, maze_type=maze_type, mouse_list=[mouse_id], ax=axs[0, 1]
#     )
#     plot_position_maze_across_time(
#         datasets, ivabradine_keys, mouse_list=[mouse_id],
#         axs=[axs[1, 1], axs[2, 1], axs[3, 1]]
#     )

#     # Add big titles on top of each column
#     for col, (label, keys) in enumerate(zip(['Saline', 'Ivabradine'], [saline_keys, ivabradine_keys])):
#         date = None
#         for key in keys[0]:
#             if key in datasets and mouse_id in datasets[key]['data']:
#                 date = list(datasets[key]['data'][mouse_id].keys())[0]
#                 break
#         if date:
#             axs[0, col].set_title(f"{mouse_id} {label} - {date}", fontsize=14, weight='bold')

#     # Add common labels
#     for row, ylabel in enumerate(['X (centered)', 'Y (centered)', 'Speed (cm/s)']):
#         axs[row + 1, 0].set_ylabel(ylabel, weight='bold')

#     axs[3, 0].set_xlabel('Time (s)', weight='bold')
#     axs[3, 1].set_xlabel('Time (s)', weight='bold')

#     plt.tight_layout()
#     plt.show()




