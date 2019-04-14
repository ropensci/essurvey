country_url_sddf <- function(country, rounds) {
  
  ## TODO
  ## You're only limiting SDDF files to rounds 1:6 until you can figure out
  ## how to include the SDDF from rounds 7:8 which are integrated for all countries
  if (any(rounds >= 7)) stop('SDDF files are only supported for rounds earlier than the 6th round')
  
  # Only select the rounds that match this:
  # /download.html\\?file= for the downoad section
  # ESS[0-9]{1,} for any of the rounds
  # [A-Z]{1,1} followed by a capital letter for
  # the country name, as in DK
  # (.*) anything in between
  # [0-9]{4, } for the year of round
  
  sddf_regex <- "^/download.html\\?file=ESS[0-9]{1,}_[A-Z]{1,2}_SDDF(.*)[0-9]{4, }$"
  
  full_urls <- grab_url(country, rounds, sddf_regex, sddf = TRUE)
  
  full_urls
}

grab_url <- function(country, rounds, regex, sddf = FALSE) {
  
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
  
  available_rounds <- show_country_rounds(country)
  
  # If any ESS round is missing
  if(any(!rounds %in% available_rounds)) {
    stop("Only rounds ",
         paste0("ESS", available_rounds, collapse = ", "),
         " available for ", country)
  }
  
  # Returns the chosen countries html that contains
  # the links to all rounds.
  country_round_html <- extract_html(country,
                                     available_countries,
                                     .global_vars$country_index)
  
  # Go deeper in the node to grab that countries url to the rounds
  country_node <- xml2::xml_find_all(country_round_html, "//ul //li //a")
  
  # Here we have all href from the website
  country_href <- xml2::xml_attrs(country_node, "href")
  
  incomplete_links <-
    sort(grep(regex,
              country_href,
              value = TRUE))
  
  # Extract round numbers
  round_numbers <- as.numeric(stringr::str_extract(incomplete_links,
                                                   "[0-9]{1,2}"))
  
  if (sddf) {
    # How many rounds actually have sddf data?
    sddf_rounds_available <- rounds %in% round_numbers
    
    # If ANY round doesn't not have SDDF data, raise error pointing
    # to the rounds which don't have SDDF data.
    if(any(!sddf_rounds_available)) {
      stop("Rounds ",
           paste0("ESS", rounds[!sddf_rounds_available], collapse = ", "),
           " don't have SDDF data available for ", country)
    }
  }
  
  # Build final ESS round links
  round_links <- incomplete_links[which(round_numbers %in% rounds)]
  
  format.files <- character(length(rounds))
  
  # Build paths for each round
  for (index in seq_along(round_links)) {
    download_page <- safe_GET(paste0(.global_vars$ess_website,
                                     round_links[index]))
    html_ess <- xml2::read_html(download_page) 
    z <- xml2::xml_text(xml2::xml_find_all(html_ess, "//a/@href"))
    format.files[index] <- format_preference(z, formats = c('stata', 'spss'))
  }

  full_urls <- sort(paste0(.global_vars$ess_website, format.files))
  
  full_urls
}

# Function accepts the chosen country and the list
# of all available countries and returns the html doc
# for the chosen country that contains the whole list of
# links to download that countries rounds.
extract_html <- function(chosen_module, available_modules, module_index) {
  
  country_refs  <- get_href(.global_vars$ess_website, module_index)
  # Returns "/data/country.html?c=ukraine" for all countries
  all_module_links <-
    xml2::xml_attr(
      country_refs,
      "href"
    )
  
  all_module_countries <- xml2::xml_text(country_refs)
  
  # Build full url for chosen country
  chosen_module_link <-
    paste0(
      .global_vars$ess_website,
      all_module_links[which(chosen_module == all_module_countries)] 
      # index where the country because all_module_links and
      # all_module_countries are in the same order
    )
  
  # Extract html from country link to donwnload rounds
  module_rounds <- safe_GET(chosen_module_link)
  
  module_round_html <- xml2::read_html(module_rounds)
  
  module_round_html
}

# Function to grab <a href="/data/country.html?c=latvia">Latvia</a>
# for each country
get_href <- function(ess_website, module_index) {
  download_page <- safe_GET(paste0(ess_website, module_index))
  
  # Get the <a href="/data/country.html?c=latvia">Latvia</a> for each country
  country_node <- xml2::xml_find_all(xml2::read_html(download_page),
                                     '//td [@class="label"]//a')
  
  country_node
}

# Function to automatically clean attributes such as
# <a> something <\a>. This will clean to: something
# if a and /a are specified as arguments.
clean_attr <- function(x, ...) {
  other_attrs <- paste0((list(...)), collapse = "|")
  gsub(paste0(">|", "<|", other_attrs), "", x)
}

# Function to find regex in x with preference in `formats`
format_preference <- function(x, formats) {
  for (i in formats) {
    format_link <- grep(i, x, value = TRUE)
    if (length(format_link) > 0)  return(format_link)
  }
}