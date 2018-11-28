#' Parse Avantes binary file
#'
#' @inheritParams parse_generic
#'
#' @inherit parse_generic return
#'
#' @importFrom stats setNames
#'
#' @examples
#' parse_trm(system.file("testdata", "avantes_trans.TRM", package = "lightr"))
#' parse_roh(system.file("testdata", "avantes_reflect.ROH", package = "lightr"))
#'
#' @export
#'
parse_trm <- function(filename) {
  # Translation of the matlab script from:
  # Copyright: (cc-by) Kotya Karapetyan, 2011.
  # kotya.karapetyan@gmail.com

  # Binary files structure provided by Avantes (http://www.avantes.com/)

  # Translation into R by Hugo Gruson

  if (!grepl("\\.(abs|trm|roh)$", filename, ignore.case = TRUE)) {
    stop("Unsupported file format. Please provide a file with either ",
         "ABS, TRM or ROH ",
         "file extension.")
  }

  f <- file(filename, "rb")

  # Header
  versionID <- readBin(f, "numeric", n = 1, size = 4)
  specID <- intToUtf8(readBin(f, "numeric", 9, 4))
  userfriendlyname <- intToUtf8(readBin(f, "numeric", 64, 4))

  # Coefficients for the polynome controlling wavelength sampling
  WLIntercept <- readBin(f, "numeric", 1, 4)
  WLX1 <- readBin(f, "numeric", 1, 4)
  WLX2 <- readBin(f, "numeric", 1, 4)
  WLX3 <- readBin(f, "numeric", 1, 4)
  WLX4 <- readBin(f, "numeric", 1, 4)

  ipixfirst <- as.numeric(readBin(f, "numeric", 1, 4))
  ipixlast <- as.numeric(readBin(f, "numeric", 1, 4))

  measuremode <- readBin(f, "numeric", 1, 4)
  dummy1 <- readBin(f, "numeric", 1, 4)
  laserwavelength <- readBin(f, "numeric", 1, 4)
  laserdelay <- readBin(f, "numeric", 1, 4)
  laserwidth <- readBin(f, "numeric", 1, 4)
  strobercontrol <- readBin(f, "numeric", 1, 4)
  dummy2 <- readBin(f, "numeric", 2, 4)
  savetime <- readBin(f, "numeric", 1, 4)
  dyndarkcorrection <- readBin(f, "numeric", 1, 4)

  smoothpix <- readBin(f, "numeric", 1, 4)
  dark_boxcar <- white_boxcar <- scope_boxcar <- smoothpix
  smoothmodel <- readBin(f, "numeric", 1, 4)
  triggermode <- readBin(f, "numeric", 1, 4)
  triggersource <- readBin(f, "numeric", 1, 4)
  triggersourcetype <- readBin(f, "numeric", 1, 4)
  # onboard temp in degrees Celsius
  NTC1 <- readBin(f, "numeric", 1, 4)
  # NTC2 in Volt (not connected)
  NTC2 <- readBin(f, "numeric",1, 4)
  # detector temp in degr Celsius (only TEC, NIR)
  Thermistor <- readBin(f, "numeric", 1, 4)
  dummy3 <- readBin(f, "numeric", 1, 4)

  # Data
  if (grepl("\\.(abs|trm)$", filename, ignore.case = TRUE)) {
    data <- readBin(f, "numeric", 3*(ipixlast - ipixfirst + 1), 4)
    data <- setNames(data.frame(matrix(data, ncol = 3, byrow = TRUE)),
                     c("scope", "white", "dark"))
  } else {# scope mode
    data <- data.frame(
      "scope" = readBin(f, "numeric", ipixlast - ipixfirst + 1, 4),
      "white" = NA,
      "dark"  = NA
    )
  }

  # integration time [ms] during file-save
  dark_inttime <- white_inttime <- scope_inttime <- readBin(f, "numeric", 1, 4)

  # nr of average during file-save
  dark_average <- white_average <- scope_average <- readBin(f, "numeric", 1, 4)
  integrationdelay <- readBin(f, "numeric", 1, 4)

  close(f)

  len <- nrow(data)

  data$wl <- rep_len(WLIntercept, len) +
    WLX1 * seq(0, len-1) +
    WLX2 * seq(0, len-1)^2 +
    WLX3 * seq(0, len-1)^3 +
    WLX4 * seq(0, len-1)^4

  # Reorder columns
  data <- data[, c("wl", "dark", "white", "scope")]
  data$processed <- (data$scope - data$dark) / (data$white - data$dark) * 100

  author <- NA
  specmodel <- NA
  metadata <- c(author, savetime, specmodel, specID,
                dark_inttime, white_inttime, scope_inttime,
                dark_average, white_average, scope_average,
                dark_boxcar, white_boxcar, scope_boxcar)

  return(list(data, metadata))
}

#' @rdname parse_trm
#'
#' @export
#'
parse_abs <- parse_trm

#' @rdname parse_trm
#'
#' @export
#'
parse_roh <- parse_trm
