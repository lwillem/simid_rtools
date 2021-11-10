#!/bin/bash

# FYI: to run this script, excecute: sbatch --job-name=param_script --export=ALL,N=40 job_vaughan_param.sh

# to use this script:
# - add your email adress to receive notifications
# - copy the 'tutorial_vsc_vaughan' folder to ${VSC_DATA}

# FYI on parallel setup
# if you want one process that can use 16 cores for multithreading: --ntasks=1 --cpus-per-task=16
# if you want to launch 16 independent processes (no communication): --ntasks=16
# if you use mpi and do not care about where those cores are distributed: --ntasks=16

# job settings:
#SBATCH --output=vsc_tutorial_%j.txt
#SBATCH --mail-user=lander.willem@uantwerpen.be
#SBATCH --mail-type=END
#SBATCH -t 00:05:00
#SBATCH --ntasks=1 --cpus-per-task=1

# actual script content:

# change directory and load modules
cd ${VSC_DATA}/tutorial_vsc_vaughan/
module load buildtools/2020a
module load R/4.0.2-intel-2020a

# start script 2 with command line parameters (and use default stdout file, which is created at the end of your job)
Rscript ./r_script_2.R ${N} ${SLURM_JOB_ID}

# start script 2 and write output in real time to a given txt file
Rscript ./r_script_2.R ${N} ${SLURM_JOB_NAME} &> ${VSC_DATA}/tutorial_vsc_vaughan/stdout_${SLURM_JOB_NAME}_${SLURM_JOB_ID}.txt
