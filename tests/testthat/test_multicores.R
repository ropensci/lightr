context("multicore")

test_that("Multicores/single core", {

  expect_equivalent(lr_get_spec(test.file(), ext = "jdx", cores = 2),
                    lr_get_spec(test.file(), ext = "jdx"))

  expect_equivalent(lr_get_metadata(test.file(), ext = "jdx", cores = 2),
                    lr_get_metadata(test.file(), ext = "jdx"))

})
