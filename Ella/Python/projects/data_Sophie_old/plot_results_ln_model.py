#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 11:21:09 2024

@author: gruffalo
"""

import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import interp1d


def plot_interpolated_coefficients(coefficients, variable, interpolation_kind='linear'):
    """
    Plots interpolated values of fitted coefficients for a lagged variable, with the oldest lag on the left.

    Parameters:
    - coefficients (dict): Dictionary of fitted coefficients with lagged variable names as keys.
    - variable (str): The base name of the variable (e.g., 'Heartrate').
    - interpolation_kind (str): Type of interpolation (default is 'linear').

    Returns:
    - None: Displays the plot.
    """
    # Extract negative lags and coefficients for the specified variable
    lags = []
    coef_values = []
    
    for lag_name, coef in coefficients.items():
        # Match variable names that follow the 'variable_t_minus_X' pattern
        if lag_name.startswith(f"{variable}_t_minus") or lag_name == f"{variable}_t_plus_0":
            # Extract the lag value (e.g., -3, -2, etc.)
            lag = -int(lag_name.split('_')[-1].replace('minus', '').replace('plus', '0'))
            lags.append(lag)
            coef_values.append(coef)

    # Sort the lags and associated coefficients from oldest to most recent
    sorted_lags, sorted_coefs = zip(*sorted(zip(lags, coef_values)))
    
    # Check if cubic interpolation is possible with the number of data points
    if interpolation_kind == 'cubic' and len(sorted_lags) < 4:
        print("Insufficient data points for cubic interpolation. Switching to linear interpolation.")
        interpolation_kind = 'linear'
   
    
    # Set up the interpolation on the negative lags
    interp_function = interp1d(sorted_lags, sorted_coefs, kind=interpolation_kind, fill_value="extrapolate")
    dense_lags = np.linspace(min(sorted_lags), max(sorted_lags), 200)
    interpolated_coefs = interp_function(dense_lags)
    
    # Plot
    plt.figure(figsize=(8, 6))
    plt.scatter(sorted_lags, sorted_coefs, color='brown', marker='o', label='Original Coefficients')
    plt.plot(dense_lags, interpolated_coefs, 'brown', linewidth=3, label='Interpolated Curve')
    
    plt.xlabel('Lag')
    plt.ylabel('Coefficient Value')
    plt.title(f'Interpolated Coefficients for {variable} Across Lags')
    plt.legend()
    plt.grid(True)
    
    # Adjust xlim based on lags and limit ylim to [0, 1.2]
    plt.xlim(min(sorted_lags)-0.1, max(sorted_lags)+0.1)
    # plt.ylim(0, 1.2)
    
    plt.show()

