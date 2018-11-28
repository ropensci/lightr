context("parsers")

test_that("Parsers", {

  # OceanOptics

  expect_length(parse_procspec(system.file("testdata", "procspec_files", "OceanOptics_Linux.ProcSpec", package = "lightr")),
                2)

  expect_length(parse_procspec(system.file("testdata", "procspec_files", "OceanOptics_Windows.ProcSpec", package = "lightr")),
                2)

  expect_length(parse_procspec(system.file("testdata", "procspec_files", "OceanOptics_badencode.ProcSpec", package = "lightr")),
                2)

  expect_length(parse_jdx(system.file("testdata", "OceanOptics.jdx", package = "lightr")),
                2)

  expect_length(parse_jaz(system.file("testdata", "jazspec.jaz", package = "lightr")),
                2)

  expect_length(parse_jazirrad(system.file("testdata", "irrad.JazIrrad", package = "lightr")),
                2)

  expect_length(parse_jaz(system.file("testdata", "FMNH6834.00000001.Master.Transmission", package = "lightr")),
                2)

  # Avantes

  expect_length(parse_roh(system.file("testdata", "avantes_reflect.ROH", package = "lightr")),
                2)

  expect_length(parse_trm(system.file("testdata", "avantes_trans.TRM", package = "lightr")),
                2)

  expect_length(parse_trm(system.file("testdata", "avantes2.TRM", package = "lightr")),
                2)

  expect_length(parse_ttt(system.file("testdata", "avantes_export.ttt", package = "lightr")),
                2)

  expect_length(parse_ttt(system.file("testdata", "avantes_export_long.ttt", package = "lightr")),
                2)

  expect_length(parse_trt(system.file("testdata", "avantes_export2.trt", package = "lightr")),
                2)

  # Generic

  expect_error(parse_generic(system.file("testdata", "spec.csv", package = "lightr")))

  expect_length(parse_generic(system.file("testdata", "spec.csv", package = "lightr"), sep = ","),
                2)

})
