read_format_data <- function(urls, rounds) {
  
  format_ext <- c(".dta", ".sav", ".por")
  # Get all paths from the format
  format_dirs <- list.files(urls,
                            pattern = paste0(format_ext, "$", collapse = "|"),
                            full.names = TRUE)
  
  # Read only the .dta/.sav/.por files
  dataset <- lapply(format_dirs, function(.x) {
    
    # Use function to read the specified format
    format_read <-
      switch(file_ext(.x),
             'dta' = haven::read_dta,
             'por' = haven::read_por,
             'sav' = haven::read_sav
      )
    
    # Catch potential read errors
    x <- try(format_read(.x), silent = TRUE)
    
    if ("try-error" %in% class(x)) {
      # Ask for a user report
      warning(
        "Some data had to be read with the `foreign` package rather than with ",
        "the `haven` package.\n",
        "Please report the issue at ",
        "https://github.com/ropensci/essurvey/issues"
      )
      # Switch to `foreign`
      foreign_read <-
        switch(file_ext(.x),
               'dta' = foreign::read.dta,
               'por' = read_foreign_spss,
               'sav' = read_foreign_spss
        )
      # Read with `foreign` (should never fail)
      x <- foreign_read(.x)
    }
    
    # Always a return a tibble with lowercase variable names
    tibble::as_tibble(x, .name_repair = tolower)
    
  })
  
  # Remove everything that was downloaded
  unlink(urls, recursive = TRUE, force = TRUE)
  
  # If it's only one round, return a df rather than a list
  if (length(rounds) == 1) dataset <- dataset[[1]]
  
  dataset
  
}

read_foreign_spss <- function(x) {
  foreign::read.spss(x, to.data.frame = TRUE, stringsAsFactors = FALSE)
}

# Taken from tools::file_ext
file_ext <- function(x) {
  pos <- regexpr("\\.([[:alnum:]]+)$", x)
  ifelse(pos > -1L, substring(x, pos + 1L), "")
}
