test_that("get_spec all", {
  expect_snapshot(
    lr_get_spec(
      test.file(),
      ext = c(
        "TRM",
        "ttt",
        "jdx",
        "jaz",
        "JazIrrad",
        "csv",
        "txt",
        "Transmission",
        "spc"
      )
    ),
    cran = TRUE
  )
})

test_that("get_spec recursive", {
  expect_snapshot(
    lr_get_spec(test.file(), ext = "ProcSpec", subdir = TRUE),
    cran = TRUE
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
  expect_snapshot(
    lr_get_spec(
      test.file("procspec_files"),
      ext = "ProcSpec",
      interpolate = FALSE
    ),
    error = TRUE,
    cran = TRUE
  )

  expect_message(
    res <- lr_get_spec(
      test.file("heliomaster"),
      ext = "jdx",
      interpolate = FALSE
    ),
    "4 files"
  )

  expect_identical(nrow(res), 1992L)
})

test_that("get_spec mixed csv and tabular format", {
  tdir <- file.path(tempdir(), "csv_mixed")

  expect_warning(expect_warning(expect_warning(
    expect_message(
      spec <- lr_get_spec(
        tdir,
        ext = c(
          "txt",
          "csv"
        )
      ),
      "files found"
    ),
    "Could not import"
  )))

  expect_identical(dim(spec), c(401L, 2L))
})

test_that("get_spec warn & error", {
  # Total fail
  expect_warning(
    expect_warning(
      expect_message(expect_null(lr_get_spec(test.file(), ext = "fail"))),
      "File import failed"
    ),
    "different value for 'sep'"
  )

  # Partial fail
  expect_warning(
    expect_warning(
      expect_message(lr_get_spec(test.file(), ext = c("fail", "jdx"))),
      "Could not import one or more"
    ),
    "different value for 'sep'"
  )

  # Missing
  expect_warning(
    expect_null(lr_get_spec(ext = "missing")),
    "No files found"
  )

  expect_warning(
    expect_warning(
      expect_null(lr_get_spec(
        test.file(),
        ext = "jdx",
        lim = c(10, 50),
        interpolate = TRUE
      )),
      "wl range"
    )
  )
})
