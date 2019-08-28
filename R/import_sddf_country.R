#' Download SDDF data by round for countries from the European Social Survey
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
#'
#' SDDF data (Sample Design Data Files) are data sets that contain additional columns with the
#' sample design and weights for a given country in a given rounds. These additional columns are
#' required to perform any weighted analysis of the ESS data. Users interested in using this data
#' should read the description of SDDF files \href{http://www.europeansocialsurvey.org/methodology/ess_methodology/sampling.html}{here}
#' and should read \href{http://www.europeansocialsurvey.org/data/download_sample_data.html}{here} for the
#' sampling design of the country of analysis for that specific round.
#'
#' Use \code{import_sddf_country} to download the SDDF data by country into R.
#' \code{import_all_sddf_cntrounds} will download all available SDDF data for a given country by
#' default and \code{download_sddf_country} will download SDDF data and save them in a specified
#' \code{format} in the supplied directory.
#'
#' The \code{format} argument from \code{import_country} should not matter to the user
#' because the data is read into R either way. However, different formats might have
#' different handling of the encoding of some questions. This option was preserved
#' so that the user can switch between formats if any encoding errors are found in the data. For more
#' details see the discussion \href{https://github.com/ropensci/essurvey/issues/11}{here}.
#' 
#' Given that the SDDF data is not very complete, some countries do not have SDDF data
#' in Stata or SPSS. For that reason, the \code{format} argument is not used in \code{import_sddf_country}.
#' Internally, \code{Stata} is chosen over \code{SPSS} and \code{SPSS} over \code{SAS} in that
#' order of preference.
#' 
#' For this particular argument, 'sas' is not supported because the data formats have
#' changed between ESS waves and separate formats require different functions to be
#' read. To preserve parsimony and format errors between waves, the user should use
#' 'stata' or 'spss'.
#'
#' Starting from round 7 (including), the ESS switched the layout of SDDF data.
#' Before the rounds, SDDF data was published separately by wave-country
#' combination. From round 7 onwards, all SDDF data is released as a single
#' integrated file with all countries combined. \code{import_sddf_country}
#' takes care of this nuance by reading the data and filtering the chosen
#' country. \code{download_sddf_country} downloads the raw file but also
#' reads in memory to subset the specific country requested. This shouldn't
#' raise any problems but beware that reading/writing the data might delete
#' some properties such as wrongly saved labels. For this reason, 'sas' format
#' is not supported for this specific function.
#'
#' @return for \code{import_sddf_country} if \code{length(rounds)} is 1, it returns a tibble with
#' the latest version of that round. Otherwise it returns a list of \code{length(rounds)}
#' containing the latest version of each round. For \code{download_sddf_country}, if
#' \code{output_dir} is a valid directory, it returns the saved directories invisibly and saves
#' all the rounds in the chosen \code{format} in \code{output_dir}
#'
#' @export
#' @examples
#' \dontrun{
#' 
#' set_email("your_email@email.com")
#' 
#' # Get first three rounds for Denmark
#' sp_three <- import_sddf_country("Spain", 5:6)
#' 
#' # For now, only SDDF files from rounds 1:6 are implemented in the package
#' show_sddf_rounds("Spain")
#' 
#' # Only download the files, this will return nothing
#' 
#' temp_dir <- tempdir()
#' 
#' download_sddf_country(
#'  "Spain",
#'  rounds = 5:6,
#'  output_dir = temp_dir
#' )
#' 
#' # By default, download_sddf_country downloads 'stata' files but
#' # you can also download 'spss' or 'sas' files.
#' 
#' download_country(
#'  "Spain",
#'  rounds = 5:6,
#'  output_dir = temp_dir,
#'  format = 'spss'
#' )
#' 
#' }
#' 
import_sddf_country <- function(country, rounds, ess_email = NULL, format = NULL) {

  stopifnot(is.character(country), length(country) > 0)
  stopifnot(is.numeric(rounds), length(rounds) > 0)
  
  if (!is.null(format) && format == "sas") {
    stop(
      "You cannot read SAS but only 'spss' and 'stata' files with this function. See ?import_rounds for more details") # nolint
  }

  late_rounds <- rounds > 6
  
  if (any(late_rounds)) {

    urls <- c(country_url_sddf(country, rounds[!late_rounds], format),
              country_url_sddf_late_rounds(country, rounds[late_rounds], format)
              )
  } else {

    urls <- country_url_sddf(country, rounds, format)

  }

  
  dir_download <- download_format(country = country,
                                  urls = urls,
                                  ess_email = ess_email)
  
  all_data <- read_format_data(dir_download, rounds)
  # Remove everything that was downloaded
  unlink(dir_download, recursive = TRUE, force = TRUE)

  if (any(late_rounds)) {
    # Search for the 2 letter code because we need to subset
    # from the integrated SDDF for the current country
    country_code <- country_lookup[country]

    # Subset the selected country from the integrated late rounds
    all_data <- lapply(all_data, function(x) x[x$cntry == country_code, ])
  }

  all_data
}

