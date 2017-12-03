ess_round_url <- function(rounds, format) {
  
  # Check if the format is either 'stata', 'spss' or 'sas'.
  
  if(!format %in% c('stata', 'spss', 'sas')) {
    stop("Format not available. Only 'stata', 'spss', or 'sas'")
  }
  
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
  round_links <- sort(grep(paste0(round_codes, collapse = "|"),
                           grab_rounds_link(), value = TRUE))
  
  # empty character to fill with urls
  format.files <- character(length(rounds))

  for (index in seq_along(round_links)) {
    download.page <- httr::GET(paste0(.global_vars$ess_website, 
                                      round_links[index]))
    download.block <- XML::htmlParse(download.page, asText = TRUE)
    z <- XML::xpathSApply(download.block, "//a", function(u) XML::xmlAttrs(u)["href"])
    format.files[index] <- z[grep(format, z)]
  }
  # } # this bracket closes the loop commented aout from above
  
  full_urls <- sort(paste0(.global_vars$ess_website, format.files))
  
  full_urls
}

# This will return a link like "/download.html?file=ESS8e01&y=2016"
# for every round available in the ess website.
grab_rounds_link <- function(ess_website = .global_vars$ess_website) {
  download_page <- httr::GET(paste0(ess_website, "/data/download.html?r="))
  download_block <- XML::htmlParse(download_page, asText = TRUE)
  z <- XML::xpathSApply(download_block, "//a", function(u) XML::xmlAttrs(u)["href"])
  
  downloads <- unique(grep("^/download.html(.*)[0-9]{4, }$", z, value = TRUE))
  downloads
}


# Here I define an environment to hold the ess_website vector
# because it's a variable I'll use in nearly all functions to
# access the website
.global_vars <- new.env()

var_names <- c(
  "ess_website",
  "theme_index",
  "country_index",
  "rounds",
  "countries",
  "themes"
)

var_values <- list(
  "http://www.europeansocialsurvey.org",
  "/data/module-index.html",
  "/data/country_index.html",
  show_rounds(),
  show_countries(),
  show_themes()
)

mapply(assign, var_names, var_values, list(envir = .global_vars))
