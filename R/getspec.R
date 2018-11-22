#' Extract reflectance data from spectra files
#'
#' Finds and imports reflectance data from spectra files in a given location.
#'
#' @param where (required) folder in which files are located.
#' @param ext file extension to be searched for, without the "."
#' (defaults to "txt").
#' @param lim a vector with two numbers determining the wavelength limits to be
#' considered (defaults to 300 and 700).
#' @param decimal character to be used to identify decimal plates
#' (defaults to ".").
#' @param sep column delimiting characters to be considered in addition to the
#' default (which are: tab, space, and ";")
#' @param subdir should subdirectories within the \code{where} folder be
#' included in the search? (defaults to \code{FALSE}).
#' @param subdir.names should subdirectory path be included in the name of the
#' spectra? (defaults to \code{FALSE}).
#' @param cores Number of cores to be used. If greater than 1, import will use
#'  parallel processing (not available in Windows).
#' @param ignore.case Logical. Should the extension search be case insensitive?
#' (defaults to TRUE)
#' @return A data frame, of class \code{rspec}, containing individual imported
#' spectral files as columns.
#' Reflectance values are interpolated to the nearest wavelength integer.
#'
#' @export
#'
#' @importFrom pbapply pblapply
#' @importFrom parallel makePSOCKcluster clusterExport stopCluster
#' @importFrom tools file_path_sans_ext
#' @importFrom stats approx
#'
#' @examples \dontrun{
#' getspec('examplespec/', lim = c(400, 900))
#' getspec('examplespec/', ext = 'ttt')}
#'
#'
getspec <- function(where = getwd(), ext = "txt", lim = c(300, 700), decimal = ".",
                    sep = NULL, subdir = FALSE, subdir.names = FALSE,
                    cores = getOption("mc.cores", 2L), ignore.case = TRUE) {

  # allow multiple extensions
  extension <- paste0("\\.", ext, "$", collapse = "|")

  # get file names
  file_names <- list.files(where,
    pattern = extension, ignore.case = ignore.case,
    recursive = subdir, include.dirs = subdir
  )
  nb_files <- length(file_names)

  if (nb_files == 0) {
    warning('No files found. Try a different extension value for argument "ext"', call. = FALSE)
    return(NULL)
  }

  files <- file.path(where, file_names)

  if (!subdir.names) {
    file_names <- basename(file_names)
  }

  specnames <- file_path_sans_ext(file_names)

  # Wavelength range
  range <- seq(lim[1], lim[2])

  # message with number of spectra files being imported
  message(nb_files, " files found; importing spectra:")

  gsp <- function(ff) {

    df <- dispatch_parser(ff, decimal = decimal, sep = sep)[[1]]

    # Only keep "wl" and "processed" columns and interpolate every nm
    interp <- approx(df[, "wl"], df[, "processed"], xout = range)$y
  }

  clstrs <- makePSOCKcluster(cores, methods = FALSE, useXDR = FALSE)
  on.exit(stopCluster(clstrs))
  clusterExport(clstrs, varlist = c("dispatch_parser", "file_ext", ls(pattern = "^parse_")))

  tmp <- pblapply(files, function(x)
    tryCatch(gsp(x),
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


  tmp <- do.call(cbind, tmp)

  final <- cbind(range, tmp)

  colnames(final) <- c("wl", specnames)
  final <- as.data.frame(final)
  class(final) <- c("rspec", "data.frame")

  return(final)
}
