#' Download integrated rounds separately for countries from the European Social Survey
#'
#' @param country a character of length 1 with the full name of the country. 
#' Use \code{\link{show_countries}} for a list of available countries.
#' @param rounds a numeric vector with the rounds to download. See \code{\link{show_rounds}}
#' for all available rounds.
#' @param ess_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}. A prefered method is to login
#' through \code{\link{set_email}}.
#' 
#' @param output_dir a character vector with the output directory in case you want to
#' only download the files using \code{download_country}. Defaults to your working
#' directory. This will be interpreted as a \strong{directory} and not a path with
#' a file name.
#' 
#' @param format the format from which to download the data. Can either be 'stata',
#' 'spss' or 'sas', with 'stata' as default. When using \code{import_country} the
#' data will be downloaded and read in the \code{format} specified.
#' For \code{download_country}, the data is downloaded from the specified
#' \code{format} (only 'spss' and 'stata' supported, see details).
#'
#' @details
#' Use \code{import_country} to download specified rounds for a given country and
#' import them to R.
#' \code{import_all_cntrounds} will download all rounds for a given country by default
#' and \code{download_country} will download rounds and save them in a specified
#' \code{format} in the supplied directory.
#'
#' The \code{format} argument from \code{import_country} should not matter to the user
#' because the data is read into R either way. However, different formats might have
#' different handling of the encoding of some questions. This option was preserved
#' so that the user
#' can switch between formats if any encoding errors are found in the data. For more
#' details see the dicussion \href{https://github.com/ropensci/essurvey/issues/11}{here}.
#' For this particular argument, 'sas' is not supported because the data formats have
#' changed between ESS waves and separate formats require different functions to be
#' read. To preserve parsimony and format errors between waves, the user should use
#' 'spss' or 'stata'.
#'
#' @return for \code{import_country} if \code{length(rounds)} is 1, it returns a tibble
#' with the latest version of that round. Otherwise it returns a list of \code{length(rounds)}
#' containing the latest version of each round. For \code{download_country}, if 
#' \code{output_dir} is a valid directory, it returns the saved directories invisibly
#' and saves all the rounds in the chosen \code{format} in \code{output_dir}
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' set_email("your_email@email.com")
#' 
#' # Get first three rounds for Denmark
#' dk_three <- import_country("Denmark", 1:3)
#' 
#' # Only download the files, this will return nothing
#' 
#' temp_dir <- tempdir()
#' 
#' download_country(
#'  "Turkey",
#'  rounds = c(2, 4),
#'  output_dir = temp_dir
#' )
#' 
#' # By default, download_country downloads 'stata' files but
#' # you can also download 'spss' or 'sas' files.
#' 
#' download_country(
#'  "Turkey",
#'  rounds = c(2, 4),
#'  output_dir = temp_dir,
#'  format = 'spss'
#' )
#' 
#' # If email is not registered at ESS website, error will arise
#' uk_one <- import_country("United Kingdom", 5, "wrong_email@email.com")
#' # Error in authenticate(ess_email) : 
#' # The email address you provided is not associated with any registered user.
#' # Create an account at http://www.europeansocialsurvey.org/user/new
#' 
#' # If selected rounds don't exist, error will arise
#' 
#' czech_two <- import_country("Czech Republic", c(1, 22))
#' 
#' # Error in ess_country_url(country, rounds) : 
#' # Only rounds ESS1, ESS2, ESS4, ESS5, ESS6, ESS7, ESS8 available
#' # for Czech Republic
#' }
#' 
import_country <- function(country, rounds, ess_email = NULL, format = 'stata') {
  
  if (format == "sas") {
    stop(
      "You cannot read SAS but only 'spss' and 'stata' files with this function. See ?ess_country for more details" # nolint
    )
  }
  
  dir_download <- download_format(rounds = rounds,
                                  country = country,
                                  ess_email = ess_email,
                                  format = format)
  
  all_data <- read_format_data(dir_download, format, rounds)
  
  all_data
}

#' @rdname import_country
#' @export
import_all_cntrounds <- function(country, rounds, ess_email = NULL, format = 'stata') {
  import_country(country, show_country_rounds(country), ess_email, format)
}

#' @rdname import_country
#' @export
download_country <- function(country, rounds, ess_email = NULL,
                             output_dir = getwd(), format = 'stata') {
  invisible(
    download_format(rounds = rounds,
                    country = country,
                    ess_email = ess_email,
                    only_download = TRUE,
                    output_dir = output_dir,
                    format = format)
  )
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
  format_dirs <- list.files(urls,
                            pattern = paste0(format_ext, "$", collapse = "|"),
                            full.names = TRUE)
  
  # Read only the .dta/.sav/ files
  dataset <- lapply(format_dirs, format_read)
  
  # Remove everything that was downloaded
  unlink(urls, recursive = TRUE, force = TRUE)
  
  # If it's only one round, return a df rather than a list
  if (length(rounds) == 1) dataset <- dataset[[1]]
  
  dataset
  
}

