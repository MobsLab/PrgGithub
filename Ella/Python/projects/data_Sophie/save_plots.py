#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 13 17:13:21 2024

@author: gruffalo
"""

import os
import matplotlib.pyplot as plt


def save_plot(figure, filename, directory=None, bbox_inches='tight', dpi=300):
    """
    Save a Matplotlib figure to a file and return the figure.

    Parameters:
    - figure: Matplotlib figure to be saved.
    - filename: Name of the file to save the figure as (e.g., 'my_plot.png').
    - directory (optional): Directory where the file will be saved. Default is None (current working directory).
    - bbox_inches (optional): Bounding box in inches. Default is 'tight'.
    - dpi (optional): Dots per inch for the figure. Default is 300.

    Returns:
    - figure: The input figure.
    """
    
    if directory:
        # If directory is provided, check if it exists, and create it if not
        os.makedirs(directory, exist_ok=True)
        filepath = os.path.join(directory, filename)
    else:
        # If no directory is provided, use the filename as-is
        filepath = filename

    # Save the figure with adjusted bbox_inches and dpi
    figure.savefig(filepath, bbox_inches=bbox_inches, dpi=dpi)
    print(f"Plot saved as: {filepath} with DPI: {dpi}")

    return figure


def save_plot_as_svg(directory, filename, fig=None):
    """
    Save the current or passed figure as an .svg file in the specified directory, ensuring that the plot is not cropped.
    
    Parameters:
    - directory (str): The path to the directory where the plot will be saved.
    - filename (str): The name of the file (without extension) to save the plot.
    - fig (matplotlib.figure.Figure, optional): The figure object to save. If None, saves the current active figure.
    
    Returns:
    - None
    """
    # Ensure the directory exists, if not, create it
    if not os.path.exists(directory):
        os.makedirs(directory)

    # Full path to save the file (adding .svg extension)
    filepath = os.path.join(directory, f"{filename}.svg")

    # Save the provided figure or the current active figure
    if fig is None:
        plt.savefig(filepath, format='svg', bbox_inches='tight')
    else:
        fig.savefig(filepath, format='svg', bbox_inches='tight')

    print(f"Plot saved to {filepath}")