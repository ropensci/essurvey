
run_tests <- Sys.getenv("NOT_CRAN") == "true"
if (run_tests) {
  # Environment variables from Travis CI
  ess_email <- Sys.getenv("ess_email")
  round_one <- import_rounds(1, ess_email)
}


if (run_tests) {
  # Test for all rounds
  available_rounds <- show_rounds()
  all_rounds <- import_rounds(available_rounds, ess_email)
}

test_that("import_rounds checks for args", {
  expect_error(import_rounds(numeric()),
               regexp = "length(rounds) > 0",
               fixed = TRUE)
})

test_that("download_rounds checks for args", {
  expect_error(download_rounds(numeric()),
               regexp = "length(rounds) > 0",
               fixed = TRUE)
})


test_that("import_round for only one round", {
  
  skip_on_cran()
  
  # check is list
  expect_is(round_one, "data.frame")
  
  # check it is the first round
  expect_true(unique(round_one$essround) == 1)
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(round_one), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(round_one), 0)
})

test_that("import_round for all rounds", {
  
  skip_on_cran()
  
  # check is list
  expect_is(all_rounds, "list")
  
  # check is length seven
  expect_length(all_rounds, length(available_rounds))
  
  # check that all ess returns data frames
  expect_true(all(vapply(all_rounds,
                         function(x) "data.frame" %in% class(x),
                         FUN.VALUE = logical(1))))
  
  # Check that all rounds are indeed the first seven rounds
  expect_true(all(vapply(all_rounds,
                         function(x) unique(x$essround),
                         FUN.VALUE = numeric(1)) == available_rounds))
  
  # check that all data frames have more than 0 rows
  expect_equal(all(vapply(all_rounds, nrow, numeric(1)) > 0), TRUE)
  
  # check that all data frames have more than 0 columns
  expect_equal(all(vapply(all_rounds, ncol, numeric(1)) > 0), TRUE)
})

test_that("download_round for downloading works fine", {
  
  skip_on_cran()
  # Test whether you get a message where the downloads are at
  expect_message(downloads <-
                   download_rounds(
                     1,
                     ess_email,
                     output_dir = tempdir(),
                     format = "stata"),
                 "All files saved to")
  
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(downloads, pattern = "ESS", recursive = TRUE)
  
  # Same number of stata files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".dta", ess_files)), 1)
  
  # Same number of zip files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".zip", ess_files)), 1)
  
  # Same number of do files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".do", ess_files)), 1)
  
  # Delete all downloaded files
  unlink(downloads, recursive = TRUE, force = TRUE)
})

test_that("output_dir should be valid", {
  
  skip_on_cran()
  
  # Here output_dir is set to NULL
  expect_error(download_rounds(1,
                               ess_email,
                               output_dir = NULL))
})

test_that("import_round files with other non-stata format", {
  skip_on_cran()
  
  # Test for only one wave
  wave_one <- import_rounds(1, ess_email, format = "spss")
  
  # check is list
  expect_is(wave_one, "data.frame")
  
  # check that the number of rows is greater than 0
  expect_gt(nrow(wave_one), 0)
  
  # check that the number of columns is greater than 0
  expect_gt(ncol(wave_one), 0)
  
})

test_that("Specify 'sas' for import_rounds data throws error",{
  skip_on_cran()
  
  expect_error(import_rounds(1, ess_email, format = "sas"),
               "You cannot read SAS but only 'spss' and 'stata' files with this function") # nolint
})

