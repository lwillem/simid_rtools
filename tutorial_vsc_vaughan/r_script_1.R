#__________________________________
# VSC TUTORIAL
#
# Authors: Willem Lander
# Last update: 15/10/2021
#__________________________________

setwd(Sys.getenv('VSC_SCRATCH'))

pdf('script1_output.pdf')
plot(1:20)
dev.off()

print('r_script_1.R terminated')
