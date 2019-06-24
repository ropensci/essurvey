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
             'por' = haven::read_sav,
             'sav' = haven::read_sav
      )
    format_read(.x)
  })
  
  # Remove everything that was downloaded
  unlink(urls, recursive = TRUE, force = TRUE)
  
  # If it's only one round, return a df rather than a list
  if (length(rounds) == 1) dataset <- dataset[[1]]
  
  dataset
  
}

# Taken from tools::file_ext
file_ext <- function(x) {
  pos <- regexpr("\\.([[:alnum:]]+)$", x)
  ifelse(pos > -1L, substring(x, pos + 1L), "")
}
