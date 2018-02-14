# ess 0.1.1


## Breaking changes

* Downloading 1 round both for countries or single rounds now returns a data frame rather than a list. If download is more than two rounds it returns a list.

## New features

* Can download files in 'stata', 'spss' and 'sas' formats for all functions (both for downloading to user's directory and for reading data. [#11](https://github.com/cimentadaj/ess/issues/11).

* show_themes() and show_theme_rounds() now available to see which themes have been included in which rounds.

* show_rounds_country() is now available to see which countries participated in which rounds [#14](https://github.com/cimentadaj/ess/issues/14)

## Bug fixes

* When parsing country rounds from the [table](http://www.europeansocialsurvey.org/data/country_index.html), shaded dots were being interpreted as valid rounds when in fact they're not. show_* funs new exclude shaded dots until they've been added as valid rounds

* If the functions can not connect to the ESS website they will return an explicit R error

* `ess_all_cntrounds` and `ess_all_rounds` were returning the directory of each of the files. Now they only return the single directory where the files where saved as a message