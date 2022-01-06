round_url <- function(rounds, format = NULL) { # nocov start
  # Get unique rounds to avoid repeting rounds
  rounds <- sort(unique(rounds))

  # Check rounds
  check_rounds(rounds)

  round_codes <- paste0("ESS", rounds)

  # Extract download urls from selected_rounds
  round_links <- sort(grep(pattern = paste0(round_codes, collapse = "|"),
                           x = get_rounds_link(.global_vars$ess_website),
                           value = TRUE))

  full_url <- get_download_url(round_links, format)

  full_url

} # nocov end

country_url <- function(country, rounds, format = NULL) { # nocov start
  # And also the rounds for that country
  check_country_rounds(country, rounds)

  # Only select the rounds that match this:
  # /download.html\\?file= for the downoad section
  # ESS[0-9] for any of the rounds
  # [A-Z]{1,1} followed by a capital letter for
  # the country name, as in DK
  # (.*) anything in between
  # [0-9]{4, } for the year of round
  country_regex <- "^/download.html\\?file=ESS[0-9][A-Z]{1,2}(.*)[0-9]{4, }$"


  full_urls <- grab_url(country, rounds, country_regex, format)

  full_urls
} # nocov end


country_url_sddf <- function(country, rounds, format = NULL) { # nocov start

  # And also the rounds for that country
  check_country_sddf_rounds(country, rounds)

  # Only select the rounds that match this:
  # /download.html\\?file= for the downoad section
  # ESS[0-9]{1,} for any of the rounds
  # [A-Z]{1,1} followed by a capital letter for
  # the country name, as in DK
  # (.*) anything in between
  # [0-9]{4, } for the year of round

  sddf_regex <-
    "^/download.html\\?file=ESS[0-9]{1,}_[A-Z]{1,2}_SDDF(.*)[0-9]{4, }$"


  full_urls <- grab_url(country, rounds, sddf_regex, format)

  full_urls
} # nocov end

country_url_sddf_late_rounds <- function(country, rounds, format = NULL) { # nocov start

  # And also the rounds for that country
  check_country_sddf_rounds(country, rounds)

  # No need to add regex as in country_url because grabbing the rounds
  # returns the direct paths
  full_urls <- grab_url_sddf_late_rounds(rounds, format)

  full_urls
} # nocov end


grab_url <- function(country, rounds, regex, format) { # nocov start

  # Get unique rounds to avoid repeting rounds
  rounds <- sort(unique(rounds))
  # Get unique country to avoid repetitions
  country <- sort(unique(country))

  # Returns the chosen countries html that contains
  # the links to all round website.
  country_round_html <- extract_country_html(country,
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
  round_numbers <- as.numeric(string_extract(incomplete_links,
                                             "[0-9]{1,2}"))

  # Build final ESS round links
  round_links <- incomplete_links[which(round_numbers %in% rounds)]

  # Using each separate round html, extract the stata or spss direct link
  # to download the data. Return the full direct path.
  full_urls <- get_download_url(round_links, format)

  full_urls
} # nocov end


grab_url_sddf_late_rounds <- function(rounds, format) { #nocov start

  # Get unique rounds to avoid repeting rounds
  rounds <- sort(unique(rounds))

  # Returns the all late SDDF rounds main page
   late_sddf_mainpage <-
    get_href(
      .global_vars$ess_website,
      .global_vars$sddf_index,
      "//ul [@class='docliste']//a"
    )

  # Here we have all late SDDF main websites
  late_sddf_href <- xml2::xml_attrs(late_sddf_mainpage, "href")

  # Extract round numbers
  round_numbers <-
    as.numeric(
      string_extract(late_sddf_href, "[0-9]{1,}")
    )

  # Build final ESS round links
  round_links <- late_sddf_href[which(round_numbers %in% rounds)]

  # Using each separate round html, extract the stata or spss direct link
  # to download the data. Return the full direct path.
  full_urls <- get_download_url(round_links, format)

  full_urls
} #nocov end

# Given a country/round website such as https://www.europeansocialsurvey.org/download.html?file=ESS1ES&c=ES&y=2002,
# extracts the stata (or spss, in that specific order if one is not available) path and
# returns the complete url path to download the data
get_download_url <- function(round_links, format) { # nocov start
  # Create empty character slot with the same length as round links
  # to populate it in the loop
  format.files <- character(length(round_links))

  # Build paths for each round
  for (index in seq_along(round_links)) {
    download_page <- safe_GET(paste0(.global_vars$ess_website,
                                     round_links[index]))

    html_ess <- xml2::read_html(download_page)
    z <- xml2::xml_text(xml2::xml_find_all(html_ess, "//a/@href"))
    format.files[index] <- format_preference(z, format)
  }

  full_urls <- sort(paste0(.global_vars$ess_website, format.files))

  full_urls

} # nocov end

# Function accepts the chosen country and the list
# of all available countries and returns the html doc
# for the chosen country that contains the whole list of
# links to download that countries rounds.
extract_country_html <- function(chosen_module, module_index) { # nocov start

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
      all_module_links[which(chosen_module == all_module_countries)]
      # index where the country because all_module_links and
      # all_module_countries are in the same order
    )

  # Extract html from country link to donwnload rounds
  module_rounds <- safe_GET(chosen_module_link)

  module_round_html <- xml2::read_html(module_rounds)

  module_round_html
} # nocov end

# Function to grab <a href="/data/country.html?c=latvia">Latvia</a>
# for each country. The default href path should take all td lists
# of class labelled (most ESS HTML lists) but for SDDF this changes
# to all li lists of clas docliste
get_href <- function(ess_website,
                     module_index,
                     href_xpath = "//td [@class='label']//a") { # nocov start

  download_page <- safe_GET(paste0(ess_website, module_index))

  country_node <-
    xml2::xml_find_all(
      xml2::read_html(download_page),
      href_xpath
    )

  country_node
} # nocov end

# This will return a link like "/download.html?file=ESS8e01&y=2016"
# for every round available in the ess website.
get_rounds_link <- function(ess_website) { # nocov start
  download_page <- safe_GET(paste0(ess_website, "/data/download.html?r="))
  html_ess <- xml2::read_html(download_page)
  z <- xml2::xml_text(xml2::xml_find_all(html_ess, "//a/@href"))

  downloads <- unique(grep("^/download.html(.*)[0-9]{4, }$", z, value = TRUE))
  downloads
} # nocov end

# Function to automatically clean attributes such as
# <a> something <\a>. This will clean to: something
# if a and /a are specified as arguments.
clean_attr <- function(x, ...) { # nocov start
  other_attrs <- paste0((list(...)), collapse = "|")
  gsub(paste0(">|", "<|", other_attrs), "", x)
} # nocov end

# Function to find regex in x with preference in `formats`
format_preference <- function(x, format) { # nocov start
  format <- if (is.null(format)) c("stata", "spss", "sas") else format

  # If the user didn't supply the format (user can only supply only one
  # format and the format arg was manually imputed from above)
  if (length(format) > 1) {

    # Read each format and return the one that has a match
    for (i in format) {
      format_link <- grep(i, x, value = TRUE)
      if (length(format_link) > 0)  return(format_link)
    }

  } else {

    # If the user supplied the format, try reading that format
    # return the link if found or an error otherwise
    format_link <- grep(format, x, value = TRUE)
    if (length(format_link) > 0)  {
      return(format_link)
    } else {
      stop(paste0("Format '", format, "' not available."))
    }

  }
} # nocov end
