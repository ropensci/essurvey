ess_url <- function(rounds) {
  
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
  # is not available. This is vectorized so if more than one wave is
  # not present, you will get a warning for each wave not present
  if (!all(all_rounds_present))  {
    stop(
      paste("ESS round", rounds[!all_rounds_present],
            "is not a available at http://www.europeansocialsurvey.org/data/round-index.html",
            collapse = "\n")
    )
  }
  
  wave_codes <- paste0("ESS", rounds)
  
  # Extract download urls from rounds selected
  wave_links <- sort(grep(paste0(wave_codes, collapse = "|"), downloads, value = TRUE))
  
  # empty character to fill with urls
  stata.files <- character(length(rounds))
  
  # This code is for grabbing countries from each wave-round
  
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
  # integrated_round <- all_round_files[all_round_files == wave_links[current_round]]
  
  for (index in seq_along(wave_links)) {
    download.page <- httr::GET(paste0("http://www.europeansocialsurvey.org", 
                                      wave_links[index]))
    download.block <- XML::htmlParse(download.page, asText = TRUE)
    z <- XML::xpathSApply(download.block, "//a", function(u) XML::xmlAttrs(u)["href"])
    stata.files[index] <- z[grep("stata", z)]
  }
  # } # this bracket closes the loop commented aout from above
  
  full_urls <- sort(paste0("http://www.europeansocialsurvey.org", stata.files))
  
  full_urls
}

