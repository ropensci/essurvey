
# show_countries

# Check whether show_countries is character
expect_is(show_countries(), "character")

# Check whether show_countries has length greater than 0
expect_gt(length(show_countries()), 0)

# Check there are no duplicate countries
expect_false(all(duplicated(show_countries())))



# show_country_waves

# Check whether show_countries is character
expect_is(show_country_waves("Denmark"), "numeric")

# Check whether show_countries has length greater than 0
expect_gt(length(show_country_waves("Denmark")), 0)

# # Check there are no duplicate waves for countries
expect_false(all(duplicated(show_country_waves("Denmark"))))
expect_false(all(duplicated(show_country_waves("United Kingdom"))))


# show_waves

# Check whether show_countries is character
expect_is(show_waves(), "numeric")

# Check whether show_countries has length greater than 0
expect_gt(length(show_waves()), 0)

# Check there are no duplicate waves
expect_false(all(duplicated(show_waves())))
