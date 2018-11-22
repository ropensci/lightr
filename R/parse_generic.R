#' Generic function to parse spectra files that don't have a specific parser
#'
#' @param filename Path of the file to parse
#' @param decimal Decimal separator
#' @param sep Column separator
#'
#' @return A list of two elements:
#'   * a dataframe with columns "wl", "dark", "white", "scope" in that order
#'   * a list with metadata including
#'
#' @export
#'

parse_generic <- function(filename, decimal = ".", sep = NULL) {

  seps <- paste0(c("[[:blank:]]", sep), collapse = "|\\")

  # Code from pavo::getspec

  raw <- scan(
    file = filename, what = character(), quiet = TRUE,
    sep = "\n", skipNul = TRUE
  )
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
  raw <- raw[grepl(paste0("^", scinum, ";"), raw)]

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

  metadata <- rep(NA, 13)

  data <- data.frame("wl" = rawsplit[, 1],
                     "dark" = NA,
                     "white" = NA,
                     "scope" = NA,
                     "processed" = rawsplit[, dim(rawsplit)[2]])

  return(list(data, metadata))
}
