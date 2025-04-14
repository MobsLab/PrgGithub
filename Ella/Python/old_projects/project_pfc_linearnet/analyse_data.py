# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 17:52:39 2024

@author: ellac
"""

import numpy as np
import pandas as pd


def extract_epoch_indices(mice_data, mouse_id, epoch_name):
    """
    Extract the time indices corresponding to start and stop epochs within a given epoch for a specific mouse.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - epoch_name (str): Name of the epoch for which indices are to be extracted.

    Returns:
    - selected_rows (list): List of time indices corresponding to the selected epochs.
    """

    # Extract start and stop timepoints of each set of a given epoch
    start_epochs = mice_data[mouse_id][epoch_name].iloc[::2].reset_index(drop=True)
    stop_epochs = mice_data[mouse_id][epoch_name].iloc[1::2].reset_index(drop=True)
    timebins = mice_data[mouse_id]['timebins']
    
    # Check if start and stop epochs have the same length
    if start_epochs.count() != stop_epochs.count():
        raise ValueError('Start and stop epochs do not have the same length')
        
    # Check if start epoch is lower than stop epoch for each pair
    for i in range(stop_epochs.count()):
        if start_epochs[i] > stop_epochs[i]:
            raise ValueError(f'Start epoch is higher than stop epoch for line {i}')

    selected_rows = []
    epoch_bin = 0 
    
    # Iterate through start and stop epochs to extract corresponding time indices
    for i in range(start_epochs.count()):
        while timebins[epoch_bin] <= stop_epochs[i] and epoch_bin < len(mice_data[mouse_id])-1:
            if timebins[epoch_bin] >= start_epochs[i]:
                selected_rows.append(epoch_bin)
                
            epoch_bin += 1
        
    return selected_rows


def extract_epoch_timepoints(mice_data, mouse_id):
    """
    Extract timepoints and corresponding epoch names from columns ending with '_epo' in the given mouse data,
    while properly handling NaN values and sorting the resulting DataFrame by chronological order.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.

    Returns:
    - epoch_df (pd.DataFrame): A DataFrame with columns ['epoch_name', 'start_time', 'stop_time'] sorted chronologically.
    """
    epoch_data = []

    # Iterate through the columns in the mouse dataframe
    for col in mice_data[mouse_id].columns:
        if col.endswith('_epo'):  # Select columns that represent epochs (ending with '_epo')
            # Extract start and stop timepoints
            start_epochs = mice_data[mouse_id][col].iloc[::2].reset_index(drop=True)
            stop_epochs = mice_data[mouse_id][col].iloc[1::2].reset_index(drop=True)

            # Filter out NaN values from both start and stop epochs
            start_epochs = start_epochs.dropna().reset_index(drop=True)
            stop_epochs = stop_epochs.dropna().reset_index(drop=True)

            # Check if the number of valid (non-NaN) start and stop timepoints match
            if start_epochs.count() != stop_epochs.count():
                raise ValueError(f"Mismatch between start and stop timepoints in {col}")

            # Create rows for each valid epoch
            for start, stop in zip(start_epochs, stop_epochs):
                epoch_data.append({'epoch_name': col, 'start_time': start, 'stop_time': stop})

    # Convert the data to a DataFrame
    epoch_df = pd.DataFrame(epoch_data)

    # Sort the DataFrame by 'start_time' to ensure chronological order
    epoch_df = epoch_df.sort_values(by='start_time').reset_index(drop=True)

    return epoch_df


def get_epochs_for_time_intervals(mice_data, mouse_id, time_intervals):
    """
    Map a list of time intervals to their corresponding epochs based on the 'timebins' column.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - time_intervals (list of tuples): List of tuples representing time intervals (start_index, stop_index).
                                       The start and stop indices correspond to positions in the 'timebins' array.

    Returns:
    - interval_to_epoch (list): A list of tuples with the time interval and corresponding epoch name(s).
    """
    interval_to_epoch = []
    timebins = mice_data[mouse_id]['timebins']

    # First, extract the epochs and their timepoints using the extract_epoch_timepoints function
    epoch_df = extract_epoch_timepoints(mice_data, mouse_id)

    # Iterate over each time interval
    for interval in time_intervals:
        start_index, stop_index = interval

        # Extract the actual start and stop times from timebins
        start_time = timebins[start_index]
        stop_time = timebins[stop_index]

        epochs_for_interval = []

        # Iterate over the epochs in the epoch_df and check for overlap
        for _, row in epoch_df.iterrows():
            epoch_name = row['epoch_name']
            start_epoch = row['start_time']
            stop_epoch = row['stop_time']

            # Check if the time interval overlaps with the epoch
            if start_time <= stop_epoch and stop_time >= start_epoch:
                epochs_for_interval.append(epoch_name)

        # Append the time interval and its corresponding epochs to the result
        interval_to_epoch.append((start_index, stop_index, epochs_for_interval))

    return interval_to_epoch



def spike_count(mice_data, mouse_id, spike_times_data):
    """
    Compute spike counts for each neuron based on spike times data, handling NaN values appropriately.
    The last row of the DataFrame is filled with NaN values.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - spike_times_data (dict): Dictionary containing spike times data for each neuron.

    Returns:
    - result_df (pd.DataFrame): DataFrame containing spike counts for each neuron.
    """

    # Check if data is available for the specified mouse
    if mouse_id not in spike_times_data:
        raise ValueError(f"No spike data available for mouse {mouse_id}.")

    # Initialize a DataFrame to store the results
    result_df = pd.DataFrame(index=mice_data[mouse_id]['timebins'])

    # Iterate through all neurons for the given mouse
    for neuron_key in spike_times_data[mouse_id].columns:
        # Extract spike times for the current neuron, dropping NaN values
        neuron_data = spike_times_data[mouse_id][neuron_key].dropna()  # Remove NaN spike times

        # Compute spike counts using np.histogram based on the timebins
        spike_counts, bin_edges = np.histogram(neuron_data, bins=mice_data[mouse_id]['timebins'], density=False)

        # Ensure spike_counts matches the length of the timebins
        if len(spike_counts) != len(mice_data[mouse_id]['timebins']):
            spike_counts = np.pad(spike_counts, (0, len(mice_data[mouse_id]['timebins']) - len(spike_counts)), 'constant')

        # Add a new column to the result DataFrame for the current neuron
        result_df[neuron_key] = spike_counts

    # Fill the last row of the DataFrame with NaN values
    result_df.iloc[-1] = np.nan

    return result_df



def spike_count_all_mice(mice_data, spike_times_data):
    """
    Compute spike counts for each mouse and each neuron based on spike times data.
    NaN spike times are ignored in the computation. The last row of each result DataFrame
    is filled with NaN values.

    Parameters:
    - mice_data (dict): Dictionary containing data for each mouse.
    - spike_times_data (dict): Dictionary containing spike times data for each mouse.

    Returns:
    - spike_count_dict (dict): Dictionary containing spike counts for each mouse and each neuron.
    """

    spike_count_dict = {}

    # Iterate over each mouse in the mice_data dictionary
    for mouse_id in mice_data:
        # Ensure the mouse exists in the spike_times_data dictionary
        if mouse_id not in spike_times_data:
            raise ValueError(f"No spike data available for mouse {mouse_id}.")

        # Initialize a DataFrame to store the results for this mouse
        result_df = pd.DataFrame(index=mice_data[mouse_id]['timebins'])

        # Iterate through all neurons for the given mouse
        for neuron_key in spike_times_data[mouse_id].columns:
            # Extract spike times for the current neuron
            neuron_data = spike_times_data[mouse_id][neuron_key].dropna()  # Drop NaN values in spike times

            # Compute spike counts using np.histogram based on the timebins
            spike_counts, bin_edges = np.histogram(neuron_data, bins=mice_data[mouse_id]['timebins'], density=False)
            
            # Ensure spike_counts matches the length of the timebins
            if len(spike_counts) != len(mice_data[mouse_id]['timebins']):
                spike_counts = np.pad(spike_counts, (0, len(mice_data[mouse_id]['timebins']) - len(spike_counts)), 'constant')

            # Add a new column to the result DataFrame for the current neuron
            result_df[neuron_key] = spike_counts

        # Fill the last row of the DataFrame with NaN values
        result_df.iloc[-1] = np.nan

        # Store the result DataFrame in the spike_count_dict for this mouse
        spike_count_dict[mouse_id] = result_df

    return spike_count_dict




def spike_count_variable(mice_data, mouse_id, spike_times_data, variable, interval_step=0.2, min_value=None, max_value=None):
    """
    Compute mean spike counts for each neuron in relation to a specified variable within a given interval range.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - spike_times_data (dict): Dictionary containing spike times data for each neuron.
    - variable (str): Name of the variable for which spike counts are computed.
    - interval_step (float): Step size for the variable interval.
    - min_value (float, optional): Minimum value of the variable range. Defaults to the min value in the data.
    - max_value (float, optional): Maximum value of the variable range. Defaults to the max value in the data.

    Returns:
    - result_df (pd.DataFrame): DataFrame containing mean spike counts for each neuron.
    """

    # Check if data is available for the specified mouse
    if mice_data[mouse_id][variable].isna().all():
        raise ValueError(f"No variable data available for mouse {mouse_id}.")
    
    # Extract data for the specified mouse
    variable_data = mice_data[mouse_id][variable]

    # Set min and max values based on user input or data defaults
    min_value = min_value if min_value is not None else min(variable_data)
    max_value = max_value if max_value is not None else max(variable_data)

    # Initialize a DataFrame to store the results with time intervals
    result_df = pd.DataFrame({variable: np.arange(min_value, max_value, step=interval_step)})

    # Iterate through all neurons for the given mouse
    for neuron_key in spike_times_data[mouse_id].columns:
        # Extract spike times for the current neuron
        neuron_data = spike_times_data[mouse_id][neuron_key]

        # Compute spike counts using np.histogram
        spike_counts, _ = np.histogram(neuron_data, bins=mice_data[mouse_id]['timebins'], density=False)
        spike_counts = np.append(spike_counts, 0)  # Padding the spike counts array for boundary issues

        # Initialize list to store mean spike counts
        mean_spikes = []

        # Loop through data intervals and compute mean spike counts
        for threshold in np.arange(min_value, max_value, step=interval_step):
            # Use boolean indexing to select spike_counts within the specified threshold interval
            interval_spikes = spike_counts[(variable_data >= threshold) & (variable_data < threshold + interval_step)]

            # Compute the mean of spikes within the interval
            mean_spike_activity = np.mean(interval_spikes) if len(interval_spikes) > 0 else 0
            mean_spikes.append(mean_spike_activity)

        # Add a new column to the result DataFrame for the current neuron
        result_df[neuron_key] = mean_spikes

    return result_df


def spike_count_variable_mean_std(mice_data, mouse_id, spike_times_data, variable, interval_step=0.2, min_value=None, max_value=None):
    """
    Compute the mean and standard deviation of spike counts for each neuron within specified variable intervals.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - spike_times_data (dict): Dictionary containing spike times data for each neuron.
    - variable (str): Name of the variable for which spike counts are computed.
    - interval_step (float): Step size for the variable interval.
    - min_value (float, optional): Minimum value of the variable range. Defaults to the min value in the data.
    - max_value (float, optional): Maximum value of the variable range. Defaults to the max value in the data.

    Returns:
    - result_df (pd.DataFrame): DataFrame containing the mean and std spike activity for each neuron.
    """

    # Check if data is available for the specified mouse
    if mice_data[mouse_id][variable].isna().all():
        raise ValueError(f"No variable data available for mouse {mouse_id}.")
    
    # Extract data for the specified mouse
    variable_data = mice_data[mouse_id][variable]

    # Set min and max values based on user input or data defaults
    min_value = min_value if min_value is not None else min(variable_data)
    max_value = max_value if max_value is not None else max(variable_data)

    # Initialize the time interval values
    time_intervals = np.arange(min_value, max_value, step=interval_step)

    # Initialize lists to store the data for all neurons
    neuron_columns = []

    # Iterate through all neurons for the given mouse
    for neuron_key in spike_times_data[mouse_id].columns:
        # Extract spike times for the current neuron
        neuron_data = spike_times_data[mouse_id][neuron_key]

        # Compute spike counts using np.histogram
        spike_counts, _ = np.histogram(neuron_data, bins=mice_data[mouse_id]['timebins'], density=False)
        spike_counts = np.append(spike_counts, 0)  # Padding the spike counts array

        # Initialize lists to store mean and std values for this neuron
        mean_spikes = []
        std_spikes = []

        # Loop through data intervals and compute spike activity
        for threshold in time_intervals:
            # Use boolean indexing to select spike counts within the specified threshold interval
            interval_spikes = spike_counts[(variable_data >= threshold) & (variable_data < threshold + interval_step)]

            # Compute mean and standard deviation for the interval
            mean_activity = np.mean(interval_spikes) if len(interval_spikes) > 0 else 0
            std_activity = np.std(interval_spikes) if len(interval_spikes) > 0 else 0

            mean_spikes.append(mean_activity)
            std_spikes.append(std_activity)

        # Create a DataFrame for this neuron's mean and std columns
        neuron_df = pd.DataFrame({
            f'{neuron_key}_mean': mean_spikes,
            f'{neuron_key}_std': std_spikes
        })

        # Append this neuron's DataFrame to the list
        neuron_columns.append(neuron_df)

    # Concatenate all neuron data columns together along with the time intervals
    result_df = pd.concat([pd.DataFrame({variable: time_intervals})] + neuron_columns, axis=1)

    return result_df






