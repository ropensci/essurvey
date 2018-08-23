# Environment variables from Travis CI

ess_email <- Sys.getenv("ess_email")

###### Tests for import_ and download_ functions.

test_that("import_country for one round", {
  
  skip_on_cran()
  
  # Test for only one wave
  wave_one <- import_country("Denmark", 1, ess_email, format = 'stata')
  
  # check is list
  expect_is(wave_one, "data.frame")
  
  # Check it is indeed DK
  expect_true(unique(wave_one$cntry) == "DK")
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(wave_one), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(wave_one), 0)
})

test_that("import_country for all rounds of a country", {
  
  skip_on_cran()
  
  # Test for all rounds
  all_rounds <- import_country("Netherlands", 1:7, ess_email)
  
  # check is list
  expect_is(all_rounds, "list")
  
  # check is length one
  expect_length(all_rounds, 7)
  
  # check that all ess returns data frames
  expect_true(all(vapply(all_rounds,
                         function(x) "data.frame" %in% class(x),
                         FUN.VALUE = logical(1))))
  
  # check that all waves are for netherlands
  expect_true(all(vapply(all_rounds,
                         function(x) unique(x$cntry) == "NL",
                         FUN.VALUE = logical(1))))
  
  # check that all data frames have more than 0 rows
  expect_equal(all(vapply(all_rounds, nrow, numeric(1)) > 0), TRUE)
  
  # check that all data frames have more than 0 columns
  expect_equal(all(vapply(all_rounds, ncol, numeric(1)) > 0), TRUE)
  
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
  
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(downloads, pattern = "ESS", recursive = TRUE)
  
  # Same number of stata files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".dta", ess_files)), which_rounds)
  
  # Same number of zip files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".zip", ess_files)), which_rounds)
  
  # Same number of do files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".do", ess_files)), which_rounds)
  
  # Delete all downloaded files
  unlink(dirname(downloads), recursive = TRUE, force = TRUE)
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
  
  # check is list
  expect_is(wave_one, "data.frame")
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(wave_one), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(wave_one), 0)
  
})

test_that("Specify 'sas' for reading ess data throws error",{
  skip_on_cran()
  
  expect_error(import_country("Denmark", 1, ess_email, format = "sas"),
               "You cannot read SAS but only 'spss' and 'stata' files with this function") #nolint
})
