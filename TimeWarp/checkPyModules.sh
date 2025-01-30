#!/bin/bash
args=("$@")

if command -v python3 &>/dev/null;then
	echo python3 installed
else
	echo
	echo Please install python3 !
	echo 
	exit 0
fi


if [[ $USER == "mobshamilton" ]]; then
	python_path="/home/$USER/miniconda3/bin/python"
	pip_path="/home/$USER/miniconda3/lib/python3.6/site-packages/pip"
else
	python_path="python"
	pip_path="pip"
fi

piptest=0

echo
"$python_path" -c "import numpy"
if test $? -eq 1; then
	echo numpy is missing, please install numpy
	piptest=1
else
	echo numpy is installed.
fi
echo
"$python_path" -c "import tables"
if test $? -eq 1; then
	echo tables is missing, please install tables
	piptest=1
else
	echo tables is installed.
fi
echo
"$python_path" -c "import tensorflow"
if test $? -eq 1; then
	echo tensorflow is missing, please install tensorflow
	piptest=1
else
	echo tensorflow is installed.
fi
echo
"$python_path" -c "import matplotlib"
if test $? -eq 1; then
	echo matplotlib is missing, please install matplotlib
	piptest=1
else
	echo matplotlib is installed.
fi
echo
"$python_path" -c "import scipy"
if test $? -eq 1; then
	echo scipy is missing, please install scipy
	piptest=1
else
	echo scipy is installed.
fi
echo
"$python_path" -c "import sklearn"
if test $? -eq 1; then
	echo sklearn is missing, please install sklearn
	piptest=1
else
	echo sklearn is installed.
fi
echo
"$python_path" -c "import struct"
if test $? -eq 1; then
	echo struct is missing, please install struct
	piptest=1
else
	echo struct is installed
fi
echo
"$python_path" -c "import bisect"
if test $? -eq 1; then
	echo bisect is missing, please install bisect
	piptest=1
else
	echo bisect is installed
fi
echo
"$python_path" -c "import matplotlib"
if test $? -eq 1; then
	echo matplotlib is missing, please install matplotlib
	piptest=1
else
	echo matplotlib is installed
fi
echo
"$python_path" -c "import twpca"
if test $? -eq 1; then
	echo twpca is missing, please install twpca
	piptest=1
else
	echo twpca is installed
fi
echo


if test $piptest -eq 1; then
	if command -v pip &>/dev/null;then
		echo pip installed
	else
		echo
		echo Please install pip !
		echo 
	fi
else
	echo Nothing to install.
fi