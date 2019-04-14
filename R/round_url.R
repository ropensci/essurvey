round_url <- function(rounds, format) { # nocov start
  # Get unique rounds to avoid repeting rounds
  rounds <- sort(unique(rounds))
  
  # Check rounds
  check_rounds(rounds)
  
  round_codes <- paste0("ESS", rounds)
  
  # Extract download urls from selected_rounds
  round_links <- sort(grep(pattern = paste0(round_codes, collapse = "|"),
                           x = get_rounds_link(.global_vars$ess_website),
                           value = TRUE))
  
  full_url <- get_download_url(round_links)
  
  full_url
  
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