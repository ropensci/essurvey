your_email <- Sys.getenv("your_email")

test_that("Download function return correct errors", {
  
  skip_on_cran()
  
  # These are the functions which are actually doing the work of testing this, not ess_rounds
  # For wrong emails, test it will through error
  
  expect_error(authenticate("random@email.morerandom"),
               "email address you provided is not associated with any registered")
  
  # Test round download throw error when round is not available
  expect_error(download_rounds_stata(c(1, 22), your_email),
               "ESS round [0-9]+ is not a available. Check show_rounds()")
  
  # Test country download will throw error when wave is not available
  expect_error(download_country_stata("Sweden", c(1, 22), your_email),
               "Only rounds (.*) available for Sweden")
})