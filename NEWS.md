## essurvey 1.0.3.9999

### Breaking changes

* If you don't know which format is available for a round/country, `import_*` and `download_*` functions now accept a NULL argument which runs through `'stata'`, `'spss'` and `'sas'` formats automatically. By default, `import_*` functions have now format set to `NULL` to automatically try the three different formats. This breaks backward dependency but only slightly where it had 'stata' set as default.

### New features

* Users can now download SDDF (weight data) for each country/round combination of files. Functions `show_sddf_cntrounds`, `import_sddf_country` and `download_sddf_country` are now introduced. For technical purposes, `show_sddf_cntrounds` needs for the user to have set their registered ESS email with `set_email`. [#9]

### Minor changes

* Bumps `haven` to minimum package version 2.1.1
* New package website at https://docs.ropensci.org/essurvey

### Internal

* `read_format_data` now tries to read data using `haven` but falls backs to `foreign` in case there's an error. This should only work for SDDF data [#38].
* `read_format_data` and `read_sddf_data` now always return a list. Checking the length of data to return a data frame now happens within each `import_*` function.

### Bug fixes

* Removes an unnecessary if statement in `set_email` that didn't allow to overwrite the email once set.

## essurvey 1.0.2

### Minor changes

* `show_country_rounds` checks if there are missing values and excludes them.

### Breaking changes

`import_all_cntrounds` and `import_country` returned incorrect countries [#31]

## essurvey 1.0.1

### Minor changes

* `ess_email` is now checked that it is not `""` because it wasn't raising an error before.

* Removes the `round` argument from `import_all_cntrounds` because it was a mistake. It already grabs the rounds internally.

## essurvey 1.0.1

Minor release

* Fixes test that checks the number of rounds that each country has. This test was a mistake
because the rounds will change as time passes by and precise country rounds shouldn't be
tested.

## essurvey 1.0.0

The `ess` package has been renamed to `essurvey` for a name conflict with Emacs Speaks Statistics (ESS). See R-pkg mailing list, the post related to the release of ess-0-0-1.

### Breaking changes

* `ess_rounds` and `ess_all_rounds` are deprecated and will be removed in the next release. Use `import_rounds` instead [#22]

* `ess_country` and `ess_all_cntrounds` are deprecated and will be removed in the next release. Use `import_countries` instead [#22]

* The `your_email` argument name of `ess_*` functions has be changed to `ess_email` [#23]

### New features

* `import_rounds`, `import_all_rounds` and `download_rounds` have been introduced as
replacements of `ess_rounds` and `ess_all_rounds`. Same changes were repeated for
`ess_country` and `ess_all_cntrounds` [#22]

* `set_email` to set your email as environmental variable rather than write it in each call [#23]

* All requests to the ESS website are now done through HTTPS rather than HTTP [#24]

* Add package level documentation [#20]

### Minor changes

* `ess_email` had no default value but now has `NULL` as default [#23]

* The `format` argument is now checked through `match.arg` rathern than manual check [#25]

## ess 0.1.1 (2018-03-05)

### Breaking changes

* Downloading 1 round both for countries or single rounds now returns a data frame rather than a list. If download is more than two rounds it returns a list. [#8]

### New features

* remove_missings() together with remove_numeric_missings() and remove_character_missings() now allow you to recode the typical categories 'Not applicable', 'Don't know', etc.. into NA's. See the vignette example for more details. [#1]

* Can download files in 'stata', 'spss' and 'sas' formats for all functions (both for downloading to user's directory and for reading data). [#11]

* show_themes() and show_theme_rounds() now available to see which themes have been included in which rounds. [#7]

* show_rounds_country() is now available to see which countries participated in which rounds [#14]

### Bug fixes

* The `ouput_dir` argument is now set to `getwd()` rather than `NULL` as default. [#16]

* When parsing country rounds from the ESS table from the website, shaded dots were being interpreted as valid rounds when in fact they're not. show_* funs new exclude shaded dots until they've been added as valid rounds

* If any `ess_*` function can not connect to the ESS website they will return an explicit R error. [#12]

* `ess_all_cntrounds` and `ess_all_rounds` were returning the directory of each of the files. Now they only return the single directory where the files where saved as a message

## ess 0.0.1 (2017-11-07)

First release
