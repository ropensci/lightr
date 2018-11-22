#' Convert spectral data files to csv files
#'
#' @param filename name of the file
#'
#' @param overwrite logical. Should the function overwrite existing files with
#' the same name? (defaults to `FALSE`).
#'
#' @section Warning:
#'
#' This step loses all metadata associated to the spectra. This metadata is
#' critical to ensure reproducibility. We recommended you use [getmetadata()] to
#' extract this information from your raw data
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom utils write.csv
#'
#' @export

spec2csv <- function(filename, overwrite = FALSE) {

  data <- dispatch_parser(filename)[[1]]

  csv_name <- paste0(file_path_sans_ext(filename), ".csv")

  if (file.exists(csv_name) && !overwrite) {
    stop(csv_name, " already exists. Select `overwrite = TRUE` to overwrite.")
  }

  write.csv(data, csv_name)

}
