#' Generic function to parse spectra files that don't have a specific parser
#'
#' @param filename Path of the file to parse
#' @param decimal Character to be used to identify decimal plates
#' (defaults to `.`).
#' @param sep Column delimiting characters to be considered in addition to the
#' default (which are: tab, space, and ";")
#'
#' @return A list of two elements:
#'   * a dataframe with columns "wl", "dark", "white", "scope" and "processed",
#'     in that order
#'   * a character vector with metadata including:
#'     - `user`: Name of the spectrometer operator
#'     - `date`: Timestamp of the recording
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
#' lr_parse_generic(system.file("testdata", "spec.csv", package = "lightr"),
#'                  sep = ",")
#' lr_parse_generic(system.file("testdata", "CRAIC_export.txt",
#'                              package = "lightr"))
#'
#' @export
#'

lr_parse_generic <- function(filename, decimal = ".", sep = NULL) {

  seps <- paste0(c("[[:blank:]]", sep), collapse = "|\\")

  # Code from pavo::getspec

  raw <- scan(
    file = filename, what = character(), quiet = TRUE,
    sep = "\n", skipNul = TRUE
  )

  # Convert to ASCII
  raw <- iconv(raw, to = "ASCII", sub = "")

  # Remove extra broken character
  raw <- gsub("\\\001", "", raw)

  # substitute separators for a single value to be used in split
  raw <- gsub(seps, ";", raw)

  # remove multiply occuring split character
  raw <- gsub(";+", ";", raw)

  # remove split character from first or last occurence
  raw <- gsub("^;|;$", "", raw)

  # convert decimal value to point
  raw <- gsub(decimal, ".", raw, fixed = TRUE)

  # exclude any line that doesn't start with a number
  scinum <- "-?[[:digit:]]+\\.?[[:digit:]]*((E|e)(-|\\+)?[[:digit:]]+)?"
  raw <- raw[grepl(paste0("^", scinum), raw)]

  # split on separators
  rawsplit <- strsplit(raw, ";")

  rawsplit <- do.call(rbind, rawsplit)

  if (dim(rawsplit)[2] < 2) {
    stop('Parsing failed.\n',
         'Please a different value for "sep" argument', call. = FALSE)
  }

  # convert to numeric, check for NA
  class(rawsplit) <- "numeric"

  # remove columns where all values are NAs (due to poor tabulation)
  rawsplit <- rawsplit[, !apply(rawsplit, 2, function(x) all(is.na(x)))]

  metadata <- rep(NA_character_, 13)

  data <- data.frame("wl" = rawsplit[, 1],
                     "dark" = NA_real_,
                     "white" = NA_real_,
                     "scope" = NA_real_,
                     "processed" = rawsplit[, dim(rawsplit)[2]])

  return(list(data, metadata))
}
