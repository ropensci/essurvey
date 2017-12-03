# ess 0.1.1

## New features

* Can download files in 'stata', 'spss' and 'sas' formats for all functions.
* show_themes() and show_theme_rounds() now available to see which themes have been asked in which rounds.

## Bug fixes
* Downloading 1 round both for countries or single rounds now returns a data frame rather than a list.
* `ess_all_cntrounds` and `ess_all_rounds` were returning the directory of each of the files. Now they only return the single directory where the files where saved as a message.