    # Environment variables from Travis CI

ess_email <- Sys.getenv("ess_email")

run_long_tests <- identical("true", Sys.getenv("NOT_CRAN"))

if (run_long_tests) {

  # Test for only one round
  round_one <- import_rounds(1, ess_email)

  # Test for only one wave
  wave_one_stata <- import_country("Denmark", 1, ess_email, format = "stata")
  wave_one_spss <- import_country("Denmark", 1, ess_email, format = "spss")

  # Test for all rounds
  rounds <- show_country_rounds("Netherlands")
  all_rounds <- import_country("Netherlands", rounds, ess_email)

  # Test for only one wave SDDF
  sample_round <- sample(show_sddf_cntrounds("Germany"), 1)
  wave_one_sddf <- import_sddf_country("Germany", sample_round, ess_email)

}


###### Tests for import_ and download_ functions.

check_one_round <- function(x, cntry) {
  # check is list
  expect_is(x, "data.frame")

  # check all columns are lower case
  expect_true(all(tolower(names(x)) == names(x)))

  # Check it is indeed the cntry
  expect_true(unique(x$cntry) == cntry)
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(x), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(x), 0)  
}

check_all_rounds <- function(x, rounds, country) {

  # Check all column names within each df are all lower case
  is_lowercase <- vapply(x,
                         function(dt) all(tolower(names(dt)) == names(df)),
                         FUN.VALUE = logical(1))
  # Check that all rounds downloaded are TRUE
  expect_true(all(is_lowercase))
  
  x <- lapply(x, function(x) {
    colnames(x) <- tolower(colnames(x))
    x
  })

  # check is list
  expect_is(x, "list")
  
  # check is length one
  expect_length(x, length(rounds))
  
  # check that all ess returns data frames
  expect_true(all(vapply(x,
                         function(x) "data.frame" %in% class(x),
                         FUN.VALUE = logical(1))))
  
  # check that all waves are for same country
  expect_true(all(vapply(x,
                         function(x) unique(x$cntry) == country,
                         FUN.VALUE = logical(1))))
  
  # check that all data frames have more than 0 rows
  expect_equal(all(vapply(x, nrow, numeric(1)) > 0), TRUE)
  
  # check that all data frames have more than 0 columns
  expect_equal(all(vapply(x, ncol, numeric(1)) > 0), TRUE)
}

check_downloaded_rounds <- function(x,
                                    rounds,
                                    format_args = c(".dta", ".do"),
                                    remove_dir = TRUE) {
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(x, pattern = "ESS", recursive = TRUE)
  
  # Same number of stata files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(format_args[1], ess_files)), rounds)
  
  # Same number of zip files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".zip", ess_files)), rounds)
  
  # Same number of do files as the rounds attempted
  # to download?
  if (".dta" %in% format_args) {
    expect_equal(sum(grepl(format_args[2], ess_files)), rounds)
  }
  
  # Delete all downloaded files
  if (remove_dir) unlink(dirname(x), recursive = TRUE, force = TRUE)
}

test_that("import_country checks for args", {

  expect_error(import_country(numeric()),
               regexp = "is.character(country) is not TRUE",
               fixed = TRUE)

  expect_error(import_country("Spain", numeric()),
               regexp = "length(rounds) > 0",
               fixed = TRUE)

  expect_error(import_country(c("Spain", "France"), 1),
               regexp = "Argument `country` should only contain one country",
               fixed = TRUE)

})


test_that("download_country checks for args", {

  expect_error(download_country(numeric()),
               regexp = "is.character(country) is not TRUE",
               fixed = TRUE)

  expect_error(download_country("Spain", numeric()),
               regexp = "length(rounds) > 0",
               fixed = TRUE)

  expect_error(download_country(c("Spain", "France"), 1),
               regexp = "Argument `country` should only contain one country",
               fixed = TRUE)

})


test_that("import_country for one round", {
  
  skip_on_cran()

  # Test for only one wave
  wave_one <- import_country("Denmark", 1, ess_email, format = "stata")
  
  check_one_round(wave_one, "DK")
  
  # Check it is indeed first round
  expect_true(unique(wave_one$essround) == 1)
  
})

test_that("import_country for all rounds of a country", {
  
  skip_on_cran()
  
  check_all_rounds(all_rounds, rounds, "NL")
  
  # Check that all waves are correct rounds
  expect_true(all(vapply(all_rounds,
                         function(x) unique(x$essround),
                         FUN.VALUE = numeric(1)) == rounds))

})

