#!/bin/bash

# This script might be usefull to locate in your VSC_HOME folder
# to load your default modules and change the directory your your
# VSC_DATA folder, where your code etc. is located.

# Notes:
# to make this script an executable: "chmod +x vaughan_load.sh"
# to run this scipt and change work directory: ". ./vaughan_load.sh"

# FYI: modules used for Stride and stochastic COVID19 model
module load buildtools/2020a
module load R/4.0.2-intel-2020a
module load Boost/1.73.0-intel-2020a
module load FFTW/3.3.8-intel-2020a

# set locale, for R setup etc.
export LC_ALL=en_US.UTF-8

# change directory to your VSC data folder
cd $VSC_DATA
