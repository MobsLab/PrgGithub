#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 16:17:54 2025

@author: gruffalo
"""

import numpy as np
import ephyviewer
import sys
import os

# Check if a file argument was provided
if len(sys.argv) != 2:
    print("Usage: python visualize_dat.py <filename.dat>")
    sys.exit(1)

# Get the file path from the command line
file_path = sys.argv[1]

# Ensure the file exists
if not os.path.exists(file_path):
    print(f"Error: File '{file_path}' not found.")
    sys.exit(1)

# Ask for user input: number of channels and sampling rate
try:
    num_channels = int(input("Enter the number of channels: "))
    sampling_rate = int(input("Enter the sampling rate (Hz): "))
except ValueError:
    print("Error: Please enter valid integer values for channels and sampling rate.")
    sys.exit(1)

# Define parameters
dtype = np.int16  # Adjust if necessary
t_start = 0

# ✅ Fast loading: Use memory mapping instead of full loading
try:
    data = np.memmap(file_path, dtype=dtype, mode='r')
    data = data.reshape(-1, num_channels)  # Efficient reshape without full load
except Exception as e:
    print(f"Error reading file: {e}")
    sys.exit(1)

# Create an InMemoryAnalogSignalSource
source = ephyviewer.InMemoryAnalogSignalSource(data, sampling_rate, t_start)

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


# import numpy as np
# import ephyviewer
# import sys
# import os

# # Check if a file argument was provided
# if len(sys.argv) != 2:
#     print("Usage: python visualize_dat.py <filename.dat>")
#     sys.exit(1)

# # Get the file path from the command line
# file_path = sys.argv[1]

# # Ensure the file exists
# if not os.path.exists(file_path):
#     print(f"Error: File '{file_path}' not found.")
#     sys.exit(1)

# # Ask for user input: number of channels and sampling rate
# try:
#     num_channels = int(input("Enter the number of channels: "))
#     sampling_rate = int(input("Enter the sampling rate (Hz): "))
# except ValueError:
#     print("Error: Please enter valid integer values for channels and sampling rate.")
#     sys.exit(1)

# # Define parameters
# dtype = np.int16  # Adjust if necessary
# t_start = 0

# # Load the binary file
# try:
#     data = np.fromfile(file_path, dtype=dtype)
# except Exception as e:
#     print(f"Error reading file: {e}")
#     sys.exit(1)

# # Ensure the file contains enough data
# if data.size % num_channels != 0:
#     print(f"Error: File size {data.size} is not compatible with {num_channels} channels.")
#     sys.exit(1)

# # Reshape data into (time, num_channels) format
# data = data.reshape(-1, num_channels)

# # Create an InMemoryAnalogSignalSource
# source = ephyviewer.InMemoryAnalogSignalSource(data, sampling_rate, t_start)

# # Initialize Ephyviewer app
# app = ephyviewer.mkQApp()
# view = ephyviewer.MainViewer(debug=True, show_auto_scale=True)

# # Create a viewer for signal with TraceViewer
# signal_viewer = ephyviewer.TraceViewer(source=source, name='preprocessed')

# # Viewer parameters
# signal_viewer.params['scale_mode'] = 'same_for_all'
# signal_viewer.params['display_labels'] = True

# # Channel parameters
# for i in range(num_channels):
#     channel_name = f'ch{i}'
#     color = '#6FA8DC' if i % 2 == 0 else '#E06666'
#     signal_viewer.by_channel_params[(channel_name, 'color')] = color 

# view.add_view(signal_viewer)

# # Show the GUI
# view.show()
# app.exec()

