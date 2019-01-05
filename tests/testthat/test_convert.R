context("convert_tocsv")

# Create temp environment to run tests
setup(dir.create("conversion_test"))
setup(file.copy(from = list.files(test.file(),
                                  full.names = TRUE),
                to = "conversion_test", recursive = TRUE))
setup(dir.create("conversion_test/csv"))
setup(file.rename("conversion_test/spec.csv",
                  "conversion_test/csv/spec.csv"))

teardown(unlink("conversion_test", recursive = TRUE))

test_that("Convert all", {

  exts <- c("TRM", "ttt", "jdx", "jaz", "JazIrrad", "txt", "Transmission")

  converted_files <- convert_tocsv("conversion_test", ext = exts)

  input_files <- tools::list_files_with_exts("conversion_test", exts)

  output_files <- tools::list_files_with_exts("conversion_test", "csv")

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

  convert_tocsv("conversion_test", ext = "ProcSpec", subdir = TRUE)

  input_files <- tools::list_files_with_exts("conversion_test/procspec_files",
                                             "ProcSpec")

  output_files <- tools::list_files_with_exts("conversion_test/procspec_files",
                                              "csv")


  expect_setequal(tools::file_path_sans_ext(input_files),
                  tools::file_path_sans_ext(output_files))
})

test_that("Convert csv", {

  expect_warning(convert_tocsv("conversion_test/csv", ext = "csv", sep = ","))

  spec2csv("conversion_test/csv", ext = "csv", sep = ",", overwrite = TRUE)

})


test_that("Convert warn/error", {
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
    convert_tocsv(ext = "missing")
  })
  expect_warning(eval(missing), "No files found")

  expect_null(suppressWarnings(eval(missing)))

})
