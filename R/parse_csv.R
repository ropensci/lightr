#' Parse csv files
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return details
#'
#' @examples
#' res_csv <- lr_parse_csv(
#'   system.file("testdata", "spec.csv", package = "lightr"),
#' )
#' head(res_csv$data)
#' # No metadata is extracted with this parser
#' res_csv$metadata
#'
#' @importFrom utils read.csv
#'
#' @export
#'

lr_parse_csv <- function(filename, decimal = ".", sep = ",", ...) {
  data <- setNames(
    read.csv(
      filename,
      dec = decimal,
      sep = sep,
      header = FALSE,
      colClasses = "numeric"
    ),
    c("wl", "processed")
  )
  data$dark <- data$white <- data$scope <- NA_real_

  # Reorder columns
  data <- data[, c("wl", "dark", "white", "scope", "processed")]

  metadata <- rep(NA_character_, 13)

  return(list(data = data, metadata = metadata))
}
