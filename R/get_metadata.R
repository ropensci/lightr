#' Extract metadata from spectra files
#'
#' Finds and imports metadata from spectra files in a given location.
#'
#' @inheritParams lr_get_spec
#'
#' @export
#'
#' @return A data.frame containing one file per row and the following columns:
#'   * `name`: File name (without the extension)
#'   * `user`: Name of the spectrometer operator
#'   * `datetime`: Timestamp of the recording (ISO 8601 format)
#'   * `spec_model`: Model of the spectrometer
#'   * `spec_ID`: Unique ID of the spectrometer
#'   * `white_inttime`: Integration time of the white reference (in ms)
#'   * `dark_inttime`: Integration time of the dark reference (in ms)
#'   * `sample_inttime`: Integration time of the sample (in ms)
#'   * `white_avgs`: Number of averaged measurements for the white reference
#'   * `dark_avgs`: Number of averaged measurements for the dark reference
#'   * `sample_avgs`: Number of averaged measurements for the sample
#'   * `white_boxcar`: Boxcar width for the white reference
#'   * `dark_boxcar`: Boxcar width for the dark reference
#'   * `sample_boxcar`: Boxcar width for the sample reference
#'
#' @inherit lr_get_spec details
#'
#' @section Warning:
#' `white_inttime`, `dark_inttime` and `sample_inttime` should be equal. The
#' normalised data may be inaccurate otherwise.
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom future.apply future_lapply
#' @importFrom progressr with_progress progressor
#'
#' @references White TE, Dalrymple RL, Noble DWA, O'Hanlon JC, Zurek DB,
#' Umbers KDL. Reproducible research in the study of biological coloration.
#' Animal Behaviour. 2015 Aug 1;106:51-7 (\doi{10.1016/j.anbehav.2015.05.007}).
#'
#' @examples
#' \donttest{
#' lr_get_metadata(system.file("testdata", "procspec_files",
#'                             package = "lightr"),
#'                 ext = "ProcSpec")
#' }

lr_get_metadata <- function(where = getwd(), ext = "ProcSpec", sep = NULL,
                            subdir = FALSE, subdir.names = FALSE,
                            ignore.case = TRUE) {

  extension <- paste0("\\.", ext, "$", collapse = "|")

  file_names <- list.files(where,
    pattern = extension, ignore.case = ignore.case,
    recursive = subdir, include.dirs = subdir
  )

  # This step is needed to ensure reproducibility between locales and platforms
  file_names <- sort(file_names, method = "radix")

  nb_files <- length(file_names)

  if (nb_files == 0) {
    warning('No files found. Try a different value for argument "ext".',
            call. = FALSE)
    return(NULL)
  }

  files <- file.path(where, file_names)

  if (!subdir.names) {
    file_names <- basename(file_names)
  }

  specnames <- file_path_sans_ext(file_names)

  message(nb_files, " files found; importing metadata:")

  gmd <- function(ff) {

    dispatch_parser(ff, sep = sep)[[2]]

  }

  with_progress({
    p <- progressor(along = files)
    tmp <- future_lapply(files, function(x) {
      p()
      tryCatch(
        gmd(x),
        error = function(e) {
          warning(conditionMessage(e), call. = FALSE)
          return(NULL)
        })
    })
  })

  whichfailed <- which(vapply(tmp, is.null, logical(1)))

  if (length(whichfailed) == nb_files) {
    warning("File import failed.\n",
            "Check input files and function arguments.", call. = FALSE)
    return(NULL)
  } else if (length(whichfailed) > 0) {

    warning(
      "Could not import one or more files:\n",
      paste(files[whichfailed], collapse = "\n"),
      call. = FALSE
    )

    specnames <- specnames[-whichfailed]
  }

  res <- as.data.frame(do.call(rbind, tmp), stringsAsFactors = FALSE)

  res <- cbind(specnames, res, stringsAsFactors = FALSE)

  colnames(res) <- c(
    "name", "user", "datetime", "spec_model", "spec_ID",
    paste(c("white", "dark", "sample"), "inttime", sep = "_"),
    paste(c("white", "dark", "sample"), "avgs", sep = "_"),
    paste(c("white", "dark", "sample"), "boxcar", sep = "_")
  )

  res[, 6:14] <- vapply(res[, 6:14], as.numeric, numeric(nrow(res)))
  res$datetime <- as.POSIXct(res$datetime, tz = "UTC")

  return(res)
}
