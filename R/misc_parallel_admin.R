############################################################################ #
# PARALLEL ADMIN
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright (C) 2023 lwillem, SIMID, UNIVERSITY OF ANTWERP, BELGIUM
############################################################################ #
#' @import doParallel
#' @import parallel
#' @import foreach
#' @import iterators
#' @import ps


############################################################### #
## START CLUSTER WITH PARALLEL WORKERS ----
############################################################### #
#' @title Start parallel working nodes
#' @param timeout The time-out in seconds for the nodes
#' @param num_proc The number of parallel workers to start (NA = default, number of CPU cores)
#' @return Cluster info, also available as global variable 'par_nodes_info'
#' @keywords external
#' @export
#' @note Explicitly setup the PSOCK cluster using the 'sequential' setup strategy, to prevent an error in RStudio on macOS with R 4.0.x (https://github.com/rstudio/rstudio/issues/6692)
smd_start_cluster <- function(timeout = 100, num_proc = NA)
{
  smd_print("START PARALLEL WORKERS")

  if(is.na(num_proc)){
    num_proc <- detectCores()
  }

  # check num_proc max and min... and use default if needed
  if(num_proc > detectCores() || num_proc < 1){
    smd_print(paste0("Requested number workers in 'smd_start_cluster()' (=",num_proc,") is not valid, so the number of CPU cores (=",detectCores(),") is used."),WARNING = T)
    num_proc <- detectCores()
  }

  # CREATE GLOBAL VARIABLE
  .GlobalEnv$par_nodes_info <- list(pid_master  = Sys.getpid())

  ## SETUP PARALLEL NODES
  # note: they will be removed after 100 seconds inactivity
  par_cluster   <- makeCluster(num_proc, cores=num_proc, timeout = timeout, setup_strategy = "sequential")
  registerDoParallel(par_cluster)

  # store the process id (pid) of the first slave
  pid_slave1 <- clusterEvalQ(par_cluster, { Sys.getpid() })[[1]]

  # update global variable
  .GlobalEnv$par_nodes_info$par_cluster <- par_cluster
  .GlobalEnv$par_nodes_info$pid_slave1  <- pid_slave1
  .GlobalEnv$par_nodes_info$time_stamp  <- Sys.time()

  return(par_nodes_info)
}


############################################################### #
## STOP CLUSTER WITH PARALLEL WORKERS ----
############################################################### #
#' @title Stop parallel working nodes (if still active)
#' @keywords external
#' @export
smd_stop_cluster <- function()
{
  ## check if global variable of existing working nodes is present
  if(exists('par_nodes_info')){

    # check if parallel workers still exist (i.e. not removed after inactivity)
    if(par_nodes_info$pid_slave1 %in% ps()$pid){
      smd_print("STOP PARALLEL WORKERS")
      stopCluster(par_nodes_info$par_cluster);
    }
    # remove global variable
    rm(par_nodes_info, envir = .GlobalEnv)
  }
}

############################################################### #
## CHECK IF CLUSTER EXISTS AND START ONE IF NOT PRESENT----
############################################################### #
#' @title Check parallel working nodes
#'
#' @description Verify whether a parallel cluster is active and start one if not. The check is based
#' on the presence of the global variable 'par_nodes_info'. If a parallel cluster is already active,
#' the time stamp in 'par_nodes_info' is updated
#'
#' @return Cluster info
#' @export
smd_check_cluster <- function()
{
  if(!exists('par_nodes_info')){
    smd_start_cluster()
  } else if (!any(grepl(par_nodes_info$pid_slave1,ps()$pid))){
    smd_start_cluster()
  }

  # update the time stamp
  .GlobalEnv$par_nodes_info$time_stamp  <- Sys.time()

  # return par_nodes_info
  return(par_nodes_info)
}
