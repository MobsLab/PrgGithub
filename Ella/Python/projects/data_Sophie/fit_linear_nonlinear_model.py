#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  7 14:43:01 2024

@author: gruffalo
"""

from preprocess_linear_model import (
    combine_dataframes_on_timebins,
    create_time_shifted_features
    )
from preprocess_ln_model import (
    zscore_columns,
    calculate_amplitude_thresholds,
    generate_variable_shift_combinations,
    extract_random_bouts
    )
from model_ln_regression import (
    ln_grid_cv
    )
from joblib import Parallel, delayed


def process_neuron(mouse_id, dependent_var, spike_counts, maze_rebinned_data, random_seed=30):
    """
    Fit LN models for a specific neuron of a given mouse and compute R² on test data.

    Parameters:
    - mouse_id (str): The ID of the mouse.
    - dependent_var (str): The dependent variable (neuron).
    - spike_counts (dict): Dictionary of spike counts for all mice.
    - maze_rebinned_data (dict): Dictionary of rebinned data for all mice.
    - random_seed (int): Random seed for reproducible train-test split.

    Returns:
    - dict: A dictionary containing results for all models, R² on test data, and the random seed.
    """
    try:
        # from scipy.stats import pearsonr
        from sklearn.metrics import r2_score
        import numpy as np
        import pandas as pd

        # Preprocess data
        maze_rebinned_normalized_data = zscore_columns(
            maze_rebinned_data[mouse_id],
            ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos']
        )
        model_all_df = combine_dataframes_on_timebins(spike_counts[mouse_id], maze_rebinned_normalized_data)
        
        # Check for sufficient data
        if len(model_all_df) < 10:
            print(f"Insufficient data for {mouse_id} - {dependent_var}. Skipping this neuron.")
            return None
        
        # Split the data
        train_data, test_data = extract_random_bouts(
            model_all_df, bout_length=10, percent=10, random_state=random_seed
        )
        
        # Calculate thresholds
        percentages = [0, 0.001, 0.002, 0.003, 0.005, 0.01, 0.02, 0.03, 0.04, 0.05]
        threshold_values = calculate_amplitude_thresholds(model_all_df, dependent_var, percentages)
        
        # Define configurations
        configs = {
            "motion": (['LinPos', 'Speed', 'Accelero'], {}),
            "HR": (['Heartrate'], {'Heartrate': 5}),
            "HRmotion": (['Heartrate', 'LinPos', 'Speed', 'Accelero'], {'Heartrate': 5}),
            "BF": (['BreathFreq'], {'BreathFreq': 5}),
            "BFmotion": (['BreathFreq', 'LinPos', 'Speed', 'Accelero'], {'BreathFreq': 5}),
            "all": (['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'], {'BreathFreq': 5, 'Heartrate': 5})
        }
        
        results = {}
        
        # Fit models for each configuration
        for name, (independent_vars, shifts) in configs.items():
            variables_shifts = generate_variable_shift_combinations(independent_vars, shifts)
            model_result = ln_grid_cv(
                data=train_data,
                dependent_var=dependent_var,
                independent_vars=independent_vars,
                threshold_values=threshold_values,
                variables_shifts=variables_shifts,
                intercept_options=[True, False],
                k=5
            )
            
            # Extract the best model and shifts
            best_model = model_result['best_model']
            best_shift_config = model_result['best_shift_config']
            
            # Clean and align test data
            test_data_cleaned = test_data.dropna(subset=[dependent_var] + independent_vars)
            if test_data_cleaned.empty:
                print(f"No aligned test data for {name}. Skipping R² calculation.")
                r2_test = np.nan
            else:
                X_test_shifted = create_time_shifted_features(test_data_cleaned[independent_vars], best_shift_config)
                aligned_data = pd.concat([X_test_shifted, test_data_cleaned[dependent_var].reset_index(drop=True)], axis=1).dropna()
                if aligned_data.empty:
                    print(f"No aligned data available after applying shifts for {name}.")
                    r2_test = np.nan
                else:
                    X_test = aligned_data[X_test_shifted.columns]
                    y_test = aligned_data[dependent_var]
                    y_pred = best_model.predict(X_test)
                    
                    # Compute R²
                    # r, _ = pearsonr(y_test, y_pred)
                    # r2_test = r ** 2
                    r2_test = r2_score(y_test, y_pred)

            
            # Store results
            model_result['r2_test'] = r2_test
            results[name] = model_result
        
        return {
            "mouse_id": mouse_id,
            "dependent_var": dependent_var,
            "results": results,
            "random_seed": random_seed
        }
    except KeyError as ke:
        print(f"KeyError processing {mouse_id} - {dependent_var}: {ke}")
    except ValueError as ve:
        print(f"ValueError processing {mouse_id} - {dependent_var}: {ve}")
    except Exception as e:
        print(f"Unexpected error processing {mouse_id} - {dependent_var}: {e}")
    return None


def process_all_neurons(mouse_id, dependent_vars, spike_counts, maze_rebinned_data, random_seed=30):
    """
    Process all neurons for a given mouse using parallelization.
    
    Parameters:
    - mouse_id (str): The ID of the mouse.
    - dependent_vars (list): List of dependent variables (neurons) for the mouse.
    - spike_counts (dict): Spike counts dictionary for all mice.
    - maze_rebinned_data (dict): Rebinned physiological data for all mice.
    
    Returns:
    - list: Results for all neurons of the mouse.
    """
    return Parallel(n_jobs=-1, verbose=10)(
        delayed(process_neuron)(mouse_id, dependent_var, spike_counts, maze_rebinned_data, random_seed=30)
        for dependent_var in dependent_vars
    )



def fit_bin_size(denoised_data, spike_times_data, bin_sizes, save_directory, random_seed=30):
    """
    Rebins data with different bin sizes, computes spike counts, fits models, and saves results.

    Parameters:
    - denoised_data (dict): Dictionary of denoised physiological data for all mice.
    - spike_times_data (dict): Dictionary of spike times data for all mice.
    - bin_sizes (list): List of bin sizes to iterate over.
    - save_directory (str): Directory where results will be saved.
    - random_seed (int): Random seed for reproducible train-test split.

    Returns:
    - results_per_bin_size (dict): Dictionary of results and saved file paths for each bin size.
    """
    from preprocess_sort_data import rebin_mice_data
    from analyse_data import spike_count_all_mice
    from fit_linear_nonlinear_model import process_all_neurons
    from joblib import dump
    import os

    results_per_bin_size = {}

    for bin_size in bin_sizes:
        print(f"\nProcessing bin size: {bin_size}...")

        try:
            # Step 1: Rebin the data
            rebinned_data = rebin_mice_data(
                denoised_data,
                ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos'],
                bin_size
            )

            # Step 2: Compute spike counts
            spike_counts = spike_count_all_mice(rebinned_data, spike_times_data)

            # Step 3: Fit models for all neurons
            all_results = []
            for mouse_id in spike_counts.keys():
                dependent_vars = spike_counts[mouse_id].columns.tolist()
                mouse_results = process_all_neurons(
                    mouse_id,
                    dependent_vars,
                    spike_counts,
                    rebinned_data,
                    random_seed=random_seed
                )
                all_results.extend([res for res in mouse_results if res is not None])

            # Step 4: Save results using joblib
            joblib_file_name = f'results_ln_model_bin_{str(bin_size).replace(".", "_")}.joblib'
            joblib_file_path = os.path.join(save_directory, joblib_file_name)
            dump(all_results, joblib_file_path)

            # Store results path for the current bin size
            results_per_bin_size[bin_size] = {
                "bin_size" : bin_size,
                "results": all_results,
                "joblib_path": joblib_file_path
            }

            print(f"Completed bin size: {bin_size}. Results saved at {joblib_file_path}.")

        except Exception as e:
            print(f"Error processing bin size {bin_size}: {e}")

    return results_per_bin_size



def process_neuron_time_lag(mouse_id, dependent_var, spike_counts, maze_rebinned_data, random_seed=30, lag_range=(-10, 10)):
    """
    Fit LN models for a specific neuron of a given mouse across different time lag configurations.

    Parameters:
    - mouse_id (str): The ID of the mouse.
    - dependent_var (str): The dependent variable (neuron).
    - spike_counts (dict): Dictionary of spike counts for all mice.
    - maze_rebinned_data (dict): Dictionary of rebinned data for all mice.
    - random_seed (int): Random seed for reproducible train-test split.
    - lag_range (tuple): Range of lags to test (inclusive).

    Returns:
    - dict: A dictionary containing results for all models and lag configurations, and the random seed.
    """
    try:
        from sklearn.metrics import r2_score
        import numpy as np
        import pandas as pd

        # Preprocess data
        maze_rebinned_normalized_data = zscore_columns(
            maze_rebinned_data[mouse_id],
            ['BreathFreq', 'Heartrate', 'Accelero', 'Speed', 'LinPos']
        )
        model_all_df = combine_dataframes_on_timebins(spike_counts[mouse_id], maze_rebinned_normalized_data)

        # Check for sufficient data
        if len(model_all_df) < 10:
            print(f"Insufficient data for {mouse_id} - {dependent_var}. Skipping this neuron.")
            return None

        # Split the data
        train_data, test_data = extract_random_bouts(
            model_all_df, bout_length=10, percent=10, random_state=random_seed
        )

        # Calculate thresholds
        percentages = [0, 0.001, 0.002, 0.003, 0.005, 0.01, 0.02, 0.03, 0.04, 0.05]
        threshold_values = calculate_amplitude_thresholds(model_all_df, dependent_var, percentages)

        # Initialize results dictionary
        results = {}

        # Loop over time lags
        for lag in range(lag_range[0], lag_range[1] + 1):
            # Define configurations for the current lag
            configs = {
                "motion": (['LinPos', 'Speed', 'Accelero'], {}),
                "HR": (['Heartrate'], {'Heartrate': lag}),
                "HRmotion": (['Heartrate', 'LinPos', 'Speed', 'Accelero'], {'Heartrate': lag}),
                "BF": (['BreathFreq'], {'BreathFreq': lag}),
                "BFmotion": (['BreathFreq', 'LinPos', 'Speed', 'Accelero'], {'BreathFreq': lag}),
                "all": (['Heartrate', 'BreathFreq', 'LinPos', 'Speed', 'Accelero'], {'BreathFreq': lag, 'Heartrate': lag})
            }

            # Fit models for each configuration
            for name, (independent_vars, shifts) in configs.items():
                variables_shifts = [{var: [shifts.get(var, 0)] for var in independent_vars}]
                model_result = ln_grid_cv(
                    data=train_data,
                    dependent_var=dependent_var,
                    independent_vars=independent_vars,
                    threshold_values=threshold_values,
                    variables_shifts=variables_shifts,
                    intercept_options=[True, False],
                    k=5
                )

                # Extract the best model and shifts
                best_model = model_result['best_model']
                best_shift_config = model_result['best_shift_config']

                # Clean and align test data
                test_data_cleaned = test_data.dropna(subset=[dependent_var] + independent_vars)
                if test_data_cleaned.empty:
                    print(f"No aligned test data for {name} (lag={lag}). Skipping R² calculation.")
                    r2_test = np.nan
                else:
                    X_test_shifted = create_time_shifted_features(test_data_cleaned[independent_vars], best_shift_config)
                    aligned_data = pd.concat([X_test_shifted, test_data_cleaned[dependent_var].reset_index(drop=True)], axis=1).dropna()
                    if aligned_data.empty:
                        print(f"No aligned data available after applying shifts for {name} (lag={lag}).")
                        r2_test = np.nan
                    else:
                        X_test = aligned_data[X_test_shifted.columns]
                        y_test = aligned_data[dependent_var]
                        y_pred = best_model.predict(X_test)

                        # Compute R²
                        r2_test = r2_score(y_test, y_pred)

                # Store results
                model_result['r2_test'] = r2_test
                results[name] = model_result

        return {
            "mouse_id": mouse_id,
            "dependent_var": dependent_var,
            "results": results,
            "random_seed": random_seed
        }
    except KeyError as ke:
        print(f"KeyError processing {mouse_id} - {dependent_var}: {ke}")
    except ValueError as ve:
        print(f"ValueError processing {mouse_id} - {dependent_var}: {ve}")
    except Exception as e:
        print(f"Unexpected error processing {mouse_id} - {dependent_var}: {e}")
    return None


def process_all_neurons_time_lag(mouse_id, dependent_vars, spike_counts, maze_rebinned_data, random_seed=30, lag_range=(-10, 10)):
    """
    Process all neurons for a given mouse using parallelization across different time lag configurations.

    Parameters:
    - mouse_id (str): The ID of the mouse.
    - dependent_vars (list): List of dependent variables (neurons) for the mouse.
    - spike_counts (dict): Spike counts dictionary for all mice.
    - maze_rebinned_data (dict): Rebinned physiological data for all mice.
    - random_seed (int): Random seed for reproducible train-test split.
    - lag_range (tuple): Range of lags to test (inclusive).

    Returns:
    - list: Results for all neurons of the mouse across all lag configurations.
    """
    from joblib import Parallel, delayed

    return Parallel(n_jobs=-1, verbose=10)(
        delayed(process_neuron_time_lag)(
            mouse_id, dependent_var, spike_counts, maze_rebinned_data, random_seed, lag_range
        )
        for dependent_var in dependent_vars
    )


def fit_time_lag(denoised_data, spike_times_data, lag_range, save_directory, random_seed=30):
    """
    Processes data for different time lags, computes spike counts once, fits models, and saves results.

    Parameters:
    - denoised_data (dict): Dictionary of denoised physiological data for all mice.
    - spike_times_data (dict): Dictionary of spike times data for all mice.
    - lag_range (tuple): Range of lags to iterate over (inclusive).
    - save_directory (str): Directory where results will be saved.
    - random_seed (int): Random seed for reproducible train-test split.

    Returns:
    - results_per_lag (dict): Dictionary of results and saved file paths for each time lag.
    """
    from analyse_data import spike_count_all_mice
    from fit_linear_nonlinear_model import process_all_neurons_time_lag
    from joblib import dump
    import os

    results_per_lag = {}

    # Compute spike counts once since it does not depend on the lag
    print("\nComputing spike counts...")
    spike_counts = spike_count_all_mice(denoised_data, spike_times_data)

    for lag in range(lag_range[0], lag_range[1] + 1):
        print(f"\nProcessing time lag: {lag}...")

        try:
            # Step 1: Fit models for all neurons
            all_results = []
            for mouse_id in spike_counts.keys():
                dependent_vars = spike_counts[mouse_id].columns.tolist()
                mouse_results = process_all_neurons_time_lag(
                    mouse_id,
                    dependent_vars,
                    spike_counts,
                    denoised_data,
                    random_seed=random_seed,
                    lag_range=(lag, lag)  # Process only the current lag
                )
                all_results.extend([res for res in mouse_results if res is not None])

            # Step 2: Save results using joblib
            joblib_file_name = f'results_ln_model_lag_{str(lag).replace("-", "neg").replace(".", "_")}.joblib'
            joblib_file_path = os.path.join(save_directory, joblib_file_name)
            dump(all_results, joblib_file_path)

            # Store results path for the current time lag
            results_per_lag[lag] = {
                "lag": lag,
                "results": all_results,
                "joblib_path": joblib_file_path
            }

            print(f"Completed time lag: {lag}. Results saved at {joblib_file_path}.")

        except Exception as e:
            print(f"Error processing time lag {lag}: {e}")

    return results_per_lag
