#' Parse CRAIC binary file
#'
#' Parse CRAIC binary file. <http://www.microspectra.com>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return
#'
#' @examples
#' lr_parse_spc(system.file("testdata", "compare", "CRAIC", "CRAIC.spc",
#'                          package = "lightr"))
#'
#' @export
#'

lr_parse_spc <- function(filename) {

  f <- file(filename, "rb")

  skip <- readBin(f, "raw", n = 512, endian = "little")

  comment <- rawToChar(skip[89:166])

  wl <- readBin(f, "numeric", n = 3761, size = 4, endian = "little")

  skip2 <- readBin(f, "raw", n = 32, endian = "little")

  processed <- readBin(f, "numeric", n = 3761, size = 4, endian = "little")

  data <- as.data.frame(cbind(wl,
                              "dark" = NA,
                              "white" = NA,
                              "scope"= NA,
                              processed))

  metadata <- rep(NA, 13)

  return(list(data, metadata))

}