test_that("Test that downloading files is working fine", {
  
  skip_on_cran()
  
  # Test whether you get a message where the downloads are at
  expect_message(downloads <-
                   download_country("Austria",
                                    1,
                                    ess_email,
                                    output_dir = tempdir(),
                                    format = "stata"
                                    ),
                 "All files saved to")

  check_downloaded_rounds(downloads, 1)

  expect_message(downloads <-
                   download_country("Spain",
                                    4,
                                    ess_email,
                                    output_dir = tempdir(),
                                    format = "spss"
                                    ),
                 "All files saved to")

  check_downloaded_rounds(downloads, 1, c(".sav", ".sps"))


  # NULL iterates over each format ("stata", "spss", "sas") and read
  # the error-free attempt
  expect_message(downloads <-
                   download_country("Germany",
                                    7,
                                    ess_email,
                                    output_dir = tempdir(),
                                    format = NULL
                                    ),
                 "All files saved to")

  check_downloaded_rounds(downloads, 1, c(".dta", ".do"))  

})

# TODO: output_dir could be checked earlier
test_that("output_dir should be valid", {
  
  skip_on_cran()
  
  # Here output_dir is set to NULL
  expect_error(download_country("Austria",
                                1,
                                ess_email,
                                output_dir = NULL))

})

test_that("import_country files with other non-stata format", {
  skip_on_cran()
  
  check_one_round(wave_one_spss, "DK")
  
  # Check it is indeed first round
  expect_true(unique(wave_one_spss$essround) == 1)
  
})

test_that("Specify 'sas' for reading ess data throws error", {
  skip_on_cran()
  
  expect_error(import_country("Denmark", 1, ess_email, format = "sas"),
               "You cannot read SAS but only 'spss' and 'stata' files with this function") #nolint
})



test_that("import_sddf_country checks for args", {

  expect_error(import_sddf_country(numeric()),
               regexp = "is.character(country) is not TRUE",
               fixed = TRUE)

  expect_error(import_sddf_country("Spain", numeric()),
               regexp = "length(rounds) > 0",
               fixed = TRUE)

  expect_error(import_sddf_country(c("Spain", "France"), 1),
               regexp = "Argument `country` should only contain one country",
               fixed = TRUE)

  expect_error(import_sddf_country("Spain", 22, ess_email),
               regexp = "ESS round 22 doesn't have SDDF data available for Spain. Check show_sddf_cntrounds('Spain')", #nolintr
               fixed = TRUE)

  expect_error(import_sddf_country("Spain", c(1, 22), ess_email),
               regexp = "ESS round 22 doesn't have SDDF data available for Spain. Check show_sddf_cntrounds('Spain')", #nolintr
               fixed = TRUE)

  expect_error(import_sddf_country("Spain", c(24, 22), ess_email),
               regexp = "ESS round 22, 24 don't have SDDF data available for Spain. Check show_sddf_cntrounds('Spain')", #nolintr
               fixed = TRUE)

})

test_that("import_sddf_country for one round", {
  
  skip_on_cran()

  ## Tests for three waves from beginning to end

  # Test for only one wave. This round downloaded
  # for hungary changes randomly each time the test is run
  # to try to catch edge cases.
  check_one_round(wave_one_sddf, "DE")
})

# If you remember correctly, downloading .por files was raising an error
# because these .por files are actually .sav files with the wrong extension.
# I fixed it by switching .por to haven::read_sav. Here I test that It reads the
## correctly. Only rounds 1:4 had wrong .por files
test_that("import_sddf_country for one/many rounds from rounds 1:4", {
  
  skip_on_cran()
  
  many_waves <- import_sddf_country("Spain", 1:2, ess_email)
  check_all_rounds(many_waves, 1:2, "ES")

  many_waves <- import_sddf_country("Slovenia", 1:4, ess_email)
  check_all_rounds(many_waves, 1:4, "SI")

})

test_that("foreign installation is checked", {

  # See https://community.rstudio.com/t/how-can-i-make-testthat-think-i-dont-have-a-package-installed/33441/3 #nolintr
  with_mock(
    "essurvey:::is_foreign_installed" = function() FALSE,
    expect_error(import_sddf_country("France", 1:6, ess_email),
                 "Package `foreign` is needed to read some SDDF data. Please install with install.packages(\"foreign\")", #nolintr
                 fixed = TRUE) 
  )

})