#' @rdname import_sddf_country
#' @export
import_all_sddf_cntrounds <- function(country,
                                      ess_email = NULL,
                                      format = NULL) {
  import_sddf_country(
    country,
    show_sddf_rounds(country),
    ess_email,
    format = format
  )
}

#' @rdname import_sddf_country
#' @export
download_sddf_country <- function(country,
                                  rounds,
                                  ess_email = NULL,
                                  output_dir = getwd(),
                                  format = "stata") {

  stopifnot(is.character(country), length(country) > 0)
  stopifnot(is.numeric(rounds), length(rounds) > 0)

  if (!is.null(format) && format == "sas") {
    stop(
      "You cannot read SAS but only 'spss' and 'stata' files with this function. See ?download_sddf_country for more details") # nolint
  }


  late_rounds <- rounds > 6
  
  if (any(late_rounds)) {

    urls <- c(country_url_sddf(country, rounds[!late_rounds], format),
              country_url_sddf_late_rounds(country, rounds[late_rounds], format)
              )
  } else {

    urls <- country_url_sddf(country, rounds, format)

  }

  
  invisible(
    dir_download <-
      download_format(urls = urls,
                      country = country,
                      ess_email = ess_email,
                      only_download = TRUE,
                      output_dir = output_dir)
  )

  ## if (any(late_rounds)) {

  ##   downloaded_rounds <-
  ##     as.numeric(
  ##       gsub(
  ##         "ESS",
  ##         "",
  ##         stringr::str_extract(dir_download, "ESS[0-9]{1,}")
  ##       )
  ##     )

  ##   new_late_rounds <- downloaded_rounds > 6

  ##   all_data <-
  ##     suppress_all(
  ##       read_format_data(dir_download[new_late_rounds], rounds[late_rounds])
  ##     )

  ## # Search for the 2 letter code because we need to subset
  ## # from the integrated SDDF for the current country
  ## country_code <- country_lookup[country]

  ## # Subset the selected country from the integrated late rounds
  ## all_data <- lapply(all_data, function(x) x[x$cntry == country_code, ])

  ## format_ext <- c(".dta", ".sav", ".por")
  ## # Get all paths from the format
  ## format_dirs <- list.files(dir_download[new_late_rounds],
  ##                           pattern = paste0(format_ext, "$", collapse = "|"),
  ##                           full.names = TRUE)
  
  ## # Read only the .dta/.sav/.por files
  ## dataset <- lapply(format_dirs, function(.x) {
  
  ##   # Use function to read the specified format
  ##   format_read <-
  ##     switch(file_ext(.x),
  ##            "dta" = haven::read_dta,
  ##            "por" = haven::read_sav,
  ##            "sav" = haven::read_sav
  ##            )


}
