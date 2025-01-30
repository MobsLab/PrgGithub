#!/bin/bash
args=("$@")

echo
echo opening python through shell...
echo
echo


if [[ $USER == "mobshamilton" ]]; then
	python_path="/home/$USER/miniconda3/bin/python"
else
	python_path="python"
fi




#python "/home/$USER/Dropbox/Kteam/PrgMatlab/TimeWarp/solveWithTWPCA.py" $*
"$python_path" "/home/$USER/Dropbox/Kteam/PrgMatlab/TimeWarp/solveWithTWPCA.py" $*


exit 0
