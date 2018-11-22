context("multicore")

test_that("Multicores", {

  skip_if(.Platform$OS.type != "windows")

  expect_message(getspec(system.file("testdata", package = "lightr"),
                         ext = "jdx", cores = 2),
                 '"cores" set to 1.')

  expect_message(getmetadata(system.file("testdata", package = "lightr"),
                             ext = "jdx", cores = 2),
                 '"cores" set to 1.')

})
