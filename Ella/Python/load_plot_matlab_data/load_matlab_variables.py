#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 19 18:12:20 2025

@author: gruffalo
"""

from pynapple import Tsd
import os
import numpy as np
import scipy.io


def subsample_tsd(tsd, new_dt_s):
    """
    Subsamples a pynapple Tsd object to a new time step (in seconds).

    INPUT:
        tsd (Tsd): Original time series
        new_dt_s (float): New time step in seconds

    OUTPUT:
        Tsd: Subsampled time series
    """
    t = tsd.t
    d = tsd.data()

    if len(t) < 2:
        print("Warning: Time vector too short to subsample.")
        return tsd

    current_dt = np.median(np.diff(t))
    if new_dt_s <= current_dt:
        print("Warning: New timestep must be larger than current timestep.")
        return tsd

    stride = int(np.round(new_dt_s / current_dt))
    # Add this line to ensure exact multiple
    if not np.isclose(stride * current_dt, new_dt_s, rtol=1e-5):
        print(f"Error: new_dt_s = {new_dt_s} is not a multiple of current_dt = {current_dt:.6f}")
        return tsd
    
    t_sub = t[::stride]
    d_sub = d[::stride]

    return Tsd(t=t_sub, d=d_sub)

def load_variables_from_path(path_dict, variables, subsample_params=None):
    """
    Loads variables from .mat files, wraps them as pynapple Tsd, and optionally subsamples.

    INPUTS:
        path_dict (dict): Dictionary with keys "path", "nMice", "ExpeInfo"
        variables (list): Variables to load (e.g., ['Heartrate', 'BreathFreq', 'OBGamma'])
        subsample_params (dict): Optional dict with {"VariableName": new_dt_in_seconds}

    OUTPUT:
        dict: {mouse_id: {YYYYMMDD: {variable: Tsd}}}
    """
    data_dict = {}
    subsample_params = subsample_params or {}

    for path, mouse_id, expe_info in zip(path_dict["path"], path_dict["nMice"], path_dict["ExpeInfo"]):
        if isinstance(mouse_id, (list, tuple, np.ndarray)):
            mouse_id = mouse_id[0]
        mouse_id = int(mouse_id)

        experiment_date = expe_info.date if hasattr(expe_info, "date") else "Unknown"

        if mouse_id not in data_dict:
            data_dict[mouse_id] = {}
        if experiment_date not in data_dict[mouse_id]:
            data_dict[mouse_id][experiment_date] = {}

        # Heartrate
        if "Heartrate" in variables:
            file_path = os.path.join(path, "HeartBeatInfo.mat")
            if os.path.exists(file_path):
                mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
                if "EKG" in mat and hasattr(mat["EKG"], "HBRate"):
                    tsd_data = mat["EKG"].HBRate
                    tsd_hr = Tsd(t=tsd_data.t / 1e4, d=tsd_data.data)
                    if "Heartrate" in subsample_params:
                        tsd_hr = subsample_tsd(tsd_hr, subsample_params["Heartrate"])
                    data_dict[mouse_id][experiment_date]["Heartrate"] = tsd_hr

        # BreathFreq
        if "BreathFreq" in variables:
            file_path = os.path.join(path, "RespiFreq.mat")
            if os.path.exists(file_path):
                mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
                if "Spectrum_Frequency" in mat:
                    tsd_data = mat["Spectrum_Frequency"]
                    tsd_bf = Tsd(t=tsd_data.t / 1e4, d=tsd_data.data)
                    if "BreathFreq" in subsample_params:
                        tsd_bf = subsample_tsd(tsd_bf, subsample_params["BreathFreq"])
                    data_dict[mouse_id][experiment_date]["BreathFreq"] = tsd_bf

        # OBGamma
        if "OBGamma" in variables:
            file_path = os.path.join(path, "SleepScoring_OBGamma.mat")
            if os.path.exists(file_path):
                mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
                if "SmoothGamma" in mat:
                    raw_obg = mat["SmoothGamma"]
                    t = np.asarray(raw_obg.t) / 1e4
                    d = np.asarray(raw_obg.data)
                    if len(t) != len(d):
                        print(f"Warning: Length mismatch in OBGamma (t: {len(t)}, d: {len(d)}), skipping.")
                        continue
                    tsd_obg = Tsd(t=t, d=d)
                    if "OBGamma" in subsample_params:
                        tsd_obg = subsample_tsd(tsd_obg, subsample_params["OBGamma"])
                    data_dict[mouse_id][experiment_date]["OBGamma"] = tsd_obg

    return data_dict


# def load_variables_from_path(path_dict, variables, obgamma_subsample_ms=None):
#     """
#     Loads requested variables ('Heartrate', 'BreathFreq', 'OBGamma') from .mat files
#     for each mouse and experiment, wrapping each as a pynapple Tsd object with time in seconds.

