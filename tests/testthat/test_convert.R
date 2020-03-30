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

  unlink(output_files)

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

  unlink(output_files)

})

test_that("Convert csv", {
  tdir <- tempdir()

  expect_warning(lr_convert_tocsv(file.path(tdir, "csv"), ext = "csv",
                                  sep = ","))

  output <- expect_message(
    lr_convert_tocsv(file.path(tdir, "csv"), ext = "csv", sep = ",",
                     overwrite = TRUE),
    "files found"
  )

  unlink(output)

})


test_that("Convert warn/error", {
  tdir <- tempdir()
  # Total fail
  expect_warning(
    expect_null(lr_convert_tocsv(tdir, ext = "fail")),
    "File import failed"
  )

  # Partial fail
  output <- expect_warning(
    lr_convert_tocsv(tdir, ext = c("fail", "jdx"), overwrite = TRUE),
    "Could not import one or more"
  )

  unlink(output)

  # Missing
  expect_warning(
    expect_null(lr_convert_tocsv(where = getwd(), ext = "missing")),
    "No files found"
  )

  expect_warning(
    expect_null(lr_convert_tocsv()),
    "Please provide a valid location"
  )

})
