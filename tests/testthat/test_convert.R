test_that("Convert all", {

  tdir <- file.path(tempdir(), "test_convert")

  exts <- c("TRM", "ttt", "jdx", "jaz", "JazIrrad", "txt", "Transmission")

  converted_files <- expect_message(
    lr_convert_tocsv(tdir, ext = exts, sep = ","),
    "14 files"
  )

  input_files <- tools::list_files_with_exts(tdir, exts)

  output_data_files <- list.files(tdir, "[^metadata]\\.csv$")
  output_metadata_files <- list.files(tdir, "_metadata\\.csv$")

  # File names are kept
  expect_setequal(!!tools::file_path_sans_ext(input_files),
                  !!tools::file_path_sans_ext(output_data_files))

  # Output file names are invisibly returned
  expect_setequal(!!basename(converted_files),
                  !!basename(output_data_files))

  expect_true(all(do.call(output_metadata_files, file.exists)))

  # It doesn't change the behaviour of getspec
#  expect_equal(getspec("conversion_test", exts),
#               getspec("conversion_test", "csv", sep = ","))

  unlink(output_files)

})

test_that("Convert recursive", {

  tdir <- file.path(tempdir(), "test_convert")

  expect_message(
    lr_convert_tocsv(tdir, ext = "ProcSpec", subdir = TRUE),
    "5 files"
  )

  input_files <- tools::list_files_with_exts(file.path(tdir, "procspec_files"),
                                             "ProcSpec")

  output_files <- tools::list_files_with_exts(file.path(tdir, "procspec_files"),
                                              "csv")


  expect_setequal(tools::file_path_sans_ext(input_files),
                  tools::file_path_sans_ext(output_files))

  unlink(output_files)

})

test_that("Convert csv", {

  tdir <- file.path(tempdir(), "test_convert")

  expect_warning(
    expect_message(lr_convert_tocsv(file.path(tdir, "csv"), ext = "csv", sep = ","))
  )

  output <- expect_message(
    lr_convert_tocsv(file.path(tdir, "csv"), ext = "csv", sep = ",",
                     overwrite = TRUE),
    "files found"
  )

  unlink(output)

})


test_that("Convert warn/error", {

  tdir <- file.path(tempdir(), "test_convert")
  # Total fail
  expect_warning(
    expect_message(expect_null(lr_convert_tocsv(tdir, ext = "fail"))),
    "File import failed"
  )

  # Partial fail
  output <- expect_warning(
    expect_message(lr_convert_tocsv(tdir, ext = c("fail", "jdx"), overwrite = TRUE)),
    "Could not import one or more"
  )

  unlink(output)

  # Missing
  expect_warning(
    expect_null(lr_convert_tocsv(where = tdir, ext = "missing")),
    "No files found"
  )

  expect_warning(
    expect_null(lr_convert_tocsv()),
    "Please provide a valid location"
  )

})
