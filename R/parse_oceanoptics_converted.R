#' Parse OceanInsight converted file
#'
#' Parse OceanInsight (formerly OceanOptics) converted file.
#' <https://www.oceaninsight.com/>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return details
#'
#' @examples
#' lr_parse_jaz(system.file("testdata", "jazspec.jaz", package = "lightr"))
#' lr_parse_jazirrad(system.file("testdata", "irrad.JazIrrad",
#'                   package = "lightr"))
#'
#' @export
#'
lr_parse_jaz <- function(filename) {

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

  specmodel <- NA_character_

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

  # Some files are missing the ending "tag". Let's then assume that data go to
  # the end of file.
  if (length(data_end)==0) {
    data_end <- length(content)
  }

  # Some files have an extra header for the data, some don't...
  # If they do, it looks like this header will always start with W
  has_header <- grepl("^W", content[data_start+1])

  data <- content[seq(ifelse(has_header, data_start+2, data_start+1),
                      data_end-1)]

  # Depending on the user locale, some files might use ',' as a decimal sep
  data <- gsub(",", ".", data)

  data <- do.call(rbind, strsplit(data, "\t"))

  if (has_header) {
    colnames(data) <- strsplit(content[data_start+1], "\t")[[1]]


  } else {

    colnames(data) <- c("W", "P")

  }

  cornames <- c("wl" = "W",
                "dark" = "D",
                "white" = "R",
                "scope" = "S",
                "processed" = "P")

  data_final <- setNames(
    as.data.frame(matrix(NA, nrow = nrow(data), ncol = 5)),
    names(cornames)
  )

  data_final[match(colnames(data), cornames)] <- data

  data_final <- apply(data_final, 2, as.numeric)

  return(list(data.frame(data_final), metadata))
}

#' @rdname lr_parse_jaz
#'
#' @export
#'
lr_parse_jazirrad <- lr_parse_jaz
