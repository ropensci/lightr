test_that("endian is always present", {

  skip_on_cran()

  expect_true({
    r_files <- list.files("../../R", full.names = TRUE)
    all(vapply(r_files, function(f) {
      content <- readLines(f)
      rb_frags <- grep("readBin", content, value = TRUE)
      none_missing <- isTRUE(all(grepl("endian", rb_frags)))
    }, logical(1)))
  })

})
