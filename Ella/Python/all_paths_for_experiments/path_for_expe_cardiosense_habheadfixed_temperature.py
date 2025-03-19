#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''
Created on Tue Mar 18 15:34:16 2025

@author: gruffalo
'''

import os
import scipy.io

def get_path_for_expe_cardiosense_habheadfixed_temperature(experiment):
    '''
    INPUT:
        experiment (str): Name of the experiment.

    OUTPUT:
        dir_info (dict): Dictionary containing paths, experiment info, mouse IDs, and experiment name.
    '''

    dir_info = {'path': [], 'ExpeInfo': [], 'nMice': [], 'experiment': experiment, 'name': []}

    if experiment == 'HabHeadFixed':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/K1690/2025-01-29_12-57-27',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-01-30_15-45-49',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-01-31_10-44-54',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-03_14-27-20',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-04_09-53-11',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-05_10-21-35',
            
            # M1711
            '/media/nas8-2/ProjectCardioSense/K1711/2025-01-29_15-00-29',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-01-30_16-54-58',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-01-31_15-52-07',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-03_16-40-43',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-04_13-06-50',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-05_16-06-57',
            
            # M1712
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-04_16-19-07',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-05_18-17-16',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-06_16-58-39',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-08_17-28-37',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-10_09-46-21',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-12_12-28-43'
        
        ]
        
        for path in mouse_data:
            expe_info_path = os.path.join(path, 'ExpeInfo.mat')  # Ensure correct path
            if os.path.exists(expe_info_path):
                print(f"Loading: {expe_info_path}")  # Debugging statement
                
                # Load only the 'ExpeInfo' subfield
                mat_contents = scipy.io.loadmat(expe_info_path, struct_as_record=False, squeeze_me=True)

                if 'ExpeInfo' in mat_contents:  # Ensure 'ExpeInfo' exists in file
                    expe_info = mat_contents['ExpeInfo']

                    # Extract 'nmouse' safely
                    nmouse = None
                    if hasattr(expe_info, 'nmouse'):
                        nmouse = expe_info.nmouse

                    dir_info['path'].append(path)
                    dir_info['ExpeInfo'].append(expe_info)  # Store full struct
                    dir_info['nMice'].append(nmouse)

                else:
                    print(f"Warning: 'ExpeInfo' not found in {expe_info_path}")

    elif experiment == 'HabHeadFixed_Test_Temperature':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-06_08-57-43',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-07_12-50-15',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-11_14-39-37',
            
            # M1711
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-06_14-12-25',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-07_09-39-42',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-10_13-21-47'
        ]
        
        for path in mouse_data:
            expe_info_path = os.path.join(path, 'ExpeInfo.mat')  # Ensure correct path
            if os.path.exists(expe_info_path):
                print(f"Loading: {expe_info_path}")  # Debugging statement
                
                # Load only the 'ExpeInfo' subfield
                mat_contents = scipy.io.loadmat(expe_info_path, struct_as_record=False, squeeze_me=True)

                if 'ExpeInfo' in mat_contents:  # Ensure 'ExpeInfo' exists in file
                    expe_info = mat_contents['ExpeInfo']

                    # Extract 'nmouse' safely
                    nmouse = None
                    if hasattr(expe_info, 'nmouse'):
                        nmouse = expe_info.nmouse

                    dir_info['path'].append(path)
                    dir_info['ExpeInfo'].append(expe_info)  # Store full struct
                    dir_info['nMice'].append(nmouse)

                else:
                    print(f"Warning: 'ExpeInfo' not found in {expe_info_path}")

    elif experiment == 'HeadFixed_HabRespiSensor':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-21_17-59-45',
            
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-21_18-53-10',
            
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-21_18-25-55'
   
        ]
        
        for path in mouse_data:
            expe_info_path = os.path.join(path, 'ExpeInfo.mat')  # Ensure correct path
            if os.path.exists(expe_info_path):
                print(f"Loading: {expe_info_path}")  # Debugging statement
                
                # Load only the 'ExpeInfo' subfield
                mat_contents = scipy.io.loadmat(expe_info_path, struct_as_record=False, squeeze_me=True)

                if 'ExpeInfo' in mat_contents:  # Ensure 'ExpeInfo' exists in file
                    expe_info = mat_contents['ExpeInfo']

                    # Extract 'nmouse' safely
                    nmouse = None
                    if hasattr(expe_info, 'nmouse'):
                        nmouse = expe_info.nmouse

                    dir_info['path'].append(path)
                    dir_info['ExpeInfo'].append(expe_info)  # Store full struct
                    dir_info['nMice'].append(nmouse)

                else:
                    print(f"Warning: 'ExpeInfo' not found in {expe_info_path}")
        
    elif experiment == 'HeadFixed_Temperature_HeatingLamp':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-24_13-05-35',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-25_11-20-01',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-26_12-02-00'
            
            # M1711
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-24_15-51-08',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-25_13-43-07',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-26_14-10-54',
            
            # M1712
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-24_17-58-21',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-25_15-51-19',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-26_16-45-30',

        ]
        
        for path in mouse_data:
            expe_info_path = os.path.join(path, 'ExpeInfo.mat')  # Ensure correct path
            if os.path.exists(expe_info_path):
                print(f"Loading: {expe_info_path}")  # Debugging statement
                
                # Load only the 'ExpeInfo' subfield
                mat_contents = scipy.io.loadmat(expe_info_path, struct_as_record=False, squeeze_me=True)

                if 'ExpeInfo' in mat_contents:  # Ensure 'ExpeInfo' exists in file
                    expe_info = mat_contents['ExpeInfo']

                    # Extract 'nmouse' safely
                    nmouse = None
                    if hasattr(expe_info, 'nmouse'):
                        nmouse = expe_info.nmouse

                    dir_info['path'].append(path)
                    dir_info['ExpeInfo'].append(expe_info)  # Store full struct
                    dir_info['nMice'].append(nmouse)

                else:
                    print(f"Warning: 'ExpeInfo' not found in {expe_info_path}")
                 
                
    elif experiment == 'HeadFixed_Temperature_Basal':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-27_10-54-20',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-02-28_11-43-27'
            
            # M1711
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-27_13-28-40',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-02-28_14-11-56',
            
            # M1712
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-27_15-51-49',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-02-28_17-01-15',
  
        ]
        
        for path in mouse_data:
            expe_info_path = os.path.join(path, 'ExpeInfo.mat')  # Ensure correct path
            if os.path.exists(expe_info_path):
                print(f"Loading: {expe_info_path}")  # Debugging statement
                
                # Load only the 'ExpeInfo' subfield
                mat_contents = scipy.io.loadmat(expe_info_path, struct_as_record=False, squeeze_me=True)

                if 'ExpeInfo' in mat_contents:  # Ensure 'ExpeInfo' exists in file
                    expe_info = mat_contents['ExpeInfo']

                    # Extract 'nmouse' safely
                    nmouse = None
                    if hasattr(expe_info, 'nmouse'):
                        nmouse = expe_info.nmouse

                    dir_info['path'].append(path)
                    dir_info['ExpeInfo'].append(expe_info)  # Store full struct
                    dir_info['nMice'].append(nmouse)

                else:
                    print(f"Warning: 'ExpeInfo' not found in {expe_info_path}")
    
    else:
        raise ValueError('Invalid name of experiment')

    # Extract mouse names based on fixed position in the path
    base_path = '/media/nas8-2/ProjectCardioSense/'
    for path in dir_info['path']:
        if path.startswith(base_path):
            parts = path[len(base_path):].split('/')
            if parts:
                mouse_number = parts[0].replace('K', 'M')
                dir_info['name'].append(mouse_number)
            else:
                dir_info['name'].append('Unknown')
        else:
            dir_info['name'].append('Unknown')

    return dir_info
