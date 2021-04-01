#############################################################################
# COPYRIGHT ADMIN
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
# Copyright (C) 2021 lwillem, SIMID, UNIVERSITY OF ANTWERP, BELGIUM
#############################################################################

#' @title Include (C) SIMID in plot
#'
#' @description Add a SIMID copyright statement to the bottom right corner of your figure
#'
#' @param text.cex the size of the text (default = 0.4)
#'
#' @examples
#' # example 1 (default)
#' plot(1)
#' smd_add_copyright()
#'
#' # example 2 (different scales)
#' plot(c(-1e6,1e5),c(1e4,1e5))
#' smd_add_copyright()
#'
#  # example 3 (increase text size)
#' plot(1:10)
#' smd_add_copyright(text.cex = 1)
#'
#' @export
smd_add_copyright <- function(text.cex = 0.4){
  plot_limits <- graphics::par("usr")
  x_value <- plot_limits[2]
  y_value <- plot_limits[3] + diff(plot_limits[3:4])/50
  graphics::text(x = x_value,
                 y = y_value,
                 # labels = ('© UAntwerpen / UHasselt / SIMID '),
                 labels = paste(intToUtf8(169),'UAntwerpen / UHasselt / SIMID '),
                 cex = text.cex,
                 adj = 1,
                 offset = 0.5)
}
