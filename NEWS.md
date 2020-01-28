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
