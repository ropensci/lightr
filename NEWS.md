# lightr 0.2

## New features and major changes

* `lr_parse_generic` (and thus `lr_get_spec()`) now works with non-UTF8 files
(this was a regression compared to pavo's `getspec()`)
* `lr_get_spec()` now has a new `interpolate` argument to determine whether you
want your data interpolated and pruned at every nm or not.

## Minor changes

* `savetime` field is now extracted from converted avantes files (when
available)

# lightr 0.1

* First release.
