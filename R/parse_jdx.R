#' Parse OceanOptics JCAMP-DX (.jdx) file
#'
#' Parse OceanOptics/OceanInsight JCAMP-DX (.jdx) file.
#' <https://www.oceanoptics.com/>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return
#'
#' @details
#' 'processed' column computed by \pkg{`r packageName()`} with the function
#' [lr_compute_processed()].
#'
#' @references McDonald RS, Wilks PA. JCAMP-DX: A Standard Form for Exchange of
#' Infrared Spectra in Computer Readable Form. Applied Spectroscopy.
#' 1988;42(1):151-62.
#'
#' @examples
#' res_jdx <- lr_parse_oceanoptics_jdx(system.file("testdata", "OceanOptics_period.jdx",
#'                                     package = "lightr"))
#' head(res_jdx$data)
#' res_jdx$metadata
#'
#' @export
#'
lr_parse_oceanoptics_jdx <- function(filename, ...) {
  content <- readLines(filename)
  author <- grep("^##OWNER=", content, value = TRUE)
  author <- gsub("^##OWNER= ", "", author)[1]
  savetime <- NA_character_ # Not available in jdx files
  specmodel <- NA_character_
  specID <- NA_character_

  # According to the standard, all blocks must start and end in this way:
  blockstarts <- grep("^##TITLE=", content)[-1]
  blockends <- grep("^##END=", content)[-4]

  blocktype <- content[blockstarts]
  blocktype <- tolower(gsub(".+: ([[:alpha:]]+) SPECTRUM$", "\\1", blocktype))

  get_inttime <- function(index) {
    inttime <- grep(
      "^##\\.ACQUISITION TIME=",
      content[blockstarts[index]:blockends[index]],
      value = TRUE
    )
    inttime <- gsub("^##\\.ACQUISITION TIME= ", "", inttime)
  }

  scope_inttime <- get_inttime(which(blocktype == "processed"))
  dark_inttime <- get_inttime(which(blocktype == "dark"))
  white_inttime <- get_inttime(which(blocktype == "reference"))

  get_avg <- function(index) {
    avg <- grep(
      "^##\\.AVERAGES=",
      content[blockstarts[index]:blockends[index]],
      value = TRUE
    )
    avg <- gsub("^##\\.AVERAGES= ", "", avg)
  }

  scope_average <- get_avg(which(blocktype == "processed"))
  dark_average <- get_avg(which(blocktype == "dark"))
  white_average <- get_avg(which(blocktype == "reference"))

  get_boxcar <- function(index) {
    boxcar <- grep(
      "^##DATA PROCESSING= BOXCAR:",
      content[blockstarts[index]:blockends[index]],
      value = TRUE
    )
    boxcar <- gsub("^##DATA PROCESSING= BOXCAR:([[:digit:]]+).*", "\\1", boxcar)
  }

  scope_boxcar <- get_boxcar(which(blocktype == "processed"))
  dark_boxcar <- get_boxcar(which(blocktype == "dark"))
  white_boxcar <- get_boxcar(which(blocktype == "reference"))

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

  get_data <- function(index) {
    # Data is contained in lines that do NOT start with ##
    data <- grep(
      "^##",
      content[blockstarts[index]:blockends[index]],
      value = TRUE,
      invert = TRUE
    )
    data <- strsplit(data, ", ", fixed = TRUE)
    data <- do.call(rbind, data)
    # Fix decimal for non-English files
    data <- gsub(",", ".", data, fixed = TRUE)
  }

  scope_data <- get_data(which(blocktype == "processed"))
  dark_data <- get_data(which(blocktype == "dark"))
  white_data <- get_data(which(blocktype == "reference"))

  data <- cbind(
    scope_data[, 1],
    dark_data[, 2],
    white_data[, 2],
    scope_data[, 2]
  )
  colnames(data) <- c("wl", "dark", "white", "scope")

  storage.mode(data) <- "numeric"
  data <- as.data.frame(data)

  data$processed <- lr_compute_processed(data)

  return(list(data = data, metadata = metadata))
}

#' @rdname lr_parse_oceanoptics_jdx
#' @export
lr_parse_jdx <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_jdx()",
    with = "lr_parse_oceanoptics_jdx()"
  )
  lr_parse_oceanoptics_jdx(filename = filename, ...)
}
