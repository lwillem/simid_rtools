#############################################################################
# FILE PATH ADMIN
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

#############################################################################
# GET FILE PATH (create required folder(s) if they are not present yet)
#############################################################################

#' @title Get (and create) folder path
#' @keywords external
#' @export
smd_file_path <- function(...){

  # get file path based on given parameters
  file_path <- file.path(...)

  # get dirname if file_path contains an extension
  if(grepl('\\.',file_path)){
    file_dir <- dirname(file_path)
  } else{
    file_dir <- file_path
  }

  # check if the requested folder exist, and create the folder(s) if not
  if(!dir.exists(file_dir)){
    smd_print('Create directory:',file_dir)
    dir.create(file_dir,recursive = T)
  }

  return(file_path)
}
