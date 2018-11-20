library(lightR)
context("metadata")

test_that("Spectra import", {

  res <- getspec(system.file("testdata", package = "lightR"),
    ext = c("TRM", "ProcSpec", "ttt", "jdx", "jaz", "JazIrrad"))

  expect_length(res, 11)

})
