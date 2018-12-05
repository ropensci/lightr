context("dispatch_parser")

test_that("Fallback", {

  expect_equal(
    parse_generic(test.file("spec.csv"), sep = ","),
    dispatch_parser(test.file("spec.csv"), sep = ",")
  )

  expect_equal(
    parse_jdx(test.file("OceanOptics.jdx")),
    dispatch_parser(test.file("OceanOptics.jdx"))
  )

  expect_equal(
    parse_jaz(test.file("jazspec.jaz")),
    dispatch_parser(test.file("jazspec.jaz"))
  )

  expect_equal(
    parse_jazirrad(test.file("irrad.JazIrrad")),
    dispatch_parser(test.file("irrad.JazIrrad"))
  )

  expect_equal(
    parse_roh(test.file("avantes_reflect.ROH")),
    dispatch_parser(test.file("avantes_reflect.ROH"))
  )

  expect_equal(
    parse_trm(test.file("avantes_trans.TRM")),
    dispatch_parser(test.file("avantes_trans.TRM"))
  )

  expect_equal(
    parse_ttt(test.file("avantes_export.ttt")),
    dispatch_parser(test.file("avantes_export.ttt"))
  )

  expect_equal(
    parse_trt(test.file("avantes_export2.trt")),
    dispatch_parser(test.file("avantes_export2.trt"))
  )

})

test_that("Similar output for all parsers", {

  files <- list.files(system.file("testdata", package = "lightr"),
                      recursive = TRUE, include.dirs = TRUE)
  files <- files[!tools::file_ext(files) %in% c("", "fail")]

  lapply(files, function(file) {
    res <- dispatch_parser(test.file(file), sep = ",")
    expect_length(res, 2)
    expect_is(res[[1]], "data.frame")
    expect_true(all(apply(res[[1]], 2, is.numeric)))
  })

})
