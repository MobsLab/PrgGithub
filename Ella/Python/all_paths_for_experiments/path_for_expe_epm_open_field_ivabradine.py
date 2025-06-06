#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 23 12:05:34 2025

@author: gruffalo
"""


import os
import scipy.io
import re
from datetime import datetime


def get_path_for_expe_epm_open_field_ivabradine(experiment):
    '''
    INPUT:
        experiment (str): Name of the experiment.

    OUTPUT:
        dir_info (dict): Dictionary containing paths, behavior info, mouse IDs, dates, and experiment name.
    '''

    dir_info = {
        'path': [],
        'behavResources': [],
        'OfflineOpenFieldZones': [],
        'nMice': [],
        'date': [],
        'experiment': experiment,
        'name': []
    }
    
    if experiment == 'Open_Field_Saline_Exposition':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1748/OpenField/FEAR-Mouse-1748-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1752/OpenField/FEAR-Mouse-1752-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1754/OpenField/FEAR-Mouse-1754-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1759/OpenField/FEAR-Mouse-1759-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1763/OpenField/FEAR-Mouse-1763-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1751/OpenField/FEAR-Mouse-1751-16042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1756/OpenField/FEAR-Mouse-1756-16042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1760/OpenField/FEAR-Mouse-1760-16042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1765/OpenField/FEAR-Mouse-1765-16042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1767/OpenField/FEAR-Mouse-1767-16042025-EPM_00',
        ]
    
    elif experiment == 'Test':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/Tests_temporary/FEAR-Mouse-1756-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/Tests_temporary/FEAR-Mouse-7-15042025-EPM_00',
            # '/media/nas8-2/ProjectCardioSense/Tests_temporary/FEAR-Mouse-1752-17042025-EPM_00',
            # '/media/nas8-2/ProjectCardioSense/Tests_temporary/FEAR-Mouse-1750-18042025-EPM_00',
            
        ]
        
    elif experiment == 'Open_Field_Ivabradine_Exposition':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1749/OpenField/FEAR-Mouse-1749-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1753/OpenField/FEAR-Mouse-1753-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1758/OpenField/FEAR-Mouse-1758-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1762/OpenField/FEAR-Mouse-1762-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1764/OpenField/FEAR-Mouse-1764-15042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1750/OpenField/FEAR-Mouse-1750-16042025-EPM_01',
            '/media/nas8-2/ProjectCardioSense/K1755/OpenField/FEAR-Mouse-1755-16042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1757/OpenField/FEAR-Mouse-1757-16042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1761/OpenField/FEAR-Mouse-1761-16042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1766/OpenField/FEAR-Mouse-1766-16042025-EPM_00',
        ]
        
    elif experiment == 'EPM_Saline_Exposition':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1749/EPM/FEAR-Mouse-1749-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1753/EPM/FEAR-Mouse-1753-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1758/EPM/FEAR-Mouse-1758-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1762/EPM/FEAR-Mouse-1762-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1764/EPM/FEAR-Mouse-1764-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1750/EPM/FEAR-Mouse-1750-18042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1755/EPM/FEAR-Mouse-1755-18042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1757/EPM/FEAR-Mouse-1757-18042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1761/EPM/FEAR-Mouse-1761-18042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1766/EPM/FEAR-Mouse-1766-18042025-EPM_00',
        ]
        
    elif experiment == 'EPM_Ivabradine_Exposition':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1748/EPM/FEAR-Mouse-1748-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1752/EPM/FEAR-Mouse-1752-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1754/EPM/FEAR-Mouse-1754-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1759/EPM/FEAR-Mouse-1759-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1763/EPM/FEAR-Mouse-1763-17042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1751/EPM/FEAR-Mouse-1751-18042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1756/EPM/FEAR-Mouse-1756-18042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1760/EPM/FEAR-Mouse-1760-18042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1765/EPM/FEAR-Mouse-1765-18042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1767/EPM/FEAR-Mouse-1767-18042025-EPM_00',
        ]
        
    elif experiment == 'Open_Field_Saline_Reexposition':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1749/OpenField/FEAR-Mouse-1749-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1753/OpenField/FEAR-Mouse-1753-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1758/OpenField/FEAR-Mouse-1758-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1762/OpenField/FEAR-Mouse-1762-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1764/OpenField/FEAR-Mouse-1764-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1750/OpenField/FEAR-Mouse-1750-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1755/OpenField/FEAR-Mouse-1755-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1757/OpenField/FEAR-Mouse-1757-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1761/OpenField/FEAR-Mouse-1761-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1766/OpenField/FEAR-Mouse-1766-23042025-EPM_01',
        ]
        
    elif experiment == 'Open_Field_Ivabradine_Reexposition':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1748/OpenField/FEAR-Mouse-1748-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1752/OpenField/FEAR-Mouse-1752-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1754/OpenField/FEAR-Mouse-1754-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1759/OpenField/FEAR-Mouse-1759-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1763/OpenField/FEAR-Mouse-1763-22042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1751/OpenField/FEAR-Mouse-1751-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1756/OpenField/FEAR-Mouse-1756-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1760/OpenField/FEAR-Mouse-1760-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1765/OpenField/FEAR-Mouse-1765-23042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1767/OpenField/FEAR-Mouse-1767-23042025-EPM_00',
        ]

    elif experiment == 'EPM_Saline_Reexposition':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1748/EPM/FEAR-Mouse-1748-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1752/EPM/FEAR-Mouse-1752-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1754/EPM/FEAR-Mouse-1754-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1759/EPM/FEAR-Mouse-1759-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1763/EPM/FEAR-Mouse-1763-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1751/EPM/FEAR-Mouse-1751-25042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1756/EPM/FEAR-Mouse-1756-25042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1760/EPM/FEAR-Mouse-1760-25042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1765/EPM/FEAR-Mouse-1765-25042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1767/EPM/FEAR-Mouse-1767-25042025-EPM_00',
        ]
        
    elif experiment == 'EPM_Ivabradine_Reexposition':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1749/EPM/FEAR-Mouse-1749-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1753/EPM/FEAR-Mouse-1753-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1758/EPM/FEAR-Mouse-1758-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1762/EPM/FEAR-Mouse-1762-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1764/EPM/FEAR-Mouse-1764-24042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1750/EPM/FEAR-Mouse-1750-25042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1755/EPM/FEAR-Mouse-1755-25042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1757/EPM/FEAR-Mouse-1757-25042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1761/EPM/FEAR-Mouse-1761-25042025-EPM_00',
            '/media/nas8-2/ProjectCardioSense/K1766/EPM/FEAR-Mouse-1766-25042025-EPM_00',            
        ]
        
    else:
        raise ValueError('Invalid name of experiment')

    for path in mouse_data:
        behav_path = os.path.join(path, 'behavResources.mat')
        if os.path.exists(behav_path):
            print(f"Loading: {behav_path}")
            mat_contents = scipy.io.loadmat(behav_path, struct_as_record=False, squeeze_me=True)
            dir_info['behavResources'].append(mat_contents)
            dir_info['path'].append(path)
    
            # Also try to load OfflineOpenFieldZones.mat if it exists
            thigmo_path = os.path.join(path, 'OfflineOpenFieldZones.mat')
            if os.path.exists(thigmo_path):
                print(f"Loading: {thigmo_path}")
                thigmo_contents = scipy.io.loadmat(thigmo_path, struct_as_record=False, squeeze_me=True)
                dir_info['OfflineOpenFieldZones'].append(thigmo_contents)
            else:
                # Append None if the file doesn't exist, to keep list lengths consistent
                dir_info['OfflineOpenFieldZones'].append(None)
    
            # Extract mouse number and date using regex
            match = re.search(r'Mouse-(\d+)-(\d+)', path)
            if match:
                mouse_number, date_raw = match.groups()
    
                # Reformat date from ddmmyyyy to yyyymmdd
                try:
                    date_obj = datetime.strptime(date_raw, "%d%m%Y")
                    date_formatted = date_obj.strftime("%Y%m%d")
                except ValueError:
                    print(f"Warning: Could not parse date '{date_raw}'")
                    date_formatted = None
    
                dir_info['nMice'].append(mouse_number)
                dir_info['date'].append(date_formatted)
                dir_info['name'].append(f'M{mouse_number}')
            else:
                print(f"Warning: Could not extract mouse number and date from path: {path}")
                dir_info['nMice'].append(None)
                dir_info['date'].append(None)
                dir_info['name'].append('Unknown')
    
        else:
            print(f"Warning: behavResources.mat not found in {path}")


    return dir_info

