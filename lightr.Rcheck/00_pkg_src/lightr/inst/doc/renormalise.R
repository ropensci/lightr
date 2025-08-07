## -----------------------------------------------------------------------------
library(lightr)

## -----------------------------------------------------------------------------
reflect_data <- lr_parse_oceanoptics_procspec(
  system.file("testdata", "procspec_files", "OceanOptics_Linux.ProcSpec",
               package = "lightr")
  )
length(reflect_data)

## -----------------------------------------------------------------------------
head(reflect_data[[1]])

## -----------------------------------------------------------------------------
white_data <- lr_parse_oceanoptics_procspec(
  system.file("testdata", "procspec_files", "whiteref.ProcSpec",
               package = "lightr")
)

## -----------------------------------------------------------------------------
reflect_data <- data.frame(reflect_data[[1]])
white_data <- data.frame(white_data[[1]])

## -----------------------------------------------------------------------------
all.equal(reflect_data$wl, white_data$wl)

## -----------------------------------------------------------------------------
res <- (reflect_data$scope - reflect_data$dark) / (white_data$white - white_data$dark)
head(res)

