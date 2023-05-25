#############################################################################
# COMMAND LINE INTERFACE TOOLS
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
#############################################################################

#' @title Print (warning) message to Console
#'
#' @description Command line interface: print message with time tag if called
#' by the master node or first parallel slave
#'
#' @param ... (parts of the) message to print
#' @param WARNING  boolean, to print the message in red
#' @param FORCED   boolean, to print the message regardless of the parallel thread
#'
#' @export
smd_print <- function(..., WARNING=F, FORCED=F) {

  # get function arguments
  function_arguments <- as.list(match.call(expand.dots=FALSE))$...

  # get function-call environment (to retrieve variable from that environment)
  pf <- parent.frame()

  #parse list => make character vector
  f_out <- ' '
  for(i in 1:length(function_arguments)){
    f_out <- cbind(f_out,eval(unlist(function_arguments[[i]]),envir = pf))
  }

  # add a space to each function arguments
  function_arguments <- paste(f_out,collapse = ' ')

  # set text color: default (black/white) or red (warning)
  text_color         <- smd_get_console_color(WARNING)

  # print time + arguments (without spaces)
  cli_out <- paste0(c('echo "',text_color, '[',format(Sys.time(),'%H:%M:%S'),']',
                      function_arguments,'"'),collapse = '')

  # print if function is called by master-node or first slave
  if(!exists('par_nodes_info') ||
     any(is.na(par_nodes_info)) ||
     Sys.getpid() == par_nodes_info$pid_master ||
     FORCED){
      system(cli_out)
  }

  # add to R warnings
  if(WARNING){
    cli_warning <- paste0(c(text_color, '[',format(Sys.time(),'%H:%M:%S'),']',
                            function_arguments),collapse = '')
    warning(cli_warning,
            call. = FALSE, immediate.=FALSE)
  }
}


#' @title Print progress to the terminal
#'
#' @description Display the progress of an iteration to the terminal, including the current time, the current
#' step, and a rough estimate of the remaining time. If this function is called in a parallel
#' environment, only the master and the first node will print the progress. Otherwise, the progress of
#' every iteration will be printed. If no 'time_stamp_loop' is provided, the creation time (or last update time)
#' of the parallel cluster will be used as the reference time.
#'
#' @param i_current       Current iteration number.
#' @param i_total         Total number of iterations.
#' @param time_stamp_loop Starting time of the iteration. The default is the time stamp included in the 'par_nodes_info'. If the latter is also not available, no time estimation is provided.
#' @param par_nodes_info  Information about parallel workers, including the process ID and the time of creation or the last update of the parallel cluster. If not given, the variable 'par_nodes_info' from the parent environment will be used.
#'
#' @export
smd_print_progress <- function(i_current, i_total, time_stamp_loop = NULL, par_nodes_info = parent.env(environment())$par_nodes_info) {

  if(any(is.null(par_nodes_info))){
    par_nodes_info <- NA
  }

  if (is.null(time_stamp_loop) && !any(is.na(par_nodes_info))){
      time_stamp_loop <- as.POSIXct(par_nodes_info$time_stamp)
    }

  # Print if the function is called by the first node or when called in the absence of parallel nodes
  if (any(is.na(par_nodes_info)) || (Sys.getpid() == par_nodes_info$pid_master || Sys.getpid() == par_nodes_info$pid_slave1)) {

    # Estimate remaining time, if possible
    time_label <- ''
    if (!is.null(time_stamp_loop)) {

      # Calculate progress
      progress_scen <- floor(i_current / i_total * 100)
      progress_time <- round(difftime(Sys.time(), time_stamp_loop, units = "min"), digits = 1)

      # print remaining time after 15%
      if (progress_time > 0 & progress_scen > 15 & progress_scen < 99) {
        estim_time <- round(progress_time / progress_scen * (100 - progress_scen), digits = 1)
        if (estim_time < 1) estim_time <- '<1'
        time_label <- paste0('[', estim_time, ' min remaining]')
      }
    }
    smd_print('RUNNING...', i_current, '/', i_total, time_label, FORCED = TRUE)
  }
}




#' @title Print progress bar [DEPRECATED]
#'
#' @param i_current       current iteration
#' @param i_total         total iterations
#' @param time_stamp_loop starting time
#' @param par_nodes_info  info about parallel nodes
#'
#' @description please use smd_print_progress()
#' @export
smd_progress <- function(i_current,i_total, time_stamp_loop = Sys.time(),par_nodes_info = NA){

  smd_print('PLEASE USE smd_print_progress() insead of smd_progress()',WARNING = T)

}

#' @title Get default Rstudio console color
#'
#' @description The default color of the console (or terminal) depends on whether Rstudio
#' is used in DARK mode. This function return 'black' or 'white', based on the current theme.
#' If the function is used in R, an empty color is returned.
#'
#' @keywords internal
smd_get_console_color <- function(WARNING=FALSE){

  if(!rstudioapi::isAvailable()){
    return('')
  }

  if(WARNING){
    return('\033[0;31m') #red
  }

  if(rstudioapi::getThemeInfo()$dark){
    return('\033[0;37m') # white
  } else{
    return('\033[0;30m') # black
  }

}
