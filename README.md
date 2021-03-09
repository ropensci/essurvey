
## essurvey <img src="man/figures/ess_logo.png" align="right" />

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/essurvey)](https://cran.r-project.org/package=essurvey)
[![R build
status](https://github.com/ropensci/essurvey/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/essurvey/actions)
[![Coverage
status](https://codecov.io/gh/ropensci/essurvey/branch/master/graph/badge.svg)](https://codecov.io/github/ropensci/essurvey?branch=master)
[![rOpensci\_Badge](https://badges.ropensci.org/201_status.svg)](https://github.com/ropensci/software-review/issues/201)

## Description

The European Social Survey (ESS) is an academically driven
cross-national survey that has been conducted across Europe since its
establishment in 2001. Every two years, face-to-face interviews are
conducted with newly selected, cross-sectional samples. The survey
measures the attitudes, beliefs and behavior patterns of diverse
populations in more than thirty nations. Taken from the [ESS
website](http://www.europeansocialsurvey.org/about/).

Note: The `essurvey` package was originally called `ess`. Since
`essurvey 1.0.0` all `ess_*` functions have been deprecated in favor of
the `import_*` and `download_*` functions. Also, versions less than and
including `essurvey 1.0.1` returned wrong countries. Please install the
latest CRAN/Github version.

The `essurvey` package is designed to download the ESS data as easily as
possible. It has a few helper functions to download rounds (a term
synonym to waves to denote the same survey in different time points),
rounds for a selected country and to show which rounds/countries are
available. Check out the vignette and other documentation in the
[package’s website](https://docs.ropensci.org/essurvey/) for more
detailed examples of the `essurvey` package.

## Installation

You can install and load the development version with these commands:

``` r
# install.packages("devtools") in case you don't have it
devtools::install_github("ropensci/essurvey")
```

or the stable version with:

``` r
install.packages("essurvey")
```

## Usage

First, you need to register at the ESS website, in case you haven’t.
Please visit the
[register](http://www.europeansocialsurvey.org/user/new) section from
the ESS website. If your email is not registered at their website, an
error will be raised prompting you to go register.

Set your valid email as en environment variable.

``` r
set_email("your@email.com")
```

To explore which rounds/countries are present in the ESS use the
`show_*()` family of functions.

``` r
library(essurvey)
show_countries()
#>  [1] "Albania"            "Austria"            "Belgium"           
#>  [4] "Bulgaria"           "Croatia"            "Cyprus"            
#>  [7] "Czechia"            "Denmark"            "Estonia"           
#> [10] "Finland"            "France"             "Germany"           
#> [13] "Greece"             "Hungary"            "Iceland"           
#> [16] "Ireland"            "Israel"             "Italy"             
#> [19] "Kosovo"             "Latvia"             "Lithuania"         
#> [22] "Luxembourg"         "Montenegro"         "Netherlands"       
#> [25] "Norway"             "Poland"             "Portugal"          
#> [28] "Romania"            "Russian Federation" "Serbia"            
#> [31] "Slovakia"           "Slovenia"           "Spain"             
#> [34] "Sweden"             "Switzerland"        "Turkey"            
#> [37] "Ukraine"            "United Kingdom"
```

To download the first round to use in R:

``` r
one_round <- import_rounds(1)
```

This will return a data frame containing the first round. Typically, the
European Social Survey data files comes with a script that recodes
missing values to `NA` for different programs (Stata, SPSS, SAS).

Use `recode_missings` to recode all values automatically.

``` r
library(tidyverse)

one_round <-
  import_rounds(1) %>%
  recode_missings()
```

See the package vignette for greater detail or see the help page with
`?recode_missings`. You can also download several rounds by supplying
the number of rounds.

``` r
five_rounds <- import_rounds(1:5)
```

This will download all latest versions of rounds 1 through 5 and return
a list of length 5 with each round as a data frame inside the list.

You can check the available rounds with `show_rounds()` because if you
supply a non existent round, the function will return an error.

``` r
two_rounds <- import_rounds(c(1, 22))
#> Error in round_url(rounds) : 
#> ESS round 22 is not a available. Check show_rounds() 
```

Alternatively, you can download all available rounds with
`import_all_rounds()`.

You can also download rounds by country:

``` r
dk_two <- import_country("Denmark", 1:2)
```

Use `show_countries()` to see available countries and
`show_country_rounds("Denmark")` to see available rounds for chosen
country. Alternatively, use `import_all_cntrounds()` to download all
available rounds of a country.

You should be be aware that data from the ESS survey should by analyzed
by taking into consideration the sampling and weights of the survey. A
useful example comes from the work of Anthony Damico and Daniel Oberski
[here](http://asdfree.com/european-social-survey-ess.html).

## Stata, SPSS and SAS users

I’m quite aware that most ESS users don’t know R, that is why the
package also allows to download the data in Stata, SPSS or SAS format
with just one line of code. Instead of the `import_*` functions, use the
`download_*` functions.

``` r
download_rounds(c(1, 2),
                output_dir = "my/new/directory",
                format = 'spss')
```

This will save the ESS rounds into separate folders and unzip them in
the specified directory (if you want to know your current directory,
type `getwd()`). This works the same way for `download_country()`. Be
aware that if you download the files manually you should read them into
R with the `haven` package for all `essurvey` related functions to work.

-----

Please note that this project is released with a [Contributor Code of
Conduct](https://docs.ropensci.org/essurvey/CONDUCT.html). By
participating in this project you agree to abide by its terms.

[![ropensci\_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
