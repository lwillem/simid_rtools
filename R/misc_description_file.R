#############################################################################
# DESCRIPTION FILE ADMIN
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

#' @title smd_increment_package_version_number
#'
#' @description Check if the git commit number in the DESCRIPTION file still corresponds
#' with the latest git commit number in the repository. If not, update the version and git info
#'
#' @param root_folder the root folder of the software project
#'
#' @export
smd_increment_package_version_number <- function(root_folder = ".") {
  smd_print('FUNCTION smd_increment_package_version_number DEPRECATED!! PLEASE USE smd_update_description_file',warning=T)
  smd_update_description_file(root_folder)
}

#' @title Update the DESCRIPTION file
#'
#' @description Check if the git commit number in the DESCRIPTION file still corresponds
#' with the latest git commit number in the repository. If not, update the version and git info
#'
#' @param root_folder the root folder of the software project
#'
#' @export
smd_update_description_file <- function(root_folder = ".") {

    # set description filename: with or without extension
    description_filename <- dir(root_folder,pattern = "DESCRIPTION",full.names=T)

    # set git log filename
    git_log_filename     <- file.path(root_folder, ".git")

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
        versionParts  <- length(versionNumber)
        vNumberKeep   <- paste(versionNumber[1:(versionParts - 1)], sep = "", collapse = ".")
        vNumberUpdate <- versionNumber[versionParts]

        ## Check if the DESCRIPTION file contains a git commit number
        if (!any(grepl("^PreviousCommit\\:", desc))) {
            # if not present yet, add a placeholder
            desc[length(desc) + 1] <- "PreviousCommit: -1"
        }

        ## Get the DESCRIPTION git commit number
        cLine   <- grep("^PreviousCommit\\:", desc)
        cNumber <- gsub("^PreviousCommit\\: ", "", desc[cLine])

        ## Get the REPOSITORY git commit tag
        cNumber_repo <- smd_get_local_git_commit_tag()

        ## if the git commit tag is different than the one in description: update commit tag & increment version number
        if (cNumber != cNumber_repo) {

            ## Replace old commit tag with the new one
            desc[cLine] <- paste0("PreviousCommit: ", cNumber_repo)

            ## Replace old version number with new one (increment by 1)
            oldVersion <- as.numeric(vNumberUpdate)
            newVersion <- oldVersion + 1

            ## Build final version number
            vFinal <- paste(vNumberKeep, newVersion, sep = ".")

            ## Update DESCRIPTION file (in R)
            desc[vLine] <- paste0("Version: ", vFinal)

            ## Update the actual DESCRIPTION file
            writeLines(desc, description_filename)

            cat("**** updated version number and commit info in DESCRIPTION.txt", fill = T)
            cat(desc[vLine], fill = T)

        } else {
            cat("**** version number OK", fill = T)
        }
    }
}


#' @title Get the local git commit id and date
#'
#' @export
smd_get_local_git_commit_tag <- function(){

  # get the local git log
  gitLog_repo       <- system("git log", intern = TRUE)

  # select the latest commit id
  cLines_repo_id    <- grep("commit", gitLog_repo)
  cNumber_repo_id   <- gsub("commit ", "", gitLog_repo[cLines_repo_id[1]])

  # select the latest commit time stamp
  cLines_repo_date  <- grep("Date:", gitLog_repo)
  cNumber_repo_date <- gsub("Date:   ", "", gitLog_repo[cLines_repo_date[1]])

  # reformat date and time
  cNumber_time <- substr(cNumber_repo_date,12,19)
  cNumber_date <- paste(substr(cNumber_repo_date,1,10), substr(cNumber_repo_date,21,24))
  cNumber_date <- as.Date(cNumber_date,format='%a %h %d %Y')

  # commit index
  cIndex <- length(cLines_repo_date)

  # create an commit tag based in the commit id and time
  commit_id_ext <- paste0(substr(cNumber_repo_id,1,10),
                          ' (#',cIndex,')',
                          ' [',cNumber_date,' ', cNumber_time,']')

  # return the commit tag
  return(commit_id_ext)
}


## PACKAGE ADMIN
# run this function during package building, suppress warnings and errors for end users
try(smd_update_description_file(), silent = T)

