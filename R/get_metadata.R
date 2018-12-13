#' Extract metadata from spectra files
#'
#' Finds and imports metadata from spectra files in a given location.
#'
#' @inheritParams get_spec
#'
#' @export
#'
#' @return A data.frame containing one file per row and the following columns:
#'   * `name`: File name (without the extension)
#'   * `user`: Name of the spectrometer operator
#'   * `date`: Timestamp of the recording
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
#' @section Warning:
#' `white_inttime`, `dark_inttime` and `sample_inttime` should be equal. The
#' normalised data may be inaccurate otherwise.
#'
#' @importFrom pbmcapply pbmclapply
#' @importFrom tools file_path_sans_ext
#'
#' @references White TE, Dalrymple RL, Noble DWA, O'Hanlon JC, Zurek DB,
#' Umbers KDL. Reproducible research in the study of biological coloration.
#' Animal Behaviour. 2015 Aug 1;106:51–7 (\doi{10.1016/j.anbehav.2015.05.007}).
#'
#' @examples
#' get_metadata(system.file("testdata", package = "lightr"), ext = "ProcSpec",
#'              subdir = TRUE)

get_metadata <- function(where = getwd(), ext = "ProcSpec", sep = NULL,
                         subdir = FALSE, subdir.names = FALSE,
                         cores = getOption("mc.cores", 2L),
                         ignore.case = TRUE) {

  extension <- paste0("\\.", ext, "$", collapse = "|")

  file_names <- list.files(where,
    pattern = extension, ignore.case = ignore.case,
    recursive = subdir, include.dirs = subdir
  )
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

  if (cores > 1 && .Platform$OS.type == "windows") {
    cores <- 1L
    message('Parallel processing not available in Windows; "cores" set to 1.\n')
  }

  gmd <- function(ff) {

    df <- dispatch_parser(ff, sep = sep)[[2]]

  }

  tmp <- pbmclapply(files, function(x)
    tryCatch(gmd(x),
             error = function(e) NULL
    ), mc.cores = cores)

  if (any(unlist(lapply(tmp, is.null)))) {
    whichfailed <- which(unlist(lapply(tmp, is.null)))
    if (length(whichfailed) == nb_files) {
      warning("File import failed.\n",
              "Check input files and function arguments.", call. = FALSE)
      return()
    }

    warning("Could not import one or more files:\n",
            paste0(files[whichfailed], "\n"),
            call. = FALSE
    )

    specnames <- specnames[-whichfailed]
  }

  res <- as.data.frame(do.call(rbind, tmp), stringsAsFactors = FALSE)

  res <- cbind(specnames, res)

  colnames(res) <- c(
    "name", "user", "date", "spec_model", "spec_ID",
    paste(c("white", "dark", "sample"), "inttime", sep = "_"),
    paste(c("white", "dark", "sample"), "avgs", sep = "_"),
    paste(c("white", "dark", "sample"), "boxcar", sep = "_")
  )

  res[, c(6,7,8,9,10,11,12,13,14)] <- vapply(res[, c(6,7,8,9,10,11,12,13,14)],
                                             as.numeric,
                                             numeric(nrow(res)))

  return(res)
}