#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 17:36:52 2025

@author: gruffalo
"""

import os

def get_experiment_paths_with_expeinfo(base_path="/media/nas8-2/ProjectCardioSense/"):
    """
    Scans the given directory recursively and returns all folder paths 
    that contain an 'ExpeInfo.mat' file, sorted by name.

    OUTPUT:
        Sorted list of full paths to folders containing 'ExpeInfo.mat'.
    """
    experiment_paths = []

    # Check if base path exists
    if not os.path.exists(base_path):
        print(f"Error: The directory '{base_path}' does not exist.")
        return []

    # Recursively search for ExpeInfo.mat in all subdirectories
    for root, _, files in os.walk(base_path):
        if "ExpeInfo.mat" in files:
            experiment_paths.append(root)

    # Sort the paths alphabetically
    experiment_paths.sort()

    return experiment_paths

# Example usage
# experiment_list = get_experiment_paths_with_expeinfo()
# for path in experiment_list:
#     print(path)


def get_experiment_paths_with_behavresources_and_keyword(base_path="/media/nas8-2/ProjectCardioSense/", keyword=None):
    """
    Scans the given directory recursively and returns all folder paths 
    that contain a 'behavResources.mat' file, optionally filtered by a keyword in the folder name.

    INPUT:
        base_path (str): Root directory to search.
        keyword (str or None): Keyword to filter folder names (case-sensitive). If None, no filtering is applied.

    OUTPUT:
        Sorted list of full paths to folders containing 'behavResources.mat' (and the keyword if provided).
    """
    matching_paths = []

    if not os.path.exists(base_path):
        print(f"Error: The directory '{base_path}' does not exist.")
        return []

    for root, _, files in os.walk(base_path):
        if "behavResources_Online.mat" in files:
            folder_name = os.path.basename(root)
            if keyword is None or keyword in folder_name:
                matching_paths.append(root)

    matching_paths.sort()
    return matching_paths

# Example usage:
# all_paths = get_experiment_paths_with_behavresources_and_keyword()
# fear_paths = get_experiment_paths_with_behavresources_and_keyword(keyword="FEAR")


