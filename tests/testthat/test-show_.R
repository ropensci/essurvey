
# Check whether show_countries is character
expect_is(show_countries(), "character")

# Check whether show_countries has length greater than 0
expect_gt(length(show_countries()), 0)


# Check whether show_countries is character
expect_is(show_country_waves("Denmark"), "numeric")

# Check whether show_countries has length greater than 0
expect_gt(length(show_country_waves("Denmark")), 0)