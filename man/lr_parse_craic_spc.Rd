% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_spc.R
\name{lr_parse_craic_spc}
\alias{lr_parse_craic_spc}
\alias{lr_parse_oceanoptics_spc}
\alias{lr_parse_spc}
\title{Parse SPC binary file}
\usage{
lr_parse_craic_spc(filename, ...)

lr_parse_oceanoptics_spc(filename, ...)

lr_parse_spc(filename, ...)
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
Parse SPC binary file. (Used by CRAIC \url{https://www.microspectra.com/} and
OceanOptics \url{https://www.oceanoptics.com/})
}
\details{
'processed' column computed by official software and provided as is.
}
\section{In development}{

Metadata parsing has not yet been implemented for this file format.
}

\examples{
res <- lr_parse_craic_spc(
  system.file(
    "testdata", "compare", "CRAIC", "CRAIC.spc",
    package = "lightr"
  )
)
head(res$data)
res$metadata

}
