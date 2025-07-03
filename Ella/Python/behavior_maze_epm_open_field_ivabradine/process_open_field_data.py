#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 26 13:59:27 2025

@author: gruffalo
"""

import os
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat, savemat
import pynapple as nap

def compute_thigmotaxis_zones(directory_path=None, percent_inner=0.4, ring=None, plot=True):
    """
    Computes thigmotaxis zones (inner, outer, and optionally a specific ring) from centered and aligned position data
    stored in OfflineOpenFieldZones.mat. The zones are based on radial distance from the center (0, 0) of a circular arena.
    
    Parameters
    ----------
    directory_path : str or None
        Path to the folder containing OfflineOpenFieldZones.mat. Defaults to the current directory.
    percent_inner : float
        The proportion of the circular area considered as the inner zone (e.g., 0.7 means 70% of the area).
    ring : tuple(float, float) or None
        Inner and outer area fractions (e.g., (0.5, 1.0)) defining a specific annular ring zone. If None, no ring zone is computed.
    plot : bool
        If True, displays a plot showing the different zones.

    Returns
    -------
    dict
        A dictionary with:
        - 'Thigmotaxis': proportion of time spent in the outer zone vs total (inner + outer)
        - 'distances': pynapple.Tsd of radial distances
        - 'ZoneEpoch_Outer', 'ZoneEpoch_Inner', 'ZoneEpoch_Specific': pynapple.IntervalSet objects
    """
    if directory_path is None:
        directory_path = os.getcwd()

    print(f"Loading OfflineOpenFieldZones.mat from: {directory_path}")
    mat_path = os.path.join(directory_path, 'OfflineOpenFieldZones.mat')
    mat = loadmat(mat_path, squeeze_me=True, struct_as_record=False)

    try:
        x = mat['CenteredXtsd']
        y = mat['CenteredYtsd']
        t = mat['timestamps']
        circle = mat['CircleCoord']  # (y_center, x_center, radius)
    except KeyError as e:
        raise ValueError(f"Missing expected field in OfflineOpenFieldZones.mat: {e}")

    if len(x) != len(y) or len(x) != len(t):
        raise ValueError("Length mismatch between position arrays and timestamps.")

    # Build pynapple Tsd
    # tsd_x = nap.Tsd(t=t, d=x, time_units='s')
    # tsd_y = nap.Tsd(t=t, d=y, time_units='s')

    # The arena is centered, so use (0,0) as the center
    center = np.array([0, 0])
    radius = float(circle[2])

    # Compute Euclidean distance from center
    pos = np.vstack((x, y)).T
    distances = np.linalg.norm(pos - center, axis=1)
    dist_tsd = nap.Tsd(t=t, d=distances, time_units='s')

    # Thresholds for zones
    inner_limit = radius * np.sqrt(percent_inner)
    in_outer = distances >= inner_limit
    in_inner = distances < inner_limit

    # Specific ring (optional)
    if ring is not None:
        spec_inner = radius * np.sqrt(ring[0])
        spec_outer = radius * np.sqrt(ring[1])
        in_specific = (distances >= spec_inner) & (distances < spec_outer)

    # Create ZoneEpochs
    # Time series format
    # ZoneEpoch_Outer = nap.Ts(t=t[in_outer], time_units='s')
    # ZoneEpoch_Inner = nap.Ts(t=t[in_inner], time_units='s')
    # ZoneEpoch_Specific = nap.Ts(t=t[in_specific], time_units='s')
    
    # IntervalSet format
    dummy = nap.Tsd(t=t, d=in_outer.astype(int), time_units='s')
    ZoneEpoch_Outer = dummy.threshold(0.5, 'above').time_support
    
    dummy = nap.Tsd(t=t, d=in_inner.astype(int), time_units='s')
    ZoneEpoch_Inner = dummy.threshold(0.5, 'above').time_support
    
    if ring is not None:
        dummy = nap.Tsd(t=t, d=in_specific.astype(int), time_units='s')
        ZoneEpoch_Specific = dummy.threshold(0.5, 'above').time_support


    # Optional plotting
    if plot:
        plt.figure(figsize=(6, 6))
        plt.plot(x[in_inner], y[in_inner], '.g', label='Inner Zone')
        plt.plot(x[in_outer], y[in_outer], '.m', label='Outer Zone')

        theta = np.linspace(0, 2 * np.pi, 100)
        plt.plot(center[0] + radius * np.cos(theta), center[1] + radius * np.sin(theta), 'k-', label='Arena Radius')
        plt.plot(center[0] + inner_limit * np.cos(theta), center[1] + inner_limit * np.sin(theta), 'k--', label='Inner Limit')

        if ring is not None:
            plt.plot(center[0] + spec_inner * np.cos(theta), center[1] + spec_inner * np.sin(theta), 'b--', label='Ring Inner')
            plt.plot(center[0] + spec_outer * np.cos(theta), center[1] + spec_outer * np.sin(theta), 'b-', label='Ring Outer')

        plt.axis('equal')
        plt.legend()
        plt.title('Thigmotaxis Zones')
        plt.xlabel('X (centered)')
        plt.ylabel('Y (centered)')
        plt.show()
        
    # Load full MAT and update
    if os.path.exists(mat_path):
        full_data = loadmat(mat_path, squeeze_me=True, struct_as_record=False)
    else:
        full_data = {}

    # Add new zone data
    full_data['AlignedZoneEpoch'] = {
        'Outer': ZoneEpoch_Outer,
        'Inner': ZoneEpoch_Inner
    }
    if ring is not None:
        full_data['AlignedZoneEpoch']['Specific'] = ZoneEpoch_Specific

    labels = ['Outer', 'Inner']
    if ring is not None:
        labels.append('Specific')
    full_data['AlignedZoneLabels'] = np.array(labels, dtype=object)
    full_data['AlignedZoneIndices'] = {
        'Outer': in_outer.astype(np.uint8),
        'Inner': in_inner.astype(np.uint8)
    }
    if ring is not None:
        full_data['AlignedZoneIndices']['Specific'] = in_specific.astype(np.uint8)

    full_data['distances'] = distances
    # full_data['Vtsd'] = v
    # full_data['timestamps'] = t
    full_data['percent_inner'] = float(percent_inner)

    # Save updated structure (overwriting but preserving previous content)
    savemat(mat_path, full_data)
    print(f"Saved updated zone data to {mat_path}")
    
    result = {
        'Thigmotaxis': np.sum(in_outer) / (np.sum(in_outer) + np.sum(in_inner)),
        'distances': dist_tsd,
        'ZoneEpoch_Outer': ZoneEpoch_Outer,
        'ZoneEpoch_Inner': ZoneEpoch_Inner
    }
    if ring is not None:
        result['ZoneEpoch_Specific'] = ZoneEpoch_Specific
    return result


# import numpy as np
from collections import defaultdict
# import pynapple as nap
# import os
# from scipy.io import loadmat
from scipy.ndimage import uniform_filter1d  # Add this at the top


def compute_behavioral_data_open_field(datasets, experiment_keys=None, 
                                       percent_inner=0.4, ring=None, plot=False,
                                       smoothing_window_s=None):
    """
    Compute behavioral metrics for Open Field experiments.

    Uses velocity time series and centered position data from OfflineOpenFieldZones.mat,
    computes thigmotaxis zones and related metrics (entries, durations, total times),
    and stores results in datasets structure per mouse and session.

    Parameters
    ----------
    datasets : dict
        Nested dictionary containing experiment data with paths to behavResources and OfflineOpenFieldZones.
    experiment_keys : list or None
        List of experiment keys to process; processes all if None.
    percent_inner : float
        Fraction of arena area considered inner zone (passed to compute_thigmotaxis_zones).
    ring : tuple or None
        Inner and outer fractions defining a specific annular ring zone.
    plot : bool
        Whether to plot zones (passed to compute_thigmotaxis_zones).
    smoothing_window_s : float or None
        Window (in seconds) for smoothing speed and distance.
    """

    if experiment_keys is None:
        experiment_keys = list(datasets.keys())

    for key in experiment_keys:
        path_dict = datasets[key]['paths']
        if 'data' not in datasets[key]:
            datasets[key]['data'] = defaultdict(dict)

        for path, mouse_id, date, behav, offline in zip(
                path_dict['path'], path_dict['nMice'], path_dict['date'],
                path_dict['behavResources'], path_dict['OfflineOpenFieldZones']):

            # Normalize mouse_id to int
            if isinstance(mouse_id, (list, tuple, np.ndarray)):
                mouse_id = int(mouse_id[0])
            else:
                mouse_id = int(mouse_id)

            # Load velocity time series from behavResources.mat
            xtsd = behav.get('Xtsd', None)
            if xtsd is None:
                print(f"Warning: Xtsd missing for mouse {mouse_id}, date {date}. Skipping.")
                continue
            vtsd = behav.get('Vtsd', None)
            if vtsd is None:
                print(f"Warning: Vtsd missing for mouse {mouse_id}, date {date}. Skipping.")
                continue
            vt_times = np.asarray(xtsd.t) / 1e4 # Convert to seconds
            vt_values = np.asarray(vtsd.data)
            
            # Estimate dt for smoothing
            dt_speed = np.median(np.diff(vt_times))  # seconds

            # Optional smoothing
            if smoothing_window_s is not None:
                win_speed = max(1, int(smoothing_window_s / dt_speed))
                smoothed_speed = uniform_filter1d(vt_values, size=win_speed)
            else:
                smoothed_speed = vt_values
                
            # Total distance = sum(speed * dt)
            total_distance = np.nansum(smoothed_speed * dt_speed)

            # Compute session time and mean speed
            session_time = (vt_times[-1] - vt_times[0]) 
            mean_speed = np.nanmean(vt_values)

            # Load OfflineOpenFieldZones.mat to get zone epochs and centered data
            offline_mat_path = os.path.join(path, 'OfflineOpenFieldZones.mat')
            if not os.path.exists(offline_mat_path):
                print(f"Warning: OfflineOpenFieldZones.mat not found for mouse {mouse_id}, date {date}. Skipping.")
                continue
            offline_mat = loadmat(offline_mat_path, squeeze_me=True, struct_as_record=False)

            # Run compute_thigmotaxis_zones logic here to get zone epochs
            zone_data = compute_thigmotaxis_zones(
                directory_path=path,
                percent_inner=percent_inner,
                ring=ring,
                plot=plot)
            
            # Store distance from center over time
            dist_tsd = zone_data['distances']
            mean_distance = np.nanmean(dist_tsd.data())  # in same units as input (usually pixels or cm)
            
            result = {}
            result["DistanceTsd"] = dist_tsd
            result["MeanDistance"] = mean_distance
            result["TraveledDistance"] = total_distance
            result["Speed"] = vtsd
            result["MeanSpeed"] = mean_speed
            result["SmoothedSpeed"] = nap.Tsd(t=vtsd.t, d=smoothed_speed)
            result["SessionTime"] = session_time

            # Calculate per-zone metrics
            result["Zones"] = {}
            total_time_all_zones = 0
            session_interval = nap.IntervalSet(start=[vt_times[0]], end=[vt_times[-1]])

            zone_labels = ['Outer', 'Inner']
            zone_epochs = [zone_data['ZoneEpoch_Outer'], zone_data['ZoneEpoch_Inner']]
            
            if ring is not None and 'ZoneEpoch_Specific' in zone_data:
                zone_labels.append('Specific')
                zone_epochs.append(zone_data['ZoneEpoch_Specific'])


            for zone_epoch, label in zip(zone_epochs, zone_labels):
                if zone_epoch is None or len(zone_epoch) == 0:
                    durations = np.array([])
                else:
                    zone_interval = zone_epoch.intersect(session_interval)
                    df = zone_interval.as_dataframe()
                    if df.empty:
                        durations = np.array([])
                    else:
                        durations = (df['end'] - df['start']).to_numpy()  # seconds

                total_time = np.sum(durations)
                total_time_all_zones += total_time

                result["Zones"][label] = {
                    "NumEntries": len(durations),
                    "MeanDuration": np.mean(durations) if len(durations) > 0 else np.nan,
                    "TotalTime": total_time
                }

            result["TotalTimeAllZones"] = total_time_all_zones

            # Add centered position data (assumes offline dict has these fields)
            result["CenteredXtsd"] = offline_mat.get('CenteredXtsd', None)
            result["CenteredYtsd"] = offline_mat.get('CenteredYtsd', None)

            # Store in dataset
            if mouse_id not in datasets[key]['data']:
                datasets[key]['data'][mouse_id] = {}
            datasets[key]['data'][mouse_id][date] = result

            # Print results for feedback
            print("\n==============================")
            print(f"Mouse {mouse_id} | Date: {date}")
            print(f"Session Time: {session_time:.2f} s")
            print(f"Mean Speed: {mean_speed:.2f} cm/s")
            print(f"Total Traveled Distance: {total_distance:.2f} cm")
            print(f"Mean Distance from Center: {mean_distance:.2f}")
            print(f"Total Time Across All Zones: {total_time_all_zones:.2f} s")
            for label, zone_data in result["Zones"].items():
                print(f"  Zone '{label}': {zone_data['NumEntries']} entries, Mean = {zone_data['MeanDuration']:.2f} s, Total = {zone_data['TotalTime']:.2f} s")

    print("\nAll Open Field behavioral data computed and stored successfully.")


# import numpy as np
# import matplotlib.pyplot as plt
# from pynapple import IntervalSet

# def compute_mean_zone_occupancy_over_time(datasets, experiment_key_groups, zones, 
#                                              legend=None, mouse_list=None, 
#                                              plot_together=True, bin_size=20.0):
#     """
#     Compute and plot mean zone occupancy over time bins for specified zones and experiment groups.

