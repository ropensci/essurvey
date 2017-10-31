
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
test_that("show_country_rounds returns correct output", {
  # Check whether show_countries is character
  expect_is(show_country_rounds("Denmark"), "numeric")
  
  # Check whether show_countries has length greater than 0
  expect_gt(length(show_country_rounds("Denmark")), 0)
  
  # # Check there are no duplicate rounds for countries
  expect_false(all(duplicated(show_country_rounds("Denmark"))))
  expect_false(all(duplicated(show_country_rounds("United Kingdom"))))
})

# show_rounds
test_that("show_rounds returns correct output", {
  # Check whether show_countries is character
  expect_is(show_rounds(), "numeric")
  
  # Check whether show_countries has length greater than 0
  expect_gt(length(show_rounds()), 0)
  
  # Check there are no duplicate rounds
  expect_false(all(duplicated(show_rounds())))
})