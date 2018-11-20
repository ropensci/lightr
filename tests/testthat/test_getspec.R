library(lightR)
context("metadata")

test_that("Spectra import", {

  res <- getspec(system.file("testdata", package = "lightR"),
    ext = c("TRM", "ROH", "ProcSpec", "ttt", "trt", "jdx", "jaz", "JazIrrad"))

  expect_length(res, 10)

})
