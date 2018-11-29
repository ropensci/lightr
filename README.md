# `lightr`: import spectral data in R

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Travis build status](https://travis-ci.org/Bisaloo/lightr.svg?branch=master)](https://travis-ci.org/Bisaloo/lightr)
[![Coverage status](https://codecov.io/gh/Bisaloo/lightr/branch/master/graph/badge.svg)](https://codecov.io/github/Bisaloo/lightr?branch=master)

There is no standard file format for spectrometry data and different scientific
instrumentation companies use wildly different formats to store spectral data.
Vendors proprietary software sometimes have an option but convert those formats
instead human readable files such as `csv` but in the process, most metadata
are lost. However, those metadata are critical to ensure reproducibility ([White
*et al*, 2015](https://doi.org/10.1016/j.anbehav.2015.05.007)).

This package aims at offering a unified user-friendly interface for users to 
read UV-VIS reflectance/transmittance/absorbance spectra files from various
formats in a single line of code.

Additionally, it provides for the first time a fully free and open source 
solution to read proprietary spectra file formats on all systems.

## Installation

This package is not yet published on CRAN and must be installed via GitHub:

```r
# install.packages("remotes")
remotes::install_github("bisaloo/lightr")
```

## Usage

A thorough documentation is available with the package, using R usual syntax
`?function` or `help(function)`. However, users will probably mainly use two 
functions:

```r
# Get a data.frame containing all useful metadata from spectra in a folder
get_metadata(where = ".", ext = "ProcSpec")
```

and

```r
# Get a single dataframe where the first column contains the wavelengths and 
# the next columns contain a spectra each (pavo's rspec class)
get_spec(where = ".", ext = "ProcSpec")
```

`get_spec()` returns a dataframe that is compatible with [`pavo`] custom S3
class (`rspec`) and can be used for further analyses using colour vision models.

All supported file formats can also be parsed using the `parse_$extension()` 
function where `$extension` is the lowercase extension of your file. This
family of functions return a list where the first element is the data dataframe
and the second element is a vector with relevant metadata.

Only exceptions are `.txt` and `.Transmission` files because those extensions
are too generic. You will need to figure out which parser you should use in this
case. `get_metadata()` and `get_spec()` automatically try generic parsers in
this case.

Alternatively, you may simply want to convert your spectra in a readable 
standard format and carry on with your analysis with another software.

In this case, you can run:

```r
# Convert every single ProcSpec file to a csv file with the same name and 
# location
spec2csv(where = ".", ext = "ProcSpec")
```

## Supported file formats

This package is still under development but currently supports:

### [OceanOptics](https://oceanoptics.com/)

  | Extension      | Parser             |
  |:---------------|:-------------------|
  | `jdx`          | `parse_jdx()`      |
  | `ProcSpec`     | `parse_procspec()` |
  | `jaz`          | `parse_jaz()`      |
  | `jazirrad`     | `parse_jazirrad()` |
  | `Transmission` | `parse_jaz()`      |
  | `txt`          | `parse_jaz()`      |

### [Avantes](https://www.avantes.com/)

  | Extension      | Parser             |
  |:---------------|:-------------------|
  | `ABS`          | `parse_abs()`      |
  | `ROH`          | `parse_roh()`      |
  | `TRM`          | `parse_trm()`      |
  | `trt`          | `parse_trt()`      |
  | `ttt`          | `parse_ttt()`      |
  | `txt`          | `parse_generic()`  |
  
### [CRAIC](http://www.microspectra.com/)

  | Extension | Parser            |
  |:----------|:------------------|
  | `txt`     | `parse_generic()` |
  
### Others

As a fallback, you should always try `parse_generic()` which offers a flexible
and general algorithm that manages to extract data from most files.

If you can't find the best parse for your specific file or if you believe you
are using an unsupported format, please 
[open an issue](https://github.com/Bisaloo/lightr/issues) or send me an email. 

## Similar projects

* `lightr` itself contains some code that has been initially forked from 
  [`pavo`], namely the `get_spec()` function. The code has since then been 
  refactored and optimised for speed. [`pavo`] differs from `lightr` in its
  focus and core functionalities. The main strength of [`pavo`] is the 
  comprehensive and user-friendly set of functions to analyse spectral data
  using [colour vision models](https://en.wikipedia.org/wiki/Color_model), while
  `lightr` focuses on the data import step.
* [`photobiologyInOut`] also provides functions to import spectral data. 
  The goal of the author is to provide a complete pipeline of spectral data 
  import and analysis using a 
  [set of tightly integrated R packages](https://www.r4photobiology.info/). 
  This however makes it more difficult to use a different tool for a given step
  of the process. On the contrary, `lightr` aims at proposing a light package 
  with limited dependencies that focuses on the data import step of the process
  and let the user pick their favorite tool for the analysis step ([`pavo`],
  [`colourvision`](https://cran.r-project.org/package=colourvision),
  [`Avicol`](https://sites.google.com/site/avicolprogram/), etc.).
* [`spectrolab`](https://github.com/meireles/spectrolab)
* Other projects such as [`hyperSpec`](http://hyperspec.r-forge.r-project.org/)
  or [`readJDX`](https://cran.r-project.org/package=readJDX) have some overlap
  with `lightr` (import of JCAMP-DX `.jdx` files for example) but mainly focus
  on other types of spectra, such a Raman spectra, while `lightr` focuses
  exclusively UV-VIS reflectance/transmittance/absorbance spectra.

To our knowledge, `lightr` is the only gratis tool to import some complex file
formats such as Avantes binary files or OceanOptics `.ProcSpec`Because of its
user-friendly high-levels functions and low dependency philosophy, `lightr` may 
also hopefully prove useful for people working with other languages than R.


[`pavo`]: https://cran.r-project.org/package=pavo

[`photobiologyInOut`]: https://cran.r-project.org/package=photobiologyInOut
