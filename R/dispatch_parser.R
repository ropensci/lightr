#' Internal function to dispatch files to the correct parser
#'
#' @inheritParams lr_parse_generic
#'
#' @importFrom tools file_ext
#'
#' @keywords internal
#'
dispatch_parser <- function(filename, decimal = ".", sep = NULL) {

  switch(
    tolower(file_ext(filename)),
    procspec = lr_parse_procspec(filename),
    abs      = lr_parse_abs(filename),
    roh      = lr_parse_roh(filename),
    trm      = lr_parse_trm(filename),
    trt      = lr_parse_trt(filename),
    ttt      = lr_parse_ttt(filename),
    jdx      = lr_parse_jdx(filename),
    jaz      = lr_parse_jaz(filename),
    jazirrad = lr_parse_jazirrad(filename),
    spc      = lr_parse_spc(filename),
    lr_parse_generic(filename, decimal = decimal, sep = sep)
  )

}
