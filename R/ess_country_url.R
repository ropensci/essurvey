country <- "Denmark"
rounds <- 1:2

ess_country_url <- function(country, rounds) {
  
  # Get unique rounds to avoid repeting rounds
  rounds <- sort(unique(rounds))
  # Get unique country to avoid repetitions  
  country <- sort(unique(country))
  
  ess_website <- "http://www.europeansocialsurvey.org"
  
  download_page <- httr::GET(paste0(ess_website, "/data/country_index.html"))
  download_block <- XML::htmlParse(download_page, asText = TRUE)
  z <- XML::xpathSApply(download_block, "//a", function(u) XML::xmlAttrs(u)["href"])
  
  # Get the <a href="/data/country.html?c=latvia">Latvia</a> for each country
  country_node <- xml2::xml_find_all(xml2::read_html(download_page), '//td [@class="label"]//a')
  
  # Extract the name
  dirty_country_names <-
    stringr::str_extract_all(as.character(country_node), ">(.*)</a>$")
  
  # Clean up the name
  available_countries <-
    gsub(
      ">|</a>",
      "",
      dirty_country_names
    )
  
  # If the chosen country is not available, prompt let the user
  # pick the country interactivibly from a list
  if (!country %in% available_countries) {
    
    # New country index
    chosen_index <- 9999 # random country index
    country_indexes <- seq_along(available_countries)
    
    # While the chosen index is NOT a valid country,
    # promt a country list with the country numbers
    # until the user chooses a new country
    
    while (!chosen_index %in% country_indexes) {
      # cat() a country list with the numbers attached
      # before each country
      cat("The specified country was not available.",
          paste0(seq_along(available_countries), ": ",
                 available_countries),
          sep = "\n")
      
      # Allow the user to enter the number and update chosen_inders
      cat("Enter the number of the new country:")
      chosen_index <- readLines(stdin(), n = 1)
    }
    
    country <- available_countries[as.numeric(chosen_index)]
    }
  
  # Build country links
  country_links <-  paste0(ess_website, xml2::xml_attr(country_node, "href"))
  
  downloads <- unique(grep("^/download.html(.*)[0-9]{4, }$", z, value = TRUE))
  
  # extract ESS* part to detect dupliacted
  ess_prefix <- sort(stringr::str_extract(downloads, "ESS[:digit:]"))
  
  # Test whether all rounds specified are present in the website
  all_rounds_present <- rounds %in% stringr::str_extract(ess_prefix, "[:digit:]")
  
  # If some is not present, show an error stating which specific round
  # is not available. This is vectorized so if more than one round is
  # not present, you will get a warning for each round not present
  if (!all(all_rounds_present))  {
    stop(
      paste("ESS round", rounds[!all_rounds_present],
            "is not a available at http://www.europeansocialsurvey.org/data/round-index.html",
            collapse = "\n")
    )
  }
  
  round_codes <- paste0("ESS", rounds)
  
  # Extract download urls from rounds selected
  round_links <- sort(grep(paste0(round_codes, collapse = "|"), downloads, value = TRUE))
  
  # empty character to fill with urls
  stata.files <- character(length(rounds))
  
  # This code is for grabbing countries from each round-round
  
  # for (current_round in seq_along(rounds)) {
  # download_page <- httr::GET(paste0("http://www.europeansocialsurvey.org/data/download.html?r=", 
  #                                   rounds[current_round]))
  # 
  # download_block <- XML::htmlParse(download_page, asText = TRUE)
  # 
  # z <- XML::xpathSApply(download_block, "//a", function(u) XML::xmlAttrs(u)["href"])
  # z <- z[!grepl("mailto", z)]
  # z <- z[tools::file_ext(z) != "html"]
  # 
  # # This is where the integrated round is but also all
  # # other country links.
  # all_round_files <- unique(z[grep(paste0("/download.html?file=ESS", 
  #                                         rounds[current_round]), z, fixed = TRUE)])
  # 
  # # Take only the integrated round
  # integrated_round <- all_round_files[all_round_files == round_links[current_round]]
  
  for (index in seq_along(round_links)) {
    download.page <- httr::GET(paste0("http://www.europeansocialsurvey.org", 
                                      round_links[index]))
    download.block <- XML::htmlParse(download.page, asText = TRUE)
    z <- XML::xpathSApply(download.block, "//a", function(u) XML::xmlAttrs(u)["href"])
    stata.files[index] <- z[grep("stata", z)]
  }
  # } # this bracket closes the loop commented aout from above
  
  full_urls <- sort(paste0("http://www.europeansocialsurvey.org", stata.files))
  
  full_urls
}

