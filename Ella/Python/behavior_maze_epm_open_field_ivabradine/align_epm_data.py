#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 12 11:43:16 2025

@author: gruffalo
"""

import os
import numpy as np
import scipy.io
import matplotlib.pyplot as plt
from matplotlib.widgets import Button
from scipy.io import savemat


import matplotlib.pyplot as plt
from matplotlib.widgets import Button
import numpy as np

def get_epm_center_from_clicks(reference_image):
    """
    Let user click 4 corners on the reference image to define EPM center.
    Allows canceling selection using a 'Cancel' button.
    Returns (x_center, y_center) or (None, None) if cancelled.
    """
    while True:
        print("Click the four corners of the two closed arms (ideally forming a rectangle)")

        clicked_points = []
        cancel_clicked = False

        fig, ax = plt.subplots()
        ax.imshow(reference_image, cmap='gray')
        ax.set_title("Click 4 corners of the closed arms")
        ax.set_xlabel("X pixels")
        ax.set_ylabel("Y pixels")

        def onclick(event):
            if event.inaxes == ax and len(clicked_points) < 4:
                clicked_points.append((event.xdata, event.ydata))
                ax.plot(event.xdata, event.ydata, 'ro')
                fig.canvas.draw()
                if len(clicked_points) == 4:
                    plt.close(fig)

        def cancel(event):
            nonlocal cancel_clicked
            cancel_clicked = True
            print("Cancel button clicked. Aborting selection.")
            plt.close(fig)

        # Connect events
        fig.canvas.mpl_connect('button_press_event', onclick)
        ax_cancel = plt.axes([0.8, 0.01, 0.1, 0.05])
        btn_cancel = Button(ax_cancel, 'Cancel')
        btn_cancel.on_clicked(cancel)

        # Wait for interaction
        while plt.fignum_exists(fig.number) and not cancel_clicked and len(clicked_points) < 4:
            plt.pause(0.1)

        # Handle cancellation or insufficient clicks
        if cancel_clicked or len(clicked_points) < 4:
            print("Selection cancelled or incomplete. Aborting.")
            return None, None

        # Compute center
        clicked_points = np.array(clicked_points)
        x_center = np.mean(clicked_points[:, 0])
        y_center = np.mean(clicked_points[:, 1])

        # Confirmation plot
        fig2, ax2 = plt.subplots()
        ax2.imshow(reference_image, cmap='gray')
        ax2.plot(clicked_points[:, 0], clicked_points[:, 1], 'ro', label='Clicked Corners')
        ax2.plot(x_center, y_center, 'g+', markersize=14, label='Computed Center')
        ax2.set_title("Confirm selection: red=corners, green=center")
        ax2.legend()
        plt.pause(0.1)

        while True:
            resp = input("Are you satisfied with this selection? (y = yes, n = no): ").strip().lower()
            if resp in ['y', 'n']:
                break
            else:
                print("Please enter 'y' or 'n'.")

        plt.close(fig2)

        if resp == 'y':
            return x_center, y_center
        else:
            print("Retrying point selection...")


def create_centered_epm_data(directory_path=None, manual_center=None):
    """
    Recomputes and recenters EPM coordinates based on a user-defined or clicked center.
    Saves output in 'OfflineEPMZones.mat'.
    """
    plt.close('all')
    if directory_path is None:
        directory_path = os.getcwd()
    print(f"Processing directory: {directory_path}")
    
    # Check if file exists
    save_path = os.path.join(directory_path, 'OfflineEPMZones.mat')
    if os.path.exists(save_path):
        response = input("OfflineEPMZones.mat already exists. Overwrite? (y/n): ").strip().lower()
        if response != 'y':
            print("Skipped overwriting. Exiting.")
            return

    # Load .mat file
    mat_path = os.path.join(directory_path, 'behavResources.mat')
    mat = scipy.io.loadmat(mat_path, squeeze_me=True, struct_as_record=False)

    # Extract positions
    if 'Xtsd' in mat and 'Ytsd' in mat:
        xdata = mat['Xtsd'].data
        ydata = mat['Ytsd'].data
    elif 'PosMat' in mat:
        xdata = mat['PosMat'][:, 2]
        ydata = mat['PosMat'][:, 1]
    else:
        raise ValueError("No valid position data found (Xtsd/Ytsd or PosMat).")

    # Load reference image and scale factor
    if 'ref' not in mat or 'Ratio_IMAonREAL' not in mat:
        raise ValueError("Missing 'ref' image or 'Ratio_IMAonREAL' scaling factor in mat file.")

    reference_image = mat['ref']
    ratio = float(mat['Ratio_IMAonREAL'])

    # Scale to image coordinates
    xdata_img = xdata * ratio
    ydata_img = ydata * ratio

    # Determine center
    # if manual_center is not None:
    #     y_c, x_c = manual_center
    #     print(f"Using provided center coordinates: ({x_c}, {y_c})")
    # else:
    #     y_c, x_c = get_epm_center_from_clicks(reference_image)
    #     print(f"Computed center from clicks: ({x_c:.1f}, {y_c:.1f})")
    
    
    if manual_center is not None:
        y_c, x_c = manual_center
        print(f"Provided center coordinates: ({x_c}, {y_c})")
    
        # Show image with center overlay
        fig, ax = plt.subplots()
        ax.imshow(reference_image, cmap='gray')
        ax.plot(y_c, x_c, 'g+', markersize=14, label='Provided Center')
        ax.set_title("Confirmation: Provided Center")
        ax.legend()
        plt.pause(0.1)
    
        while True:
            response = input("Are you satisfied with the provided center? (y = yes, n = no): ").strip().lower()
            if response in ['y', 'n']:
                break
            else:
                print("Please enter 'y' or 'n'.")
    
        plt.close(fig)
    
        if response == 'n':
            print("Switching to manual selection by clicking...")
            y_c, x_c = get_epm_center_from_clicks(reference_image)
            print(f"Computed center from clicks: ({x_c:.1f}, {y_c:.1f})")
        else:
            print("Using provided center.")
    else:
        y_c, x_c = get_epm_center_from_clicks(reference_image)
        if y_c is None or x_c is None:
            print("Selection aborted. Exiting function.")
            return  # Stop execution if selection was cancelled
        print(f"Computed center from clicks: ({x_c:.1f}, {y_c:.1f})")

    # Recenter
    x_centered = xdata_img - x_c
    y_centered = ydata_img - y_c

    # Save
    output_data = {
        'CenterCoord': np.array([y_c, x_c]),
        'CenteredXtsd': x_centered,
        'CenteredYtsd': y_centered,
        'timestamps': mat['Xtsd'].t / 1e4
    }
    save_path = os.path.join(directory_path, 'OfflineEPMZones.mat')
    scipy.io.savemat(save_path, output_data)

    print("Saved to OfflineEPMZones.mat:")
    print(" - CenterCoord:", output_data['CenterCoord'])
    print(" - CenteredXtsd shape:", output_data['CenteredXtsd'].shape)
    print(" - CenteredYtsd shape:", output_data['CenteredYtsd'].shape)

    # Plot for verification
    plt.figure(figsize=(8, 8))
    plt.imshow(reference_image, cmap='gray')
    plt.plot(ydata_img, xdata_img, '.', color='skyblue', alpha=0.3, markersize=1, label='Original')
    plt.plot(y_c, x_c, 'rx', markersize=10, label='Center')

    plt.figure(figsize=(8, 8))
    plt.plot(y_centered, x_centered, '.', color='darkgreen', markersize=1, alpha=0.5, label='Centered')
    plt.axhline(0, color='gray', linestyle='--')
    plt.axvline(0, color='gray', linestyle='--')
    plt.xlabel('X (centered)')
    plt.ylabel('Y (centered)')
    plt.title('Recentered EPM Coordinates')
    plt.axis('equal')
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.show()
    
    return (y_c, x_c)



# def get_epm_center_from_clicks(reference_image):
#     """
#     Click 4 corners of the closed arms on the reference image.
#     Confirm center selection; retry if not satisfied.
#     Works in Spyder using %matplotlib qt or %matplotlib tk.
#     """
#     while True:
#         print("Click the four corners of the two closed arms (ideally forming a rectangle)")

