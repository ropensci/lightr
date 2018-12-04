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

  files <- list("procspec_files/OceanOptics_Linux.ProcSpec",
                "procspec_files/OceanOptics_Windows.ProcSpec",
                "procspec_files/OceanOptics_badencode.ProcSpec",
                "OceanOptics.jdx",
                "jazspec.jaz",
                "irrad.JazIrrad",
                "FMNH6834.00000001.Master.Transmission")

  lapply(files, function(file) {
    res <- dispatch_parser(test.file(file))
    expect_length(res, 2)
    expect_is(res[[1]], "data.frame")
#    expect_is(res[[2]], "data.frame")
  })

})
