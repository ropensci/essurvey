ess_url <- function(waves) {
  
  # Get unique waves to avoid repeting waves
  waves <- sort(unique(waves))
  
  download_page <- httr::GET("http://www.europeansocialsurvey.org/data/download.html?r=")
  download_block <- XML::htmlParse(download_page, asText = TRUE)
  z <- XML::xpathSApply(download_block, "//a", function(u) XML::xmlAttrs(u)["href"])
  
  available_waves <-  grep("^/data/download.html(.*)[0-9]$", z, value = TRUE)
  downloads <- unique(grep("^/download.html(.*)[0-9]{4, }$", z, value = TRUE))
  
  # extract ESS* part to detect dupliacted
  ess_prefix <- sort(stringr::str_extract(downloads, "ESS[:digit:]"))
  
  # Test whether all waves specified are present in the website
  all_waves_present <- waves %in% stringr::str_extract(ess_prefix, "[:digit:]")
  
  # If some is not present, show an error stating which specific round
  # is not available. This is vectorized so if more than one wave is
  # not present, you will get a warning for each wave not present
  if (!all(all_waves_present))  {
    stop(
      paste("ESS round", waves[!all_waves_present],
            "is not a available at http://www.europeansocialsurvey.org/data/round-index.html",
            collapse = "\n")
    )
  }
  
  wave_codes <- paste0("ESS", waves)
  
  # Extract download urls from waves selected
  wave_links <- sort(grep(paste0(wave_codes, collapse = "|"), downloads, value = TRUE))
  
  # empty character to fill with urls
  stata.files <- character(length(waves))
  
  # This code is for grabbing countries from each wave-round
  
  # for (current_round in seq_along(waves)) {
  # download_page <- httr::GET(paste0("http://www.europeansocialsurvey.org/data/download.html?r=", 
  #                                   waves[current_round]))
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
  #                                         waves[current_round]), z, fixed = TRUE)])
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

