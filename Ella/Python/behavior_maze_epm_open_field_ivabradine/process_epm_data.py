#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 27 12:24:38 2025

@author: gruffalo
"""

import numpy as np
from collections import defaultdict
import pynapple as nap
from scipy.ndimage import uniform_filter1d


def compute_behavioral_data_epm(datasets, experiment_keys=None, smoothing_window_s=None):
    """
    Compute behavioral metrics for Elevated Plus Maze (EPM) experiments.

    This function processes the velocity time series and zone occupancy epochs from behavioral
    data for each mouse and session in the given dataset. It calculates the mean speed, session
    duration, and zone-specific metrics including the number of entries, mean duration per entry,
    and total time spent in each zone.

    Additionally, it extracts the X and Y position time series (xtsd and ytsd) and stores them
    alongside computed metrics. The final results are organized per mouse and date under each
    experiment key in the datasets structure.
    
    Clear progress is printed to the console for each processed mouse.
    
    If no experiment_keys are provided, all keys in the datasets will be processed.
    
    Parameters
    ----------
    datasets : dict
        Nested dictionary with EPM data per experiment.
    experiment_keys : list or None
        Keys to process; if None, process all.
    smoothing_window_s : float or None
        Window (in seconds) for smoothing speed 
    """

    if experiment_keys is None:
        experiment_keys = list(datasets.keys())
        
    for key in experiment_keys:
        path_dict = datasets[key]['paths']
        if 'data' not in datasets[key]:
            datasets[key]['data'] = defaultdict(dict)

        for path, mouse_id, date, behav, offline in zip(
            path_dict['path'], path_dict['nMice'], path_dict['date'], 
            path_dict['behavResources'], path_dict['OfflineEPMZones']):
            # Normalize mouse_id to int
            if isinstance(mouse_id, (list, tuple, np.ndarray)):
                mouse_id = int(mouse_id[0])
            else:
                mouse_id = int(mouse_id)

            zone_epochs = behav['ZoneEpoch']
            zone_labels = behav['ZoneLabels']
            xtsd = behav['Xtsd']
            vtsd = behav['Vtsd']

            vt_times = np.asarray(xtsd.t)
            vt_values = np.asarray(vtsd.data)

            # Create total session interval
            session_interval = nap.IntervalSet(start=[vt_times[0]], end=[vt_times[-1]])

            result = {}

            # --- Mean speed over the whole session
            result["MeanSpeed"] = np.nanmean(vt_values)

            # --- Total session time in seconds
            result["SessionTime"] = (vt_times[-1] - vt_times[0]) /1e4
            
            # --- Compute total distance
            x = offline['CenteredXtsd']
            y = offline['CenteredYtsd']
            t = offline['timestamps']

            dx = np.diff(x)
            dy = np.diff(y)
            dist = np.sqrt(dx**2 + dy**2)
            time_d = t[:-1]

            # Sampling interval (in seconds)
            dt_dist = np.median(np.diff(time_d)) / 1e4
            dt_speed = np.median(np.diff(vt_times)) / 1e4

            # Smoothing (optional)
            if smoothing_window_s is not None:
                win_dist = max(1, int(smoothing_window_s / dt_dist))
                win_speed = max(1, int(smoothing_window_s / dt_speed))
                dist = uniform_filter1d(dist, size=win_dist)
                vt_values = uniform_filter1d(vt_values, size=win_speed)

            # Store smoothed speed
            result["SmoothedSpeed"] = nap.Tsd(t=vtsd.t, d=vt_values)

            # Store total distance
            total_distance = np.nansum(dist)
            result["TraveledDistance"] = total_distance

            # --- Per-zone metrics
            result["Zones"] = {}
            total_time_all_zones = 0

            for zone_epoch, label in zip(zone_epochs, zone_labels):
                # starts = np.asarray(zone_epoch.start)
                # stops = np.asarray(zone_epoch.stop)
                starts = np.atleast_1d(np.asarray(zone_epoch.start))
                stops = np.atleast_1d(np.asarray(zone_epoch.stop))

                # valid = (stops > vt_times[0]) & (starts < vt_times[-1])
                # starts = starts[valid]
                # stops = stops[valid]

                if len(starts) == 0 or len(stops) == 0:
                    durations = np.array([])
                else:
                    zone_interval = nap.IntervalSet(start=starts, end=stops).intersect(session_interval)
                    df = zone_interval.as_dataframe()
                    if df.empty:
                        durations = np.array([])
                    else:
                        durations = (df['end'] - df['start']).to_numpy() /1e4

                total_time = np.sum(durations)
                total_time_all_zones += total_time

                result["Zones"][label] = {
                    "NumEntries": len(durations),
                    "MeanDuration": np.mean(durations) if len(durations) > 0 else np.nan,
                    "TotalTime": total_time
                }

            result["TotalTimeAllZones"] = total_time_all_zones
            result["CenteredXtsd"] = offline['CenteredXtsd']
            result["CenteredYtsd"] = offline['CenteredYtsd']
            result["Speed"] = behav['Vtsd']

            # Save or append to dataset
            if mouse_id not in datasets[key]['data']:
                datasets[key]['data'][mouse_id] = {}
            datasets[key]['data'][mouse_id][date] = result

            # --- Print summary
            print("\n==============================")
            print(f"Mouse {mouse_id} | Date: {date}")
            print(f"Session Time: {result['SessionTime']:.2f} s")
            print(f"Mean Speed: {result['MeanSpeed']:.2f}")
            print(f"Total Traveled Distance: {total_distance:.2f} cm")
            print(f"Total Time Across All Zones: {result['TotalTimeAllZones']:.2f} s")
            for label, zone_data in result["Zones"].items():
                print(f"  Zone '{label}': {zone_data['NumEntries']} entries, Mean = {zone_data['MeanDuration']:.2f} s, Total = {zone_data['TotalTime']:.2f} s")

    print("\nAll EPM behavioral data computed and stored successfully.")
    return




