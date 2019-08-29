# Environment variables from Travis CI

ess_email <- Sys.getenv("ess_email")

check_format <- function(result, type = "numeric") {
  # Check whether result is is of type
  expect_is(result, type)
  
  # Check whether result has length greater than 0
  expect_gt(length(result), 0)
  
  # # Check there are no duplicate rounds for results
  expect_false(all(duplicated(result)))
  
  # Checks there are no missing values
  expect_true(all(!is.na(result)))
}


# show_rounds
test_that("show_rounds returns correct output", {
  
  all_rounds <- show_rounds()
  
  check_format(all_rounds)
  
  # Check that not input is available
  expect_error(show_rounds("whatever"), "unused argument")
})

# show_rounds_country
test_that("show_rounds_country returns error when arguments are wrong", {
  expect_error(show_rounds_country("whatever"),
               "ESS round whatever is not available. Check show_rounds()")
  
  expect_error(show_rounds_country(1:50),
               "ESS round 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50 is not available. Check show_rounds()")
})

test_that("show_rounds_country returns correct output", {
  country_rounds <- show_rounds_country(1)
  check_format(country_rounds, "character")
  # Check whether has length 22, the number of countries
  # as 20 December 2017. This cannot increase as time passes by
  # because a new country cannot participate in round one ever again
  expect_equal(length(country_rounds), 22)
})

test_that("show_rounds_country returns non-duplicate rounds", {
  # # Check there are no duplicate countries
  expect_false(all(duplicated(show_rounds_country(1:6))))
  expect_false(all(duplicated(show_rounds_country(c(1, 5, 2)))))
  
  # Participating and non participating should be different!
  non_pt <- show_rounds_country(7:2, participate = FALSE)
  part <- show_rounds_country(7:2, participate = TRUE)
  expect_true(all(!part %in% non_pt))
})

test_that("show_rounds_country returns correct countries always", {
  
  # Countries that participated in the first three rounds. This
  # shouldn't change and was like this as of 20 of December of 2017
  one_to_three <-
    c("Austria", "Belgium", "Denmark", "Finland", "France", "Germany", 
      "Hungary", "Ireland", "Netherlands", "Norway", "Poland", "Portugal", 
      "Slovenia", "Spain", "Sweden", "Switzerland", "United Kingdom"
    )
  
  # Check it returns the same countries all the time
  expect_equal(show_rounds_country(1:3), one_to_three)
  
  # Check that it returns the same countries when parsing twice
  expect_equal(show_rounds_country(c(7, 1, 6)), show_rounds_country(c(7, 1, 6)))
})

# show_countries
test_that("show_countries returns correct output", {
  
  all_countries <- show_countries()
  
  check_format(all_countries, "character")
})

# show_country_rounds
test_that("show_country_rounds returns error when wrong country as argument", {
  expect_error(show_country_rounds("whatever"),
               "Country whatever not available in ESS. Check show_countries()")
})

test_that("show_country_rounds returns correct output", {
  
  dk <- show_country_rounds("Denmark")
  
  check_format(dk)
  
  # # Check there are no duplicate rounds for countries
  expect_false(all(duplicated(show_country_rounds("United Kingdom"))))
})

# show_themes()
test_that("show_themes returns correct output", {
  
  all_themes <- show_themes()
  
  check_format(all_themes, "character")
  
  # Check that no input is available
  expect_error(show_themes("whatever"), "unused argument")
})

# show theme_rounds
test_that("show_theme_rounds returns error when wrong theme as argument", {
  expect_error(show_theme_rounds("whatever"),
               "ESS theme whatever not available. Check show_themes()")
})

test_that("show_theme_rounds returns correct output for rounds  == 1", {
  
  theme_one <- show_theme_rounds("Democracy")
  check_format(theme_one)
})

# show_theme_rounds
test_that("show_theme_rounds returns correct output for rounds > 1", {
  theme_two <- show_theme_rounds("Politics")
  check_format(theme_two)
})

# show_sddf_rounds()
# This must be the FIRST test! Don't move.
# This is because we use the email ONLY in the first download, then save the
# file and the email is not needed.
test_that("show_sddf_rounds raises error when email not set / not correct", {

  old_env <- Sys.getenv("ess_email")
  set_email(ess_email = "")

  expect_error(show_sddf_rounds("Netherlands"),
               regexp = "No email account set as environment variable. Use set_email to set your email.", #nolintr
               fixed = TRUE
               )

  set_email(old_env)

  expect_error(show_sddf_rounds("Netherlands", "wrongemail"),
               regexp = "The email address you provided is not associated with any registered user. Create an account at https://www.europeansocialsurvey.org/user/new", #nolintr
               fixed = TRUE
               )
})

# This must be the SECOND test! Don't move.
# This is because I'm testing whether downloading a country twice is faster but
# since we save files in other tests that get reused, this needs to be the first
# download test

test_that("show_sddf_rounds is faster on second iteration because of reusing the save filed", { #nolintr

  skip_on_cran()

  # If for some reason, you already downloaded the SDDF German data before
  # Detect it and remove the folder so that the tests can run.
  already_dl <- list.files(tempdir(),
                           pattern = "ESS_Germany",
                           full.names = TRUE)

  if (length(already_dl) > 0) unlink(already_dl, recursive = TRUE, force = TRUE)

  init_first <- Sys.time()
  show_sddf_rounds("Germany")
  finish_first <- Sys.time()

  time_first <- finish_first - init_first

  init_second <- Sys.time()
  show_sddf_rounds("Germany")
  finish_second <- Sys.time()

  time_second <- finish_second - init_second

  expect_true(time_second < time_first)
  expect_true( (time_first - time_second) > 4)
})


test_that("show_sddf_rounds returns correct output for Spain", {

  skip_on_cran()
  
  all_spain_sddf <- show_sddf_rounds("Spain", ess_email)
  
  check_format(all_spain_sddf, "numeric")

  # Tests that we can downloaded the SDDF rounds appropriately as
  # they start from round 7 and 8
  expect_true(all(1:8 %in% all_spain_sddf))
  
  # Check that no input is available
  expect_error(show_sddf_rounds("whatever"),
               "Country whatever not available in ESS. Check show_countries()")
})

test_that("show_sddf_rounds returns correct output for Denmark", {

  skip_on_cran()
  
  all_dk_sddf <- show_sddf_rounds("Denmark", ess_email)

  check_format(all_dk_sddf, "numeric")

  # Check that at least you have these rounds
  # to test whether we're subsetting the correct
  # number of rounds for a given country
  expect_true(all(c(1, 3:7) %in% all_dk_sddf))
})
