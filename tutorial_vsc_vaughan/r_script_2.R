####################################### #
# VSC TUTORIAL
#
# - summary: dummy code to save a pdf with some dots
# - option to change output directory to VSC_SCRATCH
# - option to use command line arguments
# - use RStudio file document outline
#
# Author: Willem Lander
# Last update: 15/10/2021
####################################### #

# parse command line interface (CLI) arguments
cli_args = commandArgs(trailingOnly=TRUE)

# clear workspace, but leave the command line arguments
rm(list=ls()[ls()!='cli_args'])

# message for the user
print('START SCRIPT: r_script_2.R')

## SETTINGS ####
####################################### #

# set output directory
output_main_dir <- 'output'

# set (basic) run tag
run_tag <- 'vsc_tutorial2'

# set number of dots
num_dots <- 10

# optional: process command line argument 'NUMBER OF DOTS
if(length(cli_args) >= 1){
  num_dots <- as.numeric(cli_args[[1]])
}

# optional: process command line arguments 'JOB ID'
if(length(cli_args) >= 2){
  run_tag <- paste(run_tag,cli_args[[2]],sep='_') # add job ID to run_tag
}

## PRE_PROCESSING   ####
####################################### #

# change output directory if executed on the VSC cluster
if(nchar(Sys.getenv('VSC_INSTITUTE_CLUSTER'))>0){
  output_main_dir <- file.path(Sys.getenv('VSC_SCRATCH'),basename(getwd()),output_main_dir)
}

# add time stamp to run_tag
run_tag <- paste0(format(Sys.time(),'%Y%m%d_%H%M%S_'),run_tag)

# add input info to run_tag
run_tag <- paste0(run_tag,'_n',num_dots)

# specify output directory for this run
output_dir <- file.path(output_main_dir,run_tag)

# make sure the output directory exists
if(!dir.exists(output_dir)){
  dir.create(output_dir,recursive = T)
}

# summary (for the user)
print(paste('WORK DIRECTORY:',getwd()))
print(paste('OUTPUT DIRECTORY:', output_dir))

## RUN ####
####################################### #

# do some (real) stuff
# .....
# ....



## EXPLORE / OUTPUT ####
####################################### #

# create output
pdf(file.path(output_dir,'script_2_output.pdf'))
plot(0:num_dots,col=2)
dev.off()


# message for the user
print('END SCRIPT: r_script_2.R')


