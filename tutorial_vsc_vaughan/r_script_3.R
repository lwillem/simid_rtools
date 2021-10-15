####################################### #
# VSC TUTORIAL
#
# - summary: dummy code to save a pdf with some dots
# - option to change output directory to VSC_SCRATCH 
# - option to use command line arguments
# - use RStudio file document outline 
#
# Author: Willem Lander
# Last update: 14/10/2021
####################################### #

# parse command line interface (CLI) arguments 
cli_args = commandArgs(trailingOnly=TRUE)

# clear workspace, but leave the command line arguments
rm(list=ls()[ls()!='cli_args'])

# message for the user
print('START SCRIPT: job1c.R')

library(foreach)

# # uncomment the following lines to install the simid.rtools package from github
# install.packages('devtools')
# library(devtools)
# devtools::install_github("lwillem/simid_rtools",force=F,quiet=T)
library('simid.rtools')

## SETTINGS ####
####################################### #

# set number of dots
num_dots <- 10

# start from black run_tag
run_tag <- 'par'

# optional: process command line argument 'NUMBER OF DOTS
if(length(cli_args) >= 1){
  num_dots <- as.numeric(cli_args[[1]])
}

# optional: process command line arguments 'JOB ID'
if(length(cli_args) >= 2){
  run_tag <- paste(run_tag,cli_args[[2]],sep='_') # add job ID to run_tag
}

# set parallel chains
num_chains <- 5



## PRE_PROCESSING   ####
####################################### #

#setup parallel workers (from simid.rtools)
smd_start_cluster(num_proc = num_chains)

## RUN ####
####################################### #

# note: change 'dopar' into 'do' to run sequentially
# note: change 'do' into 'dopar' to run in parallel
foreach(i_chain = 1:num_chains) %dopar% {
  system(paste('Rscript job1b.R ',num_dots,paste(run_tag,i_chain,sep='_')))
}

## CLOSE ####
####################################### #

# close parallel workers (from simid.rtools)
smd_stop_cluster()

# message for the user
print('END SCRIPT: job1c.R')


