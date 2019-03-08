#############################################################################
# PACKAGE ADMIN
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

#########################
## PACKAGE NAME        ##
#########################
#' simid.rtools: Extended R functions.
#
#' @author  Lander Willem [lander.willem@uantwerpen.be]
#' @docType package
#' @name simid.rtools
#' @keywords internal
#'

## PACKAGE ADMIN
#usethis::use_build_ignore("tutorials")
#usethis::use_gpl3_license("lwillem")
NULL


#############################
## PACKAGE VERION NUMBER   ##
#############################
#' @title Update the version number in DESCRIPTION
#'
#' @description Increment the version number if the git commit number in the DESCRIPTION file does not correspond with the latest git commit number in the repository.
#'
#' @param packageLocation the location of the package.
#'
#' @keywords internal
#'
increment_package_version_number <- function(packageLocation = ".") {

  description_filename <- file.path(packageLocation, "DESCRIPTION")
  git_log_filename <- file.path(packageLocation, ".git")

  # check if files exists
  if (file.exists(description_filename) & file.exists(git_log_filename)) {
    ## Read DESCRIPTION file
    desc <- readLines(description_filename)

    ## Find the line where the version is defined
    vLine <- grep("^Version\\:", desc)

    ## Extract version number
    vNumber <- gsub("^Version\\:\\s*", "", desc[vLine])

    ## Split the version number into two; a piece to keep, a piece to increment
    versionNumber <- strsplit(vNumber, "\\.")[[1]]
    versionParts <- length(versionNumber)
    vNumberKeep <- paste(versionNumber[1:(versionParts - 1)], sep = "", collapse = ".")
    vNumberUpdate <- versionNumber[versionParts]

    ## Check if the DESCRIPTION file contains a git commit number
    if (!any(grepl("^Commit\\:", desc))) {
      # if not present yet, add a placeholder
      desc[length(desc) + 1] <- "Commit: -1"
    }

    ## Get the DESCRIPTION git commit number
    cLine   <- grep("^Commit\\:", desc)
    cNumber <- gsub("^Commit\\: ", "", desc[cLine])

    ## Get the REPOSITORY git commit number
    gitLog_repo  <- system("git log", intern = TRUE)
    cLines_repo  <- grep("commit", gitLog_repo)
    cNumber_repo <- gsub("commit ", "", gitLog_repo[cLines_repo[1]])

    ## if the git commit number is different than the one in description - update commit number - increment version number
    if (cNumber != cNumber_repo) {

      ## Replace old commit number with the new one
      desc[cLine] <- paste0("Commit: ", cNumber_repo)

      ## Replace old version number with new one (increment by 1)
      oldVersion <- as.numeric(vNumberUpdate)
      newVersion <- oldVersion + 1

      ## Build final version number
      vFinal <- paste(vNumberKeep, newVersion, sep = ".")

      ## Update DESCRIPTION file (in R)
      desc[vLine] <- paste0("Version: ", vFinal)

      ## Update the actual DESCRIPTION file
      writeLines(desc, file.path(packageLocation, "DESCRIPTION"))

      cat("**** updated version number and commit in DESCRIPTION", fill = T)
      cat(desc[vLine], fill = T)

    } else {
      cat("**** version number OK", fill = T)
    }
  }
}


# run this function during package building, suppress warnings and errors for end users
try(increment_package_version_number(), silent = T)

