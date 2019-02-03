context("multicore")

test_that("Multicores", {

  skip_if(.Platform$OS.type != "windows")

  expect_message(get_spec(system.file("testdata", package = "lightr"),
                         ext = "jdx", cores = 2),
                 '"cores" set to 1.')

  expect_message(get_metadata(system.file("testdata", package = "lightr"),
                             ext = "jdx", cores = 2),
                 '"cores" set to 1.')

})
