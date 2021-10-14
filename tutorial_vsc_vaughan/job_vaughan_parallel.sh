#!/bin/bash

# FYI: to run this script, excecute: sbatch job_vaughan_parallel.sh
# FYI: run one R scripts with parallel foreach and 5 workers

# job settings:
#SBATCH --job-name=vsc_tutorial_3
#SBATCH --mail-user=lander.willem@uantwerpen.be
#SBATCH --mail-type=END
#SBATCH -t 00:05:00
#SBATCH --ntasks=5 --cpus-per-task=1

# actual script content:

# change directory and load modules
cd /data/antwerpen/201/vsc20172/stochastic_model_BE/
module load buildtools/2020a
module load R/4.0.2-intel-2020a

# start parallel script
Rscript ./job1c.R 20 ${SLURM_JOB_ID}
