#############################################################################
# SIMID TUTORIAL: CEA FUNCTION LIBRARY
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Copyright (C) 2019 lwillem, SIMID, UNIVERSITY OF ANTWERP, BELGIUM
#############################################################################

#
# FUNCTION TO CALCULATE THE HEALTH AND FINANCIAL BURDEN
#
calculate_burden <- function(population, coverage, vaccine_efficacy, infection_rate, unit_cost, unit_qaly_loss, cost_per_dose){
  
  # calculate the susceptible population
  population_susceptible  <- population * (1- (coverage * vaccine_efficacy))
  
  # calculate the number of cases
  num_cases               <- population_susceptible * infection_rate
  
  # calculate the total qaly loss
  total_qaly_loss         <- num_cases * unit_qaly_loss
  
  # calculate the total medical cost
  total_medical_cost      <- num_cases * unit_cost
  
  # calculate intervention cost
  total_intervention_cost <- population * coverage * cost_per_dose
  
  # calculate total cost
  total_cost <- total_medical_cost + total_intervention_cost
  
  # create scenario label
  scenario_label <- paste0('cov. ',coverage)
  
  # sum over age
  num_cases               <- colSums(num_cases)
  total_qaly_loss         <- colSums(total_qaly_loss)
  total_medical_cost      <- colSums(total_medical_cost)
  total_intervention_cost <- colSums(total_intervention_cost)
  total_cost              <- colSums(total_cost)
  
  # return aggregated statistics
  return(data.frame(num_cases,
                    total_qaly_loss,
                    total_medical_cost,
                    total_intervention_cost,
                    total_cost,
                    coverage,
                    scenario_label))
}

#
# FUNCTION TO CALCULATE THE INCREMENTAL EFFECTS
#
calculate_incremental_effects <- function(burden_reference, burden_scenario){
  
  # incremental cost
  incremental_cost      <- burden_scenario$total_cost - burden_reference$total_cost
  
  # incremental qaly gain
  incremental_qaly_gain <- burden_reference$total_qaly_loss - burden_scenario$total_qaly_loss
  
  # ICER
  icer                  <- incremental_cost / incremental_qaly_gain
  
  # return value
  return(data.frame(incremental_cost      = incremental_cost,
                    incremental_qaly_gain = incremental_qaly_gain,
                    icer                  = icer,
                    reference_label       = unique(burden_reference$scenario_label),
                    scenario_label        = unique(burden_scenario$scenario_label)))
  
}

#
# FUNCTION TO PLOT THE CE PLANE
#
plot_cost_effectiveness_plain <- function(incremental_cost, incremental_qaly_gain, scenario_label){
  
  # get color id, from the scenario label
  plot_color <- as.factor(scenario_label)
  
  plot(x    = incremental_qaly_gain,
       y    = incremental_cost,
       col  = plot_color,
       xlab ='Incremental QALY gain',
       ylab ='Incremental cost (EURO)',
       xlim =c(0,max(incremental_qaly_gain)),
       ylim =c(0,max(incremental_cost)))
  
  legend('bottomright',
         levels(plot_color),
         col = plot_color,
         pch = 1)
  
}

