#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 22 15:40:02 2025

@author: gruffalo
"""

import os
import scipy.io
import numpy as np
import matplotlib.pyplot as plt


def plot_maze_ref_position(directory_path=None):
    """
    Load position and reference image from behavResources.mat in the given directory
    (defaults to current working directory) and plot the reference image and scaled positions.

    Args:
        directory_path: str, path to the folder (default: current working directory)

    Returns:
        None
    """
    # Step 1: Load data
    if directory_path is None:
        directory_path = os.getcwd()
    
    mat_path = os.path.join(directory_path, 'behavResources.mat')
    mat = scipy.io.loadmat(mat_path, squeeze_me=True, struct_as_record=False)


    # Step 2: Extract positions
    if 'Xtsd' in mat and 'Ytsd' in mat:
        xdata = mat['Xtsd'].data
        ydata = mat['Ytsd'].data
    elif 'PosMat' in mat:
        positions_raw = mat['PosMat']
        xdata = positions_raw[:, 2]
        ydata = positions_raw[:, 1]
    else:
        raise ValueError("No valid position data (Xtsd/Ytsd) found in mat file.")

    # Step 3: Extract and scale image
    if 'ref' not in mat:
        raise ValueError("Reference image ('ref') not found in mat file.")
    reference_image = mat['ref']

    if reference_image.max() <= 1.0:
        image_for_display = (reference_image * 255).astype(np.uint8)
    else:
        image_for_display = reference_image.astype(np.uint8)

    # Step 4: Get scaling ratio
    if 'Ratio_IMAonREAL' not in mat:
        raise ValueError("Ratio_IMAonREAL not found in mat file.")
    # ratio_ima_on_real = float(mat['Ratio_IMAonREAL'])
    ratio_ima_on_real = mat['Ratio_IMAonREAL']

    # Step 5: Plot the image and the scaled tracking data
    fig, ax = plt.subplots()
    ax.imshow(image_for_display, cmap='hot')
    ax.scatter(ydata * ratio_ima_on_real, xdata * ratio_ima_on_real, c='brown', s=1, alpha=0.5)
    ax.set_title("Reference image with raw positions")
    plt.axis('equal')
    plt.tight_layout()
    plt.show()
    
 

from PyQt5.QtWidgets import (
    QWidget, QLabel, QSlider, QPushButton,
    QHBoxLayout, QVBoxLayout
)
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QPixmap, QImage
import cv2

class CircleAdjuster(QWidget):
    def __init__(self, image, x, y, r, xdata=None, ydata=None, ratio_ima_on_real=1.0):
        super().__init__()
        self.setWindowTitle("Adjust Circle")

        self.image = image  # expect grayscale uint8 numpy image
        self.orig_x = x
        self.orig_y = y
        self.orig_r = r
        self.current_x = x
        self.current_y = y
        self.current_r = r
        
        self.xdata = xdata
        self.ydata = ydata
        self.ratio_ima_on_real = ratio_ima_on_real

        # Scale factor to enlarge the image preview window
        self.scale_factor = 3

        # QLabel to show image
        self.img_label = QLabel()
        self.img_label.setFixedSize(image.shape[1] * self.scale_factor,
                                    image.shape[0] * self.scale_factor)

        # Sliders: More gradual steps by setting pageStep and singleStep
        self.slider_x = QSlider(Qt.Horizontal)
        self.slider_x.setMinimum(0)
        self.slider_x.setMaximum(image.shape[1] - 1)
        self.slider_x.setValue(x)
        self.slider_x.setPageStep(1)
        self.slider_x.setSingleStep(1)
        self.slider_x.valueChanged.connect(self.update_circle)

        self.slider_y = QSlider(Qt.Horizontal)
        self.slider_y.setMinimum(0)
        self.slider_y.setMaximum(image.shape[0] - 1)
        self.slider_y.setValue(y)
        self.slider_y.setPageStep(1)
        self.slider_y.setSingleStep(1)
        self.slider_y.valueChanged.connect(self.update_circle)

        self.slider_r = QSlider(Qt.Horizontal)
        self.slider_r.setMinimum(1)
        max_r = min(image.shape[0], image.shape[1]) // 2
        self.slider_r.setMaximum(max_r)
        self.slider_r.setValue(r)
        self.slider_r.setPageStep(1)
        self.slider_r.setSingleStep(1)
        self.slider_r.valueChanged.connect(self.update_circle)

        # Labels for slider values
        self.label_x = QLabel(f"X: {x}")
        self.label_y = QLabel(f"Y: {y}")
        self.label_r = QLabel(f"Radius: {r}")

        # Confirm / Cancel buttons
        btn_layout = QHBoxLayout()
        self.btn_confirm = QPushButton("Confirm")
        self.btn_confirm.clicked.connect(self.confirm)
        self.btn_cancel = QPushButton("Cancel")
        self.btn_cancel.clicked.connect(self.cancel)
        btn_layout.addWidget(self.btn_confirm)
        btn_layout.addWidget(self.btn_cancel)

        # Layout assembly
        layout = QVBoxLayout()
        layout.addWidget(self.img_label)

        for label, slider in [(self.label_x, self.slider_x),
                              (self.label_y, self.slider_y),
                              (self.label_r, self.slider_r)]:
            h = QHBoxLayout()
            h.addWidget(label)
            h.addWidget(slider)
            layout.addLayout(h)

        layout.addLayout(btn_layout)
        self.setLayout(layout)

        self.result = None  # Will hold (x,y,r) if confirmed, else None

        self.update_circle()  # draw initial circle

        # Resize window to fit content nicely
        self.resize(self.img_label.width() + 50, self.img_label.height() + 180)

    def update_circle(self):
        # Get current values from sliders
        self.current_x = self.slider_x.value()
        self.current_y = self.slider_y.value()
        self.current_r = self.slider_r.value()

        # Update labels
        self.label_x.setText(f"X: {self.current_x}")
        self.label_y.setText(f"Y: {self.current_y}")
        self.label_r.setText(f"Radius: {self.current_r}")

        # Make a color version of image 
        img_color = cv2.applyColorMap(self.image, cv2.COLORMAP_HOT)
        
        # ---- Draw scatter points if available ----
        if self.xdata is not None and self.ydata is not None:
            valid_mask = ~np.isnan(self.xdata) & ~np.isnan(self.ydata)
            x_scaled = self.xdata[valid_mask] * self.ratio_ima_on_real
            y_scaled = self.ydata[valid_mask] * self.ratio_ima_on_real
        
            for x_pix, y_pix in zip(x_scaled, y_scaled):
                cv2.circle(img_color, (int(y_pix), int(x_pix)), 1, (255, 255, 255), -1)


        # Draw circle on img_color (BGR)
        # cv2.circle(img_color, (self.current_x, self.current_y), self.current_r, (0, 255, 0), 2)
        cv2.circle(img_color, (self.current_x, self.current_y), self.current_r, (0, 0, 0), 1)


        # Convert BGR to RGB for QImage
        img_rgb = cv2.cvtColor(img_color, cv2.COLOR_BGR2RGB)

        # Resize image for display
        img_rgb = cv2.resize(img_rgb, (self.image.shape[1] * self.scale_factor,
                                       self.image.shape[0] * self.scale_factor),
                             interpolation=cv2.INTER_LINEAR)

        # Create QImage from numpy array
        h, w, ch = img_rgb.shape
        bytes_per_line = ch * w
        qimg = QImage(img_rgb.data, w, h, bytes_per_line, QImage.Format_RGB888)

        # Set pixmap in QLabel
        self.img_label.setPixmap(QPixmap.fromImage(qimg))

    def confirm(self):
        self.result = (self.current_x, self.current_y, self.current_r)
        self.close()

    def cancel(self):
        self.result = None
        self.close()


import sys
from PyQt5.QtWidgets import QApplication, QMessageBox

# def ask_user_confirmation(question="Is this circle correct?"):
#     app = QApplication.instance()
#     if app is None:
#         app = QApplication(sys.argv)
#     msgBox = QMessageBox()
#     msgBox.setWindowTitle("Confirm Circle")
#     msgBox.setText(question)
#     msgBox.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
#     ret = msgBox.exec_()
#     return ret == QMessageBox.Yes

def ask_user_confirmation(question="Is this circle correct?"):
    app = QApplication.instance()
    if app is None:
        app = QApplication(sys.argv)
    msgBox = QMessageBox()
    msgBox.setWindowTitle("Confirm Circle")
    msgBox.setText(question)
    msgBox.setStandardButtons(QMessageBox.Yes | QMessageBox.No | QMessageBox.Cancel)
    ret = msgBox.exec_()
    
    if ret == QMessageBox.Yes:
        return "yes"
    elif ret == QMessageBox.No:
        return "no"
    else:
        return "cancel"



def find_and_confirm_circle(directory_path=None, param1=100, param2=30, min_radius=10, max_radius=50):
    """
    Detects circular structures in a reference image and allows the user to confirm or adjust the result.
    
    Parameters:
        directory_path (str): Path to the folder containing 'behavResources.mat'. Defaults to the current working directory.
        param1 (int): Higher threshold for the Canny edge detector used by HoughCircles.
        param2 (int): Accumulator threshold for HoughCircles.
        min_radius (int): Minimum radius of the circles to detect.
        max_radius (int): Maximum radius of the circles to detect.
    
    Returns:
        tuple or None: A tuple (x, y, r) with the center coordinates and radius of the confirmed circle,
                       or None if no circle is confirmed.
    """
    plt.close('all')
    if directory_path is None:
        directory_path = os.getcwd()

    mat_path = os.path.join(directory_path, 'behavResources.mat')
    mat = scipy.io.loadmat(mat_path, squeeze_me=True, struct_as_record=False)

    if 'ref' not in mat:
        raise ValueError("Reference image ('ref') not found in mat file.")
    image = mat['ref']

    # Normalize and convert to uint8 grayscale if needed
    if image.dtype != np.uint8:
        image = (255 * (image - image.min()) / (image.max() - image.min())).astype(np.uint8)

    blurred = cv2.medianBlur(image, 5)

    circles = cv2.HoughCircles(
        blurred, cv2.HOUGH_GRADIENT, dp=1.2,
        minDist=5,
        param1=param1, param2=param2,
        minRadius=min_radius, maxRadius=max_radius
    )

    if circles is None:
        print("No circle detected.")
        return None

    circles = np.uint16(np.around(circles))

    # Load tracking data if available
    xdata, ydata, ratio_ima_on_real = None, None, 1.0
    if 'Xtsd' in mat and 'Ytsd' in mat:
        xdata = mat['Xtsd'].data
        ydata = mat['Ytsd'].data
        if 'Ratio_IMAonREAL' not in mat:
            raise ValueError("Ratio_IMAonREAL not found in mat file.")
        ratio_ima_on_real = float(mat['Ratio_IMAonREAL'])

    app = QApplication.instance()
    if app is None:
        app = QApplication(sys.argv)

    for i, (x, y, r) in enumerate(circles[0]):
        # Show detected circle using matplotlib 
        output = image.copy().astype(np.float32)
        cv2.circle(output, (x, y), r, 0, 1)
        cv2.circle(output, (x, y), 2, 0, 2)

        plt.figure(figsize=(8, 8))
        plt.imshow(output, cmap='hot')
        plt.title(f"Detected circle #{i+1} at (x={x}, y={y}, r={r})")
        if xdata is not None and ydata is not None:
            plt.scatter(ydata * ratio_ima_on_real, xdata * ratio_ima_on_real, c='white', s=1, alpha=0.5, label="Position")
        plt.axis("off")
        plt.show(block=False)

        user_resp = ask_user_confirmation()
        plt.close()

        if user_resp == "cancel":
            print("User cancelled during circle confirmation.")
            return None
        elif user_resp == "yes":
            adjuster = CircleAdjuster(
                image=image,
                x=x, y=y, r=r,
                xdata=xdata, ydata=ydata,
                ratio_ima_on_real=ratio_ima_on_real
            )
            adjuster.show()
            app.exec_()

            if adjuster.result is None:
                print("User cancelled during adjustment panel.")
                return None
            else:
                return adjuster.result
        else:
            print(f"Circle #{i+1} rejected by user. Trying next...")
            
            
            
    # for i, (x, y, r) in enumerate(circles[0]):
    #     # Show detected circle using matplotlib 
    #     output = image.copy().astype(np.float32)
    #     cv2.circle(output, (x, y), r, 0, 1)
    #     cv2.circle(output, (x, y), 2, 0, 2)

    #     plt.figure(figsize=(8, 8))
    #     plt.imshow(output, cmap='hot')
    #     plt.title(f"Detected circle #{i+1} at (x={x}, y={y}, r={r})")
    #     if xdata is not None and ydata is not None:
    #         plt.scatter(ydata * ratio_ima_on_real, xdata * ratio_ima_on_real, c='white', s=1, alpha=0.5, label="Position")
    #     plt.axis("off")
    #     plt.show(block=False)

    #     if ask_user_confirmation():
    #         plt.close()
    #         adjuster = CircleAdjuster(
    #             image=image,
    #             x=x, y=y, r=r,
    #             xdata=xdata, ydata=ydata,
    #             ratio_ima_on_real=ratio_ima_on_real
    #         )
    #         adjuster.show()
    #         app.exec_()

    #         if adjuster.result is None:
    #             print(f"Adjustment cancelled, returning original circle at (x={x}, y={y}, r={r})")
    #             return (x, y, r)
    #         else:
    #             x_final, y_final, r_final = adjuster.result
    #             print(f"User adjusted circle to (x={x_final}, y={y_final}, r={r_final})")
    #             return adjuster.result
    #     else:
    #         plt.close()
    #         print(f"Circle #{i+1} rejected by user. Trying next detected circle...")

    print("All detected circles rejected.")
    return None


# def find_and_confirm_circle(directory_path=None, param1=100, param2=30, min_radius=10, max_radius=50):
#     """
#     Detects circular structures in a reference image and allows the user to confirm or adjust the result.
    