#     INPUTS:
#         path_dict (dict): Dictionary with keys "path", "nMice", "ExpeInfo"
#         variables (list): Variables to load (e.g., ['Heartrate', 'BreathFreq', 'OBGamma'])
#         obgamma_subsample_ms (int, optional): If given, subsample OBGamma to this resolution (ms)

#     OUTPUT:
#         dict: {mouse_id: {YYYYMMDD: {variable: Tsd}}}
#     """
#     data_dict = {}

#     for path, mouse_id, expe_info in zip(path_dict["path"], path_dict["nMice"], path_dict["ExpeInfo"]):
#         # Normalize mouse_id
#         if isinstance(mouse_id, (list, tuple, np.ndarray)):
#             mouse_id = mouse_id[0]
#         mouse_id = int(mouse_id)

#         # Get experiment date
#         experiment_date = expe_info.date if hasattr(expe_info, "date") else "Unknown"

#         # Init nested dict
#         if mouse_id not in data_dict:
#             data_dict[mouse_id] = {}
#         if experiment_date not in data_dict[mouse_id]:
#             data_dict[mouse_id][experiment_date] = {}

#         # Load Heartrate
#         if "Heartrate" in variables:
#             file_path = os.path.join(path, "HeartBeatInfo.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "EKG" in mat and hasattr(mat["EKG"], "HBRate"):
#                     tsd_data = mat["EKG"].HBRate
#                     tsd_hr = Tsd(t=tsd_data.t / 1e4, d=tsd_data.data)
#                     data_dict[mouse_id][experiment_date]["Heartrate"] = tsd_hr
            
#         # Load BreathFreq
#         if "BreathFreq" in variables:
#             file_path = os.path.join(path, "RespiFreq.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "Spectrum_Frequency" in mat:
#                     tsd_data = mat["Spectrum_Frequency"]
#                     tsd_bf = Tsd(t=tsd_data.t / 1e4, d=tsd_data.data)
#                     data_dict[mouse_id][experiment_date]["BreathFreq"] = tsd_bf

#         # Load OBGamma
#         if "OBGamma" in variables:
#             file_path = os.path.join(path, "SleepScoring_OBGamma.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "SmoothGamma" in mat:
#                     obgamma = mat["SmoothGamma"]
#                     if obgamma_subsample_ms is not None:
#                         obgamma = subsample_obgamma_tsd(obgamma, obgamma_subsample_ms)
#                     tsd_obg = Tsd(t=obgamma.t / 1e4, d=obgamma.data)

#                     # tsd_obg = Tsd(t=np.asarray(obgamma.t) / 1e4, d=np.asarray(obgamma.data))
#                     data_dict[mouse_id][experiment_date]["OBGamma"] = tsd_obg
                    
#     return data_dict

from pynapple import Tsd

# def load_variables_from_path(path_dict, variables):
#     """
#     Loads requested variables ('Heartrate', 'BreathFreq', 'OBGamma') from .mat files
#     for each mouse and experiment, wrapping each as a pynapple Tsd object with time in seconds.

#     INPUT:
#         path_dict (dict): Dictionary with keys "path", "nMice", "ExpeInfo"
#         variables (list): Variables to load (e.g., ['Heartrate', 'BreathFreq', 'OBGamma'])

#     OUTPUT:
#         dict: {mouse_id: {YYYYMMDD: {variable: Tsd}}}
#     """
#     data_dict = {}

#     for path, mouse_id, expe_info in zip(path_dict["path"], path_dict["nMice"], path_dict["ExpeInfo"]):
#         # Normalize mouse_id
#         if isinstance(mouse_id, (list, tuple, np.ndarray)):
#             mouse_id = mouse_id[0]
#         mouse_id = int(mouse_id)

#         # Get experiment date
#         experiment_date = expe_info.date if hasattr(expe_info, "date") else "Unknown"

#         # Init nested dict
#         if mouse_id not in data_dict:
#             data_dict[mouse_id] = {}
#         if experiment_date not in data_dict[mouse_id]:
#             data_dict[mouse_id][experiment_date] = {}

#         # Load Heartrate
#         if "Heartrate" in variables:
#             file_path = os.path.join(path, "HeartBeatInfo.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "EKG" in mat and hasattr(mat["EKG"], "HBRate"):
#                     tsd_data = mat["EKG"].HBRate
#                     tsd_hr = Tsd(t=tsd_data.t / 1e4, d=tsd_data.data)
#                     data_dict[mouse_id][experiment_date]["Heartrate"] = tsd_hr
            
