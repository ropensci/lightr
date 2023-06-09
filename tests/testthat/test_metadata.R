test_that("get_metadata all", {

  expect_message(
    expect_snapshot_value(
      lr_get_metadata(
        test.file(),
        ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz", "JazIrrad")
      ),
      style = "json2"
    ),
    "9 files"
  )

})

test_that("get_metadata recursive", {

  # Recursive
  expect_message(
    expect_snapshot_value(
      lr_get_metadata(test.file(), ext = "ProcSpec", subdir = TRUE),
      style = "json2"
    ),
    "5 files"
  )

})

test_that("get_metadata warn & error", {
  # Total fail
  expect_warning(
    expect_warning(
      expect_message(expect_null(lr_get_metadata(test.file(), ext = "fail"))),
      "File import failed"
    ),
    "different value for 'sep'"
  )

  # Partial fail
  expect_warning(
    expect_warning(
      expect_message(lr_get_metadata(test.file(), ext = c("fail", "jdx"))),
      "Could not import one or more"
    ),
    "different value for 'sep'"
  )

  # Missing
  expect_warning(
    expect_null(lr_get_metadata(ext = "missing")),
    "No files found"
  )

})
