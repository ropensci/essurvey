#' Download all available integrated rounds for a country from the European Social Survey
#'
#' @param country A character of length 1 with the full name of the country. Use show_countries()
#' for a list of available countries.
#' @param your_email a character vector with your email, such as "your_email@email.com".
#' @param output_dir a character vector with the output directory in case you want to only download the files using
#' the \code{only_download} argument. Defaults to the current working directory. Files will be saved
#' as ESS_*/ESS\* where the first star is the country name and the second start the round number. 
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#'
#' @return if \code{only_download} is set to FALSE it returns a list containing the latest
#' version of all available rounds. If \code{only_download} is set to TRUE, it returns nothing but
#' saves all the rounds in .dta format in \code{output_dir} 
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
#' ess_all_cntrounds("Denmark", "your_email@gmail.com", output_dir = "./denmark/", only_download = TRUE)
#' 
#' }
ess_all_cntrounds <- function(country, your_email, output_dir = ".", only_download = FALSE) {

  all_rounds <-
    ess_country(
    country,
    show_country_rounds(country),
    your_email,
    output_dir,
    only_download
  )
  
  all_rounds
}