#         # Load BreathFreq
#         if "BreathFreq" in variables:
#             file_path = os.path.join(path, "RespiFreq.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "Spectrum_Frequency" in mat:
#                     tsd_data = mat["Spectrum_Frequency"]
#                     tsd_bf = Tsd(t=tsd_data.t / 1e4, d=tsd_data.data)
#                     data_dict[mouse_id][experiment_date]["BreathFreq"] = tsd_bf

#         # Load OBGamma (no subsampling)
#         if "OBGamma" in variables:
#             file_path = os.path.join(path, "SleepScoring_OBGamma.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "SmoothGamma" in mat:
#                     raw_obg = mat["SmoothGamma"]
#                     t = np.asarray(raw_obg.t) / 1e4  # Convert to seconds
#                     d = np.asarray(raw_obg.data)
#                     if len(t) != len(d):
#                         print(f"Warning: Length mismatch in OBGamma (t: {len(t)}, d: {len(d)}), skipping.")
#                         continue
#                     tsd_obg = Tsd(t=t, d=d)
#                     data_dict[mouse_id][experiment_date]["OBGamma"] = tsd_obg

#     return data_dict


# def load_variables_from_path(path_dict, variables, obgamma_subsample_ms=None):
#     """
#     Loads requested variables ('Heartrate', 'BreathFreq', 'OBGamma') from the corresponding .mat files
#     for each mouse and organizes them by experiment date.

#     INPUTS:
#         path_dict (dict): Dictionary containing mouse paths and experiment details.
#         variables (list): List of variables to load (e.g., ['Heartrate', 'BreathFreq', 'OBGamma']).

#     OUTPUT:
#         A nested dictionary structured as:
#         {
#             MouseID1: {
#                 "YYYYMMDD": {"Variable1": data, "Variable2": data},
#                 ...
#             },
#             MouseID2: {
#                 ...
#             }
#         }
#     """
    
#     data_dict = {}

#     for path, mouse_id, expe_info in zip(path_dict["path"], path_dict["nMice"], path_dict["ExpeInfo"]):
#         # Ensure mouse_id is an int
#         if isinstance(mouse_id, (list, tuple, np.ndarray)):
#             mouse_id = mouse_id[0]
#         mouse_id = int(mouse_id)

#         # Get experiment date
#         experiment_date = expe_info.date if hasattr(expe_info, "date") else "Unknown"

#         # Initialize nested dictionary
#         if mouse_id not in data_dict:
#             data_dict[mouse_id] = {}
#         if experiment_date not in data_dict[mouse_id]:
#             data_dict[mouse_id][experiment_date] = {}

#         # Load Heartrate
#         if "Heartrate" in variables:
#             heartbeat_info_path = os.path.join(path, "HeartBeatInfo.mat")
#             if os.path.exists(heartbeat_info_path):
#                 mat_data = scipy.io.loadmat(heartbeat_info_path, struct_as_record=False, squeeze_me=True)
#                 if "EKG" in mat_data and hasattr(mat_data["EKG"], "HBRate"):
#                     data_dict[mouse_id][experiment_date]["Heartrate"] = mat_data["EKG"].HBRate
#                 else:
#                     print(f"Warning: 'EKG.HBRate' not found in {heartbeat_info_path}")
#             else:
#                 print(f"File not found: {heartbeat_info_path}")

#         # Load BreathFreq
#         if "BreathFreq" in variables:
#             respi_freq_path = os.path.join(path, "RespiFreq.mat")
#             if os.path.exists(respi_freq_path):
#                 mat_data = scipy.io.loadmat(respi_freq_path, struct_as_record=False, squeeze_me=True)
#                 if "Spectrum_Frequency" in mat_data:
#                     data_dict[mouse_id][experiment_date]["BreathFreq"] = mat_data["Spectrum_Frequency"]
#                 else:
#                     print(f"Warning: 'Spectrum_Frequency' not found in {respi_freq_path}")
#             else:
#                 print(f"File not found: {respi_freq_path}")

