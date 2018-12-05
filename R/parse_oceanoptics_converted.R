#' Parse OceanOptics converted file
#'
#' @inheritParams parse_generic
#'
#' @inherit parse_generic return
#'
#' @examples
#' parse_jaz(system.file("testdata", "jazspec.jaz", package = "lightr"))
#' parse_jazirrad(system.file("testdata", "irrad.JazIrrad", package = "lightr"))
#'
#' @export
#'
parse_jaz <- function(filename) {

  # METADATA

  content <- readLines(filename, skipNul = TRUE)

  specID <- grep("^Spectrometers?( Serial Number)?: [[:graph:]]+$",
                 content,
                 value = TRUE)
  specID <- gsub("^Spectrometers?( Serial Number)?: ", "", specID)

  author <- grep("^User: [[:print:]]*$", content, value = TRUE)
  author <- gsub("^User: ", "", author)

  savetime <- grep("^Date: .*", content, value = TRUE)
  savetime <- gsub("^Date: ", "", savetime)

  specmodel <- NA

  # For those, be careful, the line ends with '(specID)' so no $
  int <- grep("^Integration Time (.+): [[:digit:]]+", content, value = TRUE)
  inttime <- gsub("^Integration Time \\(.+\\): ([[:digit:]]+).*", "\\1", int)

  inttime_unit <- gsub("^Integration Time \\((.+)\\):.*", "\\1", int)

  if (inttime_unit == "usec") {
    inttime <- as.numeric(inttime) / 1000
  }

  average <- grep("^Spectra Averaged: [[:digit:]]+", content, value = TRUE)
  average <- gsub("^Spectra Averaged: ([[:digit:]]+).*", "\\1", average)

  boxcar <- grep("^Boxcar Smoothing: [[:digit:]]+", content, value = TRUE)
  boxcar <- gsub("^Boxcar Smoothing: ([[:digit:]]+).*", "\\1", boxcar)

  dark_inttime <- white_inttime <- scope_inttime <- inttime
  dark_average <- white_average <- scope_average <- average
  dark_boxcar <- white_boxcar <- scope_boxcar <- boxcar

  metadata <- c(author, savetime, specmodel, specID,
                dark_inttime, white_inttime, scope_inttime,
                dark_average, white_average, scope_average,
                dark_boxcar, white_boxcar, scope_boxcar)

  # SPECTRA

  data_start <- grep("^>>>>>Begin (Processed )?Spectral Data<<<<<$", content)
  data_end <- grep("^>>>>>End (Processed )?Spectral Data<<<<<$", content)

  data <- content[seq(data_start+2, data_end-1)]

  data <- do.call(rbind, strsplit(data, "\t"))

  colnames(data) <- strsplit(content[data_start+1], "\t")[[1]]

  cornames <- c("wl" = "W",
                "dark" = "D",
                "white" = "R",
                "scope" = "S",
                "processed" = "P")

  colnames(data) <- names(cornames)[match(colnames(data), cornames)]

  data <- apply(data, 2, as.numeric)

  return(list(data.frame(data), metadata))
}

#' @rdname parse_jaz
#'
#' @export
#'
parse_jazirrad <- parse_jaz
