#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 16 16:26:02 2025

@author: gruffalo
"""

import os

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


