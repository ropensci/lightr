test_that("pio_lightr_jaz", {
  skip_if_not_installed("photobiologyInOut")

  file <- test.file("irrad.JazIrrad")

  out_pio <- read_oo_jazirrad(file)
  out_pio <- as.data.frame(out_pio)
  out_pio[,2] <- out_pio[,2] * 100
  colnames(out_pio) <- NULL

  out_lightr <- parse_jazirrad(file)[[1]]
  colnames(out_lightr) <- NULL

  expect_equivalent(out_pio, out_lightr[, c(1,5)])
})
