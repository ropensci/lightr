context("get_metadata")

test_that("get_metadata all", {

  res <- lr_get_metadata(
    test.file(),
    ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz", "JazIrrad")
  )
  expect_known_hash(res, "c585251bd0")

})

test_that("get_metadata recursive", {

  # Recursive
  res <- lr_get_metadata(test.file(),
                     ext = "ProcSpec", subdir = TRUE)
  expect_known_hash(res, "f82ad88fb1")
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
