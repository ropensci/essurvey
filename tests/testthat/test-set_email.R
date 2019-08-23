context("test-set_email")

# Test for set_email
test_that("test email is correctly set and can be overwritten", {
  set_email(ess_email = "test@test.com")
  expect_equal(Sys.getenv("ESS_EMAIL"), "test@test.com")
  set_email(ess_email = "test_bis@test.com")
  expect_equal(Sys.getenv("ESS_EMAIL"), "test_bis@test.com")

  # Reset
  Sys.setenv("ESS_EMAIL" = "")
})
