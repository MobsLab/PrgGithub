#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  7 16:40:03 2025

@author: gruffalo
"""

import numpy as np
from pynapple import Tsd


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


from pynapple import Tsd
import numpy as np

def interpolate_tsd(source_tsd, target_tsd, remove_invalid=True):
    """
    Interpolate source_tsd values to match the time base of target_tsd.

    Parameters:
    - source_tsd: pynapple.Tsd
    - target_tsd: pynapple.Tsd
    - remove_invalid (bool): Whether to remove NaNs/Infs after interpolation.

    Returns:
    - interpolated_tsd: pynapple.Tsd
    """
    # Extract time and values
    t_source = source_tsd.index.values
    v_source = source_tsd.values

    # Remove NaNs/Infs from source
    valid = np.isfinite(v_source)
    t_source = t_source[valid]
    v_source = v_source[valid]

    if len(t_source) == 0:
        raise ValueError("No valid (finite) data points in source_tsd for interpolation.")

    # Sort by time just in case
    sort_idx = np.argsort(t_source)
    t_source = t_source[sort_idx]
    v_source = v_source[sort_idx]

    # Perform interpolation
    interp_values = np.interp(
        x=target_tsd.index.values,
        xp=t_source,
        fp=v_source
    )

    # Construct Tsd
    result_tsd = Tsd(t=target_tsd.index, d=interp_values)

    # Optionally remove any resulting non-finite values
    if remove_invalid:
        finite_mask = np.isfinite(result_tsd.values)
        result_tsd = result_tsd[finite_mask]

    return result_tsd



