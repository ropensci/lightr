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
    expect_silent(lr_parse_jdx(test.file("OceanOptics_period.jdx"))),
    "64a8240578"
  )

  expect_known_hash(
    expect_silent(lr_parse_jdx(test.file("non_english", "OceanOptics_comma.jdx"))),
    "4bd646e438"
  )

  expect_known_hash(
    expect_silent(lr_parse_spc(test.file("OceanOptics.spc"))),
    "6f8bbc1429"
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
    expect_silent(lr_parse_jaz(test.file("non_english", "OO_comma.txt"))),
    "6c26f981e1"
  )

})

test_that("Avantes", {

  expect_known_hash(
    expect_silent(lr_parse_roh(test.file("avantes_reflect.ROH"))),
    "08283ca249"
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
    "e600162aba"
  )

  # White reference file
  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("1305084U1.REF"))),
    "824e4331cd"
  )

  rfl8_1_implicit <- expect_warning(
    lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8")),
    "argument is missing"
  )
  rfl8_1 <- expect_silent(
    lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"), specnum = 1)
  )

  expect_identical(rfl8_1_implicit, rfl8_1)

  expect_known_hash(rfl8_1, "f844ad5fb5")

  expect_known_hash(
    expect_silent(lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"),
                                specnum = 2)),
    "29e0a49aed"
  )

  expect_error(
    lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"), specnum = 5),
    "'specnum' is larger"
  )

})

test_that("CRAIC", {

  expect_known_hash(
    expect_silent(lr_parse_spc(test.file("compare", "CRAIC", "CRAIC.spc"))),
    "4fb2c8a868"
  )

})

test_that("Generic", {

  expect_error(lr_parse_generic(test.file("spec.csv")), "Parsing failed.")

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("spec.csv"), sep = ",")),
    "4fe5a89ddb"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("RS-1.dpt"), sep = ",")),
    "e9a4c7cf15"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("irr_820_1941.IRR"))),
    "7709b0faa3"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("compare", "CRAIC", "CRAIC.txt"))),
    "91f4cc5696"
  )

  # These files are better suited to more specific parsers but are dispatched
  # here by default

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("non_english", "OceanView_nonEN.txt"), decimal = ",")),
    "d3d5283824"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("non_english", "OO_comma.txt"), decimal = ",")),
    "7bb9eb694a"
  )


})
