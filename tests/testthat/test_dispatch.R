context("dispatch_parser")

test_that("Fallback", {

  expect_equal(
    parse_generic(test.file("spec.csv"), sep = ","),
    dispatch_parser(test.file("spec.csv"), sep = ",")
  )
})

test_that("Similar output for all parsers", {

  files <- list("procspec_files/OceanOptics_Linux.ProcSpec",
                "procspec_files/OceanOptics_Windows.ProcSpec",
                "procspec_files/OceanOptics_badencode.ProcSpec",
                "OceanOptics.jdx",
                "jazspec.jaz",
                "irrad.JazIrrad",
                "FMNH6834.00000001.Master.Transmission")

  lapply(files, function(file) {
    res <- dispatch_parser(test.file(file))
    expect_length(res, 2)
    expect_is(res[[1]], "data.frame")
#    expect_is(res[[2]], "data.frame")
  })

})
