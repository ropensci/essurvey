# Environment variables from Travis CI

your_email <- Sys.getenv("your_email")

test_that("ess_country for one round", {
  
  testthat::skip_on_cran()
  
  # Test for only one wave
  wave_one <- ess_country("Denmark", 1, your_email)
  
  # check is list
  expect_is(wave_one, "list")
  
  # check is length one
  expect_length(wave_one, 1)
  
  # check that ess_country returns data frames
  expect_is(wave_one[[1]], "data.frame")
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(wave_one[[1]]), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(wave_one[[1]]), 0)
})

test_that("ess_country for all rounds of a country", {
  
  testthat::skip_on_cran()
  
  # Test for all rounds
  all_rounds <- ess_country("Netherlands", 1:7, your_email)
  
  # check is list
  expect_is(all_rounds, "list")
  
  # check is length one
  expect_length(all_rounds, 7)
  
  # check that all ess returns data frames
  expect_equal(all(sapply(all_rounds, function(x) "data.frame" %in% class(x))), TRUE)
  
  # check that all data frames have more than 0 rows
  expect_equal(all(sapply(all_rounds, nrow) > 0), TRUE)
  
  # check that all data frames have more than 0 columns
  expect_equal(all(sapply(all_rounds, ncol) > 0), TRUE)
  
})

test_that("Test that downloading files is working fine", {
  
  testthat::skip_on_cran()
  
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
  
  testthat::skip_on_cran()
  
  # Here output_dir is set to NULL
  expect_error(ess_country("Austria",
                           1:which_rounds,
                           your_email,
                           only_download = TRUE,
                           output_dir = NULL))
})

test_that("Download country files with other non-stata format is ignored", {
  testthat::skip_on_cran()
  
  # Test for only one wave
  wave_one <- ess_country("Denmark", 1, your_email, format = "spss")
  
  # check is list
  expect_is(wave_one, "list")
  
  # check is length one
  expect_length(wave_one, 1)
  
  # check that ess_country returns data frames
  expect_is(wave_one[[1]], "data.frame")
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(wave_one[[1]]), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(wave_one[[1]]), 0)
  
})
