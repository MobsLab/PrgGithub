#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar  4 10:48:09 2025

@author: gruffalo
"""



import numpy as np
import matplotlib.pyplot as plt

def plot_sigmoid_transform(df, column_name, slope=1, op_point=0):
    """
    Plots the sigmoid transformation of a given column in a dataframe along with a simulated transformation.

    Parameters:
    - df (pd.DataFrame): Dataframe containing the column to transform.
    - column_name (str): Name of the column to transform.
    - slope (float, optional): Controls the steepness of the sigmoid curve (default: 1).
    - op_point (float, optional): Shift parameter for the sigmoid function (default: 0).

    Returns:
    - None (displays the plot).
    """
    # Extract the column values
    column_values = df[column_name].dropna()

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
    transformed_values = -np.exp(-column_values / tau)

    # Create a simulated input vector covering the same range as the real data
    simulated_x = np.linspace(column_values.min(), column_values.max(), 300)
    simulated_y = -np.exp(-simulated_x / tau)

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


# import numpy as np
# import matplotlib.pyplot as plt

# def plot_sigmoid_transform(df, column_name, slope=1, op_point=0):
#     """
#     Plots the sigmoid transformation of a given column in a dataframe.

#     Parameters:
#     - df (pd.DataFrame): Dataframe containing the column to transform.
#     - column_name (str): Name of the column to transform.
#     - slope (float, optional): Controls the steepness of the sigmoid curve (default: 1).
#     - op_point (float, optional): Shift parameter for the sigmoid function (default: 0).

#     Returns:
#     - None (displays the plot).
#     """
#     # Apply the sigmoid transformation
#     transformed_values = 1 / (1 + np.exp(-slope * (df[column_name] - op_point)))

#     # Plot the transformation
#     plt.figure(figsize=(8, 5))
#     plt.scatter(df[column_name], transformed_values, color='brown', alpha=0.7, label='Sigmoid Transformed')
#     plt.xlabel(column_name)
#     plt.ylabel('Sigmoid Transform')
#     plt.title(f'Sigmoid Transformation of {column_name}')
#     plt.legend()
#     plt.grid(True)
#     plt.show()


# def plot_exp_transform(df, column_name, tau=1):
#     """
#     Plots the negative exponential transformation of a given column in a dataframe.

#     Parameters:
#     - df (pd.DataFrame): Dataframe containing the column to transform.
#     - column_name (str): Name of the column to transform.
#     - tau (float, optional): Time constant for the exponential decay (default: 1).

#     Returns:
#     - None (displays the plot).
#     """
#     # Apply the negative exponential transformation
#     transformed_values = np.exp(-df[column_name] / tau)

#     # Plot the transformation
#     plt.figure(figsize=(8, 5))
#     plt.scatter(df[column_name], transformed_values, color='brown', alpha=0.7, label='Negative Exp Transformed')
#     plt.xlabel(column_name)
#     plt.ylabel('Negative Exp Transform')
#     plt.title(f'Negative Exponential Transformation of {column_name}')
#     plt.legend()
#     plt.grid(True)
#     plt.show()
