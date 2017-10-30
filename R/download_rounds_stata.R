download_rounds_stata <- function(rounds , your_email, output_dir = ".", only_download = FALSE) {

    if( missing(your_email) ) {
    stop(
      "`your_email` parameter must be specified.  create an account at http://www.europeansocialsurvey.org/user/new"
      ) 
    }
  
    # store your e-mail address in a list to be passed to the website
    values <- list( u = your_email )
    
    # authenticate on the ess website
    authen <- httr::POST( "http://www.europeansocialsurvey.org/user/login" , body = values )
    
    check_authen <-
      httr::GET( "http://www.europeansocialsurvey.org/user/login" , query = values )
    
    authen_xml <- xml2::read_html(check_authen)
    error_node <- xml2::xml_find_all(authen_xml, '//p [@class="error"]')
    
    # If there is a log in error, stop an raise the text from the
    # class='error'. This should "Your email address is not regist
    # ered in the ESS website, or among those lines".
    if (length(error_node) != 0) stop(xml2::xml_text(error_node),
                                      " Create an account at http://www.europeansocialsurvey.org/user/new")
    
    # Grab the download urls for each round
    urls <- ess_round_url(rounds)
    
    # Extract the ESS prefix with the round number
    ess_round <- stringr::str_extract(urls, "ESS[:digit:]")
    
    # create a temporary directory to unzip the stata files
    td <- file.path(output_dir, ess_round)
    
    for (directory in td) dir.create(directory)
    
    round_downloader <- function(each_url, which_round, which_folder) {
      
      # Download the data
      message(paste("Downloading", which_round))
      
      # round specific .zip file inside the round folder
      temp_download <- file.path(which_folder, paste0(which_round, ".zip"))
      
      current_file <- httr::GET(each_url, httr::progress())
      
      # Write as a .zip file
      writeBin(httr::content( current_file, "raw" ) , temp_download)
      
      utils::unzip(temp_download, exdir = which_round)
    }

    # Loop throuch each url, round name and specific round folder,
    # download the data and save in the round-specific folder
    mapply(round_downloader, urls, ess_round, td)
    
    if (only_download) message("All files saved to ", normalizePath(output_dir))
    
    return(td)
}
