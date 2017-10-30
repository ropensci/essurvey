
Overview <img src="man/figures/ess_logo.png" align="right" />
-------------------------------------------------------------

The European Social Survey (ESS) is an academically driven cross-national survey that has been conducted across Europe since its establishment in 2001. Every two years, face-to-face interviews are conducted with newly selected, cross-sectional samples. The survey measures the attitudes, beliefs and behaviour patterns of diverse populations in more than thirty nations. Taken from the [ESS website](http://www.europeansocialsurvey.org/about/).

The `ess` package is designed to download the ESS data as easily as possible. This is very first stage of the package. At this moment there is only one function that allows you to download all or a selected number of available rounds from their website. The next stage of the package will allow to download all rounds for a specific country.

Installation
------------

You can install and load the package with these commands:

``` r
# install.packages("devtools") in case you don't have it
devtools::install_github("cimentadaj/ess")
```

For now the package will be available on Github but sometime in the near future it will be submitted to CRAN.

Usage
-----

First, you need to register at the ESS website, in case you haven't. Please visit the [register](http://www.europeansocialsurvey.org/user/new) section from the ESS website. If your email is not registered at their website, an error will be raised prompting you to go register.

To download the first round to use in R:

``` r
library(ess)
one_round <- ess_rounds(1, "your_email@email.com")
```

This will return a list object with round 1 in the first slot. You can also download several rounds by just supplying the number of rounds.

``` r
five_rounds <- ess_rounds(1:5, "your_email@email.com")
```

This will download all latest versions of rounds 1 through 5 and return a list of length 5 with each round as a data frame inside the list.

You should make sure you download the correct rounds available at [their website](http://www.europeansocialsurvey.org/data/round-index.html) because if you supply a non existent round, the function will return an error.

``` r
two_rounds <- ess_rounds(c(1, 22), "your_email@email.com")

#> Error in ess_url(rounds) :
#> ESS round 22 is not a available at
#> http://www.europeansocialsurvey.org/data/round-index.html
```

Stata users
-----------

I'm quite aware that most ESS users don't know R, that is why the function also allows you to download the data in Stata format with just one line of code. Just set the `only_download` argument to `TRUE`:

``` r
ess_rounds(c(1, 2), "your_email@email.com", only_download = TRUE)
```

This will save the ESS rounds into separate folders and unzip them in current directory (if you want to know your current directory, type `getwd()`). In case you want to change where the function saves the files, add a directory in the `output_dir` argument.

``` r
ess_rounds(c(1, 2), "your_email@email.com", output_dir = "my/new/directory", only_download = TRUE)
```

Stay tuned for new releases!
