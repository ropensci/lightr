#' @importFrom tools file_ext
#'
#' @keywords internal
#'
dispatch_parser <- function(filename) {

  switch(
    tolower(file_ext(filename)),
    procspec = parse_procspec(filename),
    abs      = parse_abs(filename),
    roh      = parse_roh(filename),
    trm      = parse_trm(filename),
    trt      = parse_trt(filename),
    jdx      = parse_jdx(filename),
    parse_generic(filename)
  )

}
