country <- "Denm"
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
  available_countries <- sapply(dirty_country_names, clean_attr, "/a")
  
  # If the chosen country is not available, prompt let the user
  # pick the country interactivibly from a list
  if (!country %in% available_countries) {
    
    # New country index
    chosen_index <- 9999 # random country index
    country_indexes <- seq_along(available_countries)
    
    # # To print out countries in nicely formatted columns
    # n_countries <- length(available_countries)
    # ncols <- 4
    # nrows <- length(available_countries) / ncols
    # 
    # strings_withnums <- paste0(1:n_countries, ": ", rep("%s", each = n_countries))
    # 
    # separate_strings <-
    #   split(strings_withnums,
    #       cut(seq_along(strings_withnums), seq(0, n_countries, length.out = 10)))
    # 
    # country_groups <-
    #   split(available_countries,
    #       cut(seq_along(available_countries),seq(0, n_countries, length.out = 10)))
    # 
    # names(country_groups) <- NULL
    # 
    # args_print <- c(list(fmt = as.character(separate_strings)), country_groups)
    # 
    # call("sprintf", args_print, quote = FALSE)
    #   
    # # I keep getting the first set of countries repeated
    # sprintf(c("1: %s", "2: %s", "3: %s", "4: %s",
    #           "5: %s", "6: %s", "7: %s", "8: %s",
    #           "9: %s", "10: %s", "11: %s", "12: %s", 
    #           "13: %s", "14: %s", "15: %s", "16: %s",
    #           "17: %s", "18: %s", "19: %s", "20: %s",
    #           "21: %s", "22: %s", "23: %s", "24: %s",
    #           "25: %s", "26: %s", "27: %s", "28: %s",
    #           "29: %s", "30: %s", "31: %s", "32: %s",
    #           "33: %s", "34: %s", "35: %s", "36: %s"),
    #         c("Albania", "Austria", "Belgium", "Bulgaria"),
    #         c("Croatia", "Cyprus", "Czech Republic", "Denmark"),
    #         c("Estonia", "Finland", "France", "Germany"),
    #         c("Greece", "Hungary", "Iceland", "Ireland"),
    #         c("Israel", "Italy", "Kosovo", "Latvia"),
    #         c("Lithuania", "Luxembourg","Netherlands", "Norway"),
    #         c("Poland", "Portugal", "Romania","Russian Federation"),
    #         c("Slovakia", "Slovenia", "Spain", "Sweden"),
    #         c("Switzerland", "Turkey", "Ukraine", "United Kingdom"))
    
    
    # While the chosen index is NOT a valid country,
    # promt a country list with the country numbers
    # until the user chooses a new country
    while (!chosen_index %in% country_indexes) {
      # cat() a country list with the numbers attached
      # before each country
      cat("The specified country was not available. \n",
          paste0(seq_along(available_countries), ": ",
                 available_countries), fill = 1)
      
      # Allow the user to enter the number and update chosen_inders
      cat("Enter the number of the new country:")
      chosen_index <- readLines(stdin(), n = 1)
    }
    
    country <- available_countries[as.numeric(chosen_index)]
  }
  
  
  all_country_links <- xml2::xml_attr(country_node, "href")
  
  # Build full url to chosen country
  chosen_country_link <-
    paste0(
      ess_website,
      all_country_links[which(country == available_countries)] # index where the country is at
    )
  
  # Extract html from country link to donwnload rounds
  country_rounds <- httr::GET(chosen_country_link)
  
  country_round_html <- xml2::read_html(country_rounds)
  
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
  
  # If any ESS round is missing
  if(any(!rounds %in% available_rounds)) {
    stop("Only rounds ",
         paste0("ESS", available_rounds, collapse = ", "),
         " available for ", country)
  }
  
  
  country_node <-
    xml2::xml_find_all(
      xml2::xml_find_all(
        xml2::xml_find_all(
          country_round_html, # Go deep down into the node
          '//ul'),
        "//li"),
      "//a")
  
  # Here we have all href from the website
  country_href <- xml2::xml_attrs(country_node, "href")
  
  # Only select the ones that match this:
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
  round_links <-
    paste0(
      ess_website,
      incomplete_links[which(round_numbers %in% rounds)]
    )
  round_links
  
  # for (index in seq_along(round_links)) {
  #   download.page <- httr::GET(paste0("http://www.europeansocialsurvey.org", 
  #                                     round_links[index]))
  #   download.block <- XML::htmlParse(download.page, asText = TRUE)
  #   z <- XML::xpathSApply(download.block, "//a", function(u) XML::xmlAttrs(u)["href"])
  #   stata.files[index] <- z[grep("stata", z)]
  # }
  # # } # this bracket closes the loop commented aout from above
  # 
  # full_urls <- sort(paste0("http://www.europeansocialsurvey.org", stata.files))
  # 
  # full_urls
}


# Function to automatically clean attributes
clean_attr <- function(x, ...) {
  other_attrs <- paste0((list(...)), collapse = "|")
  gsub(paste0(">|", "<|", other_attrs), "", x)
}
