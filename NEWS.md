# lightr 1.8.0

## Minor changes

* timezones for converted OceanOptics files are now handled differently internally (@Bisaloo, #64), 
  to handle changes in upstream tzdata 2024b, which removed for example the CET and EST timezone codes.
  This may result in some other deprecated timezone codes not being handled correctly.
  Please report any bugs or discrepancies you may notice in the `datetime` field of metadata.
* lightr now depends on R >= 4.0.0, following the tidyverse recommendation (@Bisaloo, #28)
* the future package is now explicitly listed as a dependency, removing an `R CMD check` `NOTE` and thus removing the strain on CRAN reviewers (@Bisaloo, #63). 
  The future package was already a indirect dependency via the future.apply package.

# lightr 1.7.1

## Internal changes

* this project now uses lintr to ensure the code is always following the current
best coding practices in the R community
* ensure floating precision issues are not causing tests to fail on CRAN (@Bisaloo, #156)

## Minor changes

* `lr_parse_irr8()`, `lr_parse_rfl8()` and `lr_parse_raw8()` now error if you 
provide a file not produced by AvaSoft 8.2 as they have not been tested properly
with other versions of AvaSoft 8.

# lightr 1.7.0

## Minor changes

* Errors in low-level parsers are now passed as warnings in high-level 
`lr_get_XXX()` functions instead of being completely silenced.

* IRR8 (irradiance files produced by AvaSoft 8) are now explicitly supported by 
`lr_get_spec()`. An alias has been added for the low-level parser: 
`lr_parse_irr8()`.

# lightr 1.6.2

## Minor changes

* fix failing tests on CRAN due to unattached dependency

# lightr 1.6.1

## Minor changes

* fix failing tests on CRAN caused by non UTF-8 files

# lightr 1.6.0

## Major breaking changes

* The date returned in metadata (by `lr_get_metadata()`, 
`lr_convert_tocsv(metadata = TRUE)` and `lr_parse_XXXX()`) is now a datetime
(with UTC as timezone and format `%Y-%m-%d %H:%M:%S`). 
The column name in `lr_get_metadata()` has been updated from `date` to 
`datetime` to reflect this. Thanks to Giancarlo Chiarenza for the report, and
to Hao Ye, Laura DeCicco and Elin Waring for helpful comments about timezones
and datetime formatting for reproducibility.

## Minor changes

* datetime parsing is supported for more formats
* Files produced by OceanInsight software (such as SpectraSuite) in Spanish
can now be parsed)

# lightr 1.5.0

## Major breaking changes

* the `cores` argument in `lr_get_spec()`, `lr_get_metadata()`, and 
`lr_convert_tocsv()` has been completely removed. It was already deprecated
since lightr 1.0 (released on CRAN on 2020-01-27)
* `lr_convert_tocsv()` gains a new `metadata` argument (defaults to `TRUE`) to
determine if metadata should be exported in a csv file as well alongside the
spectral data.

# lightr 1.4

## Minor changes and bug fixes

* Output of the low-level parsers `lr_parse_XXXX()` is now a named list with
elements `data` and `metadata`
* `lr_parse_raw8()` and `lr_parse_rfl8()` now explicitly mention the number 
of spectra in the warnings instead of the generic "multiple spectra"
* `lr_parse_generic()` now makes sure that the data is ordered by increasing 
wavelengths, which fixes a bug reported by @itamshab

# lightr 1.3

## Minor changes

* (mostly internal) `compute_processed()` function is now named
`lr_compute_processed()`
* disable hash tests on Solaris (the output is still checked by other tests)

# lightr 1.2

## Minor changes

* fixed tests on platform with no long-doubles ('noLD') 
* restored tests on 32bits machines
* `spec_ID` extraction from Avantes exported files (`ttt` and `trt`) is now
more robust, meaning it should work for more files.

# lightr 1.1

## New features and major changes

* `date` column in metadata is now always formatted as ISO 8601.
* `lightr` can now import AvaSoft8 files (test files provided by M.D. Shawkey 
and L. Swierk), via the functions `lr_parse_rfl8()`/`lr_parse_raw8()`.
* `lightr` can correctly imports `TRM` files from AvaSoft 6.0 (previously it 
only supported files from AvaSoft 7.0).
* `lightr` can now import binary `.spc` files (via the `lr_parse_spc()` parser).
This format is used by OceanInsight and CRAIC.

## Minor changes

* new test suite on a different locale (in this case `fr_FR.UTF-8`) to ensure
parsing is locale-independent.
* warnings on CRAN build system for platforms that don't support markdown 2 
have been fixed.
* new, stricter tests for various file formats.
* `jdx` files saved in a locale that uses `,` as the decimal separator are now
parsed correctly.
* Avantes exported files in non-English locales (`ttt` and `trt` files) are now 
parsed correctly again (this was a regression compared to pavo's 
`pavo::getspec()`). Thanks to A. Fargevieille for reporting the issue and 
providing a test file.

# lightr 1.0

## New features and major changes

* parallel processing now relies on the `future` package, which offers windows
and high performance computing (HPC) environments support. The progress bar is
produced by the `progressr` package and can be customised as well.
* `lr_parse_generic()` (and thus `lr_get_spec()`) now works with non-UTF8 files
(this was a regression compared to pavo's `pavo::getspec()`).
* `lr_get_spec()` now has a new `interpolate` argument to determine whether you
want your data interpolated and pruned at every nm or not.

## Minor changes

* `readBin()` (in the binary Avantes parser) now has an explicit `endian` value,
making this package portable to platform that use big endians.
* documentation has been updated to follow the rebranding of OceanOptics into
OceanInsight.
* vignette chunks that use `pavo` now only run if the package is available.
* `savetime` field is now extracted from converted avantes files (when
available).

# lightr 0.1

* First release.
