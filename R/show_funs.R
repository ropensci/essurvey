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
#' #' This function returns the available themes in the European Social Survey
#' However, contrary to \code{show_country()} and \code{show_country_rounds()},
#' themes can not be downloaded as separate datasets. This and the 
#' \code{show_theme_rounds()} function serve purely for informative purposes.
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