#' Helper function to return available rounds for a country in the European Social Survey
#'
#' @param country A character of length 1 with the full name of the country.
#'  Use \code{\link{show_countries}}for a list of available countries.
#'
#' @return character vector with available rounds for \code{country}
#' @export
#'
#' @examples
#' 
#' 
#' show_country_rounds("Germany")
#' 
#' show_country_rounds("Spain")
#' 
#' show_country_rounds("Turkey")
#' 
show_country_rounds <- function(country) {

  # Get unique country to avoid repetitions  
  country <- sort(unique(country))
  
  # Returns each countries href attribute with its website
  # ess_website is a vector set as metadata
  available_countries <- show_countries()
  
  # Check if country is present
  if (!country %in% available_countries) {
    stop("Country not available in ESS. Check show_countries()")
  }
  
  # Returns the chosen countries html that contains
  # the links to all rounds.
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

# Function accepts the chosen country and the list
# of all available countries and returns the html doc
# for the chosen country that contains the whole list of
# links to download that countries rounds.
extract_cnt_html <- function(country, available_countries) {
  
  # Returns "/data/country.html?c=ukraine" for all countries
  all_country_links <- xml2::xml_attr(get_country_href(.global_vars$ess_website), "href")
  
  # Build full url for chosen country
  chosen_country_link <-
    paste0(
      .global_vars$ess_website,
      all_country_links[which(country == available_countries)] # index where the country is at
    )
  
  # Extract html from country link to donwnload rounds
  country_rounds <- httr::GET(chosen_country_link)
  
  country_round_html <- xml2::read_html(country_rounds)
  
  country_round_html
}

# Function to grab <a href="/data/country.html?c=latvia">Latvia</a>
# for each country
get_country_href <- function(ess_website) {
  download_page <- httr::GET(paste0(ess_website, "/data/country_index.html"))
  download_block <- XML::htmlParse(download_page, asText = TRUE)
  z <- XML::xpathSApply(download_block, "//a", function(u) XML::xmlAttrs(u)["href"])
  
  # Get the <a href="/data/country.html?c=latvia">Latvia</a> for each country
  country_node <- xml2::xml_find_all(xml2::read_html(download_page), '//td [@class="label"]//a')
  
  country_node
}

# Function to automatically clean attributes such as
# <a> something <\a>. This will clean to: something
# if a and /a are specified as arguments.
clean_attr <- function(x, ...) {
  other_attrs <- paste0((list(...)), collapse = "|")
  gsub(paste0(">|", "<|", other_attrs), "", x)
}
