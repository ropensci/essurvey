#' Download all available integrated rounds for a country from the European Social Survey
#'
#' @param country A character of length 1 with the full name of the country.
#'  Use \code{\link{show_countries}} for a list of available countries.
#' @param your_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#' @param output_dir a character vector with the output directory in case you want to only
#' download the files using the \code{only_download} argument. Defaults to NULL because data
#' is not saved by default. Files will be saved as ESS_*/ESS\* where the first star is the
#' country name and the second star the round number.
#' 
#' @return if \code{only_download} is set to FALSE it returns a list of \code{length(rounds)}
#' containing the latest version of each round for the selected country. If \code{only_download}
#' is set to TRUE and \code{output_dir} is a validd directory, it returns the saved directories
#' invisibly and saves all the rounds in .dta format in \code{output_dir}
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Will return all available rounds for Denmark
#' ess_all_cntrounds("Denmark", "your_email@gmail.com")
#' 
#' # Will download all rounds to directory "./denmark/
#' # as .dta files and won't return the rounds in R.
#' ess_all_cntrounds(
#' "Denmark",
#' "your_email@gmail.com",
#'  only_download = TRUE,
#'  output_dir = "./denmark/"
#'  )
#' 
#' }
ess_all_cntrounds <- function(country, your_email, only_download = FALSE, output_dir = NULL) {

  all_rounds <-
    ess_country(
    country,
    show_country_rounds(country),
    your_email,
    only_download,
    output_dir
  )
  
  all_rounds
}
