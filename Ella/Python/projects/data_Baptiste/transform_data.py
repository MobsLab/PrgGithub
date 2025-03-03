#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 14:35:50 2025

@author: gruffalo
"""

import numpy as np

def apply_sigmoid(mice_data, mouse_id, column_name, slope=1, op_point=0):
    """
    Applies a sigmoid transformation to a given column of the dataframes 
    of a specified mouse or all mice.
    
    The sigmoid function applied is: 
        f(x) = 1 / (1 + exp(-slope * (x - op_point)))

    Parameters:
        mice_data (dict): Dictionary containing mouse IDs as keys and their dataframes as values.
        mouse_id (str): The ID of the mouse to transform ('all' to apply to all mice).
        column_name (str): The name of the column to apply the transformation.
        slope (float, optional): The steepness of the sigmoid function (default: 1).
        op_point (float, optional): The threshold/shift of the sigmoid function (default: 0).

    Returns:
        dict: A new dictionary with transformed dataframes.
    """
    transformed_data = {}

    mice_list = mice_data.keys() if mouse_id == 'all' else [mouse_id]

    for mouse in mice_list:
        if mouse not in mice_data:
            print(f"Warning: Mouse ID {mouse} not found in data.")
            continue

        df = mice_data[mouse].copy()

        if column_name not in df.columns:
            print(f"Warning: Column '{column_name}' not found in mouse {mouse} data.")
            transformed_data[mouse] = df  # Keep the original data unchanged
            continue

        # Apply the sigmoid transformation
        # df[column_name + "_sigmoid"] = 1 / (1 + np.exp(-slope * (df[column_name] - op_point)))
        df[column_name] = 1 / (1 + np.exp(-slope * (df[column_name] - op_point)))

        transformed_data[mouse] = df

    return transformed_data


# # Apply sigmoid transformation to the 'HeartRate' column of all mice
# transformed_mice_data = apply_sigmoid(mice_data, mouse_id='all', column_name='HeartRate', slope=1, op_point=70)

# # Apply sigmoid transformation to only mouse 'M561' for the 'BreathFreq' column
# transformed_m561 = apply_sigmoid(mice_data, mouse_id='M561', column_name='BreathFreq', slope=2, op_point=30)

# # View transformed data for mouse 'M561'
# print(transformed_m561['M561'].head())


# import matplotlib.pyplot as plt 
# import numpy as np
# z = np.linspace(-10,10,100)

# def sigmoid(z, a, b):
#     return 1/(1 + np.exp(-a*(z-b)))

# c = sigmoid(z, a, b)
# plt.plot(z, c) 
# plt.xlabel("z") 
# plt.ylabel("sigmoid(z)")


def apply_exponential(mice_data, mouse_id, column_name, tau=1):
    """
    Applies a negative exponential transformation to a given column 
    of the dataframes of a specified mouse or all mice.
    
    The exponential function applied is: 
        f(x) = exp(-x / tau)

    Parameters:
        mice_data (dict): Dictionary containing mouse IDs as keys and their dataframes as values.
        mouse_id (str): The ID of the mouse to transform ('all' to apply to all mice).
        column_name (str): The name of the column to apply the transformation.
        tau (float, optional): The time constant of the exponential function (default: 1).

    Returns:
        dict: A new dictionary with transformed dataframes.
    """
    if tau <= 0:
        raise ValueError("Tau must be positive.")

    transformed_data = {}

    mice_list = mice_data.keys() if mouse_id == 'all' else [mouse_id]

    for mouse in mice_list:
        if mouse not in mice_data:
            print(f"Warning: Mouse ID {mouse} not found in data.")
            continue

        df = mice_data[mouse].copy()

        if column_name not in df.columns:
            print(f"Warning: Column '{column_name}' not found in mouse {mouse} data.")
            transformed_data[mouse] = df  # Keep the original data unchanged
            continue

        # Apply the negative exponential transformation
        df[column_name + "_exp"] = np.exp(-df[column_name] / tau)

        transformed_data[mouse] = df

    return transformed_data


# # Apply negative exponential transformation to the 'HeartRate' column for all mice
# transformed_mice_data = apply_exponential(mice_data, mouse_id='all', column_name='HeartRate', tau=50)

# # Apply negative exponential transformation to only mouse 'M561' for the 'BreathFreq' column
# transformed_m561 = apply_exponential(mice_data, mouse_id='M561', column_name='BreathFreq', tau=20)

# # View transformed data for mouse 'M561'
# print(transformed_m561['M561'].head())


# import matplotlib.pyplot as plt 
# import numpy as np
# z = np.linspace(-10,10,100)

# def exp(z, tau):
#     return np.exp(-z/tau)

# a = exp(z, 30)
# plt.plot(z, a) 
# plt.xlabel("z") 
# plt.ylabel("exp(z)")


# def sigmoid_transform(df, column_name, slope, op_point):
#     """Applies a sigmoid transformation to a given column."""
#     return 1 / (1 + np.exp(-slope * (df[column_name] - op_point)))

# def exponential_transform(df, column_name, tau):
#     """Applies a negative exponential transformation to a given column."""
#     return np.exp(-df[column_name] / tau)


# def transform_features(df, slope, op_point, tau):
#     """
#     Transforms the input dataframe by computing the required features.

#     Parameters:
#         df (pd.DataFrame): Original dataframe with raw features.
#         slope (float): Parameter for the sigmoid transformation.
#         op_point (float): Parameter for the sigmoid transformation.
#         tau (float): Parameter for the exponential transformation.

#     Returns:
#         pd.DataFrame: Transformed dataframe with the selected features.
#     """
#     df_transformed = df.copy()

#     # Compute sig(Global Time)
#     df_transformed["sig_Global_Time"] = sigmoid_transform(df_transformed, "Global Time", slope, op_point)

#     # Compute Position * sig(Global Time)
#     df_transformed["Position_sig_Global_Time"] = df_transformed["Position"] * df_transformed["sig_Global_Time"]

#     # Compute -exp(Time since last shock)
#     df_transformed["neg_exp_Time_since_last_shock"] = -exponential_transform(df_transformed, "Time since last shock", tau)

#     # Select the required features
#     X = df_transformed[["Position", "Position_sig_Global_Time", "neg_exp_Time_since_last_shock", "Global Time"]]
#     y = df_transformed["OB frequency"]

#     return X, y

