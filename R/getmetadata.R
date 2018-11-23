#' Extract metadata from spectra files
#'
#' Finds and imports metadata from spectra files in a given location.
#'
#' @inheritParams get_spec
#'
#' @export
#'
#' @return A dataframe containing one spectrum per column and useful metadata
#' to report in your manuscript.
#'
#' @importFrom pbmcapply pbmclapply
#' @importFrom tools file_path_sans_ext
#'
#' @references White TE, Dalrymple RL, Noble DWA, O'Hanlon JC, Zurek DB,
#' Umbers KDL. Reproducible research in the study of biological coloration.
#' Animal Behaviour. 2015 Aug 1;106:51–7 (\doi{10.1016/j.anbehav.2015.05.007}).

get_metadata <- function(where = getwd(), ext = "ProcSpec",
                         subdir = FALSE, subdir.names = FALSE,
                         cores = getOption("mc.cores", 2L),
                         ignore.case = TRUE) {

  # allow multiple extensions
  extension <- paste0("\\.", ext, "$", collapse = "|")

  # get file names
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

  # On Windows, set cores to be 1
  if (cores > 1 && .Platform$OS.type == "windows") {
    cores <- 1L
    message('Parallel processing not available in Windows; "cores" set to 1.\n')
  }

  gmd <- function(ff) {

    df <- dispatch_parser(ff)[[2]]

  }

  tmp <- pbmclapply(files, function(x)
    tryCatch(gmd(x),
             error = function(e) NULL,
             warning = function(e) NULL
    ), mc.cores = cores)

  if (any(unlist(lapply(tmp, is.null)))) {
    whichfailed <- which(unlist(lapply(tmp, is.null)))
    # stop if all files are corrupt
    if (length(whichfailed) == nb_files) {
      warning("File import failed.\n",
              "Check input files and function arguments.", call. = FALSE)
      return()
    }

    # if not, import the ones remaining
    warning("Could not import one or more files:\n",
            paste0(files[whichfailed], "\n"),
            call. = FALSE
    )

    specnames <- specnames[-whichfailed]
  }

  res <- as.data.frame(do.call(rbind, tmp), stringsAsFactors = FALSE)

  res <- cbind(specnames, res)

  colnames(res) <- c(
    "Name", "User", "Date", "Spectrometer Model", "Spectrometer ID",
    paste(c("White reference", "Dark reference", "Sample"), "integration time"),
    paste(c("White reference", "Dark reference", "Sample"), "number of averages"),
    paste(c("White reference", "Dark reference", "Sample"), "boxcar width")
  )

  res[, c(6,7,8,9,10,11,12,13,14)] <- sapply(res[, c(6,7,8,9,10,11,12,13,14)], as.numeric)

#  class(res) <- c("metaspec", "data.frame")

  return(res)
}

#' @rdname get_metadata
#'
#' @export
getmetadata <- get_metadata
