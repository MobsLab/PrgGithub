#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar  4 10:48:09 2025

@author: gruffalo
"""



import numpy as np
import matplotlib.pyplot as plt


def plot_sigmoid_transform(df, column_name, slope=1, op_point=0, range=False):
    """
    Plots the sigmoid transformation of a given column in a dataframe along with a simulated transformation.

    Parameters:
    - df (pd.DataFrame): Dataframe containing the column to transform.
    - column_name (str): Name of the column to transform.
    - slope (float, optional): Controls the steepness of the sigmoid curve (default: 1).
    - op_point (float, optional): If range=False, it is a fixed value.
                                  If range=True, it is a fraction of the range of the column (default: 0).
    - range (bool, optional): If True, sets op_point as a fraction of the range of the column.

    Returns:
    - None (displays the plot).
    """
    # Extract the column values
    column_values = df[column_name].dropna()

    # Compute range-based op_point if range=True
    if range:
        col_min = column_values.min()
        col_max = column_values.max()
        col_range = col_max - col_min
        op_point = col_min + (op_point * col_range)  # Compute as fraction of range

    # Apply the sigmoid transformation to the real data
    transformed_values = 1 / (1 + np.exp(-slope * (column_values - op_point)))

    # Create a simulated input vector covering the same range as the real data
    simulated_x = np.linspace(column_values.min(), column_values.max(), 300)
    simulated_y = 1 / (1 + np.exp(-slope * (simulated_x - op_point)))

    # Plot the transformation
    plt.figure(figsize=(8, 5))
    plt.scatter(column_values, transformed_values, color='brown', alpha=0.7, label='Real Data Transformed')
    plt.plot(simulated_x, simulated_y, color='black', linestyle='dashed', label='Simulated Sigmoid Curve')

    # Labels and title
    plt.xlabel(column_name)
    plt.ylabel('Sigmoid Transform')
    plt.title(f'Sigmoid Transformation of {column_name}')
    plt.legend()
    plt.grid(True)
    plt.show()

    
def plot_exp_transform(df, column_name, tau=1):
    """
    Plots the negative exponential transformation of a given column in a dataframe along with a simulated transformation.

    Parameters:
    - df (pd.DataFrame): Dataframe containing the column to transform.
    - column_name (str): Name of the column to transform.
    - tau (float, optional): Time constant for the exponential decay (default: 1).

    Returns:
    - None (displays the plot).
    """
    # Extract the column values
    column_values = df[column_name].dropna()

    # Apply the negative exponential transformation to the real data
    transformed_values = np.exp(-column_values / tau)

    # Create a simulated input vector covering the same range as the real data
    simulated_x = np.linspace(column_values.min(), column_values.max(), 300)
    simulated_y = np.exp(-simulated_x / tau)

    # Plot the transformation
    plt.figure(figsize=(8, 5))
    plt.scatter(column_values, transformed_values, color='brown', alpha=0.7, label='Real Data Transformed')
    plt.plot(simulated_x, simulated_y, color='black', linestyle='dashed', label='Simulated Exp Curve')

    # Labels and title
    plt.xlabel(column_name)
    plt.ylabel('Negative Exp Transform')
    plt.title(f'Negative Exponential Transformation of {column_name}')
    plt.legend()
    plt.grid(True)
    plt.show()


def plot_mouse_column(mice_data, mouse_id, column_name):
    """
    Plots a specified column from a given mouse's dataframe.

    Parameters:
    - mice_data (dict): Dictionary containing dataframes for each mouse.
    - mouse_id (str): The ID of the mouse whose data will be plotted.
    - column_name (str): Name of the column to plot.

    Returns:
    - None (Displays the plot).
    """
    if mouse_id not in mice_data:
        print(f"Error: Mouse ID '{mouse_id}' not found in data.")
        return
    
    df = mice_data[mouse_id]

    if column_name not in df.columns:
        print(f"Error: Column '{column_name}' not found in mouse {mouse_id} data.")
        return

    plt.figure(figsize=(8, 5))
    plt.plot(df[column_name], color='brown', label=column_name)
    plt.xlabel("Index")
    plt.ylabel(column_name)
    plt.title(f"Plot of '{column_name}' for Mouse {mouse_id}")
    plt.legend()
    plt.grid(True)
    plt.show()

