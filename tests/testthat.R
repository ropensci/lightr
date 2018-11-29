library(testthat)
library(lightr)

test.file <- function(...) {
  system.file("testdata", ..., package = "lightr")
}

test_check("lightr")
