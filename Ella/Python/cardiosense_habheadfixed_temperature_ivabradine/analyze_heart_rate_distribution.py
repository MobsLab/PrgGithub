#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 22 17:30:13 2025

@author: gruffalo
"""

from scipy.stats import pearsonr
import numpy as np

def compute_tsd_correlation(data_dict, mouse_id, date, var1, var2):
    """
    Computes the Pearson correlation between two synchronized tsd variables.

    INPUTS:
        data_dict (dict): Nested dictionary {mouse_id -> {date -> {variable -> tsd}}}
        mouse_id (int): Mouse identifier (e.g., 1690)
        date (str): Date string in 'YYYYMMDD' format
        var1 (str): Name of the first variable
        var2 (str): Name of the second variable

    OUTPUT:
        Pearson correlation coefficient (r) and p-value
    """
    try:
        tsd1 = data_dict[mouse_id][date][var1]
        tsd2 = data_dict[mouse_id][date][var2]
    except KeyError:
        raise ValueError("One of the variables, mouse ID, or date is missing from the data dictionary.")

    # Synchronize the tsd variables based on common time points
    common_times = np.intersect1d(tsd1.t, tsd2.t)
    if len(common_times) == 0:
        raise ValueError("No overlapping time points between the two variables.")

    # Extract synchronized data
    data1 = tsd1.loc[common_times].data
    data2 = tsd2.loc[common_times].data

    # Compute Pearson correlation
    r, p = pearsonr(data1, data2)
    return r, p
