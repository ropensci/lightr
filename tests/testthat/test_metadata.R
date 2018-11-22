context("metadata")

test_that("Metadata", {

  res <- getmetadata(system.file("testdata", package = "lightr"),
	                   ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz", "JazIrrad"))
  expect_identical(nrow(res), 9L)

  # Recursive
  res <- getmetadata(system.file("testdata", package = "lightr"),
                     ext = "ProcSpec", subdir = TRUE)
  expect_identical(nrow(res), 3L)

  # Total fail
  totalfail <- expression({
    getmetadata(system.file("testdata", package = "lightr"),
                ext = "fail")
  })
  expect_warning(eval(totalfail), "File import failed")

  expect_null(suppressWarnings(eval(totalfail)))

  # Partial fail
  partialfail <- expression({
    getmetadata(system.file("testdata", package = "lightr"),
                ext = c("fail", "jdx"))
  })
  expect_warning(eval(partialfail), "Could not import one or more")

  # Missing
  missing <- expression({
    getmetadata(ext = "missing")
  })
  expect_warning(eval(missing), "No files found")

  expect_null(suppressWarnings(eval(missing)))

})
