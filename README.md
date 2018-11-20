# `lightR`: import spectral data in R


[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Travis build status](https://travis-ci.org/Bisaloo/lightR.svg?branch=master)](https://travis-ci.org/Bisaloo/lightR)
[![Coverage status](https://codecov.io/gh/Bisaloo/lightR/branch/master/graph/badge.svg)](https://codecov.io/github/Bisaloo/lightR?branch=master)

There is no standard file format for spectrometry data and different scientific
instrumentation comparnies use wildly different formats to store spectral data.
Vendors proprietary software sometimes have an option but convert those formats
instead human readable files such as `csv` but in the process, most metadata
are lost. However, those metadata are critical to ensure reproducibility ([White
*et al*, 2015](https://doi.org/10.1016/j.anbehav.2015.05.007)).

This package aims at offering a unified user-friendly interface for users to 
read spectra files from various formats in a single line of code.

## Installation

This package is not yet published on CRAN and must be installed via GitHub:

```r
# install.packages("remotes")
remotes::install_github("bisaloo/lightR")
```

## Usage

A thorough documentation is available with the package, using R usual syntax
`?function` or `help(function)`. However, users will probably mainly use two 
functions:

```r
# Get a data.frame containing all useful metadata from spectra in a folder
getmetadata(".", ext = "ProcSpec")
```

and

```r
# Get a single dataframe where the first column contains the wavelengths and 
# the next columns contain a spectra each (pavo's rspec class)
getspec(".", ext = "ProcSpec")
```

`getspec()` returns a dataframe that is compatible with [`pavo`] custom S3 class
(`rspec`) and can be used for further analyses using colour vision models.

All supported file formats can also be parsed using the `parse_$extension()` 
function where `$extension` is the lowercase extension of your file. This
family of functions return a list where the first element is the data dataframe
and the second element is a vector with relevant metadata.

Only exceptions are `.txt` and `.Transmission` files because those extensions
are too generic. You will need to figure out which parser you should use in this
case. `getmetadata` and `getspec` automatically try generic parsers in this
case.

Alternatively, you may simply want to convert your spectra in a readable 
standard format and carry on with your analysis with another software.

In this case, you can run:

```r
# Convert every single ProcSpec file to a csv file with the same name and 
# location
spec2csv(".", ext = "ProcSpec")
```

## Supported file formats

This package is still under development but currently supports:

- [OceanOptics](https://oceanoptics.com/):
    * `.jdx`
    * `.ProcSpec`
    * `.jaz`
    * `.JazIrrad`

- [Avantes](https://www.avantes.com/):
    * `.ABS`
    * `.ROH`
    * `.TRM`
    * `.trt`
    * `.ttt`
  
## Similar projects

* `lightR` itself contains some code that has been initially forked from 
  [`pavo`], namely the `getspec()` function. The code has since then been 
  refactored and optimised for speed. [`pavo`] differs from `lightR` in its
  focus and core functionalities. The main strength of [`pavo`] is the 
  comprehensive and user-friendly set of functions to analyse spectral data
  using [colour vision models](https://en.wikipedia.org/wiki/Color_model), while
  `lightR` focuses on the data import step.
* [`photobiologyInOut`] also provides functions to import spectral data. 
  The goal of the author is to provide a complete pipeline of spectral data 
  import and analysis using a 
  [set of tightly integrated R packages](https://www.r4photobiology.info/). 
  This however makes it more difficult to use a different tool for a given step
  of the process. On the contrary, `lightR` aims at proposing a light package 
  with limited dependencies that focuses on the data import step of the process
  and let the user pick their favorite tool for the analysis step.
  
Because of its user-friendly high-levels functions and low dependency
philosophy, `lightR` may also hopefully prove useful for people working with 
other languages than R.
`

[`pavo`]: https://cran.r-project.org/package=pavo

[`photobiologyInOut`]: https://cran.r-project.org/package=photobiologyInOut
