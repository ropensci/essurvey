#' Return participating countries for rounds in the European Social Survey
#'
#' @param rounds A numeric vector specifying the rounds from which to return the countries.
#' Use \code{\link{show_rounds}}for a list of available rounds.
#' @param participate A logical that controls whether to show participating countries in that/those
#' rounds or countries that didn't participate. Set to TRUE by default.
#'
#' @return A character vector with the country names
#' @export
#'
#' @examples
#' 
#' # Return countries that participated in round 2
#' 
#' show_rounds_country(2)
#' 
#' # Return countries that participated in all rounds
#' 
#' show_rounds_country(1:8)
#' 
#' # Return countries that didn't participate in the first three rounds
#' 
#' show_rounds_country(1:3, participate = FALSE)
#' 
show_rounds_country <- function(rounds, participate = TRUE) {
  
  if (!all(rounds %in% show_rounds())) {
    stop("Rounds not available in ESS. Check show_rounds()")
  }
  
  # Obtaine the country list with years that participated
  module_list <- table_to_list(.global_vars$ess_website,
                               .global_vars$country_index)
  
  # Because names get messed up when turning module_list into a df
  # here I save the pretty country names
  country_names <- names(module_list)
  
  # Turn the list into a lookupable matrix
  country_rnd_subset <- t(data.frame(module_list))
  
  # create all() function depending on whether the user wants the participating
  # or non-participating countries. The +1 is so that if its TRUE, +1 will
  # return the second argument, and 0+1 the first arguments
  new_all <- switch(as.numeric(participate) + 1, function(x) !all(x), all)
  
  # Take only the rounds specified
  subset_df <- country_rnd_subset[, rounds, drop = FALSE]
  
  # Check which countries participates in all rounds
  which_cnts <- vapply(seq_len(nrow(subset_df)),
                       function(x) new_all(subset_df[x, ]),
                       FUN.VALUE = logical(1))
  
  country_names[which_cnts]
}

#' Return available rounds for a country in the European Social Survey
#'
#' @param country A character of length 1 with the full name of the country.
#'  Use \code{\link{show_countries}}for a list of available countries.
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
  if (!country %in% show_countries()) {
    stop("Country not available in ESS. Check show_countries()")
  }
  
  show_any_rounds(country, .global_vars$country_index)
  
}

#' Return available rounds for a theme in the European Social Survey
#'
#' This function returns the available rounds for any theme from
#' \code{\link{show_themes}}. However, contrary to \code{\link{show_country_rounds}}
#' themes can not be downloaded as separate datasets. This and the 
#' \code{\link{show_themes}} function serve purely for informative purposes.
#' 
#' 
#' @param theme A character of length 1 with the full name of the theme.
#'  Use \code{\link{show_themes}}for a list of available themes.
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
  if (!theme %in% show_themes()) {
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
  available_rounds <- show_rounds()[module_list[[module]]]
  
  available_rounds
}


# This is the workhorse of the show_* funs.
# Function takes the esswebsite and the module index
# and scrapes the table from the index and returns a list
# where every slot is a country and contains a logical
# for which rounds are available for every country
table_to_list <- function(ess_website, module_index) {
  download_page <- safe_GET(paste0(ess_website, module_index))
  
  # Extract the table in xml format
  table_rounds_xml <- rvest::html_node(xml2::read_html(download_page), "table")
  
  # Some of these tables have a shaded dot which means that the data will be
  # available in the future but it is not currently available. It's best
  # if we don't show those dots at all because it confuses the users (
  # and raises an error) thinking that the round is there (at least
  # when looking at it from R).
  
  # Here I search for the .//span tag which is the tag that gives the dots
  # shaded color. <span> could be a tag somewhere else in the document
  # that's why I set .// so that it searchers below the current node,
  # that is, only on the table.
  
  # remove those nodes
  xml2::xml_remove(xml2::xml_find_all(table_rounds_xml, ".//span"), free = TRUE)
  
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
