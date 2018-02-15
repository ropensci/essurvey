#' Return available rounds in the European Social Survey
#'
#' @return numeric vector with available rounds
#' @export
#'
#' @examples
#' 
#' show_rounds()
#' 
show_rounds <- function() {
  incomplete_links <- grab_rounds_link(.global_vars$ess_website)
  
  # extract ESS* part to detect dupliacted
  ess_prefix <- sort(stringr::str_extract(incomplete_links, "ESS[:digit:]"))
  
  # extract only the digit
  unique_rounds_available <- unique(stringr::str_extract(ess_prefix, "[:digit:]"))
  
  as.numeric(unique_rounds_available)
}


#' Return available countries in the European Social Survey
#'
#' @return character vector with available countries
#' @export
#'
#' @examples
#' 
#' show_countries()
#' 
show_countries <- function() {
  show_any(.global_vars$ess_website, .global_vars$country_index)
}

#' Return available themes in the European Social Survey
#' 
#' This function returns the available themes in the European Social Survey.
#' However, contrary to \code{\link{show_countries}} and \code{\link{show_country_rounds}},
#' themes can not be downloaded as separate datasets. This and
#' \code{\link{show_theme_rounds}} serve purely for informative purposes.
#'
#' @return character vector with available themes
#' @export
#'
#' @examples
#' 
#' show_themes()
#' 
show_themes <- function() {
  show_any(.global_vars$ess_website, .global_vars$theme_index)
}


# General function to show_* any index.

show_any <- function(ess_website, module_index) {
  
  module_table <- table_to_list(ess_website, module_index)

  names(module_table)
}

# Here I define an environment to hold the ess_website vector
# because it's a variable I'll use in nearly all functions to
# access the website
.global_vars <- new.env(parent = emptyenv())

var_names <- c(
  "ess_website",
  "theme_index",
  "country_index",
  "all_codes"
)

codes <- c("6" = "Not applicable",
           "7" = "Refusal",
           "8" = "Don't know",
           "9" = "No answer",
           "9" = "Not available")

var_values <-
  list(
  "http://www.europeansocialsurvey.org",
  "/data/module-index.html",
  "/data/country_index.html",
  codes
)

mapply(assign, var_names, var_values, list(envir = .global_vars))

# At some point I also added the show_* funs here so that I only ran them once
# and then I called .global_vars$ with the result of the show_ fun. I removed it
# because if a user called show_countries() in a script and later called
# an ess_ fun that uses the show_countries() that was called from .global_vars$countries
# and if ess updated countries or rounds in that time then the result would be different
# and we wouldn't want contradictory results.