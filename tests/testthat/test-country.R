# Environment variables from Travis CI

ess_email <- Sys.getenv("ess_email")

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
  
  x <- lapply(x, function(x) {colnames(x) <- tolower(colnames(x)); x})
  # check is list
  expect_is(x, "list")
  
  # check is length one
  expect_length(x, length(rounds))
  
  # check that all ess returns data frames
  expect_true(all(vapply(x,
                         function(x) "data.frame" %in% class(x),
                         FUN.VALUE = logical(1))))
  
  # check that all waves are for netherlands
  expect_true(all(vapply(x,
                         function(x) unique(x$cntry) == country,
                         FUN.VALUE = logical(1))))
  
  # check that all data frames have more than 0 rows
  expect_equal(all(vapply(x, nrow, numeric(1)) > 0), TRUE)
  
  # check that all data frames have more than 0 columns
  expect_equal(all(vapply(x, ncol, numeric(1)) > 0), TRUE)
}

check_downloaded_rounds <- function(x, rounds, format_args = c(".dta", ".do")) {
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
  unlink(dirname(x), recursive = TRUE, force = TRUE)
  
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
  wave_one <- import_country("Denmark", 1, ess_email, format = 'stata')
  
  check_one_round(wave_one, "DK")
  
  # Check it is indeed first round
  expect_true(unique(wave_one$essround) == 1)
  
})

test_that("import_country for all rounds of a country", {
  
  skip_on_cran()
  
  rounds <- show_country_rounds("Netherlands")
  
  # Test for all rounds
  all_rounds <- import_country("Netherlands", rounds, ess_email)
  
  check_all_rounds(all_rounds, rounds, "NL")
  
  # Check that all waves are correct rounds
  expect_true(all(vapply(all_rounds,
                         function(x) unique(x$essround),
                         FUN.VALUE = numeric(1)) == rounds))

})

test_that("Test that downloading files is working fine", {
  
  skip_on_cran()
  
  # Test whether you get a message where the downloads are at
  which_rounds <- 2
  expect_message(downloads <-
                   download_country("Austria",
                                    1:which_rounds,
                                    ess_email,
                                    output_dir = tempdir()
                                    ),
                 "All files saved to")

  check_downloaded_rounds(downloads, which_rounds)

  expect_message(downloads <-
                   download_country("Spain",
                                    1:which_rounds,
                                    ess_email,
                                    output_dir = tempdir(),
                                    format = 'spss'
                                    ),
                 "All files saved to")

  check_downloaded_rounds(downloads, which_rounds, c(".sav", ".sps"))


  expect_message(downloads <-
                   download_country("Germany",
                                    1:which_rounds,
                                    ess_email,
                                    output_dir = tempdir(),
                                    format = NULL
                                    ),
                 "All files saved to")

  check_downloaded_rounds(downloads, which_rounds, c(".dta", ".do"))  
})

test_that("output_dir should be valid", {
  
  skip_on_cran()
  
  # Here output_dir is set to NULL
  expect_error(download_country("Austria",
                           1:which_rounds,
                           ess_email,
                           output_dir = NULL))
})

test_that("import_country files with other non-stata format", {
  skip_on_cran()
  
  # Test for only one wave
  wave_one <- import_country("Denmark", 1, ess_email, format = "spss")
  
  check_one_round(wave_one, "DK")
  
  # Check it is indeed first round
  expect_true(unique(wave_one$essround) == 1)
  
})

test_that("Specify 'sas' for reading ess data throws error",{
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

})

test_that("import_sddf_country for one round", {
  
  skip_on_cran()
  
  # Test for only one wave
  wave_one <- import_sddf_country("Spain", 5, ess_email)
  
  check_one_round(wave_one, "ES")
})

# If you remember correctly, downloading .por files was raising an error
# because these .por files are actually .sav files with the wrong extension.
# I fixed it by switching .por to haven::read_sav. Here I test that It reads the correctly
# Only rounds 1:4 had wrong .por files
test_that("import_sddf_country for one/many rounds from rounds 1:4", {
  
  skip_on_cran()
  
  many_waves <- import_sddf_country("Spain", 1:2, ess_email)
  check_all_rounds(many_waves, 1:2, "ES")

  many_waves <- import_sddf_country("Slovenia", 1:4, ess_email)
  check_all_rounds(many_waves, 1:4, "SI")
})


test_that("import_sddf_country for all rounds of a country", {
  
  skip_on_cran()
  
  rounds <- show_sddf_rounds("Netherlands")
  # Test for all rounds
  all_rounds <- import_sddf_country("Netherlands", rounds, ess_email)
  
  check_all_rounds(all_rounds, rounds, "NL")
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


test_that("Test that downloading files is working for sddf data", {
  
  skip_on_cran()
  

  # for very early sddf rounds there's no stata files, so this should
  # raise an error
  which_rounds <- 2
  expect_error(downloads <-
                   download_sddf_country("France",
                                         1:which_rounds,
                                         ess_email,
                                         output_dir = tempdir(),
                                         format = 'stata'
                                         ),
               regexp = "Format 'stata' not available")

  expect_message(downloads <-
                   download_sddf_country("France",
                                         1:which_rounds,
                                         ess_email,
                                         output_dir = tempdir(),
                                         format = 'spss'
                                         ),
                 "All files saved to")

  check_downloaded_rounds(downloads, which_rounds, c(".por", ".sps"))

  # Test for when format is NULL which moves through 'stata', 'spss', and 'spss'  
  expect_message(downloads <-
                   download_sddf_country("Spain",
                                         1:which_rounds,
                                         ess_email,
                                         output_dir = tempdir(),
                                         format = NULL
                                         ),
                 "All files saved to")

  check_downloaded_rounds(downloads, which_rounds, c(".por", ".sps"))
  })
