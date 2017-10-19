
# Test for only one wave
wave_one <- ess_waves(1, "cimentadaj@gmail.com")

# check is list
expect_is(wave_one, "list")

# check is length one
expect_length(wave_one, 1)

# check that ess_waves returns data frames
expect_is(wave_one[[1]], "data.frame")

# check that the number of rows is greater than 0
expect_gt(nrow(wave_one[[1]]), 0)

# check that the number of columns is greater than 0
expect_gt(ncol(wave_one[[1]]), 0)


# Test for all waves
all_waves <- ess_waves(1:7, "cimentadaj@gmail.com")

# check is list
expect_is(all_waves, "list")

# check is length one
expect_length(all_waves, 7)

# check that all ess returns data frames
expect_equal(all(sapply(all_waves, function(x) "data.frame" %in% class(x))), TRUE)

# check that all data frames have more than 0 rows
expect_equal(all(sapply(all_waves, nrow) > 0), TRUE)

# check that all data frames have more than 0 columns
expect_equal(all(sapply(all_waves, ncol) > 0), TRUE)

# Also test that setting the only_download argument will return
# the directory or nothing? I don't know. I just wanna check consistency
# in what it returns.

# Add these tests on another .R file but for download_waves_stata and ess_url

# These are the functions which are actually doing the work of testing this, not ess_waves
# # For wrong emails, test it will through error
# expect_error(ess_waves(1, "random@email.morerandom"),
#              "email address you provided is not associated with any registered")
# 
# # Test it will throw error when wave is not available
# expect_error(ess_waves(c(1, 8), "cimentadaj@gmail.com"),
#              "ESS round [0-9] is not a available at")