#' Download all available integrated rounds from the European Social Survey
#'
#' @param your_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#' @param output_dir a character vector with the output directory in case you want to only download the files using
#' the \code{only_download} argument. Defaults to the current working directory.
#'
#' @return if \code{only_download} is set to FALSE it returns a list containing the
#' latest version of each round. If \code{only_download} is set to TRUE and
#' output_dir is a valid directory, it returns the saved directories invisibly and saves
#' all the rounds in .dta format in \code{output_dir}
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' 
#' # Will download all rounds and return a list with each one
#' ess_all_rounds("your_email@gmail.com")
#' 
#' # Will download all rounds to directory "./mydownloads/
#' # as .dta files and won't return the rounds in R.
#' ess_all_rounds("your_email@gmail.com", only_download = TRUE, output_dir = "./mydownloads/")
#' } 
#' 
ess_all_rounds <- function(your_email, only_download = FALSE, output_dir = NULL) {
  all_rounds <-
    ess_rounds(
    show_rounds(),
    your_email,
    only_download,
    output_dir
  )
  
  all_rounds
}
