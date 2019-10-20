context("get_metadata")

test_that("get_metadata all", {

  res <- lr_get_metadata(
    test.file(),
	  ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz", "JazIrrad")
  )
  expect_known_value(res, "known_output/getmetadata_all.rds")

})

test_that("get_metadata recursive", {

  # Recursive
  res <- lr_get_metadata(test.file(),
                     ext = "ProcSpec", subdir = TRUE)
  expect_known_value(res, "known_output/getmetadata_recursive.rds")
})

test_that("get_metadata warn/error", {
  # Total fail
  totalfail <- expression({
    lr_get_metadata(test.file(),
                ext = "fail")
  })
  expect_warning(eval(totalfail), "File import failed")

  expect_null(suppressWarnings(eval(totalfail)))

  # Partial fail
  partialfail <- expression({
    lr_get_metadata(test.file(),
                ext = c("fail", "jdx"))
  })
  expect_warning(eval(partialfail), "Could not import one or more")

  # Missing
  missing <- expression({
    lr_get_metadata(ext = "missing")
  })
  expect_warning(eval(missing), "No files found")

  expect_null(suppressWarnings(eval(missing)))

})
