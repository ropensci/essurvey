read_format_data <- function(dir_download, rounds) {
  
  format_ext <- c(".dta", ".sav", ".por")
  # Get all paths from the format
  format_dirs <- list.files(dir_download,
                            pattern = paste0(format_ext, "$", collapse = "|"),
                            full.names = TRUE)
  
  # Read only the .dta/.sav/.por files
  dataset <- lapply(format_dirs, function(.x) {
    
    # Use function to read the specified format
    format_read <-
      switch(file_ext(.x),
             "dta" = haven::read_dta,
             "por" = haven::read_sav,
             "sav" = haven::read_sav
      )

    # Catch potential read errors
    # Reading some data such as SDDF data for France round 1 was
    # raising the message "Invalid time string (length=8): 0-------"
    # coming directly from Rcpp (https://github.com/WizardMac/ReadStat/search?q=Invalid+time+string&unscoped_q=Invalid+time+string) #nolintr
    # capture.output redirects the message to a tmpfile.
    utils::capture.output(dt <- try(format_read(.x), silent = TRUE),
                          file = tempfile())

    if ("try-error" %in% class(dt)) {

      if (!is_foreign_installed()) {
        stop("Package `foreign` is needed to read some SDDF data. Please install with install.packages(\"foreign\")") #nolintr
      }

      # Identify country + round for message
      # Match everything from _ to the first dash to extract the country name
      cnt <- string_extract(.x, "_.+?(?=\\/)", perl = TRUE)
      round_search <- basename(.x)
      rnd <- string_extract(round_search, "\\d", perl = TRUE)

      # Ask for a user report
      warning(
        paste("Round", rnd, "for", gsub("_", "", cnt),
              "was read with the `foreign` package rather than with ",
              "the `haven` package for compatibility reasons.\n",
              "Please report any issues at",
              "https://github.com/ropensci/essurvey/issues"
              ),
        call. = FALSE
      )

      # Switch to `foreign`
      foreign_read <-
        switch(file_ext(.x),
               "dta" = foreign::read.dta,
               "por" = read_foreign_spss,
               "sav" = read_foreign_spss
               )
      # Read with `foreign` (should never fail)
      dt <- suppress_all(foreign_read(.x))
    }

    # Always a return a tibble with lowercase variable names
    tibble::as_tibble(dt, .name_repair = tolower)
    
  })
  
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


is_foreign_installed <- function() {
  requireNamespace("foreign", quietly = TRUE)
}

suppress_all <- function(x) suppressMessages(suppressWarnings(x))

string_extract <- function(string, pattern, ...) {
  regmatches(string, regexpr(pattern, string, ...))
}
