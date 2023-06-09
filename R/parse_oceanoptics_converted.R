#' Parse OceanOptics converted file
#'
#' Parse OceanOptics/OceanInsight converted file.
#' <https://www.oceanoptics.com/>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return details
#'
#' @examples
#' res_jaz <- lr_parse_jaz(system.file("testdata", "jazspec.jaz",
#'                         package = "lightr"))
#' head(res_jaz$data)
#' res_jaz$metadata
#'
#' res_jazirrad <- lr_parse_jazirrad(system.file("testdata", "irrad.JazIrrad",
#'                                   package = "lightr"))
#' head(res_jazirrad$data)
#' res_jazirrad$metadata
#'
#' res_usb4000 <- lr_parse_jaz(system.file("testdata", "OOusb4000.txt",
#'                             package = "lightr"))
#' head(res_usb4000$data)
#' res_usb4000$metadata
#'
#' res_transmission <- lr_parse_jaz(
#'   system.file("testdata", "FMNH6834.00000001.Master.Transmission",
#'                package = "lightr")
#' )
#' head(res_transmission$data)
#' res_transmission$metadata
#'
#' @export
#'
lr_parse_jaz <- function(filename, ...) {
  # METADATA

  content <- readLines(filename, skipNul = TRUE)

  # Convert to ASCII
  content <- vapply(content, iconv, to = "ASCII", sub = "", character(1))

  # Can be:
  # - Spectrometer
  # - Spectrometers
  # - Spectrometer Serial Number
  # - Espectr?metros
  specID <- grep(
    "^(Spectrometers?( Serial Number)?|Espectr.metros): [[:graph:]]+$",
    content,
    value = TRUE
  )
  specID <- gsub(
    "^(Spectrometers?( Serial Number)?|Espectr.metros): ",
    "",
    specID
  )

  author <- grep("^(User|Usuario): [[:print:]]*$", content, value = TRUE)
  author <- gsub("^(User|Usuario): ", "", author)

  savetime <- grep("^(Date|Fecha): .*", content, value = TRUE)
  savetime <- gsub("^(Date|Fecha): ", "", savetime)

  oo_savetime_regex <- "^(\\w{3} \\w{3} \\d{2} \\d{2}:\\d{2}:\\d{2}) (\\w+ )?(\\d{4})$"
  tz <- ""

  if (grepl(oo_savetime_regex, savetime)) {
    # The value we extract here might not follow the official naming and could
    # not be recognized by tzdata.
    tz <- trimws(gsub(oo_savetime_regex, "\\2", savetime))
    savetime <- gsub(oo_savetime_regex, "\\1 \\3", savetime)
  }

  if (tz == "") {
    tz <- "UTC"
  }
  tz <- convert_backward_tzdata(tz)

  # OceanOptics files use locale-dependent date formats but it looks like they
  # are always using English for this, even when the locale is not set to
  # English
  orig_locale <- Sys.getlocale("LC_TIME")
  on.exit(Sys.setlocale("LC_TIME", orig_locale))
  Sys.setlocale("LC_TIME", "C")

  savetime <- as.POSIXct(
    savetime,
    tz = tz,
    tryFormats = c("%c", "%m-%d-%Y, %H:%M:%S")
  )
  savetime <- format(savetime, tz = "UTC")

  specmodel <- NA_character_

  # For those, be careful, the line ends with '(specID)' so no $
  int <- grep(
    "^(Integration Time|Tiempo de integraci.n) (.+): [[:digit:]]+",
    content,
    value = TRUE
  )
  inttime <- gsub(
    "^(Integration Time|Tiempo de integraci.n) \\(.+\\): ([[:digit:]]+).*",
    "\\2",
    int
  )

  inttime_unit <- gsub(
    "^(Integration Time|Tiempo de integraci.n) \\((.+)\\):.*",
    "\\2",
    int
  )

  if (identical(unname(inttime_unit), "usec")) {
    inttime <- as.numeric(inttime) / 1000
  }

  average <- grep(
    "^(Spectra Averaged|Promedio de Espectros Hechos un): [[:digit:]]+",
    content,
    value = TRUE
  )
  average <- gsub(
    "^(Spectra Averaged|Promedio de Espectros Hechos un): ([[:digit:]]+).*",
    "\\2",
    average
  )

  boxcar <- grep(
    "^(Boxcar Smoothing|El Alisar Del Furg.n): [[:digit:]]+",
    content,
    value = TRUE
  )
  boxcar <- gsub(
    "^(Boxcar Smoothing|El Alisar Del Furg.n): ([[:digit:]]+).*",
    "\\2",
    boxcar
  )

  dark_inttime <- white_inttime <- scope_inttime <- inttime
  dark_average <- white_average <- scope_average <- average
  dark_boxcar <- white_boxcar <- scope_boxcar <- boxcar

  metadata <- c(
    author,
    savetime,
    specmodel,
    specID,
    dark_inttime,
    white_inttime,
    scope_inttime,
    dark_average,
    white_average,
    scope_average,
    dark_boxcar,
    white_boxcar,
    scope_boxcar
  )

  # SPECTRA

  data_start <- grep(
    "^(>>>>>Begin (Processed )?Spectral Data<<<<<|>>>>> Comienza Data<<<<< Espectral Procesado Del EL)$",
    content
  )
  data_end <- grep(
    "^(>>>>>End (Processed )?Spectral Data<<<<<|>>>>> Data<<<<< Espectral Procesado Extremo)$",
    content
  )

  # Some files are missing the ending "tag". Let's then assume that data go to
  # the end of file.
  if (length(data_end) == 0) {
    data_end <- length(content)
  }

  # Some files have an extra header for the data, some don't...
  # If they do, it looks like this header will always start with W
  has_header <- startsWith(content[data_start + 1], "W")

  data <- content[seq(
    ifelse(has_header, data_start + 2, data_start + 1),
    data_end - 1
  )]

  # Depending on the user locale, some files might use ',' as a decimal sep
  data <- gsub(",", ".", data, fixed = TRUE)

  data <- do.call(rbind, strsplit(data, "\t", fixed = TRUE))

  if (has_header) {
    colnames(data) <- strsplit(content[data_start + 1], "\t", fixed = TRUE)[[1]]
  } else {
    colnames(data) <- c("W", "P")
  }
  storage.mode(data) <- "numeric"

  cornames <- c(wl = "W", dark = "D", white = "R", scope = "S", processed = "P")

  data_final <- setNames(
    as.data.frame(matrix(NA_real_, nrow = nrow(data), ncol = 5)),
    names(cornames)
  )

  data_final[match(colnames(data), cornames)] <- data

  return(list(data = data_final, metadata = unname(metadata)))
}

#' @rdname lr_parse_jaz
#'
#' @export
#'
lr_parse_jazirrad <- lr_parse_jaz