#         # Load OBGamma
#         if "OBGamma" in variables:
#             obgamma_path = os.path.join(path, "SleepScoring_OBGamma.mat")
#             if os.path.exists(obgamma_path):
#                 mat_data = scipy.io.loadmat(obgamma_path, struct_as_record=False, squeeze_me=True)
#                 if "SmoothGamma" in mat_data:
#                     obgamma = mat_data["SmoothGamma"]
#                     if obgamma_subsample_ms is not None:
#                         obgamma = subsample_obgamma_tsd(obgamma, obgamma_subsample_ms)
#                     data_dict[mouse_id][experiment_date]["OBGamma"] = obgamma
#                 else:
#                     print(f"Warning: 'SmoothGamma' not found in {obgamma_path}")
#             else:
#                 print(f"File not found: {obgamma_path}")

#     return data_dict

# Example Usage:
# path_dict = get_path_for_expe_cardiosense_ivabradine("IvabradineExperiment")
# variables = ["Heartrate", "BreathFreq"]
# loaded_data = load_variables_from_path(path_dict, variables)


# def subsample_obgamma_tsd(tsd, new_dt_ms=None):
#     t = tsd.t
#     data = tsd.data

#     if len(t) < 2:
#         print("Error: Time vector is too short to compute timestep.")
#         return None

#     current_dt = int(np.median(np.diff(t)))
#     current_dt_ms = current_dt / 10
#     print(f"Current timestep: {current_dt} (0.1 ms units), i.e., {current_dt_ms:.1f} ms")

#     if new_dt_ms is None:
#         print("To subsample, provide a new_dt_ms that is a multiple of the current dt.")
#         return None

#     new_dt = int(new_dt_ms * 10)
#     if new_dt % current_dt != 0:
#         print(f"Error: New timestep {new_dt_ms} ms is not a multiple of the current timestep {current_dt_ms:.1f} ms.")
#         return None

#     stride = new_dt // current_dt
#     t_sub = t[::stride]
#     data_sub = data[::stride]

#     tsd_subsampled = SimpleNamespace(t=t_sub, data=data_sub)

#     print(f"Subsampled to every {new_dt_ms} ms (every {stride} points). New length: {len(data_sub)}")
#     return tsd_subsampled


from pynapple import Tsd

# def subsample_obgamma_tsd(tsd, new_dt_ms=None):
#     t = tsd.t
#     data = tsd.data

#     if len(t) < 2:
#         print("Error: Time vector is too short to compute timestep.")
#         return None

#     current_dt = int(np.median(np.diff(t)))
#     current_dt_ms = current_dt / 10
#     print(f"Current timestep: {current_dt} (0.1 ms units), i.e., {current_dt_ms:.1f} ms")

#     if new_dt_ms is None:
#         print("To subsample, provide a new_dt_ms that is a multiple of the current dt.")
#         return None

#     new_dt = int(new_dt_ms * 10)
#     if new_dt % current_dt != 0:
#         print(f"Error: New timestep {new_dt_ms} ms is not a multiple of the current timestep {current_dt_ms:.1f} ms.")
#         return None

#     stride = new_dt // current_dt
#     t_sub = t[::stride]
#     data_sub = data[::stride]

#     # Return proper Tsd
#     tsd_subsampled = Tsd(t=t_sub, d=data_sub)

#     print(f"Subsampled to every {new_dt_ms} ms (every {stride} points). New length: {len(data_sub)}")
#     return tsd_subsampled


from pynapple import Tsd
import numpy as np

# def subsample_obgamma_tsd(tsd, new_dt_ms=None):
#     t = np.asarray(tsd.t)
#     data = np.asarray(tsd.data)

#     if len(t) < 2:
#         print("Error: Time vector is too short to compute timestep.")
#         return tsd

#     dt = np.diff(t)
#     if np.all(dt == 0):
#         print("Error: All timestamps are the same — skipping subsampling.")
#         return tsd

#     current_dt = int(np.median(dt))
#     if current_dt == 0:
#         print("Error: Computed timestep is zero — check data integrity.")
#         return tsd

#     current_dt_ms = current_dt * 1000  # seconds to ms
#     print(f"Current timestep: {current_dt} s, i.e., {current_dt_ms:.1f} ms")

#     if new_dt_ms is None:
#         print("To subsample, provide a new_dt_ms that is a multiple of the current dt.")
#         return tsd

#     new_dt_s = new_dt_ms / 1000
#     if (new_dt_s % current_dt) != 0:
#         print(f"Error: New timestep {new_dt_ms} ms is not a multiple of current timestep {current_dt_ms:.1f} ms.")
#         return tsd

#     stride = int(new_dt_s / current_dt)
#     t_sub = t[::stride]
#     data_sub = data[::stride]

#     tsd_subsampled = Tsd(t=t_sub, d=data_sub)
#     print(f"Subsampled to every {new_dt_ms} ms (every {stride} points). New length: {len(data_sub)}")
#     return tsd_subsampled
