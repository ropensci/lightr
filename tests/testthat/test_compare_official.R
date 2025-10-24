test_that("compare procspec & spectrasuite", {
  # Compare result from custom parser (lr_parse_procspec) and official parser
  specs <- lr_get_spec(
    test.file("compare", "OceanInsight"),
    ext = "ProcSpec",
    lim = c(100, 1000),
    interpolate = FALSE
  )
  specs_spectrasuite <- lr_get_spec(
    test.file("compare", "OceanInsight"),
    ext = "txt",
    lim = c(100, 1000),
    interpolate = FALSE
  )

  expect_equal(specs, specs_spectrasuite, tolerance = 1e-4)
})

test_that("compare trm & ttt", {
  # Compare result from custom parser (lr_parse_trm) and official parser
  # - J_PIR_AVRIL2016_0001 uses Avasoft 6.0
  # - NEW0601 uses Avasoft 7.0

  # FIXME: for some reason, the conversion from the official parser skips some
  # wl... Figure out why?
  specs <- lr_get_spec(test.file("compare", "Avantes"), ext = "TRM")
  specs_avasoft <- lr_get_spec(test.file("compare", "Avantes"), ext = "ttt")

  expect_equal(specs, specs_avasoft, tolerance = 1e-4)

  spec1_avasoft <- lr_parse_generic(test.file(
    "compare",
    "Avantes",
    "feather_1.TXT"
  ))[[1]]
  spec1 <- lr_parse_avantes_rfl8(
    test.file("compare", "Avantes", "feather.RFL8"),
    specnum = 1
  )[[1]]

  # FIXME: Avasoft sets "processed" to 0 when "dark" > "white". Hence why we
  # only test the first 200 rows until now.
  spec1[spec1$dark > spec1$white, ] <- 0
  expect_equal(spec1$processed, spec1_avasoft$processed, tolerance = 1e-7)

  spec2_avasoft <- lr_parse_generic(test.file(
    "compare",
    "Avantes",
    "feather_2.TXT"
  ))[[1]]
  spec2 <- lr_parse_avantes_rfl8(
    test.file("compare", "Avantes", "feather.RFL8"),
    specnum = 2
  )[[1]]

  expect_equal(
    spec2[, c("wl", "processed")],
    spec2_avasoft[, c("wl", "processed")],
    tolerance = 1e-4
  )

  spec3_avasoft <- lr_parse_csv(test.file(
    "compare",
    "Avantes",
    "30849.csv"
  ))[[1]]
  spec3 <- lr_parse_avantes_rfl8(
    test.file("compare", "Avantes", "30849.RFL8"),
    specnum = 1
  )[[1]]

  expect_equal(
    spec3[, c("wl", "processed")],
    spec3_avasoft[, c("wl", "processed")],
    tolerance = 1e-6
  )
})

test_that("compare spc & craic", {
  specs <- lr_get_spec(
    test.file("compare", "CRAIC"),
    ext = "spc",
    lim = c(100, 1000),
    interpolate = FALSE
  )
  specs_craic <- lr_get_spec(
    test.file("compare", "CRAIC"),
    ext = "txt",
    lim = c(100, 1000),
    interpolate = FALSE
  )

  expect_equal(specs, specs_craic, tolerance = 1e-4)
})

test_that("compare Rfl8x and Avasoft", {
  # Before 300 nm, we see differences due to different normalization methods
  # Beyond 950 nm, stitching starts and we get additional data point
  specs_lightr_low <- lr_get_spec(
    test.file("compare", "rfl8x"),
    ext = "Rfl8x",
    interpolate = FALSE,
    specnum = 1,
    lim = c(300, 950)
  )
  specs_lightr_high <- lr_get_spec(
    test.file("compare", "rfl8x"),
    ext = "Rfl8x",
    interpolate = FALSE,
    specnum = 2
  )
  specs_avasoft <- read.csv(
    test.file("compare", "rfl8x", "official.csv")
  )

  expect_equal(
    specs_lightr_low,
    specs_avasoft |> subset(wl >= 300 & wl <= 950),
    tolerance = 1e-6,
    ignore_attr = "class"
  )
})
