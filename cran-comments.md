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

Maintenance check excluding all examples/tests based on the comment from Brian
Ripley saying that "Packages which use Internet resources should fail gracefully
with an informative message if the resource is not available (and not give a
check warning nor error)". 

All tests are run weekly on Travis, which are available at https://travis-ci.org/ropensci/essurvey

- *All* examples are wrapped in \dontrun{} because they cannot be run
  in < 5 seconds. No smaller toy examples can be created. Functions
  which can be executed in < 5 are allow to run.

  Also, most functions use personal emails to actually run. Even if using
  \dontshow{} I wouldn’t want to reveal any information (either on Github or
  somewhere on the CRAN repo) of personal use.

- The tests are wrapped skip_on_cran()
  since they absolutely require using a private email. Full tests
  are run on Travis (weekly) with results available for review:
  https://travis-ci.org/ropensci/essurvey
  
  The Travis tests have an environment variable containing the email. This
  allows the tests to run smoothly.
