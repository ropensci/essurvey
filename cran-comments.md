## Test environments
- local Ubuntu 18.04.5 LTS, R-3.6.1
- Windows Server 2019 (r-release)
- Mac OS X (r-release)
- Ubuntu 20.04.2 (r-release)
- Ubuntu 20.04.2 (r-devel)


## R CMD check results

- - 0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Reverse dependencies

There are currently no downstream dependencies for this package.

---

 `essurvey` was recently removed from CRAN because of some errors being raised in the vignette. Unfortunately, this was an error on my side because the European Social Survey website was having some certificate issues. All vignettes are now precompiled and should never throw an error. Furthermore, I made sure all examples are wrapped in \dontrun, so no actual execution will happen when running R CMD check.

This should fix any execution errors for posterity.

- All tests are run weekly on Github Actions, which are available at https://github.com/ropensci/essurvey/action
