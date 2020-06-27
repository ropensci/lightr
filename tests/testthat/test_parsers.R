context("parsers")

test_that("OceanOptics", {

  skip_if_not(capabilities(what = "long.double"), "Skip on noLD")

  expect_known_hash(
    expect_silent(lr_parse_procspec(test.file("procspec_files", "OceanOptics_Linux.ProcSpec"))),
    "9857e34c56"
  )

  expect_known_hash(
    expect_silent(lr_parse_procspec(test.file("procspec_files", "OceanOptics_Windows.ProcSpec"))),
    "aec42324ce"
  )

  expect_known_hash(
    expect_silent(lr_parse_procspec(test.file("procspec_files", "OceanOptics_badencode.ProcSpec"))),
    "c97d6dff94"
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
    "3e6a201559"
  )

  expect_known_hash(
    expect_silent(lr_parse_jazirrad(test.file("irrad.JazIrrad"))),
    "0c66334253"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("FMNH6834.00000001.Master.Transmission"))),
    "2d53e6819"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("UK5.txt"))),
    "f9ccc67ccc"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("non_english", "OO_comma.txt"))),
    "077c3dc851"
  )

})

test_that("Avantes", {

  skip_if_not(capabilities(what = "long.double"), "Skip on noLD")

  expect_known_hash(
    expect_silent(lr_parse_roh(test.file("avantes_reflect.ROH"))),
    "21c61378d7"
  )

  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("avantes_trans.TRM"))),
    "ab3f3cf76d"
  )

  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("avantes2.TRM"))),
    "6d59fbc34a"
  )

  expect_known_hash(
    expect_silent(lr_parse_ttt(test.file("avantes_export.ttt"))),
    "25aaf7dc77"
  )

  expect_known_hash(
    expect_silent(lr_parse_ttt(test.file("avantes_export_long.ttt"))),
    "116b0ae4dc"
  )

  expect_known_hash(
    expect_silent(lr_parse_trt(test.file("avantes_export2.trt"))),
    "207b9bc5eb"
  )

  expect_known_hash(
    expect_silent(
      lr_parse_ttt(test.file("non_english", "J_MUR_MARS_17_0001.ttt"))
    ),
    "6a7d0bd119"
  )

  # Dark reference file
  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("1305084U1.DRK"))),
    "6364c89723"
  )

  # White reference file
  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("1305084U1.REF"))),
    "5d322b7d10"
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

  expect_known_hash(
    expect_silent(lr_parse_raw8(test.file("1904090M1_0003.Raw8"))),
    "45de5251ee"
  )

})

test_that("CRAIC", {

  skip_if_not(capabilities(what = "long.double"), "Skip on noLD")

  expect_known_hash(
    expect_silent(lr_parse_spc(test.file("compare", "CRAIC", "CRAIC.spc"))),
    "4fb2c8a868"
  )

})

test_that("Generic", {

  skip_if_not(capabilities(what = "long.double"), "Skip on noLD")

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
