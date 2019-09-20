#############################################################################
# METADATA FILE CREATION AND MANIPULATION
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


#' @title Create a text file with metadata
#'
#' @description Create a file with metadata on e.g. current software state, run info, and other info.
#'
#' @param output_dir  the directory where the new file should be created
#' @param run_tag     the tag to specify the model run (optional)
#' @param run_time    the run time (optional)
#' @param root_dir    the root directory, with a DESCRIPTION OR METADATA file to start from (default = '.')
#' @param other_info  additional info to include in the metafile (optional)
#'
#' @export
smd_create_metadata_file <- function(output_dir, file_prefix = '', run_tag = NA,
                                     run_time = NA, root_dir = '.', other_info = NA){

  # set default metadata filename
  metadata_filename <- "METADATA.txt"

  # add prefix, if given
  if(nchar(file_prefix)>0){
    metadata_filename <-  paste(file_prefix,metadata_filename,sep='_')
  }

  # set full metadata filename with output directory
  metadata_filename  <- smd_file_path(output_dir,metadata_filename)

  # look for a METADATA file in the root folder
  source_filename      <- dir(root_dir,pattern = "METAFILE",full.names=T)

  # else, look for a DESCRIPTION file in the root folder
  if(length(source_filename)==0){
    source_filename      <- dir(root_dir,pattern = "DESCRIPTION",full.names=T)
  }

  # if present, load source file with version number, software info and commit id
  # else, start from scratch
  if(length(source_filename)==1){
    metadata <- readLines(source_filename)
  } else{
    metadata <- 'METADATA'
  }

  # add blank line
  metadata <- c(metadata,'','--------------------','')

  # if provided, add run tag
  if(!is.na(run_tag)){
    metadata <- c(metadata,paste('Run_tag:\t',run_tag))
  }

  # if provided, add run time
  if(!is.na(run_time)){
    metadata <- c(metadata,paste('Run_time:\t',run_time))
  }

  # add current date and some environment variables
  metadata <- c(metadata,
            paste('Run_date:\t',format(Sys.time())),
            paste('Run_R_version:\t',sessionInfo()$R.version$version.string),
            paste('Run_platform:\t',sessionInfo()$platform),
            paste('Run_workdir:\t',getwd())
  )

  # create the METADATA file in the output directory
  writeLines(metadata, metadata_filename)
}


