
ess <img src="man/figures/ess_logo.png" align="right" />
--------------------------------------------------------

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/ess)](https://cran.r-project.org/package=ess) [![Travis-CI Build Status](https://travis-ci.org/cimentadaj/ess.svg?branch=master)](https://travis-ci.org/cimentadaj/ess)

Description
-----------

The European Social Survey (ESS) is an academically driven cross-national survey that has been conducted across Europe since its establishment in 2001. Every two years, face-to-face interviews are conducted with newly selected, cross-sectional samples. The survey measures the attitudes, beliefs and behaviour patterns of diverse populations in more than thirty nations. Taken from the [ESS website](http://www.europeansocialsurvey.org/about/).

The `ess` package is designed to download the ESS data as easily as possible. It has a few helper functions to download rounds, rounds for a selected country and to show which rounds/countries are available. Check out the vignette for a more detailed example of the `ess` package.

Installation
------------

You can install and load the development version with these commands:

``` r
# install.packages("devtools") in case you don't have it
devtools::install_github("cimentadaj/ess")
```

or the stable version with:

``` r
install.packages("ess")
```

Usage
-----

First, you need to register at the ESS website, in case you haven't. Please visit the [register](http://www.europeansocialsurvey.org/user/new) section from the ESS website. If your email is not registered at their website, an error will be raised prompting you to go register.

To download the first round to use in R:

``` r
library(ess)
one_round <- ess_rounds(1, "your_email@email.com")
```

This will return a list object with round 1 in the first slot. You can also download several rounds by supplying the number of rounds.

``` r
five_rounds <- ess_rounds(1:5, "your_email@email.com")
```

This will download all latest versions of rounds 1 through 5 and return a list of length 5 with each round as a data frame inside the list.

You can check the available rounds with `show_rounds()` because if you supply a non existent round, the function will return an error.

``` r
two_rounds <- ess_rounds(c(1, 22), "your_email@email.com")
#> Error in ess_round_url(rounds) : 
#> ESS round 22 is not a available. Check show_rounds() 
```

Alternatively, you can download all available rounds with `ess_all_rounds()`.

You can also download rounds by country:

``` r
dk_two <- ess_country("Denmark", 1:2, "your_email@email.com")
```

Use `show_countries()` to see available countries and `show_country_rounds("Denmark")` to see available rounds for chosen country. Alternatively, use `ess_all_cntrounds()` to download all available rounds of a country.

Stata, SPSS and SAS users
-------------------------

I'm quite aware that most ESS users don't know R, that is why the function also allows you to download the data in Stata, SPSS or SAS format with just one line of code. Just set the `only_download` argument to `TRUE`, specify where it will be saved and specify the format to be either `'stata'` (default), `'spss'` or `'sas'`:

``` r
ess_rounds(c(1, 2),
           "your_email@email.com",
           only_download = TRUE,
           output_dir = "my/new/directory",
           format = 'spss')
```

This will save the ESS rounds into separate folders and unzip them in the specified directory (if you want to know your current directory, type `getwd()`). This works the same way for `ess_country()`.

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
