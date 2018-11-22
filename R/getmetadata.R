#' Extract metadata from all spectra files in a folder
#'
#' @param where (required) folder in which files are located.
#' @param ext file extension to be searched for, without the "."
#' (defaults to "ProcSpec").
#' @param subdir should subdirectories within the where folder be included in
#' the search? (defaults to \code{FALSE}).
#' @param subdir.names should subdirectory path be included in the name of the
#' spectra? (defaults to \code{FALSE}).
#' @param cores Number of cores to be used. If greater than 1, import will use
#'  parallel processing (not available in Windows).
#' @param ignore.case Logical. Should the extension search be case insensitive?
#' (defaults to \code{TRUE})
#'
#' @export
#'
#' @importFrom pbapply pblapply
#' @importFrom parallel makePSOCKcluster clusterExport stopCluster
#' @importFrom tools file_path_sans_ext
#'
#' @references White TE, Dalrymple RL, Noble DWA, O'Hanlon JC, Zurek DB,
#' Umbers KDL. Reproducible research in the study of biological coloration.
#' Animal Behaviour. 2015 Aug 1;106:51–7 (\doi{10.1016/j.anbehav.2015.05.007}).

getmetadata <- function(where = getwd(), ext = "ProcSpec",
                        subdir = FALSE, subdir.names = FALSE,
                        cores = getOption("cl.cores", 2L), ignore.case = TRUE) {

  # allow multiple extensions
  extension <- paste0("\\.", ext, "$", collapse = "|")

  # get file names
  file_names <- list.files(where,
    pattern = extension, ignore.case = ignore.case,
    recursive = subdir, include.dirs = subdir
  )
  nb_files <- length(file_names)

  if (nb_files == 0) {
    warning('No files found. Try a different extension value for argument "ext"',
            call. = FALSE)
    return(NULL)
  }

  files <- file.path(where, file_names)

  if (!subdir.names) {
    file_names <- basename(file_names)
  }

  gmd <- function(ff) {

    dispatch_parser(ff)[[2]]

  }

  specnames <- file_path_sans_ext(file_names)

  clstrs <- makePSOCKcluster(cores, methods = FALSE, useXDR = FALSE)
  on.exit(stopCluster(clstrs))
  clusterExport(clstrs, varlist = c("dispatch_parser", "file_ext", ls(pattern = "^parse_")))

  tmp <- pblapply(files, function(x)
    tryCatch(gmd(x),
             error = function(e) NULL,
             warning = function(e) NULL
    ), cl = clstrs)

  if (any(unlist(lapply(tmp, is.null)))) {
    whichfailed <- which(unlist(lapply(tmp, is.null)))
    # stop if all files are corrupt
    if (length(whichfailed) == nb_files) {
      warning("Could not import spectra, check input files and function arguments", call. = FALSE)
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
  colnames(res) <- c("User", "Date", "Spectrometer Model", "Spectrometer ID",
                     paste(c("White reference", "Dark reference", "Sample"), "integration time"),
                     paste(c("White reference", "Dark reference", "Sample"), "number of averages"),
                     paste(c("White reference", "Dark reference", "Sample"), "boxcar width"))
  rownames(res) <- specnames
  res[, c(5,6,7,8,9,10,11,12,13)] <- sapply(res[, c(5,6,7,8,9,10,11,12,13)], as.numeric)

#  class(res) <- c("metaspec", "data.frame")

  return(res)
}
