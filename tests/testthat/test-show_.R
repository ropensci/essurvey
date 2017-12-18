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
test_that("show_country_rounds returns error when wrong theme as argument", {
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

# If this raises an error, it might that it needs to be 
# upated every year with the new round the url is: 
# http://www.europeansocialsurvey.org/data/country_index.html

test_that("show_country_rounds returns correct rounds for countries", {
  expect_equal(show_country_rounds("Germany"), 1:8)
  expect_equal(show_country_rounds("Albania"), 6)
  expect_equal(show_country_rounds("Turkey"), c(2, 4))
  expect_equal(show_country_rounds("Italy"), c(1, 2, 6))
  expect_equal(show_country_rounds("Spain"), 1:7)
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
