#' Recode pre-defined missing values as NA
#' 
#' This function is not needed any more, please see the details section.
#'
#' Data from the European Social Survey is always accompanied by a script
#' that recodes the categories 'Not applicable', 'Refusal', 'Don't Know',
#' 'No answer' and 'Not available' to missing. This function recodes
#' these categories to NA
#'
#' @param ess_data  data frame or \code{\link[tibble]{tibble}} with data from the
#'  European Social Survey. This data frame should come either
#'  from \code{\link{import_rounds}}, \code{\link{import_country}} or read with
#'  \code{\link[haven]{read_dta}} or \code{\link[haven]{read_spss}}. This is the case because it
#'  identifies missing values using \code{\link[haven]{labelled}} classes.
#' @param missing_codes a character vector with values 'Not applicable',
#' 'Refusal', 'Don't Know', 'No answer' or 'Not available'. By default
#' all values are chosen. Note that the wording is case sensitive.
#'
#' @return 
#' The same data frame or \code{\link[tibble]{tibble}} but with values 'Not applicable',
#' 'Refusal', 'Don't Know', 'No answer' and 'Not available' recoded
#' as NA.
#' 
#' @details 
#'
#' The European Social Survey now provides these values recoded automatically
#' in Stata data files. These missing categories are now read as missing values
#' by \code{\link[haven]{read_dta}}, reading the missing categories correctly from Stata.For an example on how these values are coded, see \href{https://github.com/ropensci/essurvey/issues/35}{here}.
#'
#' Old details:
#' 
#' When downloading data directly from the European Social Survey's website,
#' the downloaded .zip file contains a script that recodes some categories
#' as missings in Stata and SPSS formats. 
#' 
#' For recoding numeric variables \code{recode_numeric_missings}
#' uses the labels provided by the \code{\link[haven]{labelled}}
#' class to delete the labels matched in \code{missing_codes}. For the
#' character variables matching is done with the underlying number assigned to
#' each category, namely 6, 7, 8, 9 and 9 for 'Not applicable', Refusal',
#' 'Don't Know', No answer' and 'Not available'.
#' 
#' The functions are a direct translation of the Stata script that comes
#' along when downloading one of the rounds. The Stata script is the same
#' for all rounds and all countries, meaning that these functions work
#' for all rounds.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' seven <- import_rounds(7, your_email)
#' 
#' attr(seven$tvtot, "labels")
#' mean(seven$tvtot, na.rm = TRUE)
#' 
#' names(table(seven$lnghom1))
#' # First three are actually missing values
#' 
#' seven_recoded <- recode_missings(seven)
#' 
#' attr(seven_recoded$tvtot, "labels")
#' # All missings have been removed
#' mean(seven_recoded$tvtot, na.rm = TRUE)
#' 
#' names(table(seven_recoded$lnghom1))
#' # All missings have been removed
#' 
#' # If you want to operate on specific variables
#' # you can use other recode_*_missing 
#' 
#' seven$tvtot <- recode_numeric_missing(seven$tvtot)
#' 
#' # Recode only 'Don't know' and 'No answer' to missing
#' seven$tvpol <- recode_numeric_missing(seven$tvpol, c("Don't know", "No answer"))
#' 
#' 
#' # The same can be done with recode_strings_missing
#' }
#' 
recode_missings <- function(ess_data, missing_codes) {

  stopifnot(is.data.frame(ess_data))
  
  labelled_numerics <- vapply(ess_data, is_labelled_numeric, logical(1))
  character_vars <- vapply(ess_data, is.character, logical(1))
  
  ess_data[labelled_numerics] <- lapply(ess_data[labelled_numerics],
                                        recode_numeric_missing,
                                        missing_codes)
  
  ess_data[character_vars] <- lapply(ess_data[character_vars],
                                     recode_strings_missing,
                                     missing_codes)
  ess_data
}

#' @param x a \code{\link[haven]{labelled}} numeric
#'
#' @rdname recode_missings
#' @export
recode_numeric_missing <- function(x, missing_codes) {
  stopifnot(is_labelled_numeric(x))
    
    if (!missing(missing_codes)) {
      validate_missing_codes(missing_codes)
    } else {
      missing_codes <- .global_vars$all_codes
    }
  
    labels <- attr(x, "labels")
    missings <- names(labels) %in% missing_codes
    attr(x, "labels") <- labels[!missings]
    x[x %in% labels[missings]] <- NA
    x
}

#' @param y a character vector
#' @rdname recode_missings
#' @export
recode_strings_missing <- function(y, missing_codes) {
  stopifnot(is.character(y))
    
    if (!missing(missing_codes)) {
      # Check that all supplied are valid missing codes
      validate_missing_codes(missing_codes)
      # Identify the ones that match
      which_are <- .global_vars$all_codes %in% missing_codes
      # Grab the numeric recode and select unique
      missing_codes <- unique(names(.global_vars$all_codes[which_are]))
    } else {
      missing_codes <- unique(names(.global_vars$all_codes))
    }
    
    values_to_recode <- paste0(missing_codes, collapse = "")
    search_expr <- paste0("^([", values_to_recode,"])\\1{1,}$")
    missings <- grepl(search_expr, y)
    y[missings] <- NA
    y
}

validate_missing_codes <- function(x) {
  available <- x %in% .global_vars$all_codes
  if (!all(available)) {
    stop("Codes not available: ",
         paste0(x[!available], collapse = ", "))
  }
}

is_labelled_numeric <- function(x) {
  haven::is.labelled(x) && is.numeric(x)
}
