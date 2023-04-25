#################################################### #
# VSC TUTORIAL: RUN PARALLEL FOREACH IN R
#
# - highlights:
#      - change output directory to VSC_SCRATCH
#      - use command line arguments
#      - use RStudio file document outline (####)
#
# This file can be executed with or without command line arguments. For example:
#   - terminal: Rscript r_script_3.R
#   - terminal: Rscript r_script_3.R 10
#   - terminal: Rscript r_script_3.R 10 chermid
#   - within R: system('Rscript r_script_3.R 10')
#   - within R: system('Rscript r_script_3.R 10 chermid')
#
# Author: Lander Willem
# Last update: 25/04/2023
#################################################### #

# parse command line interface (CLI) arguments
cli_args = commandArgs(trailingOnly=TRUE)

# clear workspace, but leave the command line arguments
rm(list=ls()[ls()!='cli_args'])

# # uncomment the following lines to install the simid.rtools package from github
# install.packages('devtools')
# library(devtools)
# devtools::install_github("lwillem/simid_rtools",force=F,quiet=T)
library('simid.rtools')

# message for the user
print('START SCRIPT: rScript_parfor.R')

## SETTINGS ####
####################################### #

# set output directory
output_main_dir <- 'output'

# set number of dots
num_dots <- 10

# start from black run_tag
run_tag <- 'rScript_parfor'

# optional: process command line argument 1 == 'NUMBER OF DOTS'
if(length(cli_args) >= 1){
  num_dots <- as.numeric(cli_args[[1]])
}

# optional: process command line argument 2 == 'JOB ID'
if(length(cli_args) >= 2){
  run_tag <- paste(run_tag,cli_args[[2]],sep='_') # add job ID to run_tag
}

# set parallel chains
num_chains <- 5

# dummy function
foo <- function(x){
  return(x+1)
}

## PRE_PROCESSING   ####
####################################### #

# add time stamp to run_tag
run_tag <- paste0(format(Sys.time(),'%Y%m%d_%H%M%S_'),run_tag)

# add input info to run_tag
run_tag <- paste0(run_tag,'_n',num_dots)

# change output directory if the script is executed on the VSC cluster
if(nchar(system('echo $VSC_HOME',intern = T))>0){
  output_main_dir <- file.path(Sys.getenv('VSC_SCRATCH'),basename(getwd()),output_main_dir)
}

# specify output directory for this run
output_dir <- file.path(output_main_dir,run_tag)

# make sure the output directory exists
if(!dir.exists(output_dir)){
  dir.create(output_dir,recursive = T)
}

# print summary (for the user)
print(paste('WORK DIRECTORY:',getwd()))
print(paste('OUTPUT DIRECTORY:', output_dir))

# set-up parallel workers (using simid.rtools)
smd_start_cluster(num_proc = num_chains)

## RUN ####
####################################### #

# note: change 'dopar' into 'do' to run sequentially
# note: change 'do' into 'dopar' to run in parallel
foreach(i_chain = 1:num_chains,
        .combine = "rbind") %dopar%
  {

  # get process id (for illustration purpose of the parallel setup)
  str_iter_id <- Sys.getpid()
  ps_all <- system('ps -o pid,psr,comm',intern = F)

  sys.status()

  # option 1: save results to file
  # note: return results to save them here, or make sure that the model output
  pdf(file.path(output_dir,paste0(run_tag,'_c',i_chain,'.pdf')))
    plot(0:num_dots,
         col=2,
         main=str_iter_id)
  dev.off()

  # option 2: call function with iteration-specific arguments (i.e. configuration) and return resuls
  iter_out <- foo(i_chain)
  return(iter_out)

} -> exp_out

# save "exp_out"
write.table(exp_out,
            file=file.path(output_dir,paste0(run_tag,'_summary.csv')),row.names = FALSE)

## CLOSE ####
####################################### #

# close parallel workers (using simid.rtools)
smd_stop_cluster()

# message for the user
print('END SCRIPT: rScript_parfor.R')
