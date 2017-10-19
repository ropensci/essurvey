ess_waves <- function() {
  download_waves_stata()
}

# Read only the .dta file
dataset <- haven::read_dta(list.files(td, pattern = ".dta", full.names = TRUE))

# Remove everything from temporary dir
suppressWarnings(file.remove(list.files(td, full.names = TRUE)))

# return dataset
dataset
