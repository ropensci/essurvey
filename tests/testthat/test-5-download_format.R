ess_email <- Sys.getenv("ess_email")
save_dir <- tempdir()

# authenticate(ess_email)

test_that("authenticate works correctly for wrong emails", {
  expect_error(authenticate("random@email.morerandom"),
               "email address you provided is not associated with any registered") # nolint
  
  expect_error(authenticate(""),
               "email address you provided is not associated with any registered") # nolint
})
