## Test environments
- local Ubuntu 18.04.5 LTS, R-3.6.1
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Reverse dependencies

There are currently no downstream dependencies for this package.

---

- Maintenance check for problem with Solaris warning saying that 'Warning in engine$weave(file, quiet = quiet, encoding = enc) :
Pandoc (>= 1.12.3) and/or pandoc-citeproc not available. Falling back to R Markdown v1'. This is what the CRAN checks
were saying https://www.r-project.org/nosvn/R.check/r-patched-solaris-x86/essurvey-00check.html yet this runs well on
Solaris in Rhub https://builder.r-hub.io/status/original/essurvey_1.0.5.tar.gz-843e084a807144a2acc95d9dcdc9acb0. Oddly,
this warning is only present in Solaris with all other platforms passing gracefully.

- I previously submitted the package to find some NOTES that I hadn't addressed only win-builder. These are now fixed.

- All tests are run weekly on Travis, which are available at https://travis-ci.com/github/ropensci/essurvey
