context("test-set_email")

# Test for set_email
test_that("test email is correctly set and can be overwritten", {
  old_env_var <- Sys.getenv("ess_email")
  
  set_email(ess_email = "test@test.com")
  expect_equal(Sys.getenv("ess_email"), "test@test.com")
  set_email(ess_email = "test_bis@test.com")
  expect_equal(Sys.getenv("ess_email"), "test_bis@test.com")

  # Reset
  Sys.setenv("ess_email" = old_env_var)
})
