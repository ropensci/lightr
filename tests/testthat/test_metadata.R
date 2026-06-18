test_that("get_metadata all", {
  expect_snapshot(
    lr_get_metadata(
      test.file(),
      ext = c(
        "TRM",
        "ROH",
        "ttt",
        "trt",
        "jdx",
        "jaz",
        "JazIrrad",
        "spc"
      )
    ),
    cran = TRUE
  )
})

test_that("get_metadata recursive", {
  # Recursive
  expect_snapshot(
    lr_get_metadata(
      test.file(),
      ext = c("ProcSpec", "spc", "RFL8", "TRM"),
      subdir = TRUE
    ),
    cran = TRUE
  )
})

test_that("get_metadata custom parser", {
  test_dir <- withr::local_tempfile()
  dir.create(test_dir)
  file.copy(
    test.file("OOusb4000.txt"),
    test_dir
  )

  expect_snapshot(
    lr_get_metadata(test_dir, ext = "txt", parser = lr_parse_oceanoptics_jaz),
    cran = TRUE
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