#         clicked_points = []

#         fig, ax = plt.subplots()
#         ax.imshow(reference_image, cmap='gray')
#         ax.set_title("Click 4 corners of the closed arms (closed arms only)")
#         ax.set_xlabel("X pixels")
#         ax.set_ylabel("Y pixels")

#         def onclick(event):
#             if event.inaxes == ax:
#                 clicked_points.append((event.xdata, event.ydata))
#                 ax.plot(event.xdata, event.ydata, 'ro')
#                 fig.canvas.draw()

#         cid = fig.canvas.mpl_connect('button_press_event', onclick)

#         # Wait until 4 clicks are made
#         while len(clicked_points) < 4:
#             plt.pause(0.1)

#         plt.close(fig)

#         # Compute center
#         clicked_points = np.array(clicked_points)
#         x_center = np.mean(clicked_points[:, 0])
#         y_center = np.mean(clicked_points[:, 1])

#         # Show confirmation
#         fig2, ax2 = plt.subplots()
#         ax2.imshow(reference_image, cmap='gray')
#         ax2.plot(clicked_points[:, 0], clicked_points[:, 1], 'ro', label='Clicked Corners')
#         ax2.plot(x_center, y_center, 'g+', markersize=14, label='Computed Center')
#         ax2.set_title("Confirmation: Red = corners, Green = center")
#         ax2.legend()
#         plt.pause(0.1)  # brief pause to let the window render

#         # Ask for confirmation in console
#         while True:
#             response = input("Are you satisfied with the selected center? (y = yes, n = no): ").strip().lower()
#             if response in ['y', 'n']:
#                 break
#             else:
#                 print("Please enter 'y' or 'n'.")

#         plt.close(fig2)

#         if response == 'y':
#             return x_center, y_center
#         else:
#             print("Retrying point selection...")