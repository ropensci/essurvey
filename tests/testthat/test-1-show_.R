# Environment variables from GH actions

ess_email <- Sys.getenv("ESS_EMAIL")

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
  skip_on_cran()

  all_rounds <- show_rounds()

  check_format(all_rounds)

  # Check that not input is available
  expect_error(show_rounds("whatever"), "unused argument")
})

# show_rounds_country
test_that("show_rounds_country returns error when arguments are wrong", {
  skip_on_cran()

  expect_error(show_rounds_country("whatever"),
               "ESS round whatever is not available. Check show_rounds()")

  expect_error(show_rounds_country(100:110),
               "ESS round 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110 is not available. Check show_rounds()")
})

test_that("show_rounds_country returns correct output", {
  skip_on_cran()
  country_rounds <- show_rounds_country(1)
  check_format(country_rounds, "character")
  # Check whether has length 22, the number of countries
  # as 20 December 2017. This cannot increase as time passes by
  # because a new country cannot participate in round one ever again
  expect_equal(length(country_rounds), 22)
})

test_that("show_rounds_country returns non-duplicate rounds", {
  skip_on_cran()
  # # Check there are no duplicate countries
  expect_false(all(duplicated(show_rounds_country(1:6))))

  # Participating and non participating should be different!
  non_pt <- show_rounds_country(7:2, participate = FALSE)
  part <- show_rounds_country(7:2, participate = TRUE)
  expect_true(all(!part %in% non_pt))
})

test_that("show_rounds_country returns correct countries always", {
  skip_on_cran()

  # Countries that participated in the first three rounds. This
  # shouldn't change and was like this as of 20 of December of 2017
  one_to_three <-
    c("Austria", "Belgium", "Denmark", "Finland", "France", "Germany",
      "Hungary", "Ireland", "Netherlands", "Norway", "Poland", "Portugal",
      "Slovenia", "Spain", "Sweden", "Switzerland", "United Kingdom"
    )

  # Check it returns the same countries all the time
  expect_equal(show_rounds_country(1:3), one_to_three)
})

# show_countries
test_that("show_countries returns correct output", {
  skip_on_cran()
  all_countries <- show_countries()

  check_format(all_countries, "character")
})

# show_country_rounds
test_that("show_country_rounds returns error when wrong country as argument", {
  skip_on_cran()
  expect_error(show_country_rounds("whatever"),
               "Country whatever not available in ESS. Check show_countries()")
})

test_that("show_country_rounds returns correct output", {
  skip_on_cran()
  dk <- show_country_rounds("Denmark")

  check_format(dk)

  # # Check there are no duplicate rounds for countries
  expect_false(all(duplicated(dk)))
})

# show_themes()
test_that("show_themes returns correct output", {
  skip_on_cran()

  all_themes <- show_themes()

  check_format(all_themes, "character")

  # Check that no input is available
  expect_error(show_themes("whatever"), "unused argument")
})

# show theme_rounds
test_that("show_theme_rounds returns error when wrong theme as argument", {
  skip_on_cran()
  expect_error(show_theme_rounds("whatever"),
               "ESS theme whatever not available. Check show_themes()")
})

test_that("show_theme_rounds returns correct output for rounds  == 1", {
  skip_on_cran()
  theme_one <- show_theme_rounds("Democracy")
  check_format(theme_one)
})

# show_theme_rounds
test_that("show_theme_rounds returns correct output for rounds > 1", {
  skip_on_cran()
  theme_two <- show_theme_rounds("Politics")
  check_format(theme_two)
})

# show_sddf_cntrounds()
# This must be the FIRST test! Don't move.
# This is because we use the email ONLY in the first download, then save the
# file and the email is not needed.
test_that("show_sddf_cntrounds raises error when email not set / not correct", {
  skip_on_cran()

  old_env <- Sys.getenv("ESS_EMAIL")
  set_email(ess_email = "")

  expect_error(show_sddf_cntrounds("Netherlands"),
               regexp = "No email account set as environment variable. Use set_email to set your email.", #nolintr
               fixed = TRUE
               )

  set_email(old_env)

  expect_error(show_sddf_cntrounds("Netherlands", "wrongemail"),
               regexp = "The email address you provided is not associated with any registered user. Create an account at https://www.europeansocialsurvey.org/user/new", #nolintr
               fixed = TRUE
               )
})

# This must be the SECOND test! Don't move.
# This is because I'm testing whether downloading a country twice is faster but
# since we save files in other tests that get reused, this needs to be the first
# download test. This takes a lot of time and Travis hangs. Leaving it here
# to amuse you.

## test_that("show_sddf_cntrounds is faster on second iteration because of reusing the save filed", { #nolintr

##   skip_on_cran()

##   # If for some reason, you already downloaded the SDDF data before
##   # Detect it and remove the folder so that the tests can run.
##   already_dl <- list.files(tempdir(),
##                            pattern = "ESS_SDDF",
##                            full.names = TRUE)

##   if (length(already_dl) > 0) unlink(already_dl, recursive = TRUE, force = TRUE)

##   init_first <- Sys.time()
##   show_sddf_cntrounds("Germany")
##   finish_first <- Sys.time()

##   time_first <- finish_first - init_first

##   init_second <- Sys.time()
##   show_sddf_cntrounds("Germany")
##   finish_second <- Sys.time()

##   time_second <- finish_second - init_second

##   expect_true(time_second < time_first)
##   expect_true( (time_first - time_second) > 4)
## })


test_that("show_sddf_cntrounds returns correct output for Spain", {

  skip_on_cran()

  all_spain_sddf <- show_sddf_cntrounds("Spain", ess_email)

  check_format(all_spain_sddf, "numeric")

  # Tests that we can downloaded the SDDF rounds appropriately as
  # they start from round 7 and 8
  expect_true(all(1:8 %in% all_spain_sddf))

  # Check that no input is available
  expect_error(show_sddf_cntrounds("whatever"),
               "Country whatever not available in ESS. Check show_countries()")
})

# Why test two countries? Bc they have different rounds and different
# rounds have different dl strategies for SDDF
test_that("show_sddf_cntrounds returns correct output for Denmark", {

  skip_on_cran()

  all_dk_sddf <- show_sddf_cntrounds("Denmark", ess_email)

  check_format(all_dk_sddf, "numeric")

  # Check that at least you have these rounds
  # to test whether we're subsetting the correct
  # number of rounds for a given country
  expect_true(all(c(1, 3:7) %in% all_dk_sddf))
})
