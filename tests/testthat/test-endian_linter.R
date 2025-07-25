skip_if_not_installed("lintr")

test_that("endian_linter skips allowed usages", {
  linter <- endian_linter()

  lintr::expect_no_lint('readBin(x, "integer", endian = "little")', linter)
  lintr::expect_no_lint('readBin(x, "integer", endian = "big")', linter)
  lintr::expect_no_lint('readBin(x, what = "raw")', linter)
  lintr::expect_no_lint('readBin(x, "raw")', linter)
  lintr::expect_no_lint('readBin(x, "integer", size = 1)', linter)
})

test_that("endian_linter blocks simple disallowed usages", {
  linter <- endian_linter()
  lint_message <- rex::rex("endian")

  lintr::expect_lint('readBin(x, "integer")', lint_message, linter)
  lintr::expect_lint('readBin(x, what = "integer")', lint_message, linter)
  lintr::expect_lint('readBin(x, "integer", size = 4)', lint_message, linter)
})
