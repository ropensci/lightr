## -----------------------------------------------------------------------------
library(lightr)

## -----------------------------------------------------------------------------
res <- lr_get_spec(where = "data", ext = "ttt", lim = c(300, 700))
head(res)

## -----------------------------------------------------------------------------
res <- lr_get_spec(where = "data", ext = c("ttt", "trt"), lim = c(300, 700))
head(res)

## -----------------------------------------------------------------------------
res <- lr_get_spec(where = "data", ext = "procspec", lim = c(300, 700), subdir = TRUE)
head(res)

## -----------------------------------------------------------------------------
res <- lr_get_spec(where = "data", ext = "procspec", subdir = TRUE, ignore.case = FALSE)

## -----------------------------------------------------------------------------
res <- lr_get_spec(where = file.path("data", "puffin"), ext = "procspec", interpolate = FALSE)
head(res)

## -----------------------------------------------------------------------------
res <- lr_get_metadata(where = "data", ext = c("trt", "procspec"), subdir = TRUE)
head(res)

## -----------------------------------------------------------------------------
#  lr_convert_tocsv(where = "data", ext = "procspec", subdir = TRUE)

