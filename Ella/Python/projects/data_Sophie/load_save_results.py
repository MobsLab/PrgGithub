#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  3 14:47:50 2024

@author: gruffalo
"""

import pickle
import os

def load_results(file_path):
    """
    Load data from a specified file path.

    Parameters:
    - file_path: The full path to the file to load.

    Returns:
    - The loaded results object.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"The file {file_path} does not exist.")

    # Load the results using Pickle
    with open(file_path, "rb") as file:
        results = pickle.load(file)

    print(f"Data loaded successfully from {file_path}.")
    return results


def save_results(results, directory, file_name):
    """
    Save data to a specified directory.

    Parameters:
    - results: The object to save (e.g., a list of dictionaries).
    - directory: The directory where the file should be saved.
    - file_name: The name of the file (ex: 'all_results.pkl').

    Returns:
    - file_path: The full path to the saved file.
    """
    # Ensure the directory exists
    os.makedirs(directory, exist_ok=True)

    # Full file path
    file_path = os.path.join(directory, file_name)

    # Save the results using Pickle
    with open(file_path, "wb") as file:
        pickle.dump(results, file)

    print(f"Data saved successfully in {file_path}.")
    return file_path


# import os
# import json

# def load_results(file_path):
#     """
#     Load data from a specified file path.

#     Parameters:
#     - file_path: The full path to the file to load.

#     Returns:
#     - The loaded results object.
#     """
#     if not os.path.exists(file_path):
#         raise FileNotFoundError(f"The file {file_path} does not exist.")

#     # Load the results using JSON
#     with open(file_path, "r") as file:
#         results = json.load(file)

#     print(f"Data loaded successfully from {file_path}.")
#     return results


# def save_results(results, directory, file_name):
#     """
#     Save data to a specified directory.

#     Parameters:
#     - results: The object to save (e.g., a list of dictionaries).
#     - directory: The directory where the file should be saved.
#     - file_name: The name of the file (ex: 'all_results.json').

#     Returns:
#     - file_path: The full path to the saved file.
#     """
#     # Ensure the directory exists
#     os.makedirs(directory, exist_ok=True)

#     # Full file path
#     file_path = os.path.join(directory, file_name)

#     # Save the results using JSON
#     with open(file_path, "w") as file:
#         json.dump(results, file, indent=4)

#     print(f"Data saved successfully in {file_path}.")
#     return file_path



