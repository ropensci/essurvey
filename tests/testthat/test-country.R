# Environment variables from Travis CI

your_email <- Sys.getenv("your_email")

test_that("ess_country for one round", {
  
  skip_on_cran()
  
  # Test for only one wave
  wave_one <- ess_country("Denmark", 1, your_email)
  
  # check is list
  expect_is(wave_one, "data.frame")
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(wave_one), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(wave_one), 0)
})

test_that("ess_country for all rounds of a country", {
  
  skip_on_cran()
  
  # Test for all rounds
  all_rounds <- ess_country("Netherlands", 1:7, your_email)
  
  # check is list
  expect_is(all_rounds, "list")
  
  # check is length one
  expect_length(all_rounds, 7)
  
  # check that all ess returns data frames
  expect_true(all(vapply(all_rounds,
                         function(x) "data.frame" %in% class(x),
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
                   ess_country("Austria",
                               1:which_rounds,
                               your_email,
                               only_download = TRUE,
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

test_that("Test if only_download is TRUE, output_dir should be valid", {
  
  skip_on_cran()
  
  # Here output_dir is set to NULL
  expect_error(ess_country("Austria",
                           1:which_rounds,
                           your_email,
                           only_download = TRUE,
                           output_dir = NULL))
})

test_that("Download country files with other non-stata format", {
  skip_on_cran()
  
  # Test for only one wave
  wave_one <- ess_country("Denmark", 1, your_email, format = "spss")
  
  # check is list
  expect_is(wave_one, "data.frame")
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(wave_one), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(wave_one), 0)
  
})

test_that("Specify 'sas' for reading ess data throws error",{
  expect_error(ess_country("Denmark", 1, your_email, format = "sas"),
               "You cannot read SAS but only 'spss' and 'stata' files with this function")
})
