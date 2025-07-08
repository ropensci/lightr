#' Convert spectral data files to csv files
#'
#' @param overwrite logical. Should the function overwrite existing files with
#' the same name? (defaults to `FALSE`).
#' @param metadata logical (defaults to `TRUE`). Should metadata be exported as
#' well? They will be exported in csv files will the `_metadata.csv` suffix.
#'
#' @inheritParams lr_get_spec
#'
#' @inherit lr_get_spec details
#'
#' @return Convert input files to csv and invisibly return the list of created
#' file paths
#'
#' @section Warning:
#'
#' When `metadata = TRUE`, if **either** the data **or** metadata export fails,
#' nothing will be returned for this file.
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom utils write.csv
#' @importFrom future.apply future_lapply
#' @importFrom progressr with_progress progressor
#'
#' @export
lr_convert_tocsv <- function(
  where = NULL,
  ext = "txt",
  decimal = ".",
  sep = NULL,
  subdir = FALSE,
  ignore.case = TRUE,
  overwrite = FALSE,
  metadata = TRUE
) {
  if (is.null(where)) {
    warning(
      "Please provide a valid location to read and write the files.",
      call. = FALSE
    )
    return(NULL)
  }

  extension <- paste0("\\.", ext, "$", collapse = "|")

  file_names <- list.files(
    where,
    pattern = extension,
    ignore.case = ignore.case,
    recursive = subdir,
    include.dirs = subdir
  )
  nb_files <- length(file_names)

  if (nb_files == 0) {
    warning(
      'No files found. Try a different value for argument "ext".',
      call. = FALSE
    )
    return(NULL)
  }

  files <- file.path(where, file_names)

  message(nb_files, " files found")

  with_progress({
    p <- progressor(along = files)
    tmp <- future_lapply(files, function(x) {
      p()
      tryCatch(
        spec2csv_single(
          x,
          decimal = decimal,
          sep = sep,
          overwrite = overwrite,
          metadata = metadata
        ),
        error = function(e) {
          warning(conditionMessage(e), call. = FALSE)
          return(NULL)
        }
      )
    })
  })

  whichfailed <- which(vapply(tmp, is.null, logical(1)))

  if (length(whichfailed) == nb_files) {
    warning(
      "File import failed.\n",
      "Check input files and function arguments.",
      call. = FALSE
    )
    return(NULL)
  }

  if (length(whichfailed) > 0) {
    warning(
      "Could not import one or more files:\n",
      paste(files[whichfailed], collapse = "\n"),
      call. = FALSE
    )
  }

  invisible(unlist(tmp))
}

#' @noRd
spec2csv_single <- function(filename, decimal, sep, overwrite, metadata) {
  exported <- dispatch_parser(filename, decimal = decimal, sep = sep)

  csv_name_data <- paste0(file_path_sans_ext(filename), ".csv")
  csv_name_metadata <- paste0(file_path_sans_ext(filename), "_metadata.csv")

  if (file.exists(csv_name_data) && !overwrite) {
    stop(
      csv_name_data,
      " already exists. Select `overwrite = TRUE` to overwrite.",
      call. = FALSE
    )
  }
  if (metadata && file.exists(csv_name_metadata) && !overwrite) {
    stop(
      csv_name_metadata,
      " already exists. Select `overwrite = TRUE` to overwrite.",
      call. = FALSE
    )
  }

  write.csv(exported[[1]], csv_name_data, row.names = FALSE)
  write.csv(exported[[2]], csv_name_metadata, row.names = FALSE)

  invisible(csv_name_data)
}
