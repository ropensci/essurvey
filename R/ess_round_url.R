ess_round_url <- function(rounds) {
  
  # Get unique rounds to avoid repeting rounds
  rounds <- sort(unique(rounds))
  
  download_page <- httr::GET("http://www.europeansocialsurvey.org/data/download.html?r=")
  download_block <- XML::htmlParse(download_page, asText = TRUE)
  z <- XML::xpathSApply(download_block, "//a", function(u) XML::xmlAttrs(u)["href"])
  
  available_rounds <-  grep("^/data/download.html(.*)[0-9]$", z, value = TRUE)
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

# Here I define an environment to hold the ess_website vector
# because it's a variable I'll use in nearly all functions to
# access the website
.global_vars <- new.env()
assign("ess_website",
       "http://www.europeansocialsurvey.org", envir = .global_vars)