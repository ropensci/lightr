test_that("compare procspec/spectrasuite", {

  # Compare result from custom parser (lr_parse_procspec) and official parser
  specs <- lr_get_spec(test.file("compare/OceanInsight"),
                       ext = "ProcSpec",
                       lim = c(100, 1000),
                       interpolate = FALSE)
  specs_spectrasuite <- lr_get_spec(test.file("compare/OceanInsight"),
                                    ext = "txt",
                                    lim = c(100, 1000),
                                    interpolate = FALSE)

  expect_equal(specs, specs_spectrasuite, tolerance = 1e-4)
})

test_that("compare trm/ttt", {

  # Compare result from custom parser (lr_parse_trm) and official parser
  # - J_PIR_AVRIL2016_0001 uses Avasoft 6.0
  # - NEW0601 uses Avasoft 7.0

  # FIXME: for some reason, the conversion from the official parser skips some
  # wl... Figure out why?
  specs <- lr_get_spec(test.file("compare/Avantes"), ext = "TRM")
  specs_avasoft <- lr_get_spec(test.file("compare/Avantes"), ext = "ttt")

  expect_equal(specs, specs_avasoft, tolerance = 1e-4)

  spec1_avasoft <- lr_parse_generic(test.file("compare", "Avantes", "feather_1.TXT"))[[1]]
  spec1 <- lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"), specnum = 1)[[1]]

  # FIXME: Avasoft sets "processed" to 0 when "dark" > "white". Hence why we
  # only test the first 200 rows until now.
  expect_equal(spec1[seq_len(200), c("wl", "processed")],
               spec1_avasoft[seq_len(200), c("wl", "processed")],
               tol = 1e-4)

  spec2_avasoft <- lr_parse_generic(test.file("compare", "Avantes", "feather_2.TXT"))[[1]]
  spec2 <- lr_parse_rfl8(test.file("compare", "Avantes", "feather.RFL8"), specnum = 2)[[1]]

  expect_equal(spec2[, c("wl", "processed")],
               spec2_avasoft[, c("wl", "processed")],
               tolerance = 1e-4)

})

test_that("compare spc/craic", {

  specs <- lr_get_spec(test.file("compare/CRAIC"),
                       ext = "spc",
                       lim = c(100, 1000),
                       interpolate = FALSE)
  specs_craic <- lr_get_spec(test.file("compare/CRAIC"),
                             ext = "txt",
                             lim = c(100, 1000),
                             interpolate = FALSE)

  expect_equal(specs, specs_craic, tolerance = 1e-4)
})
