#' Parse Avantes converted file
#'
#' @inheritParams parse_genetic
#'
#' @inherit parse_generic return
#'
parse_ttt <- function(filename) {

  # FIXME: grep to find appropriate lines instead of relying on fixed indices

  content <- readLines(filename, skipNul = TRUE)

  # The ID is always included as the first 9 characters in the comment line
  specID <- gsub("([[:alnum:]]{9})-.*", "\\1", content[1])
  author <- NA
  savetime <- NA
  specmodel <- NA
  inttime <- gsub("^Integration time: ([[:graph:]]+) ms$", "\\1", content[2])
  average <- gsub("^Average: ([[:digit:]]+) scans$", "\\1", content[3])
  boxcar <- gsub("^Nr of pixels used for smoothing: ", "", content[4])

  # Avantes does not allow different values between measurements
  dark_inttime <- white_inttime <- scope_inttime <- inttime
  dark_average <- white_average <- scope_average <- average
  dark_boxcar <- white_boxcar <- scope_boxcar <- boxcar


  metadata <- c(author, savetime, specmodel, specID,
                dark_inttime, white_inttime, scope_inttime,
                dark_average, white_average, scope_average,
                dark_boxcar, white_boxcar, scope_boxcar)

  data_ind <- grep("^([[:digit:]]|\\.|;)+$", content)
  data <- strsplit(content[data_ind], ";")
  data <- do.call(rbind, data)

  colnames(data) <- strsplit(content[data_ind[1]-2], ";")[[1]]

  # Remove trailing whitespaces in names
  colnames(data) <- gsub("[[:space:]]*$", "", colnames(data))

  cornames <- c("wl" = "Wave",
                "dark" = "Dark",
                "white" = "Ref",
                "scope" = "Sample",
                "processed" = "Transmittance")

  colnames(data) <- names(cornames)[match(colnames(data), cornames)]

  return(list(data, metadata))

}

#' @rdname parse_ttt
parse_trt <- parse_ttt
