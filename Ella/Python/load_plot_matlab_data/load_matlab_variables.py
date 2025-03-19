#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 19 18:12:20 2025

@author: gruffalo
"""

import os
import scipy.io
import numpy as np

def load_variables_from_path(path_dict, variables):
    """
    Loads requested variables ('Heartrate', 'BreathFreq') from the corresponding .mat files
    for each mouse and organizes them by experiment date.

    INPUTS:
        path_dict (dict): Dictionary containing mouse paths and experiment details.
        variables (list): List of variables to load (e.g., ['Heartrate', 'BreathFreq']).

    OUTPUT:
        A nested dictionary structured as:
        {
            MouseID1: {
                "YYYYMMDD": {"Variable1": data, "Variable2": data},
                "YYYYMMDD": {"Variable1": data, "Variable2": data},
            },
            MouseID2: {
                "YYYYMMDD": {"Variable1": data, "Variable2": data},
            }
        }
    """

    data_dict = {}

    for path, mouse_id, expe_info in zip(path_dict["path"], path_dict["nMice"], path_dict["ExpeInfo"]):
        # Ensure mouse_id is stored as an integer (avoid NumPy array issue)
        if isinstance(mouse_id, (list, tuple, np.ndarray)):  
            mouse_id = mouse_id[0]  # Extract scalar value if stored in array format
        mouse_id = int(mouse_id)  # Ensure it's an integer key

        # Extract experiment date from ExpeInfo
        experiment_date = expe_info.date if hasattr(expe_info, "date") else "Unknown"

        # Initialize dictionary structure
        if mouse_id not in data_dict:
            data_dict[mouse_id] = {}
        if experiment_date not in data_dict[mouse_id]:
            data_dict[mouse_id][experiment_date] = {}

        # Load Heartrate from HeartBeatInfo.mat (EKG.HBRate)
        if "Heartrate" in variables:
            heartbeat_info_path = os.path.join(path, "HeartBeatInfo.mat")
            if os.path.exists(heartbeat_info_path):
                mat_data = scipy.io.loadmat(heartbeat_info_path, struct_as_record=False, squeeze_me=True)
                if "EKG" in mat_data and hasattr(mat_data["EKG"], "HBRate"):
                    data_dict[mouse_id][experiment_date]["Heartrate"] = mat_data["EKG"].HBRate
                else:
                    print(f"Warning: 'EKG.HBRate' not found in {heartbeat_info_path}")
            else:
                print(f"File not found: {heartbeat_info_path}")

        # Load BreathFreq from RespiFreq.mat (Spectrum_Frequency)
        if "BreathFreq" in variables:
            respi_freq_path = os.path.join(path, "RespiFreq.mat")
            if os.path.exists(respi_freq_path):
                mat_data = scipy.io.loadmat(respi_freq_path, struct_as_record=False, squeeze_me=True)
                if "Spectrum_Frequency" in mat_data:
                    data_dict[mouse_id][experiment_date]["BreathFreq"] = mat_data["Spectrum_Frequency"]
                else:
                    print(f"Warning: 'Spectrum_Frequency' not found in {respi_freq_path}")
            else:
                print(f"File not found: {respi_freq_path}")

    return data_dict

# Example Usage:
# path_dict = get_path_for_expe_cardiosense_ivabradine("IvabradineExperiment")
# variables = ["Heartrate", "BreathFreq"]
# loaded_data = load_variables_from_path(path_dict, variables)


