library(lightR)
context("metadata")

test_that("Metadata", {

  res <- getmetadata(system.file("testdata", package = "lightR"),
	             ext = c("TRM", "ROH", "ProcSpec", "ttt", "trt", "jdx"))
  expect_length(rownames(res), 10)

})
