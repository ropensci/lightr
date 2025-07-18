#' Internal function to dispatch files to the correct parser
#'
#' @inheritParams lr_parse_rfl8
#'
#' @inherit lr_parse_generic return
#'
#' @importFrom tools file_ext
#'
#' @keywords internal
#'
dispatch_parser <- function(filename, ...) {
  switch(
    tolower(file_ext(filename)),
    procspec = lr_parse_procspec(filename, ...),
    abs = lr_parse_abs(filename, ...),
    roh = lr_parse_roh(filename, ...),
    trm = lr_parse_trm(filename, ...),
    trt = lr_parse_trt(filename, ...),
    ttt = lr_parse_ttt(filename, ...),
    rfl8 = lr_parse_rfl8(filename, ...),
    raw8 = lr_parse_raw8(filename, ...),
    irr8 = lr_parse_irr8(filename, ...),
    jdx = lr_parse_jdx(filename, ...),
    jaz = lr_parse_jaz(filename, ...),
    jazirrad = lr_parse_jazirrad(filename, ...),
    spc = lr_parse_spc(filename, ...),
    csv = lr_parse_csv(filename, ...),
    lr_parse_generic(filename, ...)
  )
}
