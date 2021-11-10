This folder contains some examples to submit "jobs" on the VSC cluster Vaughan 
at the University of Antwerp to run e.g. R code

Files:
r_script_1.R	 	basic R script to generate a pdf figure
r_script_2.R	 	R script which takes command line arguments for 
			the number of dots in the graph and run ID
r_script_3.R	 	R script with some kind of scheduler to run the 
			r_script_2.R script multiple times in parallel.

job_vaughan_single.sh	bash script to set the environment for r_script_1.R
			and r_script_2.R and to run the code.
job_vaughan_multi.sh	bash script to set the environment for r_script_1.R
			and r_script_2.R and to run the code in parallel.
job_vaughan_parallel.sh	bash script to set the environment for r_script_3.R
			and to run the parallel code.
job_vaughan_param.sh	bash script to run r_script_2.R with command line
			interface parameters and specific job-name.

vaughan_load.sh		bash script to locate in your VSC_HOME folder to 
			easily load your default modules and change directory
			your VSC_DATA folder. (You might need to set this file
			as an executable, see comments in the .sh file)

To submit a job (best to explore them in this order)
sbatch ./job_vaughan_single.sh 
sbatch ./job_vaughan_multi.sh 
sbatch ./job_vaughan_parallel.sh 
sbatch --job-name=param_script --export=ALL,N=40 job_vaughan_param.sh

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
- if you use mpi and do not care about where those cores are distributed: --ntasks=16

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



############################################################
##  Lander Willem, 10/11/2021, lander.willem@uantwerp.be  ##
############################################################
 