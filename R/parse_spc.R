#' Parse SPC binary file
#'
#' Parse SPC binary file. (Used by CRAIC <http://www.microspectra.com> and
#' OceanInsight <https://www.oceaninsight.com/>)
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return details
#'
#' @section In development:
#' Metadata parsing has not yet been implemented for this file format.
#'
#' @examples
#' lr_parse_spc(system.file("testdata", "compare", "CRAIC", "CRAIC.spc",
#'                          package = "lightr"))
#'
#' @export
#'

lr_parse_spc <- function(filename) {

  f <- file(filename, "rb")
  on.exit(close(f))

  # HEADER (512 bytes)

  # Always 80 4b 00 80?
  skip1 <- readBin(f, "raw", n = 4, endian = "little")

  dat_len <- readBin(f, "integer", n = 1, size = 2, endian = "little")

  skip2 <- readBin(f, "raw", n = 76, endian = "little")

  comment <- readBin(f, "character", n = 1, endian = "little")

  skip3 <- readBin(f, "raw", n = 429, endian = "little")

  # DATA

  wl <- readBin(f, "numeric", n = dat_len, size = 4, endian = "little")

  skip4 <- readBin(f, "raw", n = 32, endian = "little")

  processed <- readBin(f, "numeric", n = dat_len, size = 4, endian = "little")

  data <- as.data.frame(cbind(wl,
                              "dark" = NA,
                              "white" = NA,
                              "scope"= NA,
                              processed))

  metadata <- rep(NA_character_, 13)

  return(list(data, metadata))

}
