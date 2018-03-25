#' Download all available integrated rounds for a country from the European Social Survey
#'
#' This function is deprecated and will be removed in future releases. Use
#' \code{\link{import_all_cntrounds}} instead.
#'
#' @details 
#' If \code{only_download} is set to FALSE, the data will be read in the format specified
#' in \code{format}. 'sas' is not supported because the data formats have changed between
#' ESS waves and separate formats require different functions to be read. To preserve parsimony
#' and format errors between waves, the user should use 'spss' or 'stata'.
#' 
#' @param country A character of length 1 with the full name of the country.
#'  Use \code{\link{show_countries}} for a list of available countries.
#' @param ess_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}. A prefered method is to login
#' through \code{\link{set_email}}.
#' @param only_download whether to only download the files as Stata files. Defaults to FALSE.
#' @param output_dir a character vector with the output directory in case you want to only
#' download the files using the \code{only_download} argument. Defaults to your working directory.
#' Files will be saved as ESS_*/ESS\code{N} where the first star is the country name and \code{N}
#' the round number. This will be interpreted as a \strong{directory} and not a file name. Files names
#' will be used as folder names, such as "./myfile.dta/.
#' 
#' @param format the format from which to download the data. Can either be 'stata', 'spss' or 'sas',
#' with 'stata' as default. When \code{only_download} is set to TRUE, the data will be downloaded in
#' the \code{format} specified. If \code{only_download} is FALSE, the data is downloaded and read
#' from the specified \code{format} (only 'spss' and 'stata' supported, see details).
#' 
#' @return if \code{only_download} is set to FALSE it returns a list of \code{length(rounds)}
#' containing the latest version of each round for the selected country. If \code{only_download}
#' is set to TRUE and \code{output_dir} is a valid directory, it returns the saved directories
#' invisibly and saves all the rounds in the chosen \code{format} in \code{output_dir}
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' set_email("your@email.com")
#' 
#' # Will return all available rounds for Denmark
#' ess_all_cntrounds("Denmark")
#' 
#' # Will download all rounds to the directory stored below
#' # as stata files (set by default) and won't return the rounds
#' # in R.
#' 
#' dl_dir <- file.path(tempdir(), "denmark/")
#' 
#' ess_all_cntrounds(
#' "Denmark",
#'  only_download = TRUE,
#'  output_dir = dl_dir
#'  )
#' 
#' }
ess_all_cntrounds <- function(country, ess_email = NULL, only_download = FALSE,
                              output_dir = getwd(), format = 'stata') {
  .Deprecated("import_all_cntrounds")
  
  ess_country(
    country,
    show_country_rounds(country),
    ess_email,
    only_download,
    output_dir,
    format
  )
}

