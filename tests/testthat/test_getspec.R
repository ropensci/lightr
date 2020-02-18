context("get_spec")

test_that("get_spec all", {

  res <- lr_get_spec(test.file(),
                  ext = c("TRM", "ttt", "jdx", "jaz", "JazIrrad", "csv", "txt",
                          "Transmission", "spc"),
                  sep = ",")
  expect_known_value(res, "known_output/getspec_all.rds")
})

test_that("get_spec recursive", {

  # Recursive
  res <- lr_get_spec(test.file(), ext = "ProcSpec", subdir = TRUE)
  expect_known_value(res, "known_output/getspec_recursive.rds")

})

test_that("get_spec range", {
  res <- lr_get_spec(test.file(), "ttt", lim = c(400,500))
  expect_equal(nrow(res), 101)
})

test_that("get_spec interpolate", {
  expect_error(lr_get_spec(test.file("procspec_files"), ext = "ProcSpec",
                           interpolate = FALSE),
               "'interpolate = FALSE' can only work")

  res <- lr_get_spec(test.file("heliomaster"), ext = "jdx", interpolate = FALSE)

  expect_equal(nrow(res), 1992)
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
