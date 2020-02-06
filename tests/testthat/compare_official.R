test_that("compare procspec/spectrasuite", {

  # Compare result from custom parser (lr_parse_procspec) and official parser
  specs <- lr_get_spec(test.file("compare"), ext = "ProcSpec")
  specs_spectrasuite <- lr_get_spec(test.file("compare"), ext = "txt")

  expect_equal(specs, specs_spectrasuite, tol = 1e-4)
})

test_that("compare trm/ttt", {

  # Compare result from custom parser (lr_parse_trm) and official parser
  # - J_PIR_AVRIL2016_0001 uses Avasoft 6.0
  # - NEW0601 uses Avasoft 7.0

  specs <- lr_get_spec(test.file("compare"), ext = "TRM")
  specs_avasoft <- lr_get_spec(test.file("compare"), ext = "ttt")

  expect_equal(specs, specs_avasoft, tol = 1e-4)
})
