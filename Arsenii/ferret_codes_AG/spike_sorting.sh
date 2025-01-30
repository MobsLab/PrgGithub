#!/bin/bash

# Check for input argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <session_folder>"
    exit 1
fi

session_folder=$1

# Check if the session folder exists
if [ ! -d "$session_folder" ]; then
    echo "Error: Directory '$session_folder' does not exist."
    exit 1
fi

# Change to the session folder
cd "$session_folder" || { echo "Failed to change directory to $session_folder"; exit 1; }

# Extract the date from the folder name (assumes folder name starts with YYYYMMDD)
folder_name=$(basename "$session_folder")
date=$(echo "$folder_name" | grep -oE "^[0-9]{8}")

if [ -z "$date" ]; then
    echo "Error: Could not extract date from folder name '$folder_name'. Ensure it starts with YYYYMMDD."
    exit 1
fi

echo "Extracted date: $date"

# Find all .xml files matching the generalized pattern
files=$(find . -type f -name "M4_${date}_Shropshire_${date}_*.xml" | grep -v "-01.xml")

if [ -z "$files" ]; then
    echo "No valid .xml file found matching the pattern in '$session_folder'."
    exit 1
fi

# Select the first matching file
file=$(echo "$files" | head -n 1)

# Extract the base name of the file (without .xml extension)
filename=$(basename "$file")
M4_date=${filename%%.xml}

echo "Found file: $M4_date"

# Function to measure and display execution time
run_command() {
    start_time=$(date +%s)
    echo "Running: $1"
    eval "$1"
    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))
    echo "Step completed in $elapsed_time seconds."
}

# Run commands
run_command "ndm_hipass $M4_date"
run_command "ndm_extractspikes $M4_date"
run_command "ndm_pca $M4_date"

# Create SpikeSorting directory if it doesn't exist
spike_sorting_dir="./SpikeSorting"
mkdir -p "$spike_sorting_dir"
echo "SpikeSorting directory created: $spike_sorting_dir"

# Move all relevant files to SpikeSorting
mv ./*.spk ./*.res ./*.clu ./*.fet "$spike_sorting_dir"

echo "All files moved to SpikeSorting directory."
echo "Processing completed for $M4_date."

