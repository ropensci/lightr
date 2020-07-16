test_that("Multicores/single core", {

  suppressWarnings(
    expect_warning(lr_get_spec(test.file(), ext = "test", cores = 2),
                   "deprecated")
  )

  suppressWarnings(
    expect_warning(lr_get_metadata(test.file(), ext = "test", cores = 2),
                   "deprecated")
  )

  suppressWarnings(
    # Be careful here because lr_convert_tocsv() leaves breadcrumbs
    expect_warning(lr_convert_tocsv(test.file(), ext = "test", cores = 2),
                   "deprecated")
  )

})
