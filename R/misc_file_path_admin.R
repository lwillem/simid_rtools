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
# GET OUTPUT FOLDER PATH (create folder(s) if not present yet)
#############################################################################

#' @title Get (and create) folder path
#' @keywords external
#' @export
smd_file_path <- function(...){

  output_folder <- file.path(...)

  # check if the output folder exist, and create the folder(s) if not
  if(!dir.exists(output_folder)){
    smd_print('Create folder:',output_folder)
    dir.create(output_folder,recursive = T)
  }

  return(output_folder)
}

