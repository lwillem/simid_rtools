#############################################################################
# SIMID TUTORIAL: CEA MEAN SCRIPT
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Copyright (C) 2019 lwillem, SIMID, UNIVERSITY OF ANTWERP, BELGIUM
#############################################################################

# clear workspace
rm(list=ls())

# # set working directory (or open RStudio with this script or R-project)
# setwd("C:\User\path\to\the\rcode\folder") ## WINDOWS
# setwd("/Users/path/to/the/rcode/folder") ## MAC

# load packages (optional)
# ..

# load help functions
source('./cea_functions.R')

##########################
##  SETUP               ##
##########################

# set number of samples
num_samples    <- 4

# set population ages
# note: age 0 has index 1
num_ages       <- 11
population_age <- 0:(num_ages-1)

# get population, by age
# note: or load from file...
population     <-  100 + population_age

# infection rate
infection_rate_mean <- 0.01
infection_rate_sd   <- 0.0001
   
# unit qaly loss: average per case
unit_qaly_loss_mean <- 5/365
unit_qaly_loss_sd   <- 1/365

# unit cost: average medical cost per case
unit_cost_mean      <- 500 # euro
unit_cost_sd        <- 20  # euro

# cost per dose (incl. admin?)
cost_per_dose       <- 10 # euro

# vaccine efficacy
vaccine_efficacy    <- 0.80

# random number generator seed
rng_seed <- 2019

##############################################
##  SAMPLE UNCERTAIN PARAMETERS             ##
##############################################

# set random number generator seed
set.seed(rng_seed)

# sample infection rates
sample_infection_rate   <- rnorm(num_samples,
                                 infection_rate_mean,
                                 infection_rate_sd)

# sample unit cost
sample_unit_cost        <- rnorm(num_samples,
                                 unit_cost_mean,
                                 unit_cost_sd)

# sample unit cost
sample_unit_qaly_loss   <- rnorm(num_samples,
                                 unit_qaly_loss_mean,
                                 unit_qaly_loss_sd)


############################################
## ADJUST PARAMETER DIMENTIONS            ##
############################################
# get model parameters by age and sample
# TODO create function(s) for these transitions instead of code duplication

# population by age => copy for all samples
model_population <- matrix(rep(population,num_samples),
                           ncol  = num_samples,
                           nrow  = num_ages,
                           byrow = F)

# parameter samples => copy for all ages
model_infection_rate <- matrix(rep(sample_infection_rate,num_ages),
                               ncol  = num_samples,
                               nrow  = num_ages,
                               byrow = T)

# parameter samples => copy for all ages
model_unit_cost <- matrix(rep(sample_unit_cost,num_ages),
                               ncol  = num_samples,
                               nrow  = num_ages,
                               byrow = T)

# parameter samples => copy for all ages
model_unit_qaly_loss <- matrix(rep(sample_unit_qaly_loss,num_ages),
                               ncol  = num_samples,
                               nrow  = num_ages,
                               byrow = T)

##########################
##  RUN MODEL           ##
##########################

# current situation
coverage_current <- 0
burden_current   <- calculate_burden(population       = model_population,
                                     coverage         = coverage_current,
                                     vaccine_efficacy = vaccine_efficacy,
                                     infection_rate   = model_infection_rate,
                                     unit_cost        = model_unit_cost,
                                     unit_qaly_loss   = model_unit_qaly_loss,
                                     cost_per_dose    = cost_per_dose
                                     ) 
# scenario 1: uptake of 50%
coverage_scenario50 <- 0.5
burden_scenario50   <- calculate_burden(population       = model_population,
                                        coverage         = coverage_scenario50,
                                        vaccine_efficacy = vaccine_efficacy,
                                        infection_rate   = model_infection_rate,
                                        unit_cost        = model_unit_cost,
                                        unit_qaly_loss   = model_unit_qaly_loss,
                                        cost_per_dose    = cost_per_dose
) 

# scenario 2: uptake of 60%
coverage_scenario60 <- 0.6
burden_scenario60   <- calculate_burden(population       = model_population,
                                        coverage         = coverage_scenario60,
                                        vaccine_efficacy = vaccine_efficacy,
                                        infection_rate   = model_infection_rate,
                                        unit_cost        = model_unit_cost,
                                        unit_qaly_loss   = model_unit_qaly_loss,
                                        cost_per_dose    = cost_per_dose
) 


##########################
## INCREMENTAL EFFECTS  ##
##########################

# calculate incremental effects
incr_scenario50 <- calculate_incremental_effects(burden_current,burden_scenario50)
incr_scenario60 <- calculate_incremental_effects(burden_current,burden_scenario60)

# bind all results
incr_all <- rbind(incr_scenario50,
                  incr_scenario60)


##########################
## SAVE RESULTS      ##
##########################

# combine model input and output
output_all <- data.frame(incr_all,
                         infection_rate_mean,
                         infection_rate_sd,
                         sample_infection_rate,
                         unit_cost_mean,
                         unit_cost_sd,
                         sample_unit_cost,
                         unit_qaly_loss_mean,
                         unit_qaly_loss_sd,
                         sample_unit_qaly_loss,
                         cost_per_dose,
                         vaccine_efficacy,
                         num_samples,
                         rng_seed)

# check
head(output_all)

# save as CSV
write.table(output_all,file='cea_tutorial_output.csv',sep=',',row.names=F)

# optional: save as RData file (compressed and faster to load in R)
save(output_all,file='cea_tutorial_output.RData')


##########################
## EXPLORE RESULTS      ##
##########################

# plot the CE
plot_cost_effectiveness_plain(incr_all$incremental_cost,
                              incr_all$incremental_qaly_gain,
                              incr_all$scenario_label)

# ...


# print message to terminal
print('CEA MEAN COMPLETE')


