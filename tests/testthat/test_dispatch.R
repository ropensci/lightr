context("dispatch_parser")

test_that("Fallback", {

  expect_equal(
    parse_generic(test.file("spec.csv"), sep = ","),
    dispatch_parser(test.file("spec.csv"), decimal = ".", sep = ",")
  )
})
