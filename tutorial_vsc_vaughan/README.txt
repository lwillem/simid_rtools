This folder contains some examples to run R code by submitting a "job" on the VSC cluster "Vaughan" at the University of Antwerp 

Files (best to explore them in this order):
rScript_single.R 	R script to generate a single pdf figure
rScript_parfor.R	R script which takes command line arguments and runs 
			a parallel foreach to generate pdf files and an output 
			matrix.

job_vaughan_single.sh	Bash script to set the environment for rScript_single.R 
			and to run the code.
job_vaughan_parfor.sh	Bash script to set the environment for rScript_parfor.R 
			and to run the parallel code.

Optional files:
vaughan_load.sh		Bash script to store in your VSC_HOME folder to easily
			load your default modules and change directory your 
			VSC_DATA folder. (You might need to set this file
			as an executable, see comments in the .sh file)

config			configuration file to store in your local .ssh folder
			to facilitate your ssh login to the cluster

To submit a job (best to explore them in this order)
sbatch ./job_vaughan_single.sh 
sbatch ./job_vaughan_parfor.sh 

To run the initial bash script
. ./vaughan_load.sh

Some general advice:
- code development has to be completed on your local computer
- run your R script first in an interactive job, to make sure all R libraries are installed and the file paths are working
- your code and model input should be stored in your DATA folder ($VSC_DATA)
- your model output should be stored in your SCRATCH folder ($VSC_SCRATCH)
- the (R) output of the job is stored in a .txt file with a file name based on the job ID 
- make sure you update the email address in the job script
- make sure you adapt the "--ntasks=1" to the required number of CPU's for parallel processes
- the cluster is best suited to run parallel scripts with shared memory for one script or to start multiple in parallel, to obtain the output of X runs in the same time of 1 run.

Information on parallel setup
- if you want one process that can use 16 cores for multithreading: --ntasks=1 --cpus-per-task=16
- if you want to launch 16 independent processes (no communication): --ntasks=16
- if you do not care about where those cores are distributed: --ntasks=16

Useful links on VSC and CalcUA
- https://docs.vscentrum.be
- https://www.uantwerpen.be/en/core-facilities/calcua/training/

Useful linux commands:
- cd 			change directory
- .. 			one folder up
- .			current folder
- pwd			current path
- exit			to leave the cluster
- ssh			to connect to the cluster
- cd $VSC_DATA		go to your DATA folder on the VSC cluster
- cd $VSC_SCRATCH	go to your SCRATCH folder on the VSC cluster
- cd $VSC_HOME		go to your HOME folder on the VSC cluster

Useful slurm job commands:
- sbatch <filename>	to submit a job(file)
- squeue		to see your submitted jobs by name, time and JOBID
- scancel <JOBID>	to cancel a job (eg. "scancel 47824") 



##############################################################
##  Lander Willem, 25/04/2023, lander.willem@uantwerpen.be  ##
##############################################################
 