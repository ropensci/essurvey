test_that("Test that all current ESS countries have equivalent country lookups", {
  skip_on_cran()
  # To avoid any surprises, we always test that available ESS countries DON'T
  # have NA values in their 2 letter chr codes because that would introduce very
  # random errors.

  countries <- show_countries()
  res <- country_lookup[countries]

  expect_named(res)
  expect_true(all(!is.na(res)))
  expect_true(all(!is.na(names(res))))
})
