#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 27 12:24:38 2025

@author: gruffalo
"""

import numpy as np
from collections import defaultdict
import pynapple as nap

def compute_behavioral_data_epm(datasets, experiment_keys):
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
    """

    for key in experiment_keys:
        path_dict = datasets[key]['paths']
        if 'data' not in datasets[key]:
            datasets[key]['data'] = defaultdict(dict)

        for path, mouse_id, date, behav in zip(path_dict['path'], path_dict['nMice'], path_dict['date'], path_dict['behavResources']):
            # Normalize mouse_id to int
            if isinstance(mouse_id, (list, tuple, np.ndarray)):
                mouse_id = int(mouse_id[0])
            else:
                mouse_id = int(mouse_id)

            zone_epochs = behav['ZoneEpoch']
            zone_labels = behav['ZoneLabels']
            vtsd = behav['Vtsd']
            xtsd = behav['Xtsd']
            ytsd = behav['Ytsd']

            vt_times = np.asarray(vtsd.t)
            vt_values = np.asarray(vtsd.data)

            # Create total session interval
            session_interval = nap.IntervalSet(start=[vt_times[0]], end=[vt_times[-1]])

            result = {}

            # --- Mean speed over the whole session
            result["MeanSpeed"] = np.nanmean(vt_values)

            # --- Total session time in seconds
            result["SessionTime"] = (vt_times[-1] - vt_times[0]) / 1e4

            # --- Per-zone metrics
            result["Zones"] = {}
            total_time_all_zones = 0

            for zone_epoch, label in zip(zone_epochs, zone_labels):
                starts = np.asarray(zone_epoch.start)
                stops = np.asarray(zone_epoch.stop)

                valid = (stops > vt_times[0]) & (starts < vt_times[-1])
                starts = starts[valid]
                stops = stops[valid]

                if len(starts) == 0 or len(stops) == 0:
                    durations = np.array([])
                else:
                    zone_interval = nap.IntervalSet(start=starts, end=stops).intersect(session_interval)
                    df = zone_interval.as_dataframe()
                    if df.empty:
                        durations = np.array([])
                    else:
                        durations = (df['end'] - df['start']).to_numpy() / 1e4  # seconds

                total_time = np.sum(durations)
                total_time_all_zones += total_time

                result["Zones"][label] = {
                    "NumEntries": len(durations),
                    "MeanDuration": np.mean(durations) if len(durations) > 0 else np.nan,
                    "TotalTime": total_time
                }

            result["TotalTimeAllZones"] = total_time_all_zones
            result["Xtsd"] = xtsd
            result["Ytsd"] = ytsd

            # Save or append to dataset
            if mouse_id not in datasets[key]['data']:
                datasets[key]['data'][mouse_id] = {}
            datasets[key]['data'][mouse_id][date] = result

            # Print clear output
            print("\n==============================")
            print(f"Mouse {mouse_id} | Date: {date}")
            print(f"Session Time: {result['SessionTime']:.2f} s")
            print(f"Mean Speed: {result['MeanSpeed']:.2f}")
            print(f"Total Time Across All Zones: {result['TotalTimeAllZones']:.2f} s")
            for label, zone_data in result["Zones"].items():
                print(f"  Zone '{label}': {zone_data['NumEntries']} entries, Mean = {zone_data['MeanDuration']:.2f} s, Total = {zone_data['TotalTime']:.2f} s")

    print("\nAll behavioral data computed and stored successfully.")
    return


# import numpy as np
# from collections import defaultdict

# def compute_behavioral_data_epm(datasets, experiment_keys):
#     for key in experiment_keys:
#         path_dict = datasets[key]['paths']
#         if 'data' not in datasets[key]:
#             datasets[key]['data'] = defaultdict(dict)

#         for path, mouse_id, date, behav in zip(path_dict['path'], path_dict['nMice'], path_dict['date'], path_dict['behavResources']):
#             # Normalize mouse_id to int
#             if isinstance(mouse_id, (list, tuple, np.ndarray)):
#                 mouse_id = int(mouse_id[0])
#             else:
#                 mouse_id = int(mouse_id)

#             zone_epochs = behav['ZoneEpoch']
#             zone_labels = behav['ZoneLabels']
#             vtsd = behav['Vtsd']

#             vt_times = np.asarray(vtsd.t)
#             vt_values = np.asarray(vtsd.data)
#             total_mask = (vt_times >= vt_times[0]) & (vt_times <= vt_times[-1])

#             result = {}

#             # --- Session duration
#             session_duration_sec = (vt_times[-1] - vt_times[0]) / 1e4
#             result["SessionTime"] = session_duration_sec

#             # --- Mean speed over the whole session
#             result["MeanSpeed"] = np.nanmean(vt_values[total_mask])

#             # --- Per-zone metrics
#             result["Zones"] = {}
#             for zone_epoch, label in zip(zone_epochs, zone_labels):
#                 starts = np.asarray(zone_epoch.start)
#                 stops = np.asarray(zone_epoch.stop)

#                 # Filter intervals within total epoch
#                 valid = (stops > vt_times[0]) & (starts < vt_times[-1])
#                 starts = starts[valid]
#                 stops = stops[valid]

#                 durations = (stops - starts) / 1e4  # convert to seconds

#                 result["Zones"][label] = {
#                     "NumEntries": len(durations),
#                     "MeanDuration": np.mean(durations) if len(durations) > 0 else np.nan,
#                     "TotalTime": np.sum(durations)
#                 }

#             # --- Save or append to datasets[key]['data']
#             if mouse_id not in datasets[key]['data']:
#                 datasets[key]['data'][mouse_id] = {}

#             datasets[key]['data'][mouse_id][date] = result

#     return f"Behavioral data computed and stored successfully. SessionTime : {result['SessionTime']}. Zones data: {result['Zones']}"

