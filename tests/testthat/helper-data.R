ess_email <- Sys.getenv("ess_email")

if (skip_on_cran()) {

  # Test for only one round
  round_one <- import_rounds(1, ess_email)
  round_seven <- import_rounds(7, ess_email)

  # Test for only one wave
  wave_one_stata <- import_country("Denmark", 1, ess_email, format = "stata")
  wave_one_spss <- import_country("Denmark", 1, ess_email, format = "spss")

  # Test for all rounds
  rounds <- show_country_rounds("Netherlands")
  all_rounds <- import_country("Netherlands", rounds, ess_email)

  # Test for only one wave SDDF
  sample_round <- sample(show_sddf_cntrounds("Hungary"), 1)
  wave_one_sddf <- import_sddf_country("Hungary", sample_round, ess_email)

  available_rounds <- show_sddf_cntrounds("Spain")

  # Test if downloads all data for Spain and subsets correctly
  expect_message(downloads_spain <-
                   download_sddf_country("Spain",
                                         available_rounds,
                                         ess_email,
                                         output_dir = tempdir(),
                                         format = NULL
                                         ),
                 "All files saved to")

}
