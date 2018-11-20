library(lightR)
context("metadata")

test_that("Metadata", {

  res <- getmetadata(system.file("testdata", package = "lightR"),
	             ext = c("TRM", "ROH", "ProcSpec", "ttt", "trt", "jdx", "jaz", "JazIrrad"))
  expect_length(rownames(res), 12)

})
