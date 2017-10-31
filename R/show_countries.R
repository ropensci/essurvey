#' Helper function to return available countries in the European Social Survey
#'
#' @return character vector with available countries
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' 
#' show_countries()
#' 
#' }
show_countries <- function() {
  
  country_node <- get_country_href(.global_vars$ess_website)
  
  # Extract the name
  dirty_country_names <-
    stringr::str_extract_all(as.character(country_node), ">(.*)</a>$")
  
  # Clean up the name
  available_countries <- sapply(dirty_country_names, clean_attr, "/a")
  
  available_countries
}
