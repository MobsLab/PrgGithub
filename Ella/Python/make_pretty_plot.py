#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 19 19:07:17 2025

@author: gruffalo
"""

def make_pretty_plot(ax):
    """
    Enhances the appearance of a given matplotlib axis based on specified styling:
    
    - Only left and bottom axes are visible
    - Thick axes lines
    - Bold and larger tick labels
    - Bold axis labels
    - Bold title
    - Bold legend (if present)
    - Grid for readability

    INPUT:
        ax (matplotlib.axes._subplots.AxesSubplot): The axis object to be formatted.

    OUTPUT:
        Modifies the input axis in-place.
    """
    # Hide top and right spines
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    # Make left and bottom axes thick
    ax.spines["left"].set_linewidth(2.5)
    ax.spines["bottom"].set_linewidth(2.5)

    # Set bold and larger ticks
    ax.tick_params(axis="both", which="major", labelsize=14, width=2.5, length=6)
    ax.tick_params(axis="both", which="minor", width=2, length=3)

    # Bold labels
    ax.xaxis.label.set_fontsize(16)
    ax.yaxis.label.set_fontsize(16)
    ax.xaxis.label.set_weight("bold")
    ax.yaxis.label.set_weight("bold")

    # Bold title
    ax.title.set_fontsize(18)
    ax.title.set_weight("bold")

    # Make legend bold if it exists
    legend = ax.get_legend()
    if legend:
        for text in legend.get_texts():
            text.set_fontsize(14)
            text.set_weight("bold")

    # Add grid for readability
    ax.grid(True, linestyle="--", alpha=0.6)

# # Example Usage: Apply to Any Plot
# fig, ax = plt.subplots(figsize=(10, 5))
# ax.plot([1, 2, 3, 4], [10, 20, 25, 30], color='brown', linewidth=2, label="Sample Data")

# # Add labels and title
# ax.set_xlabel("Time (s)")
# ax.set_ylabel("Value")
# ax.set_title("Example Plot")
# ax.legend()

# # Apply pretty styling
# make_pretty_plot(ax)

# plt.show()

