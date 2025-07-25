% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_avantes_converted.R
\name{lr_parse_avantes_ttt}
\alias{lr_parse_avantes_ttt}
\alias{lr_parse_avantes_trt}
\alias{lr_parse_ttt}
\alias{lr_parse_trt}
\title{Parse Avantes converted file}
\usage{
lr_parse_avantes_ttt(filename, ...)

lr_parse_avantes_trt(filename, ...)

lr_parse_ttt(filename, ...)

lr_parse_trt(filename, ...)
}
\arguments{
\item{filename}{Path of the file to parse}

\item{...}{ignored}
}
\value{
A named list of two elements:
\itemize{
\item \code{data}: a dataframe with columns "wl", "dark", "white", "scope" and
"processed", in this order.
\item \code{metadata}: a character vector with metadata including:
\itemize{
\item \code{user}: Name of the spectrometer operator
\item \code{datetime}: Timestamp of the recording in format '\%Y-\%m-\%d \%H:\%M:\%S'
and UTC timezone. If timezone is missing in source file, UTC time will
be assumed (for reproducibility purposes across computers with different
localtimes).
\item \code{spec_model}: Model of the spectrometer
\item \code{spec_ID}: Unique ID of the spectrometer
\item \code{white_inttime}: Integration time of the white reference (in ms)
\item \code{dark_inttime}: Integration time of the dark reference (in ms)
\item \code{sample_inttime}: Integration time of the sample (in ms)
\item \code{white_avgs}: Number of averaged measurements for the white reference
\item \code{dark_avgs}: Number of averaged measurements for the dark reference
\item \code{sample_avgs}: Number of averaged measurements for the sample
\item \code{white_boxcar}: Boxcar width for the white reference
\item \code{dark_boxcar}: Boxcar width for the dark reference
\item \code{sample_boxcar}: Boxcar width for the sample reference
}
}
}
\description{
Parse Avantes converted file.
\url{https://www.avantes.com/products/spectrometers/}
}
\details{
'processed' column computed by official software and provided as is.
}
\examples{
res_ttt <- lr_parse_avantes_ttt(
  system.file("testdata", "avantes_export.ttt", package = "lightr")
)
head(res_ttt$data)
res_ttt$metadata

res_trt <- lr_parse_avantes_trt(
  system.file("testdata", "avantes_export2.trt", package = "lightr")
)
head(res_trt$data)
res_trt$metadata

}
