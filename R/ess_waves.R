#' Download integrated waves from the European Social Survey
#'
#' @param waves a numeric vector with the waves to download.
#' @param your_email a character vector with your email, such as "your_email@email.com".
#' @param output_dir a character vector with the output directory in case you want to only download the files using
#' the \code{only_download} argument. Defaults to the current working directory.
#' @param only_download whether want to only download the files as Stata files. Default to FALSE.
#'
#' @return if \code{only_download} is set to FALSE it returns a list of length(waves) containing the latest
#' version of each wave specified in waves. If \code{only_download} is set to TRUE, it returns nothing but
#' saves all the waves in .dta format in \code{output_dir}
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get first three waves
#' three_waves <- ess_waves(1:3, "your_email@email.com")
#' 
#' sapply(three_waves, class)
#' lapply(three_waves, head)
#' 
#' # Only download the files, this will return nothing
#' ess_waves(1:3, "your_email@email.com", output_dir "/users/downloads", only_download = TRUE)
#' 
#' # If repeat waves, only will download unique ones
#' three_waves <- ess_waves(c(1, 1), "your_email@email.com")
#' 
#' # If email is not registered at ESS website, error will arise
#' 
#' three_waves <- ess_waves(c(1, 2), "wrong_email@email.com")
#' 
#' # Error in download_waves_stata(waves, your_email, output_dir) : 
#' # The email address you provided is not associated with any registered user.
#' # Create an account at http://www.europeansocialsurvey.org/user/new
#' 
#' # If waves selected don't exists, error will arise
#' 
#' three_waves <- ess_waves(c(1, 1), "your_email@email.com")
#' 
#' # Error in ess_url(waves) :
#' # ESS round 8 is not a available at http://www.europeansocialsurvey.org/data/round-index.html
#' 
#' }
ess_waves <- function(waves, your_email, output_dir = ".", only_download = FALSE) {
  
  # If user only wants to download, then download and return
  if (only_download) return(invisible(download_waves_stata(waves, your_email, output_dir)))
  
  # If not, download data and save the dir of the downloads
  dir_download <- download_waves_stata(waves, your_email, output_dir)
  
  # Get all .dta paths
  stata_dirs <- list.files(dir_download, pattern = ".dta", full.names = TRUE)
  
  # Read only the .dta file
  dataset <- lapply(stata_dirs, haven::read_dta)
  
  # Remove everything that was downloaded
  unlink(dir_download, recursive = TRUE, force = TRUE)
  
  # return dataset
  dataset
}