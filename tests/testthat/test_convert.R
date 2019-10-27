context("convert_tocsv")

# Create temp environment to run tests
setup({
  tdir <- tempdir()
  file.copy(from = list.files(test.file(),
                              full.names = TRUE),
            to = tdir, recursive = TRUE)
  dir.create(file.path(tdir, "csv"))
  file.rename(file.path(tdir, "spec.csv"),
              file.path(tdir, "csv", "spec.csv"))
})

teardown({
  unlink(tdir, recursive = TRUE)
})

test_that("Convert all", {
  tdir <- tempdir()

  exts <- c("TRM", "ttt", "jdx", "jaz", "JazIrrad", "txt", "Transmission")

  converted_files <- lr_convert_tocsv(tdir, ext = exts, sep = ",")

  input_files <- tools::list_files_with_exts(tdir, exts)

  output_files <- tools::list_files_with_exts(tdir, "csv")

  # File names are kept
  expect_setequal(tools::file_path_sans_ext(input_files),
                  tools::file_path_sans_ext(output_files))

  # Output file names are invisibly returned
  expect_setequal(converted_files, output_files)

  # It doesn't change the behaviour of getspec
#  expect_equal(getspec("conversion_test", exts),
#               getspec("conversion_test", "csv", sep = ","))

})

test_that("Convert recursive", {
  tdir <- tempdir()

  lr_convert_tocsv(tdir, ext = "ProcSpec", subdir = TRUE)

  input_files <- tools::list_files_with_exts(file.path(tdir, "procspec_files"),
                                             "ProcSpec")

  output_files <- tools::list_files_with_exts(file.path(tdir, "procspec_files"),
                                              "csv")


  expect_setequal(tools::file_path_sans_ext(input_files),
                  tools::file_path_sans_ext(output_files))
})

test_that("Convert csv", {
  tdir <- tempdir()

  expect_warning(lr_convert_tocsv(file.path(tdir, "csv"), ext = "csv",
                                  sep = ","))

  lr_convert_tocsv(file.path(tdir, "csv"), ext = "csv", sep = ",",
                   overwrite = TRUE)

})


test_that("Convert warn/error", {
  tdir <- tempdir()
  # Total fail
  # totalfail <- expression({
  #   spec2csv("conversion_test",
  #            ext = "fail")
  # })
  # expect_warning(eval(totalfail), "File import failed")
  #
  # expect_null(suppressWarnings(eval(totalfail)))
  #
  # # Partial fail
  # partialfail <- expression({
  #   spec2csv("conversion_test",
  #            ext = c("fail", "jdx"),
  #            overwrite = TRUE)
  # })
  # expect_warning(eval(partialfail), "Could not import one or more")

  # Missing
  missing <- expression({
    lr_convert_tocsv(ext = "missing")
  })
  expect_warning(eval(missing), "No files found")

  expect_null(suppressWarnings(eval(missing)))

})
