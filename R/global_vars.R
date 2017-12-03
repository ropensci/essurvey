# Here I define an environment to hold the ess_website vector
# because it's a variable I'll use in nearly all functions to
# access the website
.global_vars <- new.env(parent = emptyenv())

var_names <- c(
  "ess_website",
  "theme_index",
  "country_index"
)

var_values <-
  list(
    "http://www.europeansocialsurvey.org",
    "/data/module-index.html",
    "/data/country_index.html"
  )

mapply(assign, var_names, var_values, list(envir = .global_vars))

# Why not put these variables together with the previous variables and
# just run one single loop of assignment? Becuse the show_* funs actually
# use the .global_vars inside them. We have te define those first and
# then the show_* results.

show_names <- c(
  "rounds",
  "countries",
  "themes"
)

show_results <- list(
  show_rounds(),
  show_countries(),
  show_themes()
)

mapply(assign, show_names, show_results, list(envir = .global_vars))