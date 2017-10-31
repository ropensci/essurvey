ess_country_url <- function(country, rounds) {
  
  # Get unique rounds to avoid repeting rounds
  rounds <- sort(unique(rounds))
  # Get unique country to avoid repetitions  
  country <- sort(unique(country))
  
  # Returns each countries href attribute with its website
  # ess_website is a vector set as metadata
  available_countries <- show_countries()
  
  if (!country %in% available_countries) {
    stop("Country not available in ESS. Check show_countries()")
  }
  
  available_rounds <- show_country_waves(country)
  
  # If any ESS round is missing
  if(any(!rounds %in% available_rounds)) {
    stop("Only rounds ",
         paste0("ESS", available_rounds, collapse = ", "),
         " available for ", country)
  }
  
  # Returns the chosen countries html that contains
  # the links to all waves.
  country_round_html <- extract_cnt_html(country, available_countries)
  
  # Go deeper in the node to grab that countries url to the waves
  country_node <- xml2::xml_find_all(country_round_html, "//ul //li //a")

  # Here we have all href from the website
  country_href <- xml2::xml_attrs(country_node, "href")
  
  # Only select the waves that match this:
  # /download.html\\?file= for the downoad section
  # ESS[0-9] for any of the rounds
  # [A-Z]{1,1} followed by a capital letter for
  # the country name, as in DK
  # (.*) anything in between
  # [0-9]{4, } for the year of round
  incomplete_links <-
    sort(grep("^/download.html\\?file=ESS[0-9][A-Z]{1,2}(.*)[0-9]{4, }$",
              country_href,
              value = TRUE))
  
  # Extract round numbers
  round_numbers <- as.numeric(stringr::str_extract(incomplete_links, "[0-9]{1,2}"))
  
  # Build final ESS round links
  round_links <- incomplete_links[which(round_numbers %in% rounds)]
  
  stata.files <- character(length(rounds))
  
  # Build stata paths for each round
  for (index in seq_along(round_links)) {
    download.page <- httr::GET(paste0(.global_vars$ess_website,
                                      round_links[index]))
    download.block <- XML::htmlParse(download.page, asText = TRUE)
    z <- XML::xpathSApply(download.block, "//a", function(u) XML::xmlAttrs(u)["href"])
    stata.files[index] <- z[grep("stata", z)]
  }
  # } # this bracket closes the loop commented aout from above
  
  full_urls <- sort(paste0(.global_vars$ess_website, stata.files))
  
  full_urls
}