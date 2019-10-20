test_that("compare procspec/spectrasuite", {

  specs <- lr_get_spec(test.file("puffin"), ext = "ProcSpec")
  specs_spectrasuite <- lr_get_spec(test.file("puffin"), ext = "txt")

  expect_equal(specs, specs_spectrasuite, tol = 1e-4)
})
