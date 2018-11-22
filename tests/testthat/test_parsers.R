library(lightR)
context("parsers")

test_that("Parsers", {

  # OceanOptics

  expect_length(parse_procspec(system.file("testdata", "prospec_files", "OceanOptics_Linux.ProcSpec", package = "lightR")),
                2)

  expect_length(parse_procspec(system.file("testdata", "prospec_files", "OceanOptics_Windows.ProcSpec", package = "lightR")),
                2)

  expect_length(parse_procspec(system.file("testdata", "prospec_files", "OceanOptics_badencode.ProcSpec", package = "lightR")),
                2)

  expect_length(parse_jdx(system.file("testdata", "OceanOptics_jcamp-dx.jdx", package = "lightR")),
                2)

  expect_length(parse_jaz(system.file("testdata", "jazspec.jaz", package = "lightR")),
                2)

  expect_length(parse_jazirrad(system.file("testdata", "irrad.JazIrrad", package = "lightR")),
                2)

  # Avantes

  expect_length(parse_roh(system.file("testdata", "avantes_reflect.ROH", package = "lightR")),
                2)

  expect_length(parse_trm(system.file("testdata", "avantes_trans.TRM", package = "lightR")),
                2)

  expect_length(parse_trm(system.file("testdata", "avantes2.TRM", package = "lightR")),
                2)

  expect_length(parse_ttt(system.file("testdata", "avantes_export.ttt", package = "lightR")),
                2)

  expect_length(parse_ttt(system.file("testdata", "avantes_export_long.ttt", package = "lightR")),
                2)

  expect_length(parse_trt(system.file("testdata", "avantes_export2.trt", package = "lightR")),
                2)

  # Generic

  expect_error(parse_generic(system.file("testdata", "spec.csv", package = "lightR")))

  expect_length(parse_generic(system.file("testdata", "spec.csv", package = "lightR"), sep = ","),
                2)

})
