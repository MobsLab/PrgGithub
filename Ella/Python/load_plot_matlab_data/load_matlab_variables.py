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


def load_variables_from_path(path_dict, variables, experiment=None, subsample_params=None):
    """
    Loads variables from .mat files, wraps them as pynapple Tsd, and optionally subsamples.

    INPUTS:
        path_dict (dict): Dictionary with keys "path", "nMice", "ExpeInfo", and optionally "experiment"
        variables (list): Variables to load (e.g., ['Heartrate', 'BreathFreq', 'OBGamma'])
        experiment (str): Name of the experiment to tag in the output (defaults to path_dict['experiment'])
        subsample_params (dict): Optional dict with {"VariableName": new_dt_in_seconds}

    OUTPUT:
        dict: {mouse_id: {YYYYMMDD: {"experiment": str, variable: Tsd}}}
    """
    data_dict = {}
    subsample_params = subsample_params or {}

    # Use experiment from path_dict if not provided
    if experiment is None:
        experiment = path_dict.get("experiment", "Unknown")

    for path, mouse_id, expe_info in zip(path_dict["path"], path_dict["nMice"], path_dict["ExpeInfo"]):
        if isinstance(mouse_id, (list, tuple, np.ndarray)):
            mouse_id = mouse_id[0]
        mouse_id = int(mouse_id)

        experiment_date = expe_info.date if hasattr(expe_info, "date") else "Unknown"

        if mouse_id not in data_dict:
            data_dict[mouse_id] = {}
        if experiment_date not in data_dict[mouse_id]:
            data_dict[mouse_id][experiment_date] = {}

        # Add the experiment field
        data_dict[mouse_id][experiment_date]["experiment"] = experiment

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

def load_data_into_datasets(datasets, variables, subsample_params=None):
    for name, cfg in datasets.items():
        cfg["data"] = load_variables_from_path(cfg["paths"], variables, subsample_params=subsample_params)

# def load_variables_from_path(path_dict, variables, subsample_params=None):
#     """
#     Loads variables from .mat files, wraps them as pynapple Tsd, and optionally subsamples.

#     INPUTS:
#         path_dict (dict): Dictionary with keys "path", "nMice", "ExpeInfo"
#         variables (list): Variables to load (e.g., ['Heartrate', 'BreathFreq', 'OBGamma'])
#         subsample_params (dict): Optional dict with {"VariableName": new_dt_in_seconds}

#     OUTPUT:
#         dict: {mouse_id: {YYYYMMDD: {variable: Tsd}}}
#     """
#     data_dict = {}
#     subsample_params = subsample_params or {}

#     for path, mouse_id, expe_info in zip(path_dict["path"], path_dict["nMice"], path_dict["ExpeInfo"]):
#         if isinstance(mouse_id, (list, tuple, np.ndarray)):
#             mouse_id = mouse_id[0]
#         mouse_id = int(mouse_id)

#         experiment_date = expe_info.date if hasattr(expe_info, "date") else "Unknown"

#         if mouse_id not in data_dict:
#             data_dict[mouse_id] = {}
#         if experiment_date not in data_dict[mouse_id]:
#             data_dict[mouse_id][experiment_date] = {}

#         # Heartrate
#         if "Heartrate" in variables:
#             file_path = os.path.join(path, "HeartBeatInfo.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "EKG" in mat and hasattr(mat["EKG"], "HBRate"):
#                     tsd_data = mat["EKG"].HBRate
#                     tsd_hr = Tsd(t=tsd_data.t / 1e4, d=tsd_data.data)
#                     if "Heartrate" in subsample_params:
#                         tsd_hr = subsample_tsd(tsd_hr, subsample_params["Heartrate"])
#                     data_dict[mouse_id][experiment_date]["Heartrate"] = tsd_hr

#         # BreathFreq
#         if "BreathFreq" in variables:
#             file_path = os.path.join(path, "RespiFreq.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "Spectrum_Frequency" in mat:
#                     tsd_data = mat["Spectrum_Frequency"]
#                     tsd_bf = Tsd(t=tsd_data.t / 1e4, d=tsd_data.data)
#                     if "BreathFreq" in subsample_params:
#                         tsd_bf = subsample_tsd(tsd_bf, subsample_params["BreathFreq"])
#                     data_dict[mouse_id][experiment_date]["BreathFreq"] = tsd_bf

#         # OBGamma
#         if "OBGamma" in variables:
#             file_path = os.path.join(path, "SleepScoring_OBGamma.mat")
#             if os.path.exists(file_path):
#                 mat = scipy.io.loadmat(file_path, struct_as_record=False, squeeze_me=True)
#                 if "SmoothGamma" in mat:
#                     raw_obg = mat["SmoothGamma"]
#                     t = np.asarray(raw_obg.t) / 1e4
#                     d = np.asarray(raw_obg.data)
#                     if len(t) != len(d):
#                         print(f"Warning: Length mismatch in OBGamma (t: {len(t)}, d: {len(d)}), skipping.")
#                         continue
#                     tsd_obg = Tsd(t=t, d=d)
#                     if "OBGamma" in subsample_params:
#                         tsd_obg = subsample_tsd(tsd_obg, subsample_params["OBGamma"])
#                     data_dict[mouse_id][experiment_date]["OBGamma"] = tsd_obg

#     return data_dict


