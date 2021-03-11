## Test environments
- local Ubuntu 20.0.0 LTS, 4.0.3
- Windows Server 2019 (r-release)
- Mac OS X (r-release)
- Ubuntu 20.04.2 (r-release)
- Ubuntu 20.04.2 (r-devel)


## R CMD check results

- - 0 errors ✔ | 0 warnings ✔ | 1 notes ✔

* checking CRAN incoming feasibility ... NOTE

Maintainer: ‘Jorge Cimentada <cimentadaj@gmail.com>’
New submission
Package was archived on CRAN
CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2021-02-27 for policy violation.
  On Internet access, despite reminder and subsequent update.

## Reverse dependencies

There are currently no downstream dependencies for this package.

---

 `essurvey` was recently removed from CRAN because of some errors being raised in the vignette. Unfortunately, this was an error on my side because the European Social Survey website was having some certificate issues and vignettes were throwing errors. All vignettes are now precompiled by default and should never throw an error. Furthermore, I made sure all examples are wrapped in \dontrun, so no actual execution will happen when running R CMD check.

This should fix any execution errors for posterity.

- All tests are run weekly on Github Actions, which are available at https://github.com/ropensci/essurvey/action
