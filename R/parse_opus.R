#' Parse Brucker OPUS binary file
#'
#' Parse Brucker OPUS binary file (.0, .1, .2, etc. file
#' extensions).
#' <https://www.bruker.com/en/products-and-solutions/infrared-and-raman/opus-spectroscopy-software.html>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return
#'
#' @importFrom stats setNames
#'
#' @examples
#' res_trm <- lr_parse_brucker_opus(
#'   system.file("testdata", "i1_sc.0", package = "lightr")
#' )
#' head(res_trm$data)
#' res_trm$metadata
#'
#' @export
#'
lr_parse_brucker_opus <- function(filename, ...) {
  f <- file(filename, "rb")
  on.exit(close(f))

  # Header: 504 bytes
  magic_number <- readBin(f, "raw", n = 4)

  skip <- readBin(f, "raw", n = 20)

  # At this stage, we have 480 bytes left in the header.
  # Each block desc is 12 bytes long.
  # So we have at most 40 blocks.
  block_index <- as.data.frame(matrix(nrow = 40, ncol = 5))
  colnames(block_index) <- c(
    "data_type",
    "channel_type",
    "text_type",
    "block_size",
    "offset"
  )
  for (i in seq_len(nrow(block_index))) {
    block_index$data_type[i] <- readBin(f, "integer", 1, 1, signed = FALSE)
    block_index$channel_type[i] <- readBin(f, "integer", 1, 1, signed = FALSE)
    block_index$text_type[i] <- readBin(f, "integer", 1, 1, signed = FALSE)
    skip <- readBin(f, "raw", n = 1)
    block_index$block_size[i] <- readBin(f, "integer", 1, 4, endian = "little")
    block_index$offset[i] <- readBin(f, "integer", 1, 4, endian = "little")
  }

  # Ref = data_type 11

  # Data = data_type 7

  return(list(data = data, metadata = metadata))
}
