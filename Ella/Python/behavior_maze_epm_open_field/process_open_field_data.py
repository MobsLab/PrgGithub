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
    else:
        in_specific = np.full_like(distances, False, dtype=bool)

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
        'Inner': ZoneEpoch_Inner,
        'Specific': ZoneEpoch_Specific
    }
    full_data['AlignedZoneLabels'] = np.array(['Outer', 'Inner', 'Specific'], dtype=object)
    full_data['AlignedZoneIndices'] = {
        'Outer': in_outer.astype(np.uint8),
        'Inner': in_inner.astype(np.uint8),
        'Specific': in_specific.astype(np.uint8)
    }
    full_data['distances'] = distances
    # full_data['timestamps'] = t

    # Save updated structure (overwriting but preserving previous content)
    savemat(mat_path, full_data)
    print(f"Saved updated zone data to {mat_path}")
    
    return {
        'Thigmotaxis': np.sum(in_outer) / (np.sum(in_outer) + np.sum(in_inner)),
        'distances': dist_tsd,
        'ZoneEpoch_Outer': ZoneEpoch_Outer,
        'ZoneEpoch_Inner': ZoneEpoch_Inner,
        'ZoneEpoch_Specific': ZoneEpoch_Specific
    }



