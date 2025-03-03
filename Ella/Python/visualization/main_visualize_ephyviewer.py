#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 13:15:34 2025

@author: gruffalo
"""

import numpy as np
import ephyviewer

# Define parameters
file_path = "file_path.dat"
num_channels = 24 # Adjust based on your setup
sampling_rate = 30000  # Adjust to match your experiment
dtype = np.int16  # Change if necessary
t_start = 0

# Load the binary file
# data = np.fromfile(file_path, dtype=dtype)

# Use memory-mapped array instead of loading the full file
data = np.memmap(file_path, dtype=dtype, mode='r')

# Reshape data into (time, num_channels) format
data = data.reshape(-1, num_channels)  

# Create an InMemoryAnalogSignalSource
source = ephyviewer.InMemoryAnalogSignalSource(data, sampling_rate, 0)

# Initialize Ephyviewer app
app = ephyviewer.mkQApp()
view = ephyviewer.MainViewer(debug=True, show_auto_scale=True)

# Create a viewer for signal with TraceViewer
signal_viewer = ephyviewer.TraceViewer(source=source, name='preprocessed')

# Viewer parameters
signal_viewer.params['scale_mode'] = 'same_for_all'
signal_viewer.params['display_labels'] = True

# Channel parameters
for i in range(num_channels):
    channel_name = f'ch{i}'
    color = '#6FA8DC' if i % 2 == 0 else '#E06666'
    signal_viewer.by_channel_params[(channel_name, 'color')] = color 
    
view.add_view(signal_viewer)

# Show the GUI
view.show()
app.exec()



