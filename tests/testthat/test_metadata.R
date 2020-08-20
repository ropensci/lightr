test_that("get_metadata all", {

  expect_snapshot_value(
    expect_message(
      lr_get_metadata(
        test.file(),
        ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz", "JazIrrad")
      ),
      "9 files"
    ),
    style = "json2"
  )

})

test_that("get_metadata recursive", {

  # Recursive
  expect_snapshot_value(
    expect_message(
      lr_get_metadata(test.file(), ext = "ProcSpec", subdir = TRUE),
      "5 files"
    ),
    style = "json2"
  )

})

test_that("get_metadata warn/error", {
  # Total fail
  expect_warning(
    expect_message(expect_null(lr_get_metadata(test.file(), ext = "fail"))),
    "File import failed"
  )

  # Partial fail
  expect_warning(
    expect_message(lr_get_metadata(test.file(), ext = c("fail", "jdx"))),
    "Could not import one or more"
  )

  # Missing
  expect_warning(
    expect_null(lr_get_metadata(ext = "missing")),
    "No files found"
  )

})
