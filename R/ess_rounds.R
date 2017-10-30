#' Download integrated rounds from the European Social Survey
#'
#' @param rounds a numeric vector with the rounds to download.
#' @param your_email a character vector with your email, such as "your_email@email.com".
#' @param output_dir a character vector with the output directory in case you want to only download the files using
#' the \code{only_download} argument. Defaults to the current working directory.
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#'
#' @return if \code{only_download} is set to FALSE it returns a list of length(rounds) containing the latest
#' version of each round. If \code{only_download} is set to TRUE, it returns nothing but
#' saves all the rounds in .dta format in \code{output_dir}
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get first three rounds
#' three_rounds <- ess_rounds(1:3, "your_email@email.com")
#' 
#' # Only download the files, this will return nothing
#' ess_rounds(
#'  rounds = 1:3,
#'  your_email = "your_email@email.com",
#'  output_dir = ".",
#'  only_download = TRUE
#')
#' 
#' # If rounds are repeated, will download only unique ones
#' two_rounds <- ess_rounds(c(1, 1), "your_email@email.com")
#' 
#' # If email is not registered at ESS website, error will arise
#' 
#' two_rounds <- ess_rounds(c(1, 2), "wrong_email@email.com")
#' 
#' # Error in download_rounds_stata(rounds, your_email, output_dir) : 
#' # The email address you provided is not associated with any registered user.
#' # Create an account at http://www.europeansocialsurvey.org/user/new
#' 
#' # If selected rounds don't exist, error will arise
#' 
#' two_rounds <- ess_rounds(c(1, 22), "your_email@email.com")
#' 
#' # Error in ess_url(rounds) :
#' # ESS round 22 is not a available at
#' # http://www.europeansocialsurvey.org/data/round-index.html
#' 
#' }
ess_rounds <- function(rounds, your_email, output_dir = ".", only_download = FALSE) {
  
  # If user only wants to download, then download and return
  if (only_download) {
    return(
      invisible(download_rounds_stata(rounds, your_email, output_dir, only_download))
      )
  }
  # If not, download data and save the dir of the downloads
  dir_download <- download_rounds_stata(rounds, your_email, output_dir)
  
  # Get all .dta paths
  stata_dirs <- list.files(dir_download, pattern = ".dta", full.names = TRUE)
  
  # Read only the .dta file
  dataset <- lapply(stata_dirs, haven::read_dta)
  
  # Remove everything that was downloaded
  unlink(dir_download, recursive = TRUE, force = TRUE)
  
  # return dataset
  dataset
}