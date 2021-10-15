This folder contains some examples to submit "jobs" on the VSC cluster Vaughan at the University of Antwerp to run R scripts.

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
			to run the parallel code.


To submit a job (best to explore them in this order)
sbatch ./job_vaughan_single.sh 
sbatch ./job_vaughan_multi.sh 
sbatch ./job_vaughan_parallel.sh 


Some general advice:
- run your R script first in an interactive job, to make sure all R libraries are installed and the file paths are working
- your code and model input is best stored in your DATA folder ($VSC_DATA)
- your model output should be stored in your SCRATCH folder ($VSC_SCRATCH)
- the (R) output of the job is stored in a .txt file with a file name based on the job ID 
- make sure you update the email address in the job script
- make sure you adapt the "--ntasks=1" to the required number of CPU's for parallel processes

useful linux commands:
- cd 			change directory
- .. 			one folder up
- .			current folder
- pwd			current path
- exit			to leave the cluster
- ssh			to connect to the cluster
- cd $VSC_DATA		go to your DATA folder on the cluster
- cd $VSC_SCRATCH	go to your SCRATCH folder on the cluster

Useful slurm job commands:
- sbatch <filename>	to submit a job(file)
- squeue		to see your submitted jobs by name, time and JOBID
- scancel <JOBID>	to cancel a job (eg. "scancel 47824") 



############################################################
## (Lander Willem, 15/10/2021, lander.willem@uantwerp.be) ##
############################################################
 