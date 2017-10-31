#' Download all available integrated rounds from the European Social Survey
#'
#' @param your_email a character vector with your email, such as "your_email@email.com".
#' @param output_dir a character vector with the output directory in case you want to only download the files using
#' the \code{only_download} argument. Defaults to the current working directory.
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#'
#' @return if \code{only_download} is set to FALSE it returns a list of length(rounds) containing the latest
#' version of each round. If \code{only_download} is set to TRUE, it returns nothing but
#' saves all the rounds in .dta format in \code{output_dir}
#'
#' @return if \code{only_download} is set to FALSE it returns a list containing the latest
#' version of all available rounds. If \code{only_download} is set to TRUE, it returns nothing but
#' saves all the rounds in .dta format in \code{output_dir}
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' 
#' # Will download all waves and return a list with each one
#' ess_all_rounds("your_email@gmail.com")
#' 
#' # Will download all waves to directory "./mydownloads/
#' # as .dta files and won't return the rounds in R.
#' ess_all_rounds("your_email@gmail.com", output_dir = "./mydownloads/", only_download = TRUE)
#' } 
#' 
ess_all_rounds <- function(your_email, output_dir = ".", only_download = FALSE) {
  all_rounds <-
    ess_rounds(
    show_waves(),
    your_email,
    output_dir,
    only_download
  )
  
  all_rounds
}
