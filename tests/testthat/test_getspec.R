library(lightR)
context("metadata")

test_that("Spectra import", {

  res <- getspec(system.file("testdata", package = "lightR"),
		 ext = c("TRM", "jdx", "ProcSpec"))
  expect_length(res, 7)

})
