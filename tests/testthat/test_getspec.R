test_that("get_spec all", {

  # Tolerance is required for tests on Solaris
  expect_message(
    expect_snapshot_value(
      lr_get_spec(test.file(),
                  ext = c("TRM", "ttt", "jdx", "jaz", "JazIrrad", "csv", "txt",
                          "Transmission", "spc"),
                  sep = ","),

      style = "serialize",
      cran = TRUE,
      tolerance = 1e-10
    ),
    "16 files"
  )

})

test_that("get_spec recursive", {

  # Tolerance is required for tests on Solaris
  expect_message(
    expect_snapshot_value(
      lr_get_spec(test.file(), ext = "ProcSpec", subdir = TRUE),
      style = "serialize",
      cran = TRUE,
      tolerance = 1e-10
    ),
    "5 files"
  )

})

test_that("get_spec range", {
  expect_message(
    res <- lr_get_spec(test.file(), "ttt", lim = c(400, 500)),
    "2 files"
  )
  expect_identical(nrow(res), 101L)
})

test_that("get_spec interpolate", {
  expect_error(
    expect_message(lr_get_spec(test.file("procspec_files"), ext = "ProcSpec",
                               interpolate = FALSE)),
    "'interpolate = FALSE' can only work"
  )

  expect_message(
    res <- lr_get_spec(test.file("heliomaster"), ext = "jdx", interpolate = FALSE),
    "4 files"
  )

  expect_identical(nrow(res), 1992L)
})

test_that("get_spec warn & error", {
  # Total fail
  expect_warning(
    expect_message(expect_null(lr_get_spec(test.file(), ext = "fail"))),
    "File import failed"
  )

  # Partial fail
  expect_warning(
    expect_message(lr_get_spec(test.file(), ext = c("fail", "jdx"))),
    "Could not import one or more"
  )

  # Missing
  expect_warning(
    expect_null(lr_get_spec(ext = "missing")),
    "No files found"
  )

  expect_warning(
    expect_warning(
      expect_null(lr_get_spec(test.file(), ext = "jdx", lim = c(10, 50), interpolate = TRUE)),
      "wl range"
    )
  )

})
