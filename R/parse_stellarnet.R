lr_parse_stellarnet_trm <- function(file, ...) {
  if (!file.exists(file)) {
    stop("File does not exist: ", file)
  }

  data <- read.table(
    file,
    header = FALSE,
    skip = 1,
    col.names = c("wl", "processed"),
    colClasses = c("numeric", "numeric")
  )
  data$dark <- data$white <- data$scope <- NA_real_

  header <- readLines(file, n = 2)
  version <- gsub("V\\s*[:=]\\s*", "", header[1], fixed = TRUE)
  metadata <- strsplit(header[[2]], "\\s*;\\s*")[[1]] |>
    strsplit("\\s*[:=]\\s*") |>
    mode <- metadata[[1]]
  settings <- do.call(rbind, metadata[-1]) |>
    as.data.frame(stringsAsFactors = FALSE) |>
    setNames(c("setting", "value"))

  # inttime unit can be formatted as:
  # - Time (ms)=100
  # - Time=100 ms
  inttime <- settings[startsWith(settings$setting, "Time"), "value"]
  avg <- settings[startsWith(settings$setting, "Avg"), "value"]
  sm <- settings[startsWith(settings$setting, "Sm"), "value"]
  device <- settings[startsWith(settings$setting, "Device"), "value"]

  metadata <- c(
    NA_character_, # author
    NA_character_, # savetime
    NA_character_, # specmodel
    device, # specID
    NA_character_, # dark_inttime
    NA_character_, # white_inttime
    inttime, # scope_inttime
    NA_character_, # dark_average
    NA_character_, # white_average
    avg, # scope_average
    NA_character_, # dark_boxcar
    NA_character_, # white_boxcar
    sm # scope_boxcar
  )

  list(
    data = data[, c("wl", "dark", "white", "scope", "processed")],
    metadata = metadata
  )
}
