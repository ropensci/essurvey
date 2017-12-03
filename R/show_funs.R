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
  incomplete_links <- grab_rounds_link()
  
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
  
  node <- get_href(ess_website, module_index)
  
  # Extract the name
  dirty_names <-
    stringr::str_extract_all(as.character(node), ">(.*)</a>$")
  
  # Clean up the name
  available_names <- sapply(dirty_names, clean_attr, "/a")
  
  available_names
}

# Here I define an environment to hold the ess_website vector
# because it's a variable I'll use in nearly all functions to
# access the website
.global_vars <- new.env(parent = emptyenv())

var_names <- c(
  "ess_website",
  "theme_index",
  "country_index",
  "rounds",
  "countries",
  "themes"
)

var_values <- list(
  "http://www.europeansocialsurvey.org",
  "/data/module-index.html",
  "/data/country_index.html",
  show_rounds(),
  show_countries(),
  show_themes()
)

mapply(assign, var_names, var_values, list(envir = .global_vars))
