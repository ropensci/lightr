## Test environments

* local Ubuntu 20.04, R 4.1.0

* Ubuntu 20.04 LTS (on GitHub actions), R 4.0, R 3.6, R 3.5,
  R release (with different locales and different timezones), R-devel
* macOS (on GitHub actions), R release
* Windows (on GitHub actions), R release

* win-builder (R release and devel)

* rhub::check_for_cran()
* rhub::check_on_solaris()
* rhub::check(platform = "debian-gcc-devel-nold")

## R CMD check results

0 errors | 0 warnings | 1 note

N  checking CRAN incoming feasibility (1m 17.5s)
   Maintainer: ‘Hugo Gruson <hugo.gruson+R@normalesup.org>’
   
   Days since last update: 0

## Comments

This update comes right after the last one as CRAN checks caught a problem
with a test that was skipped locally and on my CI system (which is also a bug
in itself. It should have been tested there.)

The test has been fixed and my CI system has been updated to not skip this test.
