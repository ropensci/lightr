## Test environments

* local Ubuntu 16.04.6 LTS, R 3.6.1
* Ubuntu 16.04.6 LTS (on travis-ci), R 3.6.1, R 3.5.3, R devel
* macOS (on travis-ci), R 3.6.1
* win-builder (R 3.6.1 and devel)
* rhub::check_for_cran()

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

* Following CRAN feedback:
  - the default value for the 'where' argument of lr_convert_tocsv() has been
    removed.
  - the DESCRIPTION has been updated to remove acronyms, format the reference
    as requested and add a copyright holder.
