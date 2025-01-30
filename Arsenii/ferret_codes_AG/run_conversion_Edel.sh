#!/bin/bash

# Define variables
phases=("Exp" "PostExp" "PreExp")
types=("continuous" "events")
folder_names=("20220415_m" "20220415_n" "20220418_m" "20220418_n" "20220419_m" "20220419_n" "20220420_m" "20220420_n" "20220421_m" "20220421_n" "20220422_m" "20220422_n" "20220426_n" "20220427_m" "20220427_n" "20220428_m" "20220428_n" "20220429_m" "20220429_n" "20220430_m" "20220502_n" "20220503_m" "20220503_n" "20220504_m" "20220504_n" "20220505_m" "20220505_n" "20220506_m" "20220509_n" "20220510_m" "20220510_n" "20220511_m" "20220511_n" "20220512_m" "20220512_n" "20220513_m" "20220517_m" "20220517_n" "20220518_m" "20220518_n" "20220519_m" "20220519_n" "20220520_m" "20220520_n" "20220523_m" "20220523_n" "20220524_m" "20220524_n")

# Iterate through each combination of phase, type, and folder_name
for phase in "${phases[@]}"; do
    for type in "${types[@]}"; do
        for folder_name in "${folder_names[@]}"; do
            # Construct the path
            path="/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/$folder_name/$phase/$type/"
            
            # Run the Python script
            python3 ~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat.py -p "$path"
        done
    done
done

echo "All tasks completed."

