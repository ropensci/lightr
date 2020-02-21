#' Compute processed spectral data
#'
#' Compute processed spectral data, from the raw count/scope data, counts from
#' a dark reference, and from a white reference.
#'
#' @param spdata data.frame containing the spectral data with the columns
#'   'scope', 'dark', and 'white'
#'
compute_processed <- function(spdata) {

  with(spdata, (scope - dark) / (white - dark) * 100)

}