#     Parameters
#     ----------
#     datasets : dict
#         Dictionary containing datasets for each experiment key.
#     experiment_key_groups : list of list of str
#         Each sublist contains experiment keys for one group.
#     zones : list of str
#         List of zone names to include, e.g., ['Outer', 'Inner', 'Specific'].
#     legend : list of str or None
#         Legend labels for each group.
#     mouse_list : list or None
#         If provided, only includes data for mice in this list.
#     plot_together : bool
#         If True, plots all groups on the same figure. Otherwise, separate plots per group.
#     bin_size : float
#         Bin size in seconds for occupancy calculation.
#     """
#     color_cycle = plt.colormaps['tab10'].colors
#     zone_key_map = {
#         'Outer': 'ZoneEpoch_Outer',
#         'Inner': 'ZoneEpoch_Inner',
#         'Specific': 'ZoneEpoch_Specific'
#     }

#     group_zone_timecourses = {zone: [] for zone in zones}
#     common_bins = None

#     for group_index, experiment_keys in enumerate(experiment_key_groups):
#         group_zone_data = {zone: [] for zone in zones}

#         for key in experiment_keys:
#             path_dict = datasets[key]['paths']
#             for path, mouse_id, date, behav, offline in zip(
#                     path_dict['path'], path_dict['nMice'], path_dict['date'],
#                     path_dict['behavResources'], path_dict['OfflineOpenFieldZones']):
                
