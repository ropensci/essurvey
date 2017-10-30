#' Helper function to return available countries in the European Social Survey
#'
#' @return character vector with available countries
#' @export
#'
#' @examples
#' 
#' show_countries()
#' 
show_countries <- function() {
  
  ess_website <- "http://www.europeansocialsurvey.org"
  
  country_node <- get_country_href(ess_website)
  
  # Extract the name
  dirty_country_names <-
    stringr::str_extract_all(as.character(country_node), ">(.*)</a>$")
  
  # Clean up the name
  available_countries <- sapply(dirty_country_names, clean_attr, "/a")
  
  available_countries
}
