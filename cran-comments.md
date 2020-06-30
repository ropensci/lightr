## Test environments

* local Ubuntu 20.04, R 4.0.2
* local Raspbian buster (ARM/noLD), R 3.5.2

* Ubuntu 16.04.6 LTS (on GitHub actions), R 3.6, R 3.5,
  R 4.0 (with two different locales)
* macOS (on GitHub actions), R 4.0 and R-devel
* Windows (on GitHub actions), R 4.0

* win-builder (R release and devel)

* rhub::check_for_cran()
* rhub::check_on_solaris()

## R CMD check results

0 errors | 0 warnings | 0 notes

## Comments

Resubmission as required by Prof Brian Ripley after the latest changes uncovered
precision issues on Solaris that cause the hash tests to fail.