#     This function loads a reference image ('ref') from the specified directory (or current working directory by default)
#     from the 'behavResources.mat' file. It applies a median blur and uses the Hough Circle Transform (via OpenCV) to 
#     detect potential circles. Each detected circle is displayed to the user for visual inspection. The user is prompted 
#     to confirm or reject each circle. Upon confirmation, the user may optionally adjust the circle parameters using a 
#     graphical interface (CircleAdjuster). The function returns the coordinates and radius of the confirmed or adjusted 
#     circle, or `None` if no circle is confirmed.
    
#     Parameters:
#         directory_path (str): Path to the folder containing 'behavResources.mat'. Defaults to the current working directory.
#         param1 (int): Higher threshold for the Canny edge detector used by HoughCircles. Default is 50.
#         param2 (int): Accumulator threshold for HoughCircles. Lower values detect more circles. Default is 30.
#         min_radius (int): Minimum radius of the circles to detect. Default is 10.
#         max_radius (int): Maximum radius of the circles to detect. Default is 0 (interpreted as unlimited by OpenCV).
    
#     Returns:
#         tuple or None: A tuple (x, y, r) with the center coordinates and radius of the confirmed circle,
#                        or None if no circle is confirmed.
#     """
#     plt.close('all')
#     if directory_path is None:
#         directory_path = os.getcwd()

