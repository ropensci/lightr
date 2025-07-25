#' Parse Avantes converted file
#'
#' Parse Avantes converted file.
#' <https://www.avantes.com/products/spectrometers/>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return details
#'
#' @examples
#' res_ttt <- lr_parse_avantes_ttt(
#'   system.file("testdata", "avantes_export.ttt", package = "lightr")
#' )
#' head(res_ttt$data)
#' res_ttt$metadata
#'
#' res_trt <- lr_parse_avantes_trt(
#'   system.file("testdata", "avantes_export2.trt", package = "lightr")
#' )
#' head(res_trt$data)
#' res_trt$metadata
#'
#' @export
#'
lr_parse_avantes_ttt <- function(filename, ...) {
  # FIXME: grep to find appropriate lines instead of relying on fixed indices

  content <- readLines(filename, skipNul = TRUE)

  author <- NA_character_

  # nolint start
  # FIXME: from what I understand, this "timestamp" is arbitrary since it
  # represents the 10*microsecond units since last reset and we don't know
  # when last reset occurred
  #
  # savetime <- grep("^Timestamp", content, value = TRUE)
  # savetime <- gsub("^Timestamp \\[.+\\]([[:digit:]]+)$", "\\1", savetime)
  # if (length(savetime)==0) {
  #   savetime <- NA_character_
  # }
  # nolint end
  savetime <- NA_character_

  specmodel <- NA_character_
  inttime <- gsub("^Integration time: ([[:graph:]]+) ms$", "\\1", content[2])
  average <- gsub("^Average: ([[:digit:]]+) scans$", "\\1", content[3])
  boxcar <- gsub("^Nr of pixels used for smoothing: ", "", content[4])

  # The ID is also sometimes included in the first line (comment line) but not
  # always so it's better not to rely on this.
  specID <- gsub("^.*: ([[:alnum:]]{9}).*$", "\\1", content[5])

  # Avantes does not allow different values between measurements
  dark_inttime <- white_inttime <- scope_inttime <- inttime
  dark_average <- white_average <- scope_average <- average
  dark_boxcar <- white_boxcar <- scope_boxcar <- boxcar

  metadata <- c(
    author,
    savetime,
    specmodel,
    specID,
    dark_inttime,
    white_inttime,
    scope_inttime,
    dark_average,
    white_average,
    scope_average,
    dark_boxcar,
    white_boxcar,
    scope_boxcar
  )

  data_ind <- grep("^([[:digit:];.,-])+$", content)
  data <- strsplit(content[data_ind], ";", fixed = TRUE)
  data <- do.call(rbind, data)

  # Fix decimal for non-English files
  data <- gsub(",", ".", data, fixed = TRUE)

  colnames(data) <- strsplit(content[data_ind[1] - 2], ";", fixed = TRUE)[[1]]

  # Remove trailing whitespaces in names
  colnames(data) <- gsub("[[:space:]]*$", "", colnames(data))

  storage.mode(data) <- "numeric"

  cornames <- c(
    wl = "Wave",
    dark = "Dark",
    white = "Ref",
    scope = "Sample",
    processed = "Transmittance"
  )

  data_final <- setNames(
    as.data.frame(matrix(NA_real_, nrow = nrow(data), ncol = 5)),
    names(cornames)
  )

  data_final[match(colnames(data), cornames)] <- data

  return(list(data = data_final, metadata = metadata))
}

#' @rdname lr_parse_avantes_ttt
#'
#' @export
#'
lr_parse_avantes_trt <- lr_parse_avantes_ttt

# Backward compatibility aliases
#' @rdname lr_parse_avantes_ttt
#' @export
lr_parse_ttt <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_ttt()",
    with = "lr_parse_avantes_ttt()"
  )
  lr_parse_avantes_ttt(filename = filename, ...)
}

#' @rdname lr_parse_avantes_ttt
#' @export
lr_parse_trt <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_trt()",
    with = "lr_parse_avantes_trt()"
  )
  lr_parse_avantes_trt(filename = filename, ...)
}
