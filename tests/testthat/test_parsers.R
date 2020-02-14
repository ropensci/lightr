context("parsers")

test_that("OceanOptics", {

  expect_known_hash(
    expect_silent(lr_parse_procspec(test.file("procspec_files", "OceanOptics_Linux.ProcSpec"))),
    "4a3b24e17d"
  )

  expect_known_hash(
    expect_silent(lr_parse_procspec(test.file("procspec_files", "OceanOptics_Windows.ProcSpec"))),
    "2e4d05a0e8"
  )

  expect_known_hash(
    expect_silent(lr_parse_procspec(test.file("procspec_files", "OceanOptics_badencode.ProcSpec"))),
    "3474bf01db"
  )

  expect_known_hash(
    expect_silent(lr_parse_jdx(test.file("OceanOptics.jdx"))),
    "64a8240578"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("jazspec.jaz"))),
    "8af6858198"
  )

  expect_known_hash(
    expect_silent(lr_parse_jazirrad(test.file("irrad.JazIrrad"))),
    "1e71c660d6"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("FMNH6834.00000001.Master.Transmission"))),
    "b95ed8922c"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("UK5.txt"))),
    "026afbfbd8"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("OO_comma.txt"))),
    "6c26f981e1"
  )

})

test_that("Avantes", {

  expect_known_hash(
    expect_silent(lr_parse_roh(test.file("avantes_reflect.ROH"))),
    "c0d5f0efea"
  )

  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("avantes_trans.TRM"))),
    "7264ef8eaa"
  )

  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("avantes2.TRM"))),
    "0b261983d9"
  )

  expect_known_hash(
    expect_silent(lr_parse_ttt(test.file("avantes_export.ttt"))),
    "959c7de9c4"
  )

  expect_known_hash(
    expect_silent(lr_parse_ttt(test.file("avantes_export_long.ttt"))),
    "268d0c6203"
  )

  expect_known_hash(
    expect_silent(lr_parse_trt(test.file("avantes_export2.trt"))),
    "578a1ea3e8"
  )

  # Dark reference file
  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("1305084U1.DRK"))),
    "c99c81aa5e"
  )

  # White reference file
  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("1305084U1.REF"))),
    "4f9ce28d1e"
  )

})

test_that("Generic", {

  expect_error(lr_parse_generic(test.file("spec.csv")), "Parsing failed.")

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("spec.csv"), sep = ",")),
    "84908426d7"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("RS-1.dpt"), sep = ",")),
    "53771afc43"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("notest", "OceanView_nonEN.txt"), decimal = ",")),
    "243c174dbb"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("irr_820_1941.IRR"))),
    "d9d50623ee"
  )

})
