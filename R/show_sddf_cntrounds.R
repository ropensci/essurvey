#' Return available SDDF rounds for a country in the European Social Survey
#'
#' @param country A character of length 1 with the full name of the country.
#' Use \code{\link{show_countries}} for a list of available countries.
#'
#' @param ess_email a character vector with your email, such as "your_email@email.com".
#' If you haven't registered in the ESS website, create an account at 
#' \url{http://www.europeansocialsurvey.org/user/new}. A preferred method is to login
#' through \code{\link{set_email}}.
#' 
#' @details
#' SDDF data are the equivalent weight data used to analyze the European Social Survey
#' properly. For more information, see the details section of \code{\link{import_sddf_country}}.
#' As an exception to the \code{show_*} family of functions, \code{show_sddf rounds}
#' needs your ESS email to check which rounds are available. Be sure to add it
#' with \code{\link{set_email}}.
#' 
#'
#' @return numeric vector with available rounds for \code{country}
#' @export
#'
#' @examples
#'
#' \dontrun{
#' set_email("your_email@email.com")
#' 
#' show_sddf_cntrounds("Spain")
#' }
#'
show_sddf_cntrounds <- function(country, ess_email = NULL) {
  check_country(country)
  
  # Returns the chosen countries html that contains
  # the links to all rounds.
  country_round_html <- extract_country_html(country,
                                             .global_vars$country_index)
  
  # Go deeper in the node to grab that countries url to the rounds
  country_node <- xml2::xml_find_all(country_round_html, "//ul //li //a")
  
  # Here we have all href from the website
  country_href <- xml2::xml_attrs(country_node, "href")
  
  incomplete_links <-
    sort(
      grep("^/download.html\\?file=ESS[0-9]{1,}_[A-Z]{1,2}_SDDF(.*)[0-9]{4, }$",
           country_href,
           value = TRUE)
    )
  
  # Extract round numbers
  early_rounds <-
    as.numeric(
      string_extract(incomplete_links, "[0-9]{1,2}")
    )

  # Extracting late rounds
  all_rounds <- show_rounds()
  late_rounds <- all_rounds[all_rounds > 6]

  url_download <- grab_url_sddf_late_rounds(late_rounds, format = NULL)

  # Here I thought I might've introduced a bug because
  # if I run show_sddf_cntrounds("Spain") and then
  # show_sddf_cntrounds("Italy") then I thought that
  # because the sddf_laterounds_dir was already created and existed
  # for Spain, it WON'T download the data files for Italy. The thing
  # is that it doesn't matter because late rounds are integrated for
  # all countries, so I just reread the Spanish downloaded one
  # and filter for ITALY.
  if (!all(dir.exists(.global_vars$sddf_laterounds_dir))) {

    utils::capture.output(
      dir_downloads <-
        suppress_all(
          download_format(urls = url_download,
                          ess_email = ess_email,
                          only_download = TRUE,
                          output_dir = file.path(tempdir(), "ESS_SDDF"))
        ),
      file = tempfile()
    )

    .global_vars$sddf_laterounds_dir <- dir_downloads
  }

  late_data <-
    suppress_all(
      read_sddf_data(.global_vars$sddf_laterounds_dir,
                     country)
    )

  nrow_data <- vapply(late_data, nrow, FUN.VALUE = numeric(1))

  c(early_rounds, late_rounds[nrow_data > 0])
}
