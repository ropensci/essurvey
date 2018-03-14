ess_round_url <- function(rounds, format) {
  # Get unique rounds to avoid repeting rounds
  rounds <- sort(unique(rounds))
  
  # Test whether all rounds specified are present in the website
  all_rounds_present <- rounds %in% show_rounds()
  
  # If some is not present, show an error stating which specific round
  # is not available. This is vectorized so if more than one round is
  # not present, you will get a warning for each round not present
  if (!all(all_rounds_present))  {
    stop(
      paste("ESS round", rounds[!all_rounds_present],
            "is not a available. Check show_rounds()",
            collapse = "\n")
    )
  }
  
  round_codes <- paste0("ESS", rounds)
  
  # Extract download urls from selected_rounds
  round_links <- sort(grep(pattern = paste0(round_codes, collapse = "|"),
                           x = grab_rounds_link(.global_vars$ess_website),
                           value = TRUE))
  
  # empty character to fill with urls
  format.files <- character(length(rounds))

  for (index in seq_along(round_links)) {
    download_page <- safe_GET(paste0(.global_vars$ess_website, 
                                      round_links[index]))
    html_ess <- xml2::read_html(download_page) 
    z <- xml2::xml_text(xml2::xml_find_all(html_ess, "//a/@href"))
    format.files[index] <- z[grep(format, z)]
  }
  # } # this bracket closes the loop commented aout from above
  
  full_urls <- sort(paste0(.global_vars$ess_website, format.files))
  
  full_urls
}

# This will return a link like "/download.html?file=ESS8e01&y=2016"
# for every round available in the ess website.
grab_rounds_link <- function(ess_website) {
  download_page <- safe_GET(paste0(ess_website, "/data/download.html?r="))
  html_ess <- xml2::read_html(download_page) 
  z <- xml2::xml_text(xml2::xml_find_all(html_ess, "//a/@href"))
  
  downloads <- unique(grep("^/download.html(.*)[0-9]{4, }$", z, value = TRUE))
  downloads
}