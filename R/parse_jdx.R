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
  author <- sub("^##OWNER= ", "", content[startsWith(content, "##OWNER=")])[1]
  savetime <- NA_character_ # Not available in jdx files
  specmodel <- NA_character_
  specID <- NA_character_

  # According to the standard, all blocks must start and end in this way:
  blockstarts <- which(startsWith(content, "##TITLE="))[-1]
  blockends <- which(startsWith(content, "##END="))[-4]

  blocktype <- content[blockstarts]
  blocktype <- tolower(gsub(".+: ([[:alpha:]]+) SPECTRUM$", "\\1", blocktype))

  get_block_metadata <- function(index) {
    block <- content[blockstarts[index]:blockends[index]]
    inttime <- block[startsWith(block, "##.ACQUISITION TIME=")]
    inttime <- sub("^##\\.ACQUISITION TIME= ", "", inttime)
    avg <- block[startsWith(block, "##.AVERAGES=")]
    avg <- sub("^##\\.AVERAGES= ", "", avg)
    boxcar <- block[startsWith(block, "##DATA PROCESSING= BOXCAR:")]
    boxcar <- sub("^##DATA PROCESSING= BOXCAR:([[:digit:]]+).*", "\\1", boxcar)
    return(c(inttime, avg, boxcar))
  }

  scope_meta <- get_block_metadata(which(blocktype == "processed"))
  dark_meta <- get_block_metadata(which(blocktype == "dark"))
  white_meta <- get_block_metadata(which(blocktype == "reference"))

  metadata <- c(
    author,
    savetime,
    specmodel,
    specID,
    dark_meta[1],
    white_meta[1],
    scope_meta[1],
    dark_meta[2],
    white_meta[2],
    scope_meta[2],
    dark_meta[3],
    white_meta[3],
    scope_meta[3]
  )

  get_data <- function(index) {
    # Data is contained in lines that do NOT start with ##
    block <- content[blockstarts[index]:blockends[index]]
    data <- block[!startsWith(block, "##")]
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
