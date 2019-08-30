context("parsers")

test_that("OceanOptics", {

  expect_length(parse_procspec(test.file("procspec_files",
                                         "OceanOptics_Linux.ProcSpec")),
                2)

  expect_length(parse_procspec(test.file("procspec_files",
                                         "OceanOptics_Windows.ProcSpec")),
                2)

  expect_length(parse_procspec(test.file("procspec_files",
                                         "OceanOptics_badencode.ProcSpec")),
                2)

  expect_length(parse_jdx(test.file("OceanOptics.jdx")),
                2)

  expect_length(parse_jaz(test.file("jazspec.jaz")),
                2)

  expect_length(parse_jazirrad(test.file("irrad.JazIrrad")),
                2)

  expect_length(parse_jaz(test.file("FMNH6834.00000001.Master.Transmission")),
                2)

  expect_length(parse_jaz(test.file("UK5.txt")),
                2)
})

test_that("Avantes", {

  expect_length(parse_roh(test.file("avantes_reflect.ROH")),
                2)

  expect_length(parse_trm(test.file("avantes_trans.TRM")),
                2)

  expect_length(parse_trm(test.file("avantes2.TRM")),
                2)

  expect_length(parse_ttt(test.file("avantes_export.ttt")),
                2)

  expect_length(parse_ttt(test.file("avantes_export_long.ttt")),
                2)

  expect_length(parse_trt(test.file("avantes_export2.trt")),
                2)
})

test_that("Generic", {

  expect_error(parse_generic(test.file("spec.csv")), "Parsing failed.")

  expect_length(parse_generic(test.file("spec.csv"), sep = ","),
                2)

  expect_length(parse_generic(test.file("RS-1.dpt"), sep = ","),
                2)
})
