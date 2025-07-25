test_that("OceanOptics ProcSpec", {
  # We have mismatches that can't be reproduced from CRAN M1 machine
  skip_on_cran()

  expect_snapshot(
    lr_parse_oceanoptics_procspec(
      test.file("tampered_procspec.zip"),
      verify_checksum = TRUE
    ),
    error = TRUE
  )

  expect_snapshot(
    lr_parse_oceanoptics_procspec(
      test.file("procspec_files", "OceanOptics_Linux.ProcSpec"),
      verify_checksum = TRUE
    )
  )

  expect_snapshot(
    lr_parse_oceanoptics_procspec(
      test.file("procspec_files", "OceanOptics_Windows.ProcSpec"),
      verify_checksum = TRUE
    )
  )

  expect_snapshot(
    lr_parse_oceanoptics_procspec(
      test.file("procspec_files", "OceanOptics_badencode.ProcSpec")
    )
  )
})

test_that("OceanOptics others", {
  # Floating point precision issue on noLD platforms.
  # This is caused by the conversion to "numeric":
  # storage.mode(data) <- "numeric"
  expect_snapshot(
    lr_parse_oceanoptics_jdx(test.file("OceanOptics_period.jdx"))
  )

  # Floating point precision issue on noLD platforms.
  # This is caused by the conversion to "numeric":
  # storage.mode(data) <- "numeric"
  expect_snapshot(
    lr_parse_oceanoptics_jdx(test.file("non_english", "OceanOptics_comma.jdx"))
  )

  expect_snapshot(
    lr_parse_spc(test.file("OceanOptics.spc"))
  )

  expect_snapshot(
    lr_parse_oceanoptics_jaz(test.file("jazspec.jaz"))
  )

  # Floating point precision issue on noLD platforms.
  # This is caused by the conversion to "numeric":
  # storage.mode(data) <- "numeric"
  expect_snapshot(
    lr_parse_oceanoptics_jazirrad(test.file("irrad.JazIrrad"))
  )

  expect_snapshot(
    lr_parse_oceanoptics_jaz(test.file("FMNH6834.00000001.Master.Transmission"))
  )

  expect_snapshot(
    lr_parse_oceanoptics_jaz(test.file("UK5.txt"))
  )

  expect_snapshot(
    lr_parse_oceanoptics_jaz(test.file("non_english", "OO_comma.txt"))
  )

  expect_snapshot(
    lr_parse_oceanoptics_jaz(test.file("non_english", "OceanView_nonEN.txt"))
  )
})

test_that("Avantes", {
  expect_snapshot(
    lr_parse_avantes_roh(test.file("avantes_reflect.ROH"))
  )

  expect_snapshot(
    lr_parse_avantes_trm(test.file("avantes_trans.TRM"))
  )

  expect_snapshot(
    lr_parse_avantes_trm(test.file("avantes2.TRM"))
  )

  expect_snapshot(
    lr_parse_avantes_ttt(test.file("avantes_export.ttt"))
  )

  expect_snapshot(
    lr_parse_avantes_ttt(test.file("avantes_export_long.ttt"))
  )

  expect_snapshot(
    lr_parse_avantes_trt(test.file("avantes_export2.trt"))
  )

  expect_snapshot(
    lr_parse_avantes_ttt(test.file("non_english", "J_MUR_MARS_17_0001.ttt"))
  )

  # Dark reference file
  expect_snapshot(
    lr_parse_avantes_trm(test.file("1305084U1.DRK"))
  )

  # White reference file
  expect_snapshot(
    lr_parse_avantes_trm(test.file("1305084U1.REF"))
  )

  expect_warning(
    rfl8_1_implicit <- lr_parse_avantes_rfl8(test.file(
      "compare",
      "Avantes",
      "feather.RFL8"
    )),
    "argument is missing"
  )
  rfl8_1 <- expect_silent(
    lr_parse_avantes_rfl8(
      test.file("compare", "Avantes", "feather.RFL8"),
      specnum = 1
    )
  )

  expect_identical(rfl8_1_implicit, rfl8_1)

  expect_snapshot(rfl8_1)

  expect_snapshot(
    lr_parse_avantes_rfl8(
      test.file("compare", "Avantes", "feather.RFL8"),
      specnum = 2
    )
  )

  expect_snapshot(
    lr_parse_avantes_rfl8(
      test.file("compare", "Avantes", "feather.RFL8"),
      specnum = 5
    ),
    error = TRUE
  )

  # expect_snapshot(
  #   lr_parse_raw8(test.file("1904090M1_0003.Raw8"))
  # )
})

test_that("CRAIC", {
  expect_snapshot(
    lr_parse_spc(test.file("compare", "CRAIC", "CRAIC.spc"))
  )
})

test_that("Generic", {
  expect_snapshot(
    lr_parse_generic(test.file("spec.csv")),
    error = TRUE
  )

  expect_snapshot(
    lr_parse_generic(test.file("spec.csv"), sep = ",")
  )

  expect_snapshot(
    lr_parse_generic(test.file("RS-1.dpt"), sep = ",")
  )

  # Floating point precision issue on noLD platforms.
  # This is caused by the conversion to "numeric":
  # storage.mode(rawsplit) <- "numeric"
  # in parse_generic()
  expect_snapshot(
    lr_parse_generic(test.file("irr_820_1941.IRR"))
  )

  expect_snapshot(
    lr_parse_generic(test.file("compare", "CRAIC", "CRAIC.txt"))
  )

  # These files are better suited to more specific parsers but are dispatched
  # here by default

  expect_snapshot(
    lr_parse_generic(
      test.file("non_english", "OceanView_nonEN.txt"),
      decimal = ","
    )
  )

  expect_snapshot(
    lr_parse_generic(
      test.file("non_english", "OO_comma.txt"),
      decimal = ","
    )
  )
})

test_that("csv parser", {
  expect_snapshot(
    lr_parse_csv(test.file("spec.csv"))
  )
})
