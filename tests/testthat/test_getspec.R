context("get_spec")

test_that("get_spec all", {

  res <- get_spec(test.file(),
                  ext = c("TRM", "ttt", "jdx", "jaz", "JazIrrad", "csv", "txt",
                          "Transmission"),
                  sep = ",")
  expect_equal_to_reference(res, "known_output/getspec_all.rds")
})

test_that("get_spec recursive", {

  # Recursive
  res <- get_spec(test.file(), ext = "ProcSpec", subdir = TRUE)
  expect_equal_to_reference(res, "known_output/getspec_recursive.rds")

})

test_that("get_spec warn/error", {
  # Total fail
  totalfail <- expression({
    get_spec(test.file(),
            ext = "fail")
  })
  expect_warning(eval(totalfail), "File import failed")

  expect_null(suppressWarnings(eval(totalfail)))

  # Partial fail
  partialfail <- expression({
    get_spec(test.file(),
            ext = c("fail", "jdx"))
  })
  expect_warning(eval(partialfail), "Could not import one or more")

  # Missing
  missing <- expression({
    get_spec(ext = "missing")
  })
  expect_warning(eval(missing), "No files found")

  expect_null(suppressWarnings(eval(missing)))

})
