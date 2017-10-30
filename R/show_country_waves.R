#' Helper function to return available waves for a country in the European Social Survey
#'
#' @param country A character of length 1 with the full name of the country. Use show_countries()
#' for a list of available countries.
#'
#' @return character vector with available waves for \code{country}
#' @export
#'
#' @examples
#' 
#' show_country_waves("Germany")
#' 
#' show_country_waves("Spain")
#' 
#' show_country_waves("Turkey")
#' 
show_country_waves <- function(country) {

  # Get unique country to avoid repetitions  
  country <- sort(unique(country))
  
  ess_website <- "http://www.europeansocialsurvey.org"
  
  # Returns each countries href attribute with its website
  # ess_website is a vector set as metadata
  available_countries <- show_countries()
  
  # Check if country is present
  if (!country %in% available_countries) {
    stop("Country not available in ESS. Check show_countries()")
  }
  
  country_round_html <-
    extract_cnt_html(
      country,
      available_countries
      )
  # Find only the name of the round
  dirty_round_names <- xml2::xml_find_all(country_round_html, "//h2")
  
  # Clean the dirty round name fromit's attributes
  round_names <-
    sapply(
      X = as.character(dirty_round_names),
      FUN = clean_attr,
      "/", "h2", # FUN ARGS
      USE.NAMES = FALSE
    )
  
  # Extract only the ESS round number
  available_rounds <-
    sort(
      as.numeric(
        trimws(
          stringr::str_extract_all(round_names, " [0-9] ")
        )
      )
    )
  
  available_rounds
}

# Function to grab a country-round-html
extract_cnt_html <- function(country, available_countries) {
  ess_website <- "http://www.europeansocialsurvey.org"
  
  all_country_links <- xml2::xml_attr(get_country_href(ess_website), "href")
  
  # Build full url to chosen country
  chosen_country_link <-
    paste0(
      ess_website,
      all_country_links[which(country == available_countries)] # index where the country is at
    )
  
  # Extract html from country link to donwnload rounds
  country_rounds <- httr::GET(chosen_country_link)
  
  country_round_html <- xml2::read_html(country_rounds)
  
  country_round_html
}
