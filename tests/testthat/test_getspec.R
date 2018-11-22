context("metadata")

test_that("Spectra import", {

  res <- getspec(system.file("testdata", package = "lightr"),
                 ext = c("TRM", "ttt", "jdx", "jaz", "JazIrrad", "csv"), sep = ",")
  expect_identical(ncol(res), 9L)

  # Recursive
  res <- getspec(system.file("testdata", package = "lightr"),
                 ext = "ProcSpec", subdir = TRUE)
  expect_identical(ncol(res), 4L)

  # Total fail
  totalfail <- expression({
    getspec(system.file("testdata", package = "lightr"),
            ext = "fail")
  })
  expect_warning(eval(totalfail), "Could not import spectra")

  expect_null(suppressWarnings(eval(totalfail)))

  # Partial fail
  partialfail <- expression({
    getspec(system.file("testdata", package = "lightr"),
            ext = c("fail", "jdx"))
  })
  expect_warning(eval(partialfail), "Could not import one or more")

  # Missing
  missing <- expression({
    getspec(ext = "missing")
  })
  expect_warning(eval(missing), "No files found")

  expect_null(suppressWarnings(eval(missing)))

})
