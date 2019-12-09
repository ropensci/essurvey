# Function downloads the rounds or country rounds specified with ess_email and saves
# in output_dir unzipped as the format specified in format (only supports sas, spss and stata).
# If only_download, function will print a out a message where it saved everything.
# the specifi ess_* functions takes care of deleting the folders in only_downloader was FALSE.

# If only wants to download rounds, then name every argument after rounds.
# If rounds and country are specified, country rounds will be downloaded.
download_format <- function(country,
                            urls,
                            ess_email = NULL,
                            only_download = FALSE,
                            output_dir = NULL) {
  
  if (is.null(ess_email)) ess_email <- get_email()
  # Check user is valid
  authenticate(ess_email)
  
  # Extract the ESS prefix with the round number
  ess_round <- string_extract(urls, "ESS[[:digit:]]")
  
  # The saving path is output if download is set to TRUE
  # otherwise tempdir()
  if (only_download && is.null(output_dir)) {
    stop("`output_dir` should be a valid directory")
  }

  alt_dir <- ifelse(only_download, output_dir, tempdir())
  
  # create a temporary directory to unzip the files
  # if country is specified, create pre-folder with country
  # name
  if (!missing(country)) {
    td <- file.path(alt_dir, paste0("ESS_", country), ess_round)
  } else {
    td <- file.path(alt_dir, ess_round)
  }

  for (dire in td) dir.create(dire, recursive = TRUE, showWarnings = FALSE)
  # Loop throuch each url, round name and specific round folder,
  # download the data and save in the round-specific folder
  mapply(round_downloader, urls, ess_round, td)
  
  if (only_download) message("All files saved to ", normalizePath(output_dir))
  
  td
}

# function authenticates the user with his/her email.
authenticate <- function(ess_email) {
  
  if(missing(ess_email)) {
    stop(
      "`ess_email` parameter must be specified. Create an account at https://www.europeansocialsurvey.org/user/new" # nolint
    )
  }
  
  if (nchar(ess_email) == 0) {
    stop(
      "The email address you provided is not associated with any registered user. Create an account at https://www.europeansocialsurvey.org/user/new" # nolint
      )
  }
  
  # store your e-mail address in a list to be passed to the website
  values <- list(u = ess_email)
  
  url_login <- paste0(.global_vars$ess_website, .global_vars$path_login)
  # authenticate on the ess website
  authen <- httr::POST(url_login,
                        body = values)
  
  check_authen <-
    safe_GET(url_login,
              query = values)
  
  authen_xml <- xml2::read_html(check_authen)
  error_node <- xml2::xml_find_all(authen_xml, '//p [@class="error"]')
  
  # If there is a log in error, stop an raise the text from the
  # class='error'. This should "Your email address is not regist
  # ered in the ESS website, or among those lines".
  if (length(error_node) != 0) {
    stop(xml2::xml_text(error_node),
         " Create an account at https://www.europeansocialsurvey.org/user/new")
  }
  
}

# Function downloads the url after authentification and saves
# in the which_folder
round_downloader <- function(each_url, which_round, which_folder) { # nocov start
  
  # Download the data
  message(paste("Downloading", which_round))
  
  # round specific .zip file inside the round folder
  temp_download <- file.path(which_folder, paste0(which_round, ".zip"))
  
  current_file <- safe_GET(each_url, httr::progress())
  
  # Write as a .zip file
  writeBin(httr::content(current_file, as = "raw") , temp_download)
  
  utils::unzip(temp_download, exdir = which_folder)
} # nocov end

# Safe getter
safe_GET <- function(url, config = list(), ...) { # nocov start
  resp_conn <- httr::GET(url = url, config = config, ...)

  if (httr::status_code(resp_conn) > 300) {
    stop("We're unable to reach 'www.europeansocialsurvey.org'. Are you connected to the internet or is the website down?'")
  }

  resp_conn
} # nocov end
