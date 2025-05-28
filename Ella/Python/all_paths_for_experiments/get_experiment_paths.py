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
        if "behavResources.mat" in files:
            folder_name = os.path.basename(root)
            if keyword is None or keyword in folder_name:
                matching_paths.append(root)

    matching_paths.sort()
    return matching_paths

# Example usage:
# all_paths = get_experiment_paths_with_behavresources_and_keyword()
# fear_paths = get_experiment_paths_with_behavresources_and_keyword(keyword="FEAR")


def rename_behav_resources(base_path, keyword=None):
    """
    Scan directories under base_path, find folders containing both 'behavResources.mat' and 'behavResources_Offline.mat',
    ask for user confirmation, then rename:
        'behavResources.mat'      -> 'behavResources_Online.mat'
        'behavResources_Offline.mat' -> 'behavResources.mat'

    Args:
        base_path (str): root directory to scan
        keyword (str or None): optional keyword filter on folder name

    Returns:
        None
    """
    def get_folders_with_both(base_path, keyword):
        matching = []
        for root, _, files in os.walk(base_path):
            if "behavResources.mat" in files and "behavResources_Offline.mat" in files:
                folder_name = os.path.basename(root)
                if keyword is None or keyword in folder_name:
                    matching.append(root)
        matching.sort()
        return matching

    folders = get_folders_with_both(base_path, keyword)

    if not folders:
        print("No folders found with both 'behavResources.mat' and 'behavResources_Offline.mat'.")
        return

    for folder in folders:
        print(f"\nFolder: {folder}")
        print("Contains:")
        print(" - behavResources.mat")
        print(" - behavResources_Offline.mat")
        ans = input("Rename 'behavResources.mat' -> 'behavResources_Online.mat' and 'behavResources_Offline.mat' -> 'behavResources.mat'? (y/n): ").strip().lower()
        if ans == 'y':
            old_online = os.path.join(folder, 'behavResources.mat')
            old_offline = os.path.join(folder, 'behavResources_Offline.mat')
            new_online = os.path.join(folder, 'behavResources_Online.mat')
            new_offline = os.path.join(folder, 'behavResources.mat')

            if os.path.exists(new_online):
                print(f"Erreur : '{new_online}' already exists, cancelling to avoid writing the file.")
                continue
            
            try:
                # Rename behavResources.mat -> behavResources_Online.mat
                os.rename(old_online, new_online)
                # Rename behavResources_Offline.mat -> behavResources.mat
                os.rename(old_offline, new_offline)

                print("Files renamed successfully.")
            except Exception as e:
                print(f"Error during renaming: {e}")
        else:
            print("Skipping this folder.")

# Example usage:
# rename_behav_resources("/media/nas8-2/ProjectCardioSense/")


