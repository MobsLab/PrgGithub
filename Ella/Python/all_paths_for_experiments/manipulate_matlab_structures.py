#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 19 10:52:20 2025

@author: gruffalo
"""

def print_struct_fields(struct):
    """
    Prints all field names and values of a MATLAB struct loaded in Python.

    INPUT:
        struct: The loaded MATLAB struct (e.g., `ExpeInfo`, `ExpeInfo.Temperature`).
    """
    if hasattr(struct, "_fieldnames"):  
        for field in struct._fieldnames:
            value = getattr(struct, field)

            # Check if it's another struct
            if hasattr(value, "_fieldnames"):
                print(f"{field}: [Nested Struct]")
            else:
                print(f"{field}: {value}")
    else:
        print("No fields found or not a MATLAB struct.")

# # Example Usage
# expe_info = a['ExpeInfo'][0]  # Extract first ExpeInfo entry
# print_struct_fields(expe_info)  # Prints ExpeInfo fields

# # To explore a nested struct like InfoLFP
# if hasattr(expe_info, "InfoLFP"):
#     print_struct_fields(expe_info.InfoLFP)  # Prints only InfoLFP fields