#     mat_path = os.path.join(directory_path, 'behavResources.mat')
#     mat = scipy.io.loadmat(mat_path, squeeze_me=True, struct_as_record=False)
#     if 'ref' not in mat:
#         raise ValueError("Reference image ('ref') not found in mat file.")
#     image = mat['ref']

#     # Normalize and convert to uint8 grayscale if needed
#     if image.dtype != np.uint8:
#         image = (255 * (image - image.min()) / (image.max() - image.min())).astype(np.uint8)

#     blurred = cv2.medianBlur(image, 5)

#     circles = cv2.HoughCircles(
#         blurred, cv2.HOUGH_GRADIENT, dp=1.2,
#         minDist=5,
#         param1=param1, param2=param2,
#         minRadius=min_radius, maxRadius=max_radius
#     )

#     if circles is None:
#         print("No circle detected.")
#         return None

#     circles = np.uint16(np.around(circles))

#     app = QApplication.instance()
#     if app is None:
#         app = QApplication(sys.argv)

#     for i, (x, y, r) in enumerate(circles[0]):
#         # Show detected circle using matplotlib 
#         output = image.copy().astype(np.float32)
#         cv2.circle(output, (x, y), r, 0, 1)
#         cv2.circle(output, (x, y), 2, 0, 2)

