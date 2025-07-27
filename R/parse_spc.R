#' Parse SPC binary file
#'
#' Parse SPC binary file. (Used by CRAIC <https://www.microspectra.com/> and
#' OceanOptics <https://www.oceanoptics.com/>)
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return details
#'
#' @section In development:
#' Metadata parsing has not yet been implemented for this file format.
#'
#' @examples
#' res <- lr_parse_craic_spc(
#'   system.file(
#'     "testdata", "compare", "CRAIC", "CRAIC.spc",
#'     package = "lightr"
#'   )
#' )
#' head(res$data)
#' res$metadata
#'
#' @export
#'

lr_parse_craic_spc <- function(filename, ...) {
  f <- file(filename, "rb")
  on.exit(close(f))

  # specification
  # https://docs.c6h6.org/docs/assets/files/spc-3bb9ec9e4c158c5418bcfcc970be77f1.pdf

  # HEADER (512 bytes)
  filetype <- readBin(
    f,
    "integer",
    n = 1,
    size = 1,
    signed = FALSE,
    endian = "little"
  )
  spc_file_version <- readBin(f, "raw", n = 1, endian = "little")
  experiment_type <- readBin(f, "raw", n = 1, endian = "little")
  exponent_y_values <- readBin(f, "raw", n = 1, endian = "little")

  dat_len <- readBin(f, "integer", n = 1, size = 4, endian = "little")

  firstx <- readBin(f, "double", n = 1, size = 8, endian = "little")
  firsty <- readBin(f, "double", n = 1, size = 8, endian = "little")

  number_subfiles <- readBin(f, "integer", n = 1, size = 4, endian = "little")

  xunits_type_code <- readBin(f, "raw", n = 1, endian = "little")
  yunits_type_code <- readBin(f, "raw", n = 1, endian = "little")
  zunits_type_code <- readBin(f, "raw", n = 1, endian = "little")

  posting_disposition <- readBin(f, "raw", n = 1, endian = "little")

  compressed_date <- readBin(f, "integer", size = 4, endian = "little")

  resolution_description_text <- readBin(f, "raw", n = 9, endian = "little")
  source_instrument_description <- readBin(f, "raw", 9, endian = "little")

  peak_point_number <- readBin(f, "raw", n = 2, endian = "little")
  spare <- readBin(f, "double", n = 8, size = 4, endian = "little")

  # SPC from CRAIC contains additional info here. But not those from OceanOptics
  comment <- intToUtf8(readBin(f, "raw", n = 130, endian = "little"))
  custom_axis_strings <- intToUtf8(readBin(f, "raw", 30, endian = "little"))

  byte_offset_to_log_block <- readBin(f, "integer", size = 4, endian = "little")
  file_modification_flag <- readBin(f, "integer", size = 4, endian = "little")

  processing_code <- readBin(f, "raw", endian = "little")
  calibration_level <- readBin(f, "raw", endian = "little")

  submethod_sample <- readBin(f, "raw", n = 2, endian = "little")
  concentration__multiplier <- readBin(
    f,
    "double",
    size = 4,
    endian = "little"
  )

  method_file <- intToUtf8(readBin(f, "raw", n = 47, endian = "little"))

  z_subfile_increment <- readBin(f, "double", size = 4, endian = "little")
  w_plane_number <- readBin(f, "integer", size = 4, endian = "little")
  w_plane_increment <- readBin(f, "double", size = 4, endian = "little")
  w_axis_unit_code <- readBin(f, "raw", n = 2, endian = "little")

  skip <- readBin(f, "raw", n = 187, endian = "little")

  # DATA

  wl <- readBin(f, "numeric", n = dat_len, size = 4, endian = "little")

  skip4 <- readBin(f, "raw", n = 32, endian = "little")

  processed <- readBin(f, "numeric", n = dat_len, size = 4, endian = "little")

  data <- cbind(
    wl,
    dark = NA_real_,
    white = NA_real_,
    scope = NA_real_,
    processed
  )

  metadata <- c(
    NA_character_,
    uncompress_spc_date(compressed_date),
    rep(NA_character_, 11)
  )

  return(list(data = as.data.frame(data), metadata = metadata))
}

#' @rdname lr_parse_craic_spc
#' @export
lr_parse_oceanoptics_spc <- lr_parse_craic_spc


