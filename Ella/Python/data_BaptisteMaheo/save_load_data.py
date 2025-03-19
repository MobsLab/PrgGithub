#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  7 10:43:18 2025

@author: gruffalo
"""

import json
import os
import pandas as pd

def save_variable_to_json(variable, filepath):
    """
    Saves a Python variable to a JSON file, supporting pandas DataFrames.

    Parameters:
        variable (any): The variable to save (must be JSON serializable or a pandas DataFrame).
        filepath (str): The full path where the JSON file should be saved.

    Returns:
        None
    """
    os.makedirs(os.path.dirname(filepath), exist_ok=True)

    # Convert DataFrame to JSON if applicable
    if isinstance(variable, pd.DataFrame):
        variable = variable.to_dict(orient="records")  # Convert DataFrame to list of dictionaries

    with open(filepath, 'w') as f:
        json.dump(variable, f, indent=4)

    print(f"Variable successfully saved to {filepath}")


def load_variable_from_json(filepath):
    """
    Loads a Python variable from a JSON file, converting it to a pandas DataFrame if applicable.

    Parameters:
        filepath (str): The full path to the JSON file.

    Returns:
        The loaded variable (dict or DataFrame).
    """
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"Error: The file {filepath} does not exist.")

    with open(filepath, 'r') as f:
        variable = json.load(f)

    # Convert back to DataFrame if the data was stored as records
    if isinstance(variable, list) and isinstance(variable[0], dict):
        variable = pd.DataFrame(variable)

    print(f"Variable successfully loaded from {filepath}")
    return variable
