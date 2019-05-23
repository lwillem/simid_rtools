#############################################################################
# LOAD (AND INSTALL) PACKAGES
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

#' @title Load the given packages (and install them if not present yet)
#'
#' @param all_packages  container with package names to load
#' @keywords external
#' @export
smd_load_packages <- function(all_packages)
{

  # load the doParallel package seperatly so we can use 'all_packages' in a parallel foreach
  all_packages_with_parallel <- c(all_packages,'doParallel')

  # loop over the packages
  for(package_i in all_packages_with_parallel){

    # if not present => install
    if(!package_i %in% rownames(installed.packages())){
      install.packages(package_i)
    }

    # load package
    library(package_i,
            character.only=TRUE,
            quietly = TRUE,
            warn.conflicts = FALSE,
            verbose = FALSE)
  }

}

