% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/misc_description_file.R
\name{smd_update_description_file}
\alias{smd_update_description_file}
\title{Update the DESCRIPTION file}
\usage{
smd_update_description_file(root_folder = ".", misc_info = "")
}
\arguments{
\item{root_folder}{the root folder of the software project}

\item{misc_info}{misc info to complete the description file (e.g. unit test info). Works only with values with a (col)name such as c(test='OK') and is empty by default.}
}
\description{
Check if the git commit number in the DESCRIPTION file still corresponds
with the latest git commit number in the repository. If not, update the version and git info
}
