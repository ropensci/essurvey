ess_email <- Sys.getenv("ess_email")
save_dir <- tempdir()

# authenticate(ess_email)

test_that("authenticate works correctly for wrong emails", {
  expect_error(authenticate("random@email.morerandom"),
               "email address you provided is not associated with any registered") # nolint
  
  expect_error(authenticate(""),
               "email address you provided is not associated with any registered") # nolint
})

test_that("download_format can download COUNTRY files in STATA format", {
  
  skip_on_cran()
  
  # ess_email <- Sys.getenv("ess_email")
  # Test whether you get a message where the downloads are at
  which_rounds <- 2
  
  urls <- country_url("Italy", 1:which_rounds, format = 'stata')
  
  expect_message(download_link <-
                   download_format(
                     urls = urls,
                     country = "Italy",
                     ess_email = ess_email,
                     only_download = TRUE,
                     output_dir = tempdir(),
                     format = 'stata'
                   ),
                 "All files saved to"
                 )

  
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(download_link, pattern = "ESS", recursive = TRUE)
  
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
  unlink(save_dir, recursive = TRUE, force = TRUE)
})

test_that("download_format can download ROUND files in STATA format", {
  
  skip_on_cran()
  # Test whether you get a message where the downloads are at
  which_rounds <- 2
  
  urls <- round_url(1:which_rounds, format = 'stata')
  
  expect_message(download_link <-
                   download_format(
                     urls = urls,
                     ess_email = ess_email,
                     only_download = TRUE,
                     output_dir = tempdir(),
                     format = 'stata'),
                 "All files saved to")
  
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(download_link, pattern = "ESS", recursive = TRUE)
  
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
  unlink(download_link, recursive = TRUE, force = TRUE)
})

test_that("download_format can download COUNTRY files in SPSS format", {
  
  skip_on_cran()
  # Test whether you get a message where the downloads are at
  which_rounds <- 2
  
  urls <- country_url("Germany", 1:which_rounds, format = 'spss')
  
  expect_message(download_link <-
                   download_format(
                     urls = urls,
                     country = "Germany",
                     ess_email = ess_email,
                     only_download = TRUE,
                     output_dir = tempdir(),
                     format = 'spss'),
                 "All files saved to")
  
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(download_link, pattern = "ESS", recursive = TRUE)
  
  # Same number of spss files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".sav", ess_files)), which_rounds)
  
  # Same number of zip files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".zip", ess_files)), which_rounds)

  # Delete all downloaded files
  unlink(save_dir, recursive = TRUE, force = TRUE)
})

test_that("download_format can download ROUND files in SPSS format", {
  
  skip_on_cran()
  # Test whether you get a message where the downloads are at
  which_rounds <- 2
  
  urls <- round_url(1:which_rounds, format = 'spss')
  
  expect_message(download_link <-
                   download_format(
                     urls = urls,
                     ess_email = ess_email,
                     only_download = TRUE,
                     output_dir = tempdir(),
                     format = 'spss'),
                 "All files saved to")
  
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(download_link, pattern = "ESS", recursive = TRUE)
  
  # Same number of spss files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".sav", ess_files)), which_rounds)
  
  # Same number of zip files as the rounds attempted
  # to download?
  expect_equal(sum(grepl(".zip", ess_files)), which_rounds)
  
  # Delete all downloaded files
  unlink(save_dir, recursive = TRUE, force = TRUE)
})

test_that("download_format can download COUNTRY files in SAS format", {
  
  skip_on_cran()
  # Test whether you get a message where the downloads are at
  which_rounds <- 2
  
  urls <- country_url("Sweden", 1:which_rounds, format = 'sas')
  
  expect_message(download_link <-
                   download_format(
                     urls = urls,
                     country = "Sweden",
                     ess_email = ess_email,
                     only_download = TRUE,
                     output_dir = tempdir(),
                     format = 'sas'),
                 "All files saved to")
  
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(download_link, pattern = "ESS", recursive = TRUE)
  
  # SAS needs more files that the number of rounds.
  # It's actually 3 .sas files per round, so everything multiplied by three.
  expect_equal(sum(grepl(".sas$", ess_files)), 3 * which_rounds)
  
  expect_equal(sum(grepl(".zip$", ess_files)), 1 * which_rounds)
  
  # Delete all downloaded files
  unlink(save_dir, recursive = TRUE, force = TRUE)
})

test_that("download_format can download ROUND files in SAS format", {
  
  skip_on_cran()
  # Test whether you get a message where the downloads are at
  which_rounds <- 2
  
  urls <- round_url(1:which_rounds, format = 'sas')
  
  expect_message(download_link <-
                   download_format(
                     urls = urls,
                     ess_email = ess_email,
                     only_download = TRUE,
                     output_dir = tempdir(),
                     format = 'sas'),
                 "All files saved to")
  
  # Test whether the downloaded files are indeed there
  ess_files <- list.files(download_link, pattern = "ESS", recursive = TRUE)
  
  # SAS needs more files that the number of rounds.
  # It's actually 3 .sas files per round, so everything multiplied by three.
  expect_equal(sum(grepl(".sas$", ess_files)), 3 * which_rounds)
  
  expect_equal(sum(grepl(".zip$", ess_files)), 1 * which_rounds)

  # Delete all downloaded files
  unlink(save_dir, recursive = TRUE, force = TRUE)
})
