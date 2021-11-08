test_that("pio_lightr_jaz", {
  skip_if_not_installed("photobiologyInOut")
  skip_on_cran()

  attachNamespace("photobiologyInOut", include.only = "read_oo_jazirrad")

  file <- test.file("irrad.JazIrrad")

  out_pio <- read_oo_jazirrad(file)
  out_pio <- as.data.frame(out_pio)
  out_pio[,2] <- out_pio[,2] * 100
  colnames(out_pio) <- NULL

  out_lightr <- lr_parse_jazirrad(file)[[1]]
  colnames(out_lightr) <- NULL

  expect_equal(out_pio, out_lightr[, c(1,5)], ignore_attr = TRUE)
})
