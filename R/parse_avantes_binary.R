#' Parse Avantes binary file
#'
#' Parse Avantes binary file. <https://www.avantes.com/products/spectrometers>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return
#'
#' @importFrom stats setNames
#'
#' @examples
#' lr_parse_trm(system.file("testdata", "avantes_trans.TRM",
#'                          package = "lightr"))
#' lr_parse_roh(system.file("testdata", "avantes_reflect.ROH",
#'                          package = "lightr"))
#'
#' @export
#'
lr_parse_trm <- function(filename) {
  # Translation of the matlab script from:
  # Copyright: (cc-by) Kotya Karapetyan, 2011.
  # kotya.karapetyan@gmail.com

  # Binary files structure provided by Avantes (http://www.avantes.com/)

  # Translation into R by Hugo Gruson

  f <- file(filename, "rb")
  on.exit(close(f))

  # Header
  versionID <- readBin(f, "numeric", n = 1, size = 4, endian = "little")

  if (versionID == 70) {
    specID <- intToUtf8(readBin(f, "numeric", 9, 4, endian = "little"))
    userfriendlyname <- intToUtf8(readBin(f, "numeric", 64, 4, endian = "little"))
  }

  # Coefficients for the polynome controlling wavelength sampling
  WLIntercept <- readBin(f, "numeric", 1, 4, endian = "little")
  WLX1 <- readBin(f, "numeric", 1, 4, endian = "little")
  WLX2 <- readBin(f, "numeric", 1, 4, endian = "little")
  WLX3 <- readBin(f, "numeric", 1, 4, endian = "little")
  WLX4 <- readBin(f, "numeric", 1, 4, endian = "little")

  if (versionID == 60) {
    specID <- intToUtf8(readBin(f, "numeric", 9, 4, endian = "little"))
  }

  ipixfirst <- as.numeric(readBin(f, "numeric", 1, 4, endian = "little"))
  ipixlast <- as.numeric(readBin(f, "numeric", 1, 4, endian = "little"))

  measuremode <- readBin(f, "numeric", 1, 4, endian = "little")
  dummy1 <- readBin(f, "numeric", 1, 4, endian = "little")

  if (versionID == 70) {
    laserwavelength <- readBin(f, "numeric", 1, 4, endian = "little")
    laserdelay <- readBin(f, "numeric", 1, 4, endian = "little")
    laserwidth <- readBin(f, "numeric", 1, 4, endian = "little")
    strobercontrol <- readBin(f, "numeric", 1, 4, endian = "little")
    dummy2 <- readBin(f, "numeric", 2, 4, endian = "little")
    savetime <- readBin(f, "numeric", 1, 4, endian = "little")
    dyndarkcorrection <- readBin(f, "numeric", 1, 4, endian = "little")

    smoothpix <- readBin(f, "numeric", 1, 4, endian = "little")
    dark_boxcar <- white_boxcar <- scope_boxcar <- smoothpix
    smoothmodel <- readBin(f, "numeric", 1, 4, endian = "little")
    triggermode <- readBin(f, "numeric", 1, 4, endian = "little")
    triggersource <- readBin(f, "numeric", 1, 4, endian = "little")
    triggersourcetype <- readBin(f, "numeric", 1, 4, endian = "little")
    # onboard temp in degrees Celsius
    NTC1 <- readBin(f, "numeric", 1, 4, endian = "little")
    # NTC2 in Volt (not connected)
    NTC2 <- readBin(f, "numeric",1, 4, endian = "little")
    # detector temp in degr Celsius (only TEC, NIR)
    Thermistor <- readBin(f, "numeric", 1, 4, endian = "little")
    dummy3 <- readBin(f, "numeric", 1, 4, endian = "little")
  }

  # Data
  if (grepl("\\.(abs|trm)$", filename, ignore.case = TRUE)) {
    data <- readBin(f, "numeric", 3*(ipixlast - ipixfirst + 1), 4, endian = "little")
    data <- setNames(data.frame(matrix(data, ncol = 3, byrow = TRUE)),
                     c("scope", "white", "dark"))
  } else {# scope mode
    data <- data.frame(
      "scope" = readBin(f, "numeric", ipixlast - ipixfirst + 1, 4, endian = "little"),
      "white" = NA,
      "dark"  = NA
    )
  }

  # integration time [ms] during file-save
  dark_inttime <- white_inttime <- scope_inttime <- readBin(f, "numeric", 1, 4, endian = "little")

  # nr of average during file-save
  dark_average <- white_average <- scope_average <- readBin(f, "numeric", 1, 4, endian = "little")

  if (versionID == 70) {
    integrationdelay <- readBin(f, "numeric", 1, 4, endian = "little")
  }
  if (versionID == 60) {
    dark_boxcar <- white_boxcar <- scope_boxcar <- readBin(f, "numeric", 1, 4, endian = "little")
    savetime <- NA
  }

  len <- nrow(data)

  data$wl <- rep_len(WLIntercept, len) +
    WLX1 * seq(ipixfirst, ipixlast) +
    WLX2 * seq(ipixfirst, ipixlast)^2 +
    WLX3 * seq(ipixfirst, ipixlast)^3 +
    WLX4 * seq(ipixfirst, ipixlast)^4

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

#' @rdname lr_parse_trm
#'
#' @export
#'
lr_parse_abs <- lr_parse_trm

#' @rdname lr_parse_trm
#'
#' @export
#'
lr_parse_roh <- lr_parse_trm
