context("dispatch_parser")

test_that("Fallback", {

  expect_equal(
    lr_parse_generic(test.file("spec.csv"), sep = ","),
    dispatch_parser(test.file("spec.csv"), sep = ",")
  )

  expect_equal(
    lr_parse_jdx(test.file("OceanOptics_period.jdx")),
    dispatch_parser(test.file("OceanOptics_period.jdx"))
  )

  expect_equal(
    lr_parse_jaz(test.file("jazspec.jaz")),
    dispatch_parser(test.file("jazspec.jaz"))
  )

  expect_equal(
    lr_parse_jazirrad(test.file("irrad.JazIrrad")),
    dispatch_parser(test.file("irrad.JazIrrad"))
  )

  expect_equal(
    lr_parse_roh(test.file("avantes_reflect.ROH")),
    dispatch_parser(test.file("avantes_reflect.ROH"))
  )

  expect_equal(
    lr_parse_trm(test.file("avantes_trans.TRM")),
    dispatch_parser(test.file("avantes_trans.TRM"))
  )

  expect_equal(
    lr_parse_ttt(test.file("avantes_export.ttt")),
    dispatch_parser(test.file("avantes_export.ttt"))
  )

  expect_equal(
    lr_parse_trt(test.file("avantes_export2.trt")),
    dispatch_parser(test.file("avantes_export2.trt"))
  )

  expect_equal(
    lr_parse_spc(test.file("compare/CRAIC/CRAIC.spc")),
    dispatch_parser(test.file("compare/CRAIC/CRAIC.spc"))
  )

  expect_equal(
    lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"), specnum = 1),
    dispatch_parser(test.file("compare", "Avantes", "feather.RFL8"), specnum = 1)
  )

})

test_that("Similar output for all parsers", {

  files <- list.files(system.file("testdata", package = "lightr"),
                      recursive = TRUE, include.dirs = TRUE)
  files <- files[!tools::file_ext(files) %in% c("", "fail", "DRK", "REF")]

  lapply(files, function(file) {
    res <- expect_silent(dispatch_parser(test.file(file), sep = ",", specnum = 1))
    expect_length(res, 2)
    expect_is(res[[1]], "data.frame")
    expect_true(all(apply(res[[1]], 2, is.numeric)))
    expect_named(res[[1]], c("wl", "dark", "white", "scope", "processed"))
    expect_length(res[[2]], 13)
    expect_is(res[[2]], "character")
  })

})
