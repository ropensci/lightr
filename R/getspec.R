#' Extract spectral data from all spectra files in a folder
#'
#' Finds and imports spectra files from a folder. Currently works
#' for reflectance files generated in Ocean Optics SpectraSuite (USB2000,
#' USB4000 and Jaz spectrometers), CRAIC software (after exporting) and
#' Avantes (before or after exporting).
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
#' @importFrom pbmcapply pbmclapply
#' @importFrom tools file_path_sans_ext
#' @importFrom stats approx
#'
#' @examples \dontrun{
#' getspec('examplespec/', lim = c(400, 900))
#' getspec('examplespec/', ext = 'ttt')}
#'
#' @author Rafael Maia \email{rm72@@zips.uakron.edu}
#' @author Hugo Gruson \email{hugo.gruson+R@@normalesup.org}
#'
#' @references Montgomerie R (2006) Analyzing colors. In: Hill G, McGraw K (eds)
#' Bird coloration. Harvard University Press, Cambridge, pp 90-147.

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

  # On Windows, set cores to be 1
  if (cores > 1 && .Platform$OS.type == "windows") {
    cores <- 1L
    message('Parallel processing not available in Windows; "cores" set to 1.\n')
  }

  # message with number of spectra files being imported
  message(nb_files, " files found; importing spectra:")

  gsp <- function(ff) {

    df <- dispatch_parser(ff, decimal = decimal, sep = sep)[[1]]

    # Only keep first and last column ("wl" and "processed") and interpolate
    # every nm
    interp <- approx(df[, 1], df[, 5], xout = range)$y
  }

  tmp <- pbmclapply(files, function(x)
    tryCatch(gsp(x),
             error = function(e) NULL,
             warning = function(e) NULL
    ), mc.cores = cores)

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

  # Negative value check
  if (any(final < 0, na.rm = TRUE)) {
    message(
      "\nThe spectral data contain ", sum(final < 0, na.rm = TRUE),
      " negative value(s), which may produce unexpected results if used in models. Consider using procspec() to correct them."
    )
  }

  return(final)
}
