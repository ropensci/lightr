library(lightR)
context("metadata")

test_that("Metadata", {

  res <- getmetadata(system.file("testdata", package = "lightR"),
	                   ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz", "JazIrrad"))
  expect_identical(nrow(res), 9L)

  res <- getmetadata(system.file("testdata", package = "lightR"),
                     ext = "ProcSpec", subdir = TRUE)
  expect_identical(nrow(res), 3L)

})
