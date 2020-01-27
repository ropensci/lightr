context("multicore")

test_that("Multicores/single core", {

  expect_warning(lr_get_spec(test.file(), ext = "jdx", cores = 2),
                 "deprecated")

  expect_warning(lr_get_metadata(test.file(), ext = "jdx", cores = 2),
                 "deprecated")

  expect_warning(lr_convert_tocsv(test.file(), ext = "jdx", cores = 2),
                 "deprecated")

})
