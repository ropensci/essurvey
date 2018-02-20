# ess 0.1.1 (2018-02-20)

## Breaking changes

* Downloading 1 round both for countries or single rounds now returns a data frame rather than a list. If download is more than two rounds it returns a list. [#8](https://github.com/cimentadaj/ess/issues/8)

## New features

* remove_missings() together with remove_numeric_missings() and remove_character_missings() now allow you to recode the typical categories 'Not applicable', 'Don't know', etc.. into NA's. See the vignette example for more details. [#1](https://github.com/cimentadaj/ess/issues/1)

* Can download files in 'stata', 'spss' and 'sas' formats for all functions (both for downloading to user's directory and for reading data). [#11](https://github.com/cimentadaj/ess/issues/11).

* show_themes() and show_theme_rounds() now available to see which themes have been included in which rounds. [#7](https://github.com/cimentadaj/ess/issues/7)

* show_rounds_country() is now available to see which countries participated in which rounds [#14](https://github.com/cimentadaj/ess/issues/14)

## Bug fixes

* The `ouput_dir` argument is now set to `getwd()` rather than `NULL` as default. [#16](https://github.com/cimentadaj/ess/issues/16)

* When parsing country rounds from the [table](http://www.europeansocialsurvey.org/data/country_index.html), shaded dots were being interpreted as valid rounds when in fact they're not. show_* funs new exclude shaded dots until they've been added as valid rounds

* If any `ess_*` function can not connect to the ESS website they will return an explicit R error. [#12](https://github.com/cimentadaj/ess/issues/12)

* `ess_all_cntrounds` and `ess_all_rounds` were returning the directory of each of the files. Now they only return the single directory where the files where saved as a message

# ess 0.0.1 (2017-11-07)

First release