#                 if mouse_list and mouse_id not in mouse_list:
#                     continue

#                 # Get session time range
#                 vt_times = behav['Xtsd'].t / 1e4  # convert to seconds
#                 session_interval = IntervalSet(start=vt_times[0], end=vt_times[-1])

#                 # Define bin edges and intervals
#                 bin_edges = np.arange(0, 880 + bin_size, bin_size)  # e.g. 0,20,...,900
#                 # Slightly shrink the bin ends to avoid overlap warnings
#                 bin_intervals = nap.IntervalSet(
#                     start=bin_edges[:-1],
#                     end=bin_edges[1:] - 1e-5
#                 )
#                 bin_edges = np.arange(vt_times[0], vt_times[-1] + bin_size, bin_size)
#                 bin_intervals = IntervalSet(start=bin_edges[:-1], end=bin_edges[1:] - 1e-10) # avoid exact overlap

#                 if common_bins is None:
#                     common_bins = bin_edges

#                 for zone in zones:
#                     zone_epoch = offline.get(zone_key_map[zone], None)
#                     if zone_epoch is None or len(zone_epoch) == 0:
#                         group_zone_data[zone].append(np.zeros(len(bin_intervals)))
#                         continue

#                     intersected = zone_epoch.intersect(session_interval)
#                     binned = np.array([
#                         intersected.intersect(IntervalSet(start=s, end=e)).duration().sum()
#                         for s, e in zip(bin_edges[:-1], bin_edges[1:])
#                     ])
#                     group_zone_data[zone].append(binned)

