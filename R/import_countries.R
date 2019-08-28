#' Download integrated rounds separately for countries from the European Social
#' Survey
#'
#' @param country a character of length 1 with the full name of the country. 
#' Use \code{\link{show_countries}} for a list of available countries.
#' @param rounds a numeric vector with the rounds to download. See \code{\link{show_rounds}}
#' for all available rounds.
#' @param ess_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}. A preferred method is to login
#' through \code{\link{set_email}}.
#' 
#' @param output_dir a character vector with the output directory in case you want to
#' only download the files using \code{download_country}. Defaults to your working
#' directory. This will be interpreted as a \strong{directory} and not a path with
#' a file name.
#' 
#' @param format the format from which to download the data. By default it is NULL for \code{import_*} functions and tries to read 'stata', 'spss' and 'sas' in the specific order. This can be useful if some countries don't have a particular format available.  Alternatively, the user can specify the format which can either be 'stata', 'spss' or 'sas'. For the \code{download_*} functions it is set to 'stata' because the format should be specificied down the download. When using \code{import_country} the data will be downloaded and read in the \code{format} specified. For \code{download_country}, the data is downloaded from the specified \code{format} (only 'spss' and 'stata' supported, see details).
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
#' details see the discussion \href{https://github.com/ropensci/essurvey/issues/11}{here}.
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
#' # Error in country_url(country, rounds) : 
#' # Only rounds ESS1, ESS2, ESS4, ESS5, ESS6, ESS7, ESS8 available
#' # for Czech Republic
#' }
#' 
import_country <- function(country, rounds, ess_email = NULL, format = NULL) {

  stopifnot(is.character(country), length(country) > 0)
  stopifnot(is.numeric(rounds), length(rounds) > 0)

  if (!is.null(format) && format == "sas") {
    stop(
      "You cannot read SAS but only 'spss' and 'stata' files with this function. See ?import_country for more details" # nolint
    )
  }
  
  urls <- country_url(country, rounds, format = format)
  
  dir_download <- download_format(country = country,
                                  urls,
                                  ess_email = ess_email)
  
  all_data <- read_format_data(dir_download)
  # Remove everything that was downloaded
  unlink(dir_download, recursive = TRUE, force = TRUE)
  
  all_data
}

#' @rdname import_country
#' @export
import_all_cntrounds <- function(country, ess_email = NULL, format = NULL) {
  import_country(country, show_country_rounds(country), ess_email, format)
}

#' @rdname import_country
#' @export
download_country <- function(country, rounds, ess_email = NULL,
                             output_dir = getwd(), format = 'stata') {

  stopifnot(is.character(country), length(country) > 0)
  stopifnot(is.numeric(rounds), length(rounds) > 0)
  
  urls <- country_url(country, rounds, format = format)
  
  invisible(
    download_format(country = country,
                    urls = urls,
                    ess_email = ess_email,
                    only_download = TRUE,
                    output_dir = output_dir)
  )
}
