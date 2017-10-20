# These are the functions which are actually doing the work of testing this, not ess_waves
# For wrong emails, test it will through error
expect_error(download_waves_stata(1, "random@email.morerandom"),
             "email address you provided is not associated with any registered")

# Test it will throw error when wave is not available
expect_error(download_waves_stata(c(1, 22), "cimentadaj@gmail.com"),
             "ESS round [0-9]+ is not a available at")