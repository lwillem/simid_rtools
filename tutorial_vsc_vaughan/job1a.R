#__________________________________
# VSC TUTORIAL
#
# Authors: Willem Lander
# Last update: 14/10/2021
#__________________________________

setwd(Sys.getenv('VSC_SCRATCH'))

pdf('job1a_output.pdf')
plot(1:20)
dev.off()

print('job1a terminated')
