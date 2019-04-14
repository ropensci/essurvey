## TODO
## Properly document these functions if you want to export them.
## Think about it or ask in the issues?
check_rounds <- function(rounds) {
  all_rounds_present <- rounds %in% show_rounds()
  
  if (!all(all_rounds_present))  {
    
    failed_rounds <- paste0(rounds[!all_rounds_present], collapse = ", ")
    
    stop(
      paste("ESS round", failed_rounds,
            "is not available. Check show_rounds()")
    )
  }
  
  TRUE
}

check_country <- function(country) {
  
  if (length(country) > 1) stop("Argument `country` should only contain one country")
  
  all_countries_present <- country %in% show_countries()
  

  if (!all(all_countries_present))  {

    failed_countries <- paste0(country[!all_countries_present], collapse = ", ")
    
    stop(
      paste("Country", failed_countries,
            "not available in ESS. Check show_countries()",
            collapse = "\n")
    )
  }
  
  TRUE
}


check_country_rounds <- function(country, rounds) {
  
  check_country(country)
  
  all_rounds_present <- rounds %in% show_country_rounds(country)

  if (!all(all_rounds_present))  {
    
    failed_rounds <- paste0(rounds[!all_rounds_present], collapse = ", ")
    
    stop(
      paste0("ESS round ", failed_rounds,
            " not available for ", country,
            ". Check show_rounds()")
    )
  }
  
  TRUE
}

check_theme <- function(theme) {
  
  if (length(theme) > 1) stop("Argument `theme` should only contain one theme")
  
  all_theme_present <- theme %in% show_themes()
  
  if (!all(all_theme_present))  {
    
    stop(
      paste0("ESS theme ", theme, " not available. Check show_themes()")
    )
  }
  
  TRUE
}
