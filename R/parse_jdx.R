#' Parse OceanInsight JCAMP-DX (.jdx) file
#'
#' Parse OceanInsight (formerly OceanOptics) JCAMP-DX (.jdx) file.
#' <https://www.oceaninsight.com/>
#'
#' @inheritParams lr_parse_generic
#'
#' @inherit lr_parse_generic return
#'
#' @references McDonald RS, Wilks PA. JCAMP-DX: A Standard Form for Exchange of
#' Infrared Spectra in Computer Readable Form. Applied Spectroscopy.
#' 1988;42(1):151-62.
#'
#' @examples
#' lr_parse_jdx(system.file("testdata", "OceanOptics_period.jdx",
#'                          package = "lightr"))
#'
#' @export
#'
lr_parse_jdx <- function(filename) {
  content <- readLines(filename)
  author <- grep("^##OWNER=", content, value = TRUE)
  author <- gsub("^##OWNER= ", "", author)[1]
  savetime <- NA
  specmodel <- NA
  specID <- NA

  # According to the standard, all blocks must start and end in this way:
  blockstarts <- grep("^##TITLE=", content)[-1]
  blockends   <- grep("^##END=", content)[-4]

  blocktype <- content[blockstarts]
  blocktype <- tolower(gsub(".+: ([[:alpha:]]+) SPECTRUM$", "\\1", blocktype))

  get_inttime <- function(index) {
    inttime <- grep("^##\\.ACQUISITION TIME=",
                    content[blockstarts[index]:blockends[index]],
                    value = TRUE)
    inttime <- gsub("^##\\.ACQUISITION TIME= ", "", inttime)
  }

  scope_inttime <- get_inttime(which(blocktype=="processed"))
  dark_inttime <- get_inttime(which(blocktype=="dark"))
  white_inttime <- get_inttime(which(blocktype=="reference"))

  get_avg <- function(index) {
    avg <- grep("^##\\.AVERAGES=",
                content[blockstarts[index]:blockends[index]],
                value = TRUE)
    avg <- gsub("^##\\.AVERAGES= ", "", avg)
  }

  scope_average <- get_avg(which(blocktype=="processed"))
  dark_average <- get_avg(which(blocktype=="dark"))
  white_average <- get_avg(which(blocktype=="reference"))

  get_boxcar <- function(index) {
    boxcar <- grep("^##DATA PROCESSING= BOXCAR:",
                   content[blockstarts[index]:blockends[index]],
                   value = TRUE)
    boxcar <- gsub("^##DATA PROCESSING= BOXCAR:([[:digit:]]+).*", "\\1", boxcar)
  }

  scope_boxcar <- get_boxcar(which(blocktype=="processed"))
  dark_boxcar <- get_boxcar(which(blocktype=="dark"))
  white_boxcar <- get_boxcar(which(blocktype=="reference"))

  metadata <- c(author, savetime, specmodel, specID,
                dark_inttime, white_inttime, scope_inttime,
                dark_average, white_average, scope_average,
                dark_boxcar, white_boxcar, scope_boxcar)


  get_data <- function(index) {
    # Data is contained in lines that do NOT start with ##
    data <- grep("^##", content[blockstarts[index]:blockends[index]],
                 value = TRUE, invert = TRUE)
    data <- strsplit(data, ",")
    data <- do.call(rbind, data)
  }

  scope_data <- get_data(which(blocktype=="processed"))
  dark_data <- get_data(which(blocktype=="dark"))
  white_data <- get_data(which(blocktype=="reference"))

  data <- cbind(scope_data[,1], dark_data[,2], white_data[,2], scope_data[,2])
  colnames(data) <- c("wl", "dark", "white", "scope")
  data <- data.frame(apply(data, 2, as.numeric))
  data$processed <- (data$scope - data$dark) / (data$white - data$dark) * 100

  return(list(data, metadata))

}
