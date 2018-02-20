#' Download integrated rounds separately for countries from the European Social Survey
#'
#' @details 
#' If \code{only_download} is set to FALSE, the data will be read in the format specified
#' in \code{format}. 'sas' is not supported because the data formats have changed between
#' ESS waves and separate formats require different functions to be read. To preserve parsimony
#' and format errors between waves, the user should use 'spss' or 'stata'.
#'
#' @param country a character of length 1 with the full name of the country. 
#' Use \code{\link{show_countries}} for a list of available countries.
#' @param rounds a numeric vector with the rounds to download. See \code{\link{show_rounds}}
#' for all available rounds.
#' @param your_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#' @param output_dir a character vector with the output directory in case you want to only
#' download the files using the \code{only_download} argument. Defaults to your working directory.
#' Files will be saved as ESS_*/ESS\code{N} where the first star is the country name and \code{N}
#' the round number. This will be interpreted as a \strong{directory} and not a file name. Files names
#' will be used as folder names, such as "./myfile.dta/.
#' @param format the format from which to download the data. Can either be 'stata', 'spss' or 'sas',
#' with 'stata' as default. When \code{only_download} is set to TRUE, the data will be downloaded in
#' the \code{format} specified. If \code{only_download} is FALSE, the data is downloaded and read
#' from the specified \code{format} (only 'spss' and 'stata' supported, see details).
#' 
#' @return if \code{only_download} is set to FALSE and \code{length(rounds)} is 1, it returns a tibble
#' with the latest version of that round. Otherwise it returns a list of \code{length(rounds)}
#' containing the latest version of each round. If \code{only_download} is set to TRUE and
#' output_dir is a valid directory, it returns the saved directories invisibly and saves all
#' the rounds in the chosen \code{format} in \code{output_dir}
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get first three rounds for Denmark
#' dk_three <- ess_country("Denmark", 1:3, "your_email@email.com")
#' 
#' # Only download the files, this will return nothing
#' 
#' temp_dir <- tempdir()
#' 
#' ess_country(
#'  "Turkey",
#'  rounds = c(2, 4),
#'  your_email = "your_email@email.com",
#'  only_download = TRUE,
#'  output_dir = temp_dir
#' )
#' 
#' # By default, ess_country downloads 'stata' files but
#' # you can also download 'spss' or 'sas' files.
#' 
# ess_country(
#  "Turkey",
#  rounds = c(2, 4),
#  your_email = "your_email@email.com",
#  only_download = TRUE,
#  output_dir = temp_dir,
#  format = 'spss'
# )
#' 
#' # If email is not registered at ESS website, error will arise
#' uk_one <- ess_country("United Kingdom", 5, "wrong_email@email.com")
#' # Error in authenticate(your_email) : 
#' # The email address you provided is not associated with any registered user.
#' # Create an account at http://www.europeansocialsurvey.org/user/new
#' 
#' # If selected rounds don't exist, error will arise
#' 
#' czech_two <- ess_country("Czech Republic", c(1, 22), "your_email@email.com")
#' 
#' # Error in ess_country_url(country, rounds) : 
#' # Only rounds ESS1, ESS2, ESS4, ESS5, ESS6, ESS7, ESS8 available
#' # for Czech Republic
#' }

ess_country <- function(country, rounds, your_email, only_download = FALSE, output_dir = getwd(), format = 'stata') {
  
  # If user only wants to download, then download and return
  if (only_download) {
    return(
      invisible(
        download_format(rounds = rounds,
                        country = country,
                        your_email = your_email,
                        only_download = only_download,
                        output_dir = output_dir,
                        format = format
        )
      )
    )
  }
  
  if (format == "sas") {
    stop(
      "You cannot read SAS but only 'spss' and 'stata' files with this function. See ?ess_country for more details")
  }
  
  # If not, download data and save the dir of the downloads
  dir_download <- download_format(rounds = rounds,
                                  country = country,
                                  your_email = your_email,
                                  format = format)
  
  all_data <- read_format_data(dir_download, format, rounds)

  all_data
}

read_format_data <- function(urls, format, rounds) {
  
  # Use function ro read the specified format
  format_read <-
    switch(format,
           'spss' = haven::read_spss,
           'stata' = haven::read_dta
    )
  
  format_ext <- c(".dta", ".sav")
  # Get all paths from the format
  format_dirs <- list.files(urls, pattern = paste0(format_ext, "$", collapse = "|"), full.names = TRUE)
  
  # Read only the .dta/.sav/ files
  dataset <- lapply(format_dirs, format_read)
  
  # Remove everything that was downloaded
  unlink(urls, recursive = TRUE, force = TRUE)
  
  # If it's only one round, return a df rather than a list
  if (length(rounds) == 1) dataset <- dataset[[1]]
  
  dataset
  
}
