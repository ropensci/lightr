# Deprecated functions -------------------------------------------------------
#
# This file contains all deprecated functions to make it easier to manage
# the deprecation process and remove them in the future.

# From parse_avantes_binary.R -------------------------------------------------

#' @rdname lr_parse_avantes_trm
#' @export
lr_parse_trm <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_trm()",
    with = "lr_parse_avantes_trm()"
  )
  lr_parse_avantes_trm(filename = filename, ...)
}

#' @rdname lr_parse_avantes_trm
#' @export
lr_parse_abs <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_abs()",
    with = "lr_parse_avantes_abs()"
  )
  lr_parse_avantes_abs(filename = filename, ...)
}

#' @rdname lr_parse_avantes_trm
#' @export
lr_parse_roh <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_roh()",
    with = "lr_parse_avantes_roh()"
  )
  lr_parse_avantes_roh(filename = filename, ...)
}

#' @rdname lr_parse_avantes_trm
#' @export
lr_parse_rfl8 <- function(filename, specnum = 1L, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_rfl8()",
    with = "lr_parse_avantes_rfl8()"
  )
  lr_parse_avantes_rfl8(filename = filename, specnum = specnum, ...)
}

#' @rdname lr_parse_avantes_trm
#' @export
lr_parse_raw8 <- function(filename, specnum = 1L, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_raw8()",
    with = "lr_parse_avantes_raw8()"
  )
  lr_parse_avantes_raw8(filename = filename, specnum = specnum, ...)
}

#' @rdname lr_parse_avantes_trm
#' @export
lr_parse_irr8 <- function(filename, specnum = 1L, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_irr8()",
    with = "lr_parse_avantes_irr8()"
  )
  lr_parse_avantes_irr8(filename = filename, specnum = specnum, ...)
}

# From parse_avantes_converted.R ----------------------------------------------

#' @rdname lr_parse_avantes_ttt
#' @export
lr_parse_ttt <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_ttt()",
    with = "lr_parse_avantes_ttt()"
  )
  lr_parse_avantes_ttt(filename = filename, ...)
}

#' @rdname lr_parse_avantes_ttt
#' @export
lr_parse_trt <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_trt()",
    with = "lr_parse_avantes_trt()"
  )
  lr_parse_avantes_trt(filename = filename, ...)
}

# From parse_jdx.R ------------------------------------------------------------

#' @rdname lr_parse_oceanoptics_jdx
#' @export
lr_parse_jdx <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_jdx()",
    with = "lr_parse_oceanoptics_jdx()"
  )
  lr_parse_oceanoptics_jdx(filename = filename, ...)
}

# From parse_oceanoptics_converted.R ------------------------------------------

#' @rdname lr_parse_oceanoptics_jaz
#' @export
lr_parse_jaz <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_jaz()",
    with = "lr_parse_oceanoptics_jaz()"
  )
  lr_parse_oceanoptics_jaz(filename = filename, ...)
}

#' @rdname lr_parse_oceanoptics_jaz
#' @export
lr_parse_jazirrad <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_jazirrad()",
    with = "lr_parse_oceanoptics_jazirrad()"
  )
  lr_parse_oceanoptics_jazirrad(filename = filename, ...)
}

# From parse_procspec.R -------------------------------------------------------

#' @rdname lr_parse_oceanoptics_procspec
#' @export
lr_parse_procspec <- function(filename, verify_checksum = FALSE, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_procspec()",
    with = "lr_parse_oceanoptics_procspec()"
  )
  lr_parse_oceanoptics_procspec(filename = filename, verify_checksum = verify_checksum, ...)
}

# From parse_spc.R ------------------------------------------------------------

#' @rdname lr_parse_craic_spc
#' @export
lr_parse_spc <- function(filename, ...) {
  lifecycle::deprecate_warn(
    when = "2.0.0",
    what = "lr_parse_spc()",
    details = paste(
      "lr_parse_spc() should be replaced by ",
      "lr_parse_oceanoptics_spc() or lr_parse_craic_spc() ",
      "depending on the manufacturer of the spectrometer ",
      "which created this file."
    )
  )
  lr_parse_oceanoptics_spc(filename = filename, ...)
}
