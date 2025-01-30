#!/bin/bash

# Define variables
types=("continuous" "events")

folder_names_FM=("20241224_TORCs_short" "20241228_LSP_saline" "20241230_LSP_saline")
folder_names_HF=("20241225_TORCs_atropine" "20241226_TORCs_saline" "20241227_TORCs_atropine" "20241228_TORCs_saline" "20241231_TORCs_atropine" "20250101_TORCs_saline" "20250102_TORCs_atropine")

# FM
for type in "${types[@]}"; do
    for folder_name in "${folder_names_FM[@]}"; do
        # Construct the path
        path="/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/$folder_name/recording1/$type/"
            
        # Run the Python script
        python3 ~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat.py -p "$path"
        # Check if the path exists before running the Python script
        if [ -d "$path" ]; then
            echo "Processing path: $path"
            python3 ~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat.py -p "$path" || {
                echo "Error occurred at path: $path";
                exit 1;
            }
        else
            echo "Path does not exist: $path"
        fi
    done
done

echo "Freely-moving complete"


# HF
for type in "${types[@]}"; do
    for folder_name in "${folder_names_HF[@]}"; do
        # Construct the path
        path="/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/$folder_name/recording1/$type/"
            
        # Run the Python script
        python3 ~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat.py -p "$path"
        # Check if the path exists before running the Python script
        if [ -d "$path" ]; then
            echo "Processing path: $path"
            python3 ~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat.py -p "$path" || {
                echo "Error occurred at path: $path";
                exit 1;
            }
        else
            echo "Path does not exist: $path"
        fi
    done
done

echo "Head-fixed complete"

