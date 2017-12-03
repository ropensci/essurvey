#' Return available rounds for a country in the European Social Survey
#'
#' @param country A character of length 1 with the full name of the country.
#'  Use \code{\link{show_countries()}}for a list of available countries.
#'
#' @return character vector with available rounds for \code{country}
#' @export
#'
#' @examples
#' 
#' show_country_rounds("Spain")
#' 
#' show_country_rounds("Turkey")
#' 
show_country_rounds <- function(country) {

  # Check if country is present
  if (!country %in% .global_vars$countries) {
    stop("Country not available in ESS. Check show_countries()")
  }
  
  show_any_rounds(country, .global_vars$country_index)
  
}

#' Return available rounds for a theme in the European Social Survey
#'
#' This function returns the available rounds for any theme from
#' \code{\link{show_themes()}}. However, contrary to \code{\link{show_country_rounds()}}
#' themes can not be downloaded as separate datasets. This and the 
#' \code{\link{show_themes()}} function serve purely for informative purposes.
#' 
#' 
#' @param theme A character of length 1 with the full name of the theme.
#'  Use \code{\link{show_themes()}}for a list of available themes.
#'
#' @return character vector with available rounds for \code{country}
#' @export
#'
#' @examples
#' 
#' chosen_theme <- show_themes()[3]
#' 
#' # In which rounds was the topic of 'Democracy' asked?
#' show_theme_rounds(chosen_theme)
#' 
#' # And politics?
#' show_theme_rounds("Politics")
#' 
show_theme_rounds <- function(theme) {
  
  # Check if country is present
  if (!theme %in% .global_vars$themes) {
    stop("Theme not available in ESS. Check show_themes()")
  }
  
  show_any_rounds(theme, .global_vars$theme_index)
}

# Generic function to grab the rounds of any module
show_any_rounds <- function(module, module_index) {
  
  # Get unique country to avoid repetitions  
  module <- sort(unique(module))
  
  # Get the table for each module-round combination as a list
  module_list <- table_to_list(.global_vars$ess_website, module_index)
  
  # The list is easy to subset, so just subset the available module
  # from the list and then subset the available rounds from the
  # global variable
  available_rounds <- .global_vars$rounds[module_list[[module]]]
  
  available_rounds
}


# This is the workhorse of the show_* funs.
# Function takes the esswebsite and the module index
# and scrapes the table from the index and returns a list
# where every slot is a country and contains a logical
# for which rounds are available for every country
table_to_list <- function(ess_website, module_index) {
  download_page <- httr::GET(paste0(ess_website, module_index))
  
  # Extract the table in xml format
  table_rounds_xml <- rvest::html_node(xml2::read_html(download_page), "table")
  
  # Turn the xml table into a df. First col is country names and
  # all other are rounds
  dirty_table_df <- rvest::html_table(table_rounds_xml, header = TRUE)
  
  # Recode the empty cells to FALSE and others to TRUE
  dirty_table_df[, -1] <-
    lapply(dirty_table_df[, -1],
           function(x) ifelse(x == "", FALSE, TRUE)
    )
  
  # Returns a list for every country containing the
  # logical for which rounds they were present. This
  # is better than a df because subsetting would be
  # too dirty to subset country rows.
  list_rounds <- split(dirty_table_df[, -1], dirty_table_df[[1]])
  
  list_rounds <- lapply(list_rounds, as.logical)
  
  list_rounds
}
