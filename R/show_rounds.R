#' Helper function to return available rounds in the European Social Survey
#'
#' @return numeric vector with available rounds
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' 
#' show_rounds()
#' 
#' }
show_rounds <- function() {
  incomplete_links <- grab_rounds_link()
  
  # extract ESS* part to detect dupliacted
  ess_prefix <- sort(stringr::str_extract(incomplete_links, "ESS[:digit:]"))
  
  # extract only the digit
  unique_rounds_available <- unique(stringr::str_extract(ess_prefix, "[:digit:]"))
  
  as.numeric(unique_rounds_available)
}