#         plt.figure(figsize=(8, 8))
#         plt.imshow(output, cmap='hot')
#         plt.title(f"Detected circle #{i+1} at (x={x}, y={y}, r={r})")
#         plt.axis("off")
#         plt.show(block=False)
        
#         if 'Xtsd' in mat and 'Ytsd' in mat:
#             xdata = mat['Xtsd'].data
#             ydata = mat['Ytsd'].data
            
#             if 'Ratio_IMAonREAL' not in mat:
#                 raise ValueError("Ratio_IMAonREAL not found in mat file.")
#             # ratio_ima_on_real = float(mat['Ratio_IMAonREAL'])
#             ratio_ima_on_real = mat['Ratio_IMAonREAL']
            
#             plt.scatter(ydata * ratio_ima_on_real, xdata * ratio_ima_on_real, c='white', s=1, alpha=0.5, label="Position")


#         if ask_user_confirmation():
#             plt.close()
#             adjuster = CircleAdjuster(image, x, y, r)
#             adjuster.show()
#             app.exec_()  # Run Qt event loop until dialog closes

#             if adjuster.result is None:
#                 print(f"Adjustment cancelled, returning original circle at (x={x}, y={y}, r={r})")
#                 print(f"Final circle: x={x}, y={y}, radius={r}")
#                 return (x, y, r)
#             else:
#                 x_final, y_final, r_final = adjuster.result
#                 print(f"User adjusted circle to (x={x_final}, y={y_final}, r={r_final})")
#                 print(f"Final circle: x={x_final}, y={y_final}, radius={r_final}")
#                 return adjuster.result
            
