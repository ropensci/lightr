test_that("get_spec all", {

  expect_snapshot_value(
    lr_get_spec(test.file(),
                ext = c("TRM", "ttt", "jdx", "jaz", "JazIrrad", "csv", "txt",
                        "Transmission", "spc"),
                sep = ","),
    style = "serialize",
    cran = TRUE
  )

})

test_that("get_spec recursive", {

  # Recursive
  expect_snapshot_value(
    lr_get_spec(test.file(), ext = "ProcSpec", subdir = TRUE),
    style = "serialize",
    cran = TRUE
  )

})

test_that("get_spec range", {
  res <- lr_get_spec(test.file(), "ttt", lim = c(400,500))
  expect_identical(nrow(res), 101L)
})

test_that("get_spec interpolate", {
  expect_error(lr_get_spec(test.file("procspec_files"), ext = "ProcSpec",
                           interpolate = FALSE),
               "'interpolate = FALSE' can only work")

  res <- lr_get_spec(test.file("heliomaster"), ext = "jdx", interpolate = FALSE)

  expect_identical(nrow(res), 1992L)
})

test_that("get_spec warn/error", {
  # Total fail
  expect_warning(
    expect_null(lr_get_spec(test.file(), ext = "fail")),
    "File import failed"
  )

  # Partial fail
  expect_warning(
    lr_get_spec(test.file(), ext = c("fail", "jdx")),
    "Could not import one or more"
  )

  # Missing
  expect_warning(
    expect_null(lr_get_spec(ext = "missing")),
    "No files found"
  )

})
