context("test-recode_missings.R")

ess_email <- Sys.getenv("ess_email")


test_that("recoded object is a df", {
  skip_on_cran()
  
  recode_esp <- recode_missings(import_rounds(7, ess_email))
  expect_is(recode_esp, "data.frame")
})

test_that("recode_missing correctly recodes chr na's", {
  skip_on_cran()
  
  recode_esp <- recode_missings(import_rounds(7, ess_email))
  
  chrs <- vapply(recode_esp, is.character, logical(1))
  
  chr_miss <- vapply(recode_esp[chrs], function(.x) sum(is.na(.x)), numeric(1))
  
  # These are the missing values taken from running this script
  # in stata. This is only for comparison.
  stata_chr_missings <- c(name = 0,
                          edition = 0,
                          proddate = 0,
                          cntry = 0,
                          ctzshipc = 38249,
                          cntbrthc = 35876,
                          lnghom1 = 310,
                          lnghom2 = 2363,
                          fbrncntb = 33534,
                          mbrncntb = 33789,
                          region = 3)
  
  expect_equal(chr_miss, stata_chr_missings)
})

test_that("recoding_mising correctly recodes numeric na's", {
  skip_on_cran()
  
  recode_esp <- recode_missings(import_rounds(7, ess_email))
  num_miss <- vapply(recode_esp[c("tvtot", "agea", "vote")],
                     function(x) sum(is.na(x)), numeric(1))
  
  stata_num_missings <- c(tvtot = 74,
                          agea = 99,
                          vote = 328)
  
  expect_equal(num_miss, stata_num_missings)
})

test_that("recoding_missing recodes cutomized labels", {
  skip_on_cran()
  
  esp <- import_rounds(7, ess_email)
  recode_esp <- recode_missings(esp)
  
  remove_labels <- c("Don't know", "Not available")
  equivalent_codes <- c("888", "999") # for strings!
  
  custom_esp <- recode_missings(esp, remove_labels)
  
  # For numeric variables
  removed <- all(!remove_labels %in% names(attr(custom_esp$tvtot, "labels")))
  expect_true(removed)
  
  # For character variables
  removed <- all(!equivalent_codes %in% names(table(custom_esp$lnghom1)))
  expect_true(removed)
})

test_that("recode_numeric can recode customized labels", {
  all_codes <- .global_vars$all_codes
  
  skip_on_cran()
  
  esp <- import_rounds(7, ess_email)

  removed_miss <- names(attr(recode_numeric_missing(esp$tvtot), "labels"))
  
  # All codes were removed
  expect_true(all(!all_codes %in% removed_miss))

  act_labels <- attr(recode_numeric_missing(esp$tvtot, c("Don't know")),
                     "labels")
  
  expect_true(!"Don't know" %in% names(act_labels))
  
  expect_error(
    recode_numeric_missing(esp$tvtot, c("Hey", "Don't know")),
    "Codes not available: Hey"
  )
  
  expect_error(
    recode_numeric_missing(esp$tvtot, c("Hey", "Another", "Don't know")),
    "Codes not available: Hey, Another"
  )
})

test_that("recode_strings can recode customized labels", {
  all_codes <- .global_vars$all_codes
  
  skip_on_cran()
  
  esp <- import_rounds(7, ess_email)
  
  # 777, 888, 999
  removed_miss <-
    c("777", "888", "999") %in%
    names(table(recode_strings_missing(esp$lnghom1)))
  
  # All codes were removed
  expect_true(!all(removed_miss))
  
  ### Remove 'Don't know: 888
  remove_dk <- recode_strings_missing(esp$lnghom1, "Don't know")
  removed_miss <-
    "888" %in%
    names(table(remove_dk))
  
  expect_true(!all(removed_miss))
  
  kept_miss <-
    c("777", "999") %in%
    names(table(remove_dk))
  
  expect_true(all(kept_miss))
  
  expect_error(
    recode_strings_missing(esp$lnghom1, c("Hey", "Don't know")),
    "Codes not available: Hey"
  )
  
  expect_error(
    recode_strings_missing(esp$lnghom1, c("Hey", "Another", "Don't know")),
    "Codes not available: Hey, Another"
  )
})