#         else:
#             plt.close()
#             print(f"Circle #{i+1} rejected by user. Trying next detected circle...")

#     print("All detected circles rejected.")
#     return None


      
import matplotlib
matplotlib.use('Qt5Agg')  # or 'TkAgg' if Qt5Agg doesn't work well
from matplotlib.patches import Circle

def confirm_circle_cli(image, circle):
    fig, ax = plt.subplots()
    ax.imshow(image, cmap='hot')
    circ_patch = Circle((circle[0], circle[1]), circle[2], edgecolor='black', fill=False, linewidth=1)
    ax.add_patch(circ_patch)
    ax.set_title("Close this window after viewing the circle to confirm")
    
    plt.draw()       # Force drawing
    plt.pause(0.001) # Tiny pause helps render fully in some backends
    plt.show(block=True)

    while True:
        resp = input("Do you confirm this circle? (y/n): ").strip().lower()
        if resp in ['y', 'yes']:
            return True
        elif resp in ['n', 'no']:
            return False
        else:
            print("Please type 'y' or 'n'.")


def create_centered_open_field_data(directory_path=None, initial_circle=None):
    """
    Loads positional data from a .mat file, recenters it based on a detected or provided circle,
    and saves the recentered data back to the .mat file.
    
    This function reads positional tracking data (X and Y coordinates) from 'behavResources.mat' 
    located in the specified directory (defaults to the current working directory). It also loads 
    a reference image and a scaling factor to convert positional data into the image coordinate space. 
    If an initial circle is provided, the user is prompted to confirm it; otherwise, the function 
    attempts to detect a circle using the `find_and_confirm_circle` method. Using the confirmed circle, 
    the positional data is recentered relative to the circle’s center, and the new centered coordinates, 
    along with the circle parameters, are saved back into the .mat file. Finally, it plots the recentered 
    positions along with the detected circle for visual verification.
    
    Parameters:
        directory_path (str, optional): Path to the folder containing 'behavResources.mat'. Defaults to current working directory.
        initial_circle (tuple, optional): A tuple (x_center, y_center, radius) representing a circle to confirm before detection.
    
    Returns:
        None
    
    Raises:
        ValueError: If required position data or reference image/scaling factor are missing from the .mat file.
    """
    plt.close('all')
    if directory_path is None:
        directory_path = os.getcwd()
        
    # Print the directory being processed
    print(f"Processing directory: {directory_path}")

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

    # Scale positions to image space
    xdata_img = xdata * ratio
    ydata_img = ydata * ratio

    # Use initial circle if provided
    if initial_circle is not None:
        print("Initial circle provided. Please inspect and close to confirm.")
        confirmed = confirm_circle_cli(reference_image, initial_circle)
        if confirmed:
            circle_result = initial_circle
        else:
            print("Searching for a new circle...")
            circle_result = find_and_confirm_circle(directory_path=directory_path)
    else:
        circle_result = find_and_confirm_circle(directory_path=directory_path)

    if circle_result is None:
        print("No circle found or confirmed.")
        return

    # Correct for axis convention: (row, col) = (y, x)
    y_c, x_c, r = circle_result  # note: x and y are inverted according to the axes

    # Recenter positions
    x_centered = xdata_img - x_c
    y_centered = ydata_img - y_c

  
    output_data = {
        'CircleCoord': np.array([y_c, x_c, r]),
        'CenteredXtsd': x_centered,
        'CenteredYtsd': y_centered,
        # 'Vtsd' : mat['Vtsd'],
        'timestamps': mat['Xtsd'].t / 1e4,
        
    }
    
    savemat_path = os.path.join(directory_path, 'OfflineOpenFieldZones.mat')
    scipy.io.savemat(savemat_path, output_data)

    # Confirmation of new variables saved
    print("Saved the following variables to OfflineOpenFieldZones.mat:")
    print(" - 'CircleCoord':", output_data['CircleCoord'])
    print(" - 'CenteredXtsd': array with shape", output_data['CenteredXtsd'].shape)
    print(" - 'CenteredYtsd': array with shape", output_data['CenteredYtsd'].shape)

    # Plot the recentered result
    theta = np.linspace(0, 2 * np.pi, 200)
    circle_x = r * np.cos(theta)
    circle_y = r * np.sin(theta)

    plt.figure(figsize=(8, 8))
    plt.plot(y_centered, x_centered, '.', label='Recentered Positions', color='brown', markersize=1, alpha=0.5)
    plt.plot(circle_y, circle_x, 'r-', linewidth=2, label='Detected Circle (centered at 0,0)')
    plt.gca().set_aspect('equal')
    plt.xlabel("Y (centered)")
    plt.ylabel("X (centered)")
    plt.title("Recentered Position Data with Detected Circle")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show(block=True)
    
    return np.array([y_c, x_c, r])



