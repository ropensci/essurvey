#' Return available SDDF rounds for a country in the European Social Survey
#'
#'
#' @param country A character of length 1 with the full name of the country.
#'  Use \code{\link{show_countries}}for a list of available countries.
#'  
#'  @details SDDF data are the equivalent weight data used to analyze the European
#'  Social Survey properly.
#'
#' @return numeric vector with available rounds for \code{country}
#' @export
#'
#' @examples
#' 
#' show_sddf_rounds("Spain")
#'
show_sddf_rounds <- function(country) {
  
  ## TODO
  ## Properly document the function with links to what the SDDF data means
  ## and how to understand it. 
  check_country(country)
  
  # Returns the chosen countries html that contains
  # the links to all rounds.
  country_round_html <- extract_html(country, .global_vars$country_index)
  
  # Go deeper in the node to grab that countries url to the rounds
  country_node <- xml2::xml_find_all(country_round_html, "//ul //li //a")
  
  # Here we have all href from the website
  country_href <- xml2::xml_attrs(country_node, "href")
  
  incomplete_links <-
    sort(grep("^/download.html\\?file=ESS[0-9]{1,}_[A-Z]{1,2}_SDDF(.*)[0-9]{4, }$",
              country_href,
              value = TRUE))
  
  # Extract round numbers
  round_numbers <- as.numeric(stringr::str_extract(incomplete_links, "[0-9]{1,2}"))
  
  round_numbers
}
