library(lightR)
context("metadata")

test_that("Spectra import", {

  res <- getspec(system.file("testdata", package = "lightR"),
                 ext = c("TRM", "ttt", "jdx", "jaz", "JazIrrad"))
  expect_identical(ncol(res), 8L)

  res <- getspec(system.file("testdata", package = "lightR"),
                 ext = "ProcSpec", subdir = TRUE)
  expect_identical(ncol(res), 4L)


})
