## Test environments
* local macOS High Sierra 10.13.3, R-3.4.3
* Ubuntu 14.04.5 LTS (on travis-ci), R-3.4.3
* win-builder

## R CMD check results

0 errors | 0 warnings | 0 notes

For win-builder:

Status: 1 NOTE
R Under development (unstable) (2018-02-19 r74276)

## Reverse dependencies

There are currently no downstream dependencies for this package.

---

**Change of name**

`essurvey` is the same package as `ess` in CRAN. I've decided to change the name of the package because it has very strong conflicts with the name Emacs Speaks Statistics (ESS). This problem was raised in the R-pkgs mailing list [here](http://r.789695.n4.nabble.com/R-pkgs-Release-of-ess-0-0-1-td4746540.html) and it also raised issues with other members of the R community [here](https://github.com/ropensci/onboarding/issues/201#issuecomment-372304003). In fact, the developers of the R package for Emacs Speaks Statistics and me agreed to put a note in the DESCRIPTION file of the `ess` package to explain that this is unrelated to the Emacs Speaks Statistics package. Because Emacs Speaks Statistics (ESS) has such a long precedence in the R community (dating back to at least 1994), I've decided to switch the name of `ess` to `essurvey` to avoid further conflicts. However, `essurvey` has new features so the idea is to drop `ess` altogether and upload `essurvey` instead.


---

- *Most* examples are wrapped in \dontrun{} because they cannot be run
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