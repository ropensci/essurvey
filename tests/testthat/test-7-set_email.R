context("test-set_email")
ess_email <- Sys.getenv("ess_email")
save_dir <- tempdir()

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

test_that("authenticate works correctly for wrong emails", {
  expect_error(authenticate("random@email.morerandom"),
               "email address you provided is not associated with any registered") # nolint
  
  expect_error(authenticate(""),
               "email address you provided is not associated with any registered") # nolint
})
