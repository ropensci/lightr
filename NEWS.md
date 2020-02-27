# lightr 1.1

## New features and major changes

* `date` column in metadata is now always formatted as ISO 8601.
* `lightr` can now import AvaSoft8 files (test file provided by M.D. Shawkey),
via the function `lr_parse_rfl8()`.
* `lightr` can correctly imports `TRM` files from AvaSoft 6.0 (previously it 
only supported files from AvaSoft 7.0).
* `lightr` can now import binary `.spc` files (via the `lr_parse_spc()` parser).
This format is used by OceanInsight and CRAIC.

## Minor changes

* warnings on CRAN build system for platforms that don't support markdown 2 
have been fixed.
* new tests for `.IRR` files
* `jdx` files saved in a locale that uses `,` as the decimal separator are now
parsed correctly.

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
