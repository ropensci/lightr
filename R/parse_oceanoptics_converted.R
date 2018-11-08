#' Parse OceanOptics converted file
#'
#' @param filename Path of the ABS, TRM or ROH file
#'
#' @return A list of two elements:
#'   * a dataframe with columns "wl", "dark", "white", "scope" in that order
#'   * a list with metadata including
#'
#' @author Hugo Gruson \email{hugo.gruson+R@@normalesup.org}
#'
parse_oceanoptics <- function(filename) {

}

#' @rdname parse_oceanoptics
parse_jaz <- parse_oceanoptics

#' @rdname parse_oceanoptics
parse_jazirrad <- parse_oceanoptics
