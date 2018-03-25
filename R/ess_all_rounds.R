#' Download all available integrated rounds from the European Social Survey
#' 
#' #' This function is deprecated and will be removed in future releases. Use
#' \code{\link{import_all_rounds}} instead.
#'
#' @details 
#' If \code{only_download} is set to FALSE, the data will be read in the format specified
#' in \code{format}. 'sas' is not supported because the data formats have changed between
#' ESS waves and separate formats require different functions to be read. To preserve parsimony
#' and format errors between waves, the user should use 'spss' or 'stata'.
#' 
#' @param ess_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}. A prefered method is to login
#' through \code{\link{set_email}}.
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#' @param output_dir a character vector with the output directory in case you want to only download the files using
#' the \code{only_download} argument. Defaults to your working directory.
#' This will be interpreted as a \strong{directory} and not a file name. Files names
#' will be used as folder names, such as "./myfile.dta/.
#' 
#' @param format the format from which to download the data. Can either be 'stata', 'spss' or 'sas',
#' with 'stata' as default. When \code{only_download} is set to TRUE, the data will be downloaded in
#' the \code{format} specified. If \code{only_download} is FALSE, the data is downloaded and read
#' from the specified \code{format} (only 'spss' and 'stata' supported, see details).
#' 
#'
#' @return if \code{only_download} is set to FALSE it returns a list with all the latest rounds.
#' If \code{only_download} is set to TRUE and output_dir is a valid directory, it returns the
#' saved directories invisibly and saves all the rounds in the chosen \code{format} in
#' \code{output_dir}
#' 
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' 
#' set_email("your@email.com")
#' 
#' # Will download all rounds and return a list with each one
#' ess_all_rounds()
#' 
#' # Will download all rounds to the directory below
#' # as .dta files and won't return the rounds in R.
#' 
#' dl_dir <- file.path(tempdir(), "mydownloads")
#' 
#' ess_all_rounds(only_download = TRUE, output_dir = dl_dir)
#' }
#' 
ess_all_rounds <- function(ess_email = NULL, only_download = FALSE,
                           output_dir = getwd(), format = 'stata') {
  .Deprecated("import_all_rounds")
    ess_rounds(
    show_rounds(),
    ess_email,
    only_download,
    output_dir,
    format
  )
  
}
