context("multicore")

test_that("Multicores windows", {

  skip_if(.Platform$OS.type != "windows")

  expect_message(lr_get_spec(test.file(), ext = "jdx", cores = 2),
                 '"cores" set to 1.')

  expect_message(lr_get_metadata(test.file(), ext = "jdx", cores = 2),
                 '"cores" set to 1.')

})

test_that("Multicores/single core", {

  expect_equivalent(lr_get_spec(test.file(), ext = "jdx", cores = 2),
                    lr_get_spec(test.file(), ext = "jdx"))

  expect_equivalent(lr_get_metadata(test.file(), ext = "jdx", cores = 2),
                    lr_get_metadata(test.file(), ext = "jdx"))

})
