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

  # HEADER (512 bytes)

  skip1 <- readBin(f, "raw", n = 4, endian = "little")

  dat_len <- readBin(f, "integer", n = 1, size = 8, endian = "little")

  skip2 <- readBin(f, "raw", n = 500, endian = "little")

  comment <- rawToChar(skip2[77:154])

  # DATA

  wl <- readBin(f, "numeric", n = dat_len, size = 4, endian = "little")

  skip2 <- readBin(f, "raw", n = 32, endian = "little")

  processed <- readBin(f, "numeric", n = dat_len, size = 4, endian = "little")

  data <- as.data.frame(cbind(wl,
                              "dark" = NA,
                              "white" = NA,
                              "scope"= NA,
                              processed))

  metadata <- rep(NA_character_, 13)

  return(list(data, metadata))

}
