#!/bin/bash

# FYI: to run this script, excecute: sbatch job_vaughan_parallel.sh
# FYI: run one R scripts with parallel foreach and 5 workers

# to use this script:
# - add your email adress to receive notifications
# - copy the 'tutorial_vsc_vaughan' folder to ${VSC_DATA}

# job settings:
#SBATCH --job-name=vsc_tutorial
#SBATCH --output=vsc_tutorial_%j.txt
#SBATCH --mail-user=xxx.xxx@uantwerpen.be
#SBATCH --mail-type=END
#SBATCH -t 00:05:00
#SBATCH --ntasks=5 --cpus-per-task=1

# actual script content:

# change directory and load modules
cd ${VSC_DATA}/tutorial_vsc_vaughan/
module load buildtools/2020a
module load R/4.0.2-intel-2020a

# start parallel script
Rscript ./r_script_3.R 20 ${SLURM_JOB_ID}
