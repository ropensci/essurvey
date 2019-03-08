context("test-set_email")

# Test for set_email
test_that("test email is correctly set", {
  set_email(ess_email = "test@test.com")
  expect_equal(Sys.getenv("ESS_EMAIL"), "test@test.com")
})

test_that("check if email can be overwritten", {
  set_email(ess_email = "test_bis@test.com")
  expect_false(is(Sys.getenv("ESS_EMAIL"), "test@test.com"))
})
