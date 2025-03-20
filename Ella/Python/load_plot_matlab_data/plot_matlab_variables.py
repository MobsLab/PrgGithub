#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 19 19:00:02 2025

@author: gruffalo
"""

import matplotlib.pyplot as plt
from make_pretty_plot import make_pretty_plot

def plot_variable_over_time(data, mouse_id, variable, date):
    """
    Plots a given variable against time for a specific mouse and experiment date.

    INPUTS:
        data (dict): Nested dictionary {mouse_id -> {date -> {variable -> tsd_data}}}
        mouse_id (int): Mouse identifier (e.g., 1690)
        date (str): Experiment date in 'YYYYMMDD' format (e.g., '20250221')
        variable (str): Name of the variable to plot (e.g., 'Heartrate' or 'BreathFreq')

    OUTPUT:
        Displays a time series plot of the selected variable with enhanced styling.
    """

    if mouse_id not in data:
        print(f"Error: Mouse {mouse_id} not found in the dataset.")
        return
    if date not in data[mouse_id]:
        print(f"Error: No data found for Mouse {mouse_id} on {date}.")
        return
    if variable not in data[mouse_id][date]:
        print(f"Error: Variable '{variable}' not found for Mouse {mouse_id} on {date}.")
        return

    # Extract time and variable data
    tsd_data = data[mouse_id][date][variable]
    time = tsd_data.t / 1e4  # Convert to seconds
    values = tsd_data.data   # Extract variable values

    # Create the plot
    fig, ax = plt.subplots(figsize=(10, 5))
    ax.plot(time, values, color='brown', linewidth=2)

    # Formatting
    ax.set_title(f"{variable} over Time (Mouse {mouse_id}, {date})")
    ax.set_xlabel("Time (s)")
    ax.set_ylabel(variable)

    # Apply the pretty formatting function
    make_pretty_plot(ax)

    plt.show()


import seaborn as sns

def plot_variable_distribution(data_list, mouse_id, variable, dates=None, ylim=None):
    """
    Plots a violin plot to visualize the distribution of a given variable 
    for a specific mouse across multiple datasets.

    By default, it plots data from all available dates in all provided datasets.
    If specific dates are provided, only those dates will be plotted.

    INPUTS:
        data_list (list of dicts): List of nested dictionaries {mouse_id -> {date -> {variable -> tsd_data}}}
        mouse_id (int): Mouse identifier (e.g., 1690)
        variable (str): Name of the variable to plot (e.g., 'Heartrate' or 'BreathFreq')
        dates (list, optional): List of dates to plot (format ['YYMMDD', 'YYMMDD']). 
                                If None, plots all available dates.
        ylim (tuple, optional): Custom y-axis limits (e.g., (min, max)). 
                                Defaults:
                                  - Heartrate: (6, 14)
                                  - BreathFreq: (0, 9)

    OUTPUT:
        Displays a violin plot of the selected variable's distribution.
    """
    
    all_data = []
    labels = []

    # Convert YYMMDD format to YYYYMMDD for searching
    if dates:
        full_dates = {f"20{date}" for date in dates}  # Convert to full YYYYMMDD format
    else:
        full_dates = None  # If no specific dates, use all available ones

    # Iterate through all provided datasets
    for data in data_list:
        if mouse_id not in data:
            continue  # Skip if the mouse is not in this dataset

        for session_date, session_data in data[mouse_id].items():
            short_date = session_date[2:]  # Convert 'YYYYMMDD' → 'YYMMDD'

            # Check if we should include this date
            if full_dates is None or session_date in full_dates:
                if variable in session_data:
                    values = session_data[variable].data
                    all_data.append(values)
                    labels.append(short_date)

    if not all_data:
        print(f"Error: No data available for Mouse {mouse_id} and variable '{variable}'.")
        return

    # Set default y-limits if not provided
    if ylim is None:
        default_ylim = {"Heartrate": (6, 14), "BreathFreq": (0, 9)}
        ylim = default_ylim.get(variable, None)  # If variable not listed, don't set ylim

    # Create the plot
    fig, ax = plt.subplots(figsize=(8, 6))
    sns.violinplot(data=all_data, inner="box", palette="muted", ax=ax)

    # Set labels and title
    ax.set_xticks(range(len(labels)))
    ax.set_xticklabels(labels, fontsize=12, fontweight="bold")
    ax.set_xlabel("Date" if not dates else "Selected Sessions", fontsize=14, fontweight="bold")
    ax.set_ylabel(variable, fontsize=14, fontweight="bold")
    ax.set_title(f"Distribution of {variable} (Mouse {mouse_id})", fontsize=16, fontweight="bold")

    # Apply y-limits if defined
    if ylim:
        ax.set_ylim(ylim)

    # Apply custom styling
    make_pretty_plot(ax)

    plt.show()

# Example Usage:
# plot_variable_distribution([data1, data2], 1690, 'Heartrate', dates=['240221', '240223'])

