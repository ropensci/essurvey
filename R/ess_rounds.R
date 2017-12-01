#' Download integrated rounds from the European Social Survey
#'
#' @param rounds a numeric vector with the rounds to download. See \code{\link{show_rounds}}
#' for all available rounds.
#' @param your_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#' @param output_dir a character vector with the output directory in case you want to only download the files using
#' the \code{only_download} argument. Defaults to NULL because data is not saved by default.
#' @param format the format from which download the data. Can either be 'stata', 'spss' or 'sas',
#' with 'stata' as default. This argument is used only when \code{only_download} is set
#' to TRUE, otherwise it's ignored.
#'
#' @return if \code{only_download} is set to FALSE it returns a list of \code{length(rounds)}
#' containing the latest version of each round. If \code{only_download} is set to TRUE and
#' output_dir is a valid directory, it returns the saved directories invisibly and saves all
#' the rounds in the chosen \code{format} in \code{output_dir}
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get first three rounds
#' three_rounds <- ess_rounds(1:3, "your_email@email.com")
#' 
#' temp_dir <- tempdir()
#' 
#' # Only download the files to output_dir, this will return nothing.
#' ess_rounds(
#'  rounds = 1:3,
#'  your_email = "your_email@email.com",
#'  only_download = TRUE,
#'  output_dir = temp_dir,
#' )
#' 
#' # By default, ess_rounds saves a 'stata' file. You can
#' # also download 'spss' and 'sas' files.
#' 
#' ess_rounds(
#'  rounds = 1:3,
#'  your_email = "your_email@email.com",
#'  only_download = TRUE,
#'  output_dir = temp_dir,
#'  format = 'spss'
#' )
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
#' # Error in ess_round_url(rounds) : 
#' # ESS round 22 is not a available. Check show_rounds()
#' }
ess_rounds <- function(rounds, your_email, only_download = FALSE, output_dir = NULL,
                       format = 'stata') {
  
  if (only_download && is.null(output_dir)) {
    stop(
      "If only_download = TRUE, please provide a directory to save the files in output_dir"
      )
  }
  
  # If user only wants to download, then download and return
  if (only_download) {
    return(
      invisible(download_format(rounds = rounds,
                                your_email = your_email,
                                only_download = only_download,
                                output_dir = output_dir,
                                format = format))
      )
  }
  # If not, download data and save the dir of the downloads
  dir_download <- download_format(rounds = rounds,
                                  your_email = your_email)
  
  # Get all .dta paths
  stata_dirs <- list.files(dir_download, pattern = ".dta", full.names = TRUE)
  
  # Read only the .dta file
  dataset <- lapply(stata_dirs, haven::read_dta)
  
  # Remove everything that was downloaded
  unlink(dir_download, recursive = TRUE, force = TRUE)
  
  # return dataset
  dataset
}
