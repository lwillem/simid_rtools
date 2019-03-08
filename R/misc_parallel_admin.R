#############################################################################
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
# Copyright (C) 2019 lwillem, SIMID, UNIVERSITY OF ANTWERP, BELGIUM
#############################################################################
#' @import doParallel
#' @import parallel
#' @import foreach
#' @import iterators


################################################################
## START CLUSTER WITH PARALLEL WORKERS
################################################################
#' @title Start parallel working nodes
#' @keywords external
#' @export
smd_start_cluster <- function()
{
  smd_print("START PARALLEL WORKERS")

  ## SETUP PARALLEL NODES
  # note: they will be removed after 280 seconds inactivity
  num_proc      <- detectCores()
  par_cluster   <- makeCluster(num_proc, cores=num_proc, timeout = 600)
  registerDoParallel(par_cluster)

  # store the process id (pid) of the first slave
  pid_slave1 <- clusterEvalQ(par_cluster, { Sys.getpid() })[[1]]

  # CREATE GLOBAL VARIABLE
  par_nodes_info <<- list(par_cluster = par_cluster,
                          pid_master  = Sys.getpid(),
                          pid_slave1  = pid_slave1)

}

################################################################
## STOP CLUSTER WITH PARALLEL WORKERS
################################################################
#' @title Stop parallel working nodes
#' @keywords external
#' @export
smd_stop_cluster <- function()
{
  ## CLOSE NODES AND NODE INFO
  if(exists('par_nodes_info')){
    smd_print("STOP PARALLEL WORKERS")

    stopCluster(par_nodes_info$par_cluster);
    rm(par_nodes_info,envir = .GlobalEnv) # REMOVE GLOBAL VARIABLE

  }
}

################################################################
## CHECK IF CLUSTER EXISTS AND START ONE IF NOT
################################################################
#' @title Check parallel working nodes
#' @keywords internal
smd_check_cluster <- function(){
  if(!exists('par_nodes_info')){
    smd_start_cluster()
  } else if (!any(grepl(par_nodes_info$pid_slave1,system('ps -A',intern = T)))){
    smd_start_cluster()
  }
}
