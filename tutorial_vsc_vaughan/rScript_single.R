# VSC TUTORIAL: RUN SINGLE PROCESS
#
# - highlights:
#      - change output directory to VSC_SCRATCH if needed
#
# Author: Lander Willem
# Last update: 25/04/2023
#__________________________________

# change output directory if the script is executed on the VSC cluster
if(nchar(system('echo $VSC_HOME',intern = T))>0){
  setwd(Sys.getenv('VSC_SCRATCH'))
}

pdf('rScript_single_output.pdf')
plot(1:20)
dev.off()

print('rScript_single.R terminated')
