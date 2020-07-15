test_that("get_metadata all", {

  expect_snapshot_value(
    lr_get_metadata(
      test.file(),
      ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz", "JazIrrad")
    ),
    style = "json2"
  )

})

test_that("get_metadata recursive", {

  # Recursive
  expect_snapshot_value(
    lr_get_metadata(test.file(),
                    ext = "ProcSpec", subdir = TRUE),
    style = "json2"
  )

})

test_that("get_metadata warn/error", {
  # Total fail
  expect_warning(
    expect_null(lr_get_metadata(test.file(), ext = "fail")),
    "File import failed"
  )

  # Partial fail
  expect_warning(
    lr_get_metadata(test.file(), ext = c("fail", "jdx")),
    "Could not import one or more"
  )

  # Missing
  expect_warning(
    expect_null(lr_get_metadata(ext = "missing")),
    "No files found"
  )

})
