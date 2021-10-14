#!/bin/bash

# FYI: to run this script, excecute: sbatch job_vaughan_single.sh

# job settings:
#SBATCH --job-name=vsc_tutorial
#SBATCH --mail-user=lander.willem@uantwerpen.be
#SBATCH --mail-type=END
#SBATCH -t 00:05:00
#SBATCH --ntasks=1 --cpus-per-task=1

# actual script content:

# change directory and load modules
cd /data/antwerpen/201/vsc20172/stochastic_model_BE/
module load buildtools/2020a
module load R/4.0.2-intel-2020a

# start script
Rscript ./job1a.R
# some time to prevent similar run names etc.
sleep 2

# start a second script
Rscript ./job1b.R 20 ${SLURM_JOB_ID}


