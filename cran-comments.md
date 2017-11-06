## Test environments
* local macOS Sierra 10.12.6, R-3.4.2
* Ubuntu 14.04.5 LTS (on travis-ci), R-3.4.2
* win-builder

## R CMD check results

0 errors | 0 warnings | 0 notes

For win-builder:

Status: 1 NOTE
R Under development (unstable) (2017-09-12 r73242)

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

- *Most* examples are wrapped in \dontrun{} because they cannot be run
  in < 5 seconds. No smaller toy examples can be created. Functions
  which can be executed in < 5 are allow to run.

  Also, most functions use personal emails to actually run. Even if using
  \dontshow{} I wouldn’t want to reveal any information (either on Github or
  somewhere on the CRAN repo) of personal use.

- The tests are wrapped in testthat:::skip_on_cran()
  since they absolutely require using a private email. Full tests
  are run on Travis (weekly) with results available for review:
  https://travis-ci.org/cimentadaj/ess
  
  The Travis tests have an environment variable containing the email. This
  allows the tests to run smoothly.