# show_rounds
test_that("show_rounds returns correct output", {
  # Check whether show_countries is character
  expect_is(show_rounds(), "numeric")
  
  # Check that not input is available
  expect_error(show_rounds("whatever"), "unused argument")
  
  # Check whether show_countries has length greater than 0
  expect_gt(length(show_rounds()), 0)
  
  # Check there are no duplicate rounds
  expect_false(all(duplicated(show_rounds())))
})

# show_rounds_country
test_that("show_rounds_country returns error when arguments are wrong", {
  expect_error(show_rounds_country("whatever"),
               "Rounds not available in ESS. Check show_rounds()")
  
  expect_error(show_rounds_country(1:100),
               "Rounds not available in ESS. Check show_rounds()")
})

test_that("show_rounds_country returns correct output", {
  # Check whether is character
  expect_is(show_rounds_country(1), "character")
  
  # Check whether has length 22, the number of countries
  # as 20 December 2017
  expect_equal(length(show_rounds_country(1)), 22)
})

test_that("show_rounds_country returns non-duplicate rounds", {
  # # Check there are no duplicate countries
  expect_false(all(duplicated(show_rounds_country(1:6))))
  expect_false(all(duplicated(show_rounds_country(c(1, 5, 2)))))
  
  # Participating and non participating should be different!
  non_pt <- show_rounds_country(7:2, participate = FALSE)
  part <- show_rounds_country(7:2, participate = TRUE)
  all(!part %in% non_pt)
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
  # Check whether show_countries is character
  expect_is(show_countries(), "character")
  
  # Check whether show_countries has length greater than 0
  expect_gt(length(show_countries()), 0)
  
  # Check there are no duplicate countries
  expect_false(all(duplicated(show_countries())))
})

# show_country_rounds
test_that("show_country_rounds returns error when wrong country as argument", {
  expect_error(show_country_rounds("whatever"),
               "Country not available in ESS. Check show_countries()")
})

test_that("show_country_rounds returns correct output", {
  # Check whether show_countries is character
  expect_is(show_country_rounds("Denmark"), "numeric")
  
  # Check whether show_countries has length greater than 0
  expect_gt(length(show_country_rounds("Denmark")), 0)
  
  # # Check there are no duplicate rounds for countries
  expect_false(all(duplicated(show_country_rounds("Denmark"))))
  expect_false(all(duplicated(show_country_rounds("United Kingdom"))))
})

# show_themes()
test_that("show_themes returns correct output", {
  # Check whether show_countries is character
  expect_is(show_themes(), "character")
  
  # Check that no input is available
  expect_error(show_themes("whatever"), "unused argument")
  
  # Check whether show_countries has length greater than 0
  expect_gt(length(show_themes()), 0)
  
  # Check there are no duplicate countries
  expect_false(all(duplicated(show_themes())))
})

# show theme_rounds
test_that("show_theme_rounds returns error when wrong theme as argument", {
  expect_error(show_theme_rounds("whatever"),
               "Theme not available in ESS. Check show_themes()")
})

test_that("show_theme_rounds returns correct output for rounds  == 1", {
  # Check whether show_countries is character
  expect_is(show_theme_rounds("Democracy"), "numeric")
  
  # Check whether show_countries has length greater than 0
  expect_gt(length(show_theme_rounds("Democracy")), 0)
  
  # # Check there are no duplicate rounds for countries
  expect_false(all(duplicated(show_theme_rounds("Democracy"))))
})

# show_theme_rounds
test_that("show_theme_rounds returns correct output for rounds > 1", {
  # Check whether show_countries is character
  expect_is(show_theme_rounds("Politics"), "numeric")
  
  # Check whether show_countries has length greater than 0
  expect_gt(length(show_theme_rounds("Politics")), 0)
  
  # # Check there are no duplicate rounds for countries
  expect_false(all(duplicated(show_theme_rounds("Politics"))))
})
