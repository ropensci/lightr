local_edition(2)

test_that("OceanOptics ProcSpec", {
  # We have mismatches that can't be reproduced from CRAN M1 machine
  skip_on_cran()

  if (capabilities(what = "long.double")) {
    expect_known_hash(
      expect_silent(lr_parse_procspec(test.file(
        "procspec_files",
        "OceanOptics_Linux.ProcSpec"
      ))),
      "f98109a490"
    )

    expect_known_hash(
      expect_silent(lr_parse_procspec(test.file(
        "procspec_files",
        "OceanOptics_Windows.ProcSpec"
      ))),
      "38f10dbdc7"
    )

    expect_known_hash(
      expect_silent(lr_parse_procspec(test.file(
        "procspec_files",
        "OceanOptics_badencode.ProcSpec"
      ))),
      "04cb771bd7"
    )
  } else {
    expect_known_hash(
      expect_silent(lr_parse_procspec(test.file(
        "procspec_files",
        "OceanOptics_Linux.ProcSpec"
      ))),
      "c937c66868"
    )

    expect_known_hash(
      expect_silent(lr_parse_procspec(test.file(
        "procspec_files",
        "OceanOptics_Windows.ProcSpec"
      ))),
      "5751112645"
    )

    expect_known_hash(
      expect_silent(lr_parse_procspec(test.file(
        "procspec_files",
        "OceanOptics_badencode.ProcSpec"
      ))),
      "78c84f7e93"
    )
  }
})

test_that("OceanOptics others", {
  skip_on_os("solaris")

  # Floating point precision issue on noLD platforms.
  # This is caused by the conversion to "numeric":
  # storage.mode(data) <- "numeric"
  expect_identical(
    digest::sha1(expect_silent(lr_parse_jdx(test.file(
      "OceanOptics_period.jdx"
    )))),
    "34745a6112ef7679fbf0bc694d952c6eecdb347a"
  )

  # Floating point precision issue on noLD platforms.
  # This is caused by the conversion to "numeric":
  # storage.mode(data) <- "numeric"
  expect_identical(
    digest::sha1(expect_silent(lr_parse_jdx(test.file(
      "non_english",
      "OceanOptics_comma.jdx"
    )))),
    "7c17148cb62abe1053048eb0ca1c3c55b43b482b"
  )

  expect_known_hash(
    expect_silent(lr_parse_spc(test.file("OceanOptics.spc"))),
    "eb91187641"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("jazspec.jaz"))),
    "4e9fdd1a25"
  )

  # Floating point precision issue on noLD platforms.
  # This is caused by the conversion to "numeric":
  # storage.mode(data) <- "numeric"
  expect_identical(
    digest::sha1(expect_silent(lr_parse_jazirrad(test.file("irrad.JazIrrad")))),
    "ff4b1833ee0fceac1370914678aeba240ea1da03"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file(
      "FMNH6834.00000001.Master.Transmission"
    ))),
    "b96dd6783"
  )

  expect_known_hash(
    expect_silent(lr_parse_jaz(test.file("UK5.txt"))),
    "737473e8b"
  )

  # No expect_silent() here because 'CST' is not a valid timezone and per
  # ?as.POSIXct, "invalid values are most commonly treated as UTC, on some
  # platforms with a warning."
  expect_known_hash(
    suppressWarnings(lr_parse_jaz(test.file("non_english", "OO_comma.txt"))),
    "5035522e53"
  )

  expect_known_hash(
    suppressWarnings(lr_parse_jaz(test.file(
      "non_english",
      "OceanView_nonEN.txt"
    ))),
    "4e7b424f6d"
  )
})

test_that("Avantes", {
  skip_on_os("solaris")

  expect_known_hash(
    expect_silent(lr_parse_roh(test.file("avantes_reflect.ROH"))),
    "1b71c9b6df"
  )

  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("avantes_trans.TRM"))),
    "e0e679afb0"
  )

  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("avantes2.TRM"))),
    "e507434490"
  )

  expect_known_hash(
    expect_silent(lr_parse_ttt(test.file("avantes_export.ttt"))),
    "4731f9e00c"
  )

  expect_known_hash(
    expect_silent(lr_parse_ttt(test.file("avantes_export_long.ttt"))),
    "08df8af0db"
  )

  expect_known_hash(
    expect_silent(lr_parse_trt(test.file("avantes_export2.trt"))),
    "c87bdb9f0d"
  )

  expect_known_hash(
    expect_silent(
      lr_parse_ttt(test.file("non_english", "J_MUR_MARS_17_0001.ttt"))
    ),
    "d062e2e4a1"
  )

  # Dark reference file
  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("1305084U1.DRK"))),
    "e27a0199ae"
  )

  # White reference file
  expect_known_hash(
    expect_silent(lr_parse_trm(test.file("1305084U1.REF"))),
    "8a4b93655f"
  )

  rfl8_1_implicit <- expect_warning(
    lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8")),
    "argument is missing"
  )
  rfl8_1 <- expect_silent(
    lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"), specnum = 1)
  )

  expect_identical(rfl8_1_implicit, rfl8_1)

  expect_known_hash(rfl8_1, "9bf9f003dd")

  expect_known_hash(
    expect_silent(lr_parse_rfl8(
      test.file("compare", "Avantes", "feather.RFL8"),
      specnum = 2
    )),
    "6012c0aa1c"
  )

  expect_error(
    lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"), specnum = 5),
    "'specnum' is larger"
  )

  # expect_known_hash(
  #   expect_silent(lr_parse_raw8(test.file("1904090M1_0003.Raw8"))),
  #   "7ff3a7ed7a"
  # )
})

test_that("CRAIC", {
  skip_on_os("solaris")

  expect_known_hash(
    expect_silent(lr_parse_spc(test.file("compare", "CRAIC", "CRAIC.spc"))),
    "12780a7f0d"
  )
})

test_that("Generic", {
  skip_on_os("solaris")

  expect_error(lr_parse_generic(test.file("spec.csv")), "Parsing failed.")

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("spec.csv"), sep = ",")),
    "1e246ba044"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("RS-1.dpt"), sep = ",")),
    "43350b3bd5"
  )

  # Floating point precision issue on noLD platforms.
  # This is caused by the conversion to "numeric":
  # storage.mode(rawsplit) <- "numeric"
  # in parse_generic()
  expect_identical(
    digest::sha1(expect_silent(lr_parse_generic(test.file(
      "irr_820_1941.IRR"
    )))),
    "55a511f366b3ec370ef32b7ca64ab06bebd4ce63"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(test.file("compare", "CRAIC", "CRAIC.txt"))),
    "8b82d5108d"
  )

  # These files are better suited to more specific parsers but are dispatched
  # here by default

  expect_known_hash(
    expect_silent(lr_parse_generic(
      test.file("non_english", "OceanView_nonEN.txt"),
      decimal = ","
    )),
    "ca6a058368"
  )

  expect_known_hash(
    expect_silent(lr_parse_generic(
      test.file("non_english", "OO_comma.txt"),
      decimal = ","
    )),
    "c061c4395f"
  )
})
