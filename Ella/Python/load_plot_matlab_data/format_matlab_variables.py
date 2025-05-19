#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr  1 17:46:27 2025

@author: gruffalo
"""

def build_datasets(entries):
    """
    entries: list of tuples
        Each tuple should be (path_arg, legend, get_path_function, color)
    """
    datasets = {}
    for path_arg, legend, get_path_func, color in entries:
        datasets[path_arg] = {
            "paths": get_path_func(path_arg),
            "color": color,
            "legend": legend
        }
    return datasets

