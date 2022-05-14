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
