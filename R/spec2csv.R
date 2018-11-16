#' @importFrom tools file_path_sans_ext

spec2csv <- function(filename, overwrite = FALSE) {

  data <- dispatch_parser(filename))[[1]]

  csv_name <- paste0(file_path_sans_ext(filename), ".csv")

  if (file.exists(csv_name) && !overwrite) {
    stop(csv_name, " already exists. Select `overwrite = TRUE` to overwrite.")
  }

  write.csv(data, csv_name)

}