# import os
# import numpy as np
# import scipy.io
# import matplotlib.pyplot as plt

# def create_centered_open_field_data(directory_path=None):
#     if directory_path is None:
#         directory_path = os.getcwd()
    
#     # Load .mat file
#     mat_path = os.path.join(directory_path, 'behavResources.mat')
#     mat = scipy.io.loadmat(mat_path, squeeze_me=True, struct_as_record=False)

#     # Extract positions
#     if 'Xtsd' in mat and 'Ytsd' in mat:
#         xdata = mat['Xtsd'].data
#         ydata = mat['Ytsd'].data
#     elif 'PosMat' in mat:
#         xdata = mat['PosMat'][:, 2]
#         ydata = mat['PosMat'][:, 1]
#     else:
#         raise ValueError("No valid position data found (Xtsd/Ytsd or PosMat).")

#     # Load reference image and scale factor
#     if 'ref' not in mat or 'Ratio_IMAonREAL' not in mat:
#         raise ValueError("Missing 'ref' image or 'Ratio_IMAonREAL' scaling factor in mat file.")

#     reference_image = mat['ref']
#     ratio = float(mat['Ratio_IMAonREAL'])

#     # Scale positions to image space
#     xdata_img = xdata * ratio
#     ydata_img = ydata * ratio

#     # Find circle in image space
#     circle_result = find_and_confirm_circle(directory_path=directory_path)
#     if circle_result is None:
#         print("No circle found or confirmed.")
#         return

#     # Correct for axis convention: (row, col) = (y, x)
#     y_c, x_c, r = circle_result

#     # Recenter positions
#     x_centered = xdata_img - x_c
#     y_centered = ydata_img - y_c

#     # Save new data back to behavResources.mat
#     mat['CircleCoord'] = np.array([y_c, x_c, r])
#     mat['CenteredXtsd'] = x_centered
#     mat['CenteredYtsd'] = y_centered

#     # Save the updated dictionary
#     scipy.io.savemat(mat_path, mat)

#     # Plot the result
#     theta = np.linspace(0, 2*np.pi, 200)
#     circle_x = r * np.cos(theta)
#     circle_y = r * np.sin(theta)

#     plt.figure(figsize=(8, 8))
#     plt.plot(y_centered, x_centered, '.', label='Recentered Positions', color='brown', markersize=1, alpha=0.5)
#     plt.plot(circle_y, circle_x, 'r-', linewidth=2, label='Detected Circle (centered at 0,0)')
    
#     plt.gca().set_aspect('equal')
#     plt.xlabel("Y (centered)")
#     plt.ylabel("X (centered)")
#     plt.title("Recentered Position Data with Detected Circle")
#     plt.legend()
#     plt.grid(True)
#     plt.tight_layout()
#     plt.show()
