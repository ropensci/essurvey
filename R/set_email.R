#' Save your ESS email as an environment variable
#'
#' @param ess_email a character string with your registered email.
#'
#' @details You should only run \code{set_email()} once and every \code{ess_*} function
#' should work fine. Make sure your email is registered at 
#' \url{http://www.europeansocialsurvey.org/} before setting the email.
#' 
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' set_email("my_registered@email.com")
#' 
#' ess_country(1)
#' }
#' 
set_email <- function(ess_email) {
  if (Sys.getenv("ESS_EMAIL") == "") {
    Sys.setenv("ESS_EMAIL" = ess_email)
  }
}

get_email <- function() {
  ess_email <- Sys.getenv("ESS_EMAIL")
  if (ess_email == "") {
    stop("No email account set as environment variable. Use set_email to set your email.")
  }
  ess_email
}

