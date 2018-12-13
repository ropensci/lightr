#' Extract spectral data from spectra files
#'
#' Finds and imports reflectance/transmittance/absorbance data from spectra
#' files in a given location.
#'
#' @inheritParams parse_generic
#'
#' @param where Folder in which files are located (defaults to current working
#' directory).
#' @param ext File extension to be searched for, without the "."
#' (defaults to `txt`).
#' @param lim A vector with two numbers determining the wavelength limits to be
#' considered (defaults to `c(300, 700)`).
#' @param subdir Should subdirectories within the `where` folder be included in
#' the search? (defaults to `FALSE`).
#' @param subdir.names Should subdirectory path be included in the name of the
#' spectra? (defaults to `FALSE``).
#' @param cores Number of cores to be used. If greater than 1, import will use
#' parallel processing (not available in Windows).
#' @param ignore.case Should the extension search be case insensitive? (defaults
#' to `TRUE``)
#'
#' @return A data.frame, containing the wavelengths in the first column and
#' individual imported spectral files in the subsequent columns.
#' Reflectance values are interpolated to the nearest wavelength integer.
#'
#' @export
#'
#' @importFrom pbmcapply pbmclapply
#' @importFrom tools file_path_sans_ext
#' @importFrom stats approx
#'
#' @examples
#' get_spec(system.file("testdata", package = "lightr"), lim = c(400, 900))
#'
get_spec <- function(where = getwd(), ext = "txt", lim = c(300, 700),
                     decimal = ".", sep = NULL, subdir = FALSE,
                     subdir.names = FALSE, cores = getOption("mc.cores", 2L),
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

  range <- seq(lim[1], lim[2])

  if (cores > 1 && .Platform$OS.type == "windows") {
    cores <- 1L
    message('Parallel processing not available in Windows; "cores" set to 1.\n')
  }

  message(nb_files, " files found; importing spectra:")

  gsp <- function(ff) {

    df <- dispatch_parser(ff, decimal = decimal, sep = sep)[[1]]

    interp <- approx(df[, "wl"], df[, "processed"], xout = range)$y
  }

  tmp <- pbmclapply(files, function(x)
    tryCatch(gsp(x),
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


  tmp <- do.call(cbind, tmp)

  final <- cbind(range, tmp)

  colnames(final) <- c("wl", specnames)
  final <- as.data.frame(final)
  class(final) <- c("rspec", "data.frame")

  return(final)
}