if (is_foreign_installed()) {

  test_that("import_sddf_country can read files with foreign for France", {
    ## See https://github.com/ropensci/essurvey/issues/9#issuecomment-500131013
    
    skip_on_cran()

    rounds <- 1:3
    warning_msg <-
      paste("Round",
            rounds,
            "for France was read with the `foreign` package rather than with  the `haven` package for compatibility reasons.\n Please report any issues at https://github.com/ropensci/essurvey/issues") #nolintr
            
            for (i in rounds) {

              one_wave <-
                expect_warning(
                  import_sddf_country("France", i, ess_email),
                  warning_msg[i],
                  fixed = TRUE
                )

              check_one_round(one_wave, country_lookup["France"])
            }
  })

}

test_that("import_sddf_country for all rounds of a country", {
  
  skip_on_cran()
  # I want to test that the function is robust to different rounds, which
  # are read with different strategies: early rounds sometimes read with
  # foreign, middel rounds are read with haven and late rounds are read
  # from the integrated file

  test_all_rounds <- function(long_cnt, short_cnt) {
    rounds <- show_sddf_cntrounds(long_cnt, ess_email)
    # Round 7 was being read with foreign in the past, so I tried to capture
    # the warning that states that foreign read the package. Apparently they
    # fixed it, so now I test that NO WARNINGS occur.
    all_rounds <-
      expect_warning(
        import_sddf_country(long_cnt, rounds, ess_email),
        regexp = NA,
        fixed = TRUE
      )


    check_all_rounds(all_rounds, rounds, short_cnt)
  }

  # I had the same test repeated for other countries
  # but it takes too much time to run the tests
  test_all_rounds("Spain", country_lookup["Spain"])

})


test_that("download_sddf_country checks for args", {

  expect_error(download_sddf_country(numeric()),
               regexp = "is.character(country) is not TRUE",
               fixed = TRUE)

  expect_error(download_sddf_country("Spain", numeric()),
               regexp = "length(rounds) > 0",
               fixed = TRUE)

  expect_error(download_sddf_country(c("Spain", "France"), 1),
               regexp = "Argument `country` should only contain one country",
               fixed = TRUE)

})


# DO NOT MOVE this download function to the top of the script
# with the other downloads. I leave it here because it is used
# in this test and in the next and some of the tests above
# delete the tempdir (I think), deleting the downloaded files.
available_rounds <- show_sddf_cntrounds("Spain")

# Test if downloads all data for Spain and subsets correctly
# Test for when format is NULL which moves through 'stata', 'spss', and 'spss'
expect_message(downloads_spain <-
                 download_sddf_country("Spain",
                                       available_rounds,
                                       ess_email,
                                       output_dir = tempdir(),
                                       format = NULL
                                       ),
               "All files saved to")


test_that("Test that downloading files is working for sddf data", {
  
  skip_on_cran()

  # for very early sddf rounds there's no stata files, so this should
  # raise an error
  expect_error(downloads <-
                 download_sddf_country("France",
                                       1,
                                       ess_email,
                                       output_dir = tempdir(),
                                       format = "stata"
                                       ),
               regexp = "Format 'stata' not available")

  expect_message(downloads <-
                   download_sddf_country("France",
                                         1,
                                         ess_email,
                                         output_dir = tempdir(),
                                         format = "spss"
                                         ),
                 "All files saved to")

  # In SDDF no need to check for .do or .sps in the second argument
  check_downloaded_rounds(downloads, rounds = 1, c(".por", ""))

  # In SDDF no need to check for .do or .sps in the second argument
  # See the definition of downloading data at the beginning of the script
  check_downloaded_rounds(downloads_spain,
                          rounds = 8,
                          c(".dta|.por|.sav", ""),
                          # do not remove, files used in next test
                          remove_dir = FALSE)
})

test_that("Test that downloading all rounds is working for sddf data", {
  
  skip_on_cran()

  format_ext <- c(".dta", ".sav", ".por")

  file_names <-
    list.files(downloads_spain,
               recursive = TRUE,
               full.names = TRUE,
               pattern = paste(format_ext, collapse = "|"))

  expect_equal(seq_along(file_names), available_rounds)

  country_abbrv <- lapply(file_names, function(.x) {

    # Use function to read the specified format
    format_read <-
      switch(file_ext(.x),
             "dta" = haven::read_dta,
             "por" = haven::read_sav,
             "sav" = haven::read_sav
             )

    dt <- format_read(.x)
    names(dt) <- tolower(names(dt))
    unique(dt$cntry)
  })

  expect_true(all(country_abbrv == country_lookup["Spain"]))

})
