#' Generic function to parse spectra files that don't have a specific parser
#'
#' @param filename Path of the file to parse
#' @param decimal Character to be used to identify decimal plates
#' (defaults to `.`).
#' @param sep Column delimiting characters to be considered in addition to the
#' default (which are: tab, space, and ";")
#' @param ... ignored
#'
#' @return A named list of two elements:
#'   * `data`: a dataframe with columns "wl", "dark", "white", "scope" and
#'     "processed", in this order.
#'   * `metadata`: a character vector with metadata including:
#'     - `user`: Name of the spectrometer operator
#'     - `datetime`: Timestamp of the recording in format '%Y-%m-%d %H:%M:%S'
#'     and UTC timezone. If timezone is missing in source file, UTC time will
#'     be assumed (for reproducibility purposes across computers with different
#'     localtimes).
#'     - `spec_model`: Model of the spectrometer
#'     - `spec_ID`: Unique ID of the spectrometer
#'     - `white_inttime`: Integration time of the white reference (in ms)
#'     - `dark_inttime`: Integration time of the dark reference (in ms)
#'     - `sample_inttime`: Integration time of the sample (in ms)
#'     - `white_avgs`: Number of averaged measurements for the white reference
#'     - `dark_avgs`: Number of averaged measurements for the dark reference
#'     - `sample_avgs`: Number of averaged measurements for the sample
#'     - `white_boxcar`: Boxcar width for the white reference
#'     - `dark_boxcar`: Boxcar width for the dark reference
#'     - `sample_boxcar`: Boxcar width for the sample reference
#'
#' @details
#' 'processed' column computed by official software and provided as is.
#'
#' @examples
#' res_csv <- lr_parse_generic(
#'   system.file("testdata", "spec.csv", package = "lightr"),
#'   sep = ","
#' )
#' head(res_csv$data)
#' # No metadata is extracted with this parser
#' res_csv$metadata
#'
#' res_craic <- lr_parse_generic(
#'   system.file("testdata", "CRAIC_export.txt", package = "lightr")
#' )
#' head(res_craic$data)
#' # No metadata is extracted with this parser
#' res_craic$metadata
#'
#' @export
#'
lr_parse_generic <- function(filename, decimal = ".", sep = NULL, ...) {
  seps <- paste0("(", paste(c("[[:blank:]]", ";", sep), collapse = "|\\"), ")+")

  # Code from pavo::getspec

  raw <- scan(
    file = filename,
    what = character(),
    quiet = TRUE,
    sep = "\n",
    skipNul = TRUE
  )

  # Convert to ASCII
  raw <- iconv(raw, to = "ASCII", sub = "")

  # Remove extra broken character
  raw <- sub("\001", "", raw, fixed = TRUE)

  # substitute separators for a single value to be used in split
  raw <- gsub(seps, ";", raw)

  # remove split character from first or last occurence
  raw <- gsub("^;|;$", "", raw)

  # convert decimal value to point
  raw <- gsub(decimal, ".", raw, fixed = TRUE)

  # exclude any line that doesn't start with a number
  scinum <- "-?[[:digit:]]+\\.?[[:digit:]]*((E|e)(-|\\+)?[[:digit:]]+)?"
  raw <- raw[grepl(paste0("^", scinum), raw)]

  # split on separators
  rawsplit <- strsplit(raw, ";", fixed = TRUE)

  rawsplit <- do.call(rbind, rawsplit)

  if (is.null(rawsplit) || dim(rawsplit)[2] < 2) {
    stop(
      "Parsing failed.\n",
      "Please a different value for 'sep' argument",
      call. = FALSE
    )
  }

  # convert to numeric, check for NA
  # FIXME: this causes a loss of precision on some platforms, which ultimately
  # results in irreproducibility on noLD platforms
  storage.mode(rawsplit) <- "numeric"

  # remove columns where all values are NAs (due to poor tabulation)
  rawsplit <- rawsplit[, !apply(rawsplit, 2, function(x) all(is.na(x)))]

  metadata <- rep(NA_character_, 13)

  data <- data.frame(
    wl = rawsplit[, 1],
    dark = NA_real_,
    white = NA_real_,
    scope = NA_real_,
    processed = rawsplit[, dim(rawsplit)[2]]
  )

  data <- data[order(data$wl), ]

  return(list(data = data, metadata = metadata))
}
