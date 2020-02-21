#' Parse Avantes binary file
#'
#' Parse Avantes binary file (TRM, ABS, ROH, DRK, REF file extensions).
#' <https://www.avantes.com/products/spectrometers>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return
#'
#' @inherit lr_parse_jdx details
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

  if (!versionID %in% c(60, 70)) {
    stop("parsing for this file type has not yet been implemented. ",
         "Please open an issue with the problematic file.", call. = FALSE)
  }

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
  data$processed <- compute_processed(data)

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

#' @rdname lr_parse_trm
#'
#' @param specnum Integer representing the position of the spectrum to read in
#'   the file. This option only makes sense for AvaSoft8 files and is ignored
#'   in the other cases.
#'
#' @export
#'
#' @examples
#' lr_parse_rfl8(system.file("testdata", "compare", "Avantes",
#'                           "feather.RFL8",
#'                           package = "lightr"),
#'               specnum = 1)
#' lr_parse_rfl8(system.file("testdata", "compare", "Avantes",
#'                           "feather.RFL8",
#'                           package = "lightr"),
#'               specnum = 2)
#'
lr_parse_rfl8 <- function(filename, specnum) {

  # File structure information provided courtesy of Avantes

  f <- file(filename, "rb")
  on.exit(close(f))

  # HEADER
  # always 'AVS82'
  marker <- rawToChar(readBin(f, "raw", n = 5, endian = "little"))

  # number of spectra in file
  numspectra <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

  if (numspectra > 1 & missing(specnum)) {
    specnum <- 1L
    warning(
      "This file contains multiple spectra and 'specnum' argument is missing. ",
      "Returning the first spectrum by default.",
      call. = FALSE
    )
  }
  if (specnum > numspectra) {
    stop("'specnum' is larger than the number of spectra in the input file",
         call. = FALSE)
  }

  for (i in seq_len(numspectra)) {
    # total length of the subfile
    length <- int32_to_uint32(
      readBin(f, "integer", size = 4, n = 1, endian = "little")
    )

    seqnum <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    measmode <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    bitness <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    SDmarker <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    # AvsIdentityType (75 bytes)
    specID <- rawToChar(readBin(f, "raw", n = 10, endian = "little"))
    userfriendlyname <- readBin(f, "raw", n = 64, endian = "little")
    status <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    # MeasConfigType (41 bytes)
    m_startpixel <- readBin(f, "integer", size = 2, signed = FALSE, endian = "little")
    m_stoppixel <- readBin(f, "integer", size = 2, signed = FALSE, endian = "little")
    dark_inttime <- white_inttime <- scope_inttime <- readBin(f, "numeric", size = 4, endian = "little")
    m_integrationdelay <- int32_to_uint32(
      readBin(f, "integer", size = 4, endian = "little")
    )
    dark_average <- white_average <- scope_average <- int32_to_uint32(
      readBin(f, "integer", size = 4, endian = "little")
    )

    ## DarkCorrectionType
    m_enable <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")
    m_forgetpercentage <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    ## SmoothingType
    dark_boxcar <- white_boxcar <- scope_boxcar <- readBin(f, "integer", size = 2, signed = FALSE, endian = "little")
    m_smoothmodel <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    m_saturationdetection <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    ## TriggerType
    m_mode <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")
    m_source <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")
    m_sourcetype <- readBin(f, "integer", size = 1, signed = FALSE, endian = "little")

    ## ControlSettingsType
    m_strobecontrol <- readBin(f, "integer", size = 2, signed = FALSE, endian = "little")
    m_laserdelay <- int32_to_uint32(
      readBin(f, "integer", size = 4, endian = "little")
    )
    m_laserwidth <- int32_to_uint32(
      readBin(f, "integer", size = 4, endian = "little")
    )
    m_laserwavelength <- readBin(f, "numeric", size = 4, endian = "little")
    m_storetoram <- readBin(f, "integer", size = 2, signed = FALSE, endian = "little")

    timestamp <- readBin(f, "raw", n = 4, endian = "little")
    SPCfiledate <- readBin(f, "raw", n = 4, endian = "little")

    detectortemp <- readBin(f, "numeric", size = 4, endian = "little")
    boardtemp <- readBin(f, "numeric", size = 4, endian = "little")

    NTC2volt <- readBin(f, "numeric", size = 4, endian = "little")
    ColorTemp <- readBin(f, "numeric", size = 4, endian = "little")
    CalIntTime <- readBin(f, "numeric", size = 4, endian = "little")

    fitdata <- readBin(f, "double", size = 8, n = 5, endian = "little")

    comment <- intToUtf8(readBin(f, "raw", n = 130, endian = "little"))

    len <- m_stoppixel - m_startpixel + 1

    xcoord <- readBin(f, "numeric", 4, n = len, endian = "little")
    scope <- readBin(f, "numeric", 4, n = len, endian = "little")
    dark <- readBin(f, "numeric", 4, n = len, endian = "little")
    reference <- readBin(f, "numeric", 4, n = len, endian = "little")

    mergegroup <- intToUtf8(readBin(f, "raw", n = 10, endian = "little"))

    data <- as.data.frame(cbind("wl" = xcoord,
                                dark,
                                "white" = reference,
                                scope))
    data$processed <- compute_processed(data)

    author <- NA
    savetime <- NA # FIXME: extract this from SPCfiledate
    specmodel <- NA

    metadata <-  metadata <- c(author, savetime, specmodel, specID,
                               dark_inttime, white_inttime, scope_inttime,
                               dark_average, white_average, scope_average,
                               dark_boxcar, white_boxcar, scope_boxcar)

    if (specnum == i) {
      return(list(data, metadata))
    }

  }
}