#         # Store mean per group
#         for zone in zones:
#             group_zone_data[zone] = np.array(group_zone_data[zone])
#             if len(group_zone_data[zone]) > 0:
#                 mean_occ = np.nanmean(group_zone_data[zone], axis=0)
#             else:
#                 mean_occ = np.zeros(len(bin_edges) - 1)
#             group_zone_timecourses[zone].append(mean_occ)

#     # Plotting
#     for zone in zones:
#         if plot_together:
#             fig, ax = plt.subplots(figsize=(10, 5))
#             for i, occ in enumerate(group_zone_timecourses[zone]):
#                 color = color_cycle[i % len(color_cycle)]
#                 label = legend[i] if legend and i < len(legend) else f'Group {i + 1}'
#                 ax.plot(common_bins[:-1], occ, color=color, label=label, linewidth=2)
#             ax.set_title(f"Mean Zone Occupancy Over Time — {zone}")
#             ax.set_xlabel("Time (s)")
#             ax.set_ylabel("Occupancy (s)")
#             ax.grid(True)
#             if legend:
#                 ax.legend()
#             plt.tight_layout()
#             plt.show()
#         else:
#             for i, occ in enumerate(group_zone_timecourses[zone]):
#                 fig, ax = plt.subplots(figsize=(10, 5))
#                 color = color_cycle[i % len(color_cycle)]
#                 label = legend[i] if legend and i < len(legend) else f'Group {i + 1}'
#                 ax.plot(common_bins[:-1], occ, color=color, label=label, linewidth=2)
#                 ax.set_title(f"Mean Zone Occupancy Over Time — {zone} — Group {label}")
#                 ax.set_xlabel("Time (s)")
#                 ax.set_ylabel("Occupancy (s)")
#                 ax.grid(True)
#                 if legend:
#                     ax.legend()
#                 plt.tight_layout()
#                 plt.show()

