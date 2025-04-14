#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 19 15:10:47 2025

@author: gruffalo
"""

import os
import scipy.io

def get_path_for_expe_cardiosense_ivabradine(experiment):
    '''
    INPUT:
        experiment (str): Name of the experiment.

    OUTPUT:
        dir_info (dict): Dictionary containing paths, experiment info, mouse IDs, and experiment name.
    '''

    dir_info = {'path': [], 'ExpeInfo': [], 'nMice': [], 'experiment': experiment, 'name': []}
    
    if experiment == 'Basal_Pre_Injection':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-04_09-48-02/1690_250304_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-05_10-15-01/1690_250305_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-11_10-16-14/1690_250311_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-12_10-56-54/1690_250312_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-13_10-48-26/1690_250313_Basal_Pre-Injection',
            
            # M1711
            '/media/nas8-2/ProjectCardioSense/K1711/2025-03-04_11-59-07/1711_250304_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1711/2025-03-05_14-29-26/1711_250305_Basal_Pre-Injection',
            
            # M1712
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-04_17-18-54/1712_250304_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-05_16-32-38/1712_250305_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-11_14-19-28/1712_250311_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-12_15-07-02/1712_250312_Basal_Pre-Injection',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-13_15-28-37/1712_250313_Basal_Pre-Injection',
        
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
              
    
    # To remove after
    elif experiment == 'Test':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/TestSleepScoring/2025-02-21_17-59-45',
            '/media/nas8-2/ProjectCardioSense/TestSleepScoring/K1690/2025-01-29_12-57-27',
            '/media/nas8-2/ProjectCardioSense/TestSleepScoring/K1690/2025-01-30_15-45-49',
            '/media/nas8-2/ProjectCardioSense/TestSleepScoring/2025-02-04_16-19-07',
            
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
                    
    # To remove after
    
    elif experiment == 'Injection_Saline':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-04_09-48-02/1690_250304_Injection_Saline',
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-13_10-48-26/1690_250313_Injection_Saline',

            
            # M1711
            '/media/nas8-2/ProjectCardioSense/K1711/2025-03-04_11-59-07/1711_250304_Injection_Saline',
            
            # M1712
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-04_17-18-54/1712_250304_Injection_Saline',
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-13_15-28-37/1712_250313_Injection_Saline',
            
            
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
                    
    ### 

    elif experiment == 'Injection_Ivabradine_20mgkg':
        mouse_data = [
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-05_10-15-01/1690_250305_Injection_Ivabradine_20mgkg',
            
            '/media/nas8-2/ProjectCardioSense/K1711/2025-03-05_14-29-26/1711_250305_Injection_Ivabradine_20mgkg',
            
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-05_16-32-38/1712_250305_Injection_Ivabradine_20mgkg',
   
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
        
    elif experiment == 'Injection_Ivabradine_5mgkg':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-11_10-16-14/1690_250311_Injection_Ivabradine_5mgkg',
            
            # M1712
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-11_14-19-28/1712_250311_Injection_Ivabradine_5mgkg',

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
                 
                
    elif experiment == 'Injection_Ivabradine_10mgkg':
        mouse_data = [
            # M1690
            '/media/nas8-2/ProjectCardioSense/K1690/2025-03-12_10-56-54/1690_250312_Injection_Ivabradine_10mgkg',

            # M1712
            '/media/nas8-2/ProjectCardioSense/K1712/2025-03-12_15-07-02/1712_250312_Injection_Ivabradine_10mgkg',
  
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
