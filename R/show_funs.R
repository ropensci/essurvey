#' Return available rounds in the European Social Survey
#'
#' @return numeric vector with available rounds
#' @export
#'
#' @examples
#'
#' \dontrun{
#' show_rounds()
#' }
#' 
#' 
show_rounds <- function() {
  incomplete_links <- get_rounds_link(.global_vars$ess_website)
  
  # extract ESS* part to detect dupliacted
  ess_prefix <- sort(string_extract(incomplete_links,
                                    "ESS[[:digit:]]"))
                     
  
  # extract only the digit
  unique_rounds_available <- unique(string_extract(ess_prefix,
                                                   "[[:digit:]]"))
                       
  as.numeric(unique_rounds_available)
}


#' Return available countries in the European Social Survey
#'
#' @return character vector with available countries
#' @export
#'
#' @examples
#'
#' \dontrun{
#' show_countries()
#' }
#' 
#' 
show_countries <- function() {
  show_any(.global_vars$ess_website, .global_vars$country_index)
}

#' Return available themes in the European Social Survey
#' 
#' This function returns the available themes in the European Social Survey.
#' However, contrary to \code{\link{show_countries}} and \code{\link{show_country_rounds}},
#' themes can not be downloaded as separate datasets. This and
#' \code{\link{show_theme_rounds}} serve purely for informative purposes.
#'
#' @return character vector with available themes
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' show_themes()
#' }
#' 
show_themes <- function() {
  show_any(.global_vars$ess_website, .global_vars$theme_index)
}


# General function to show_* any index.

show_any <- function(ess_website, module_index) { # nocov start
  
  module_table <- table_to_list(ess_website, module_index)

  names(module_table)
} # nocov end

# Here I define an environment to hold the ess_website vector
# because it's a variable I'll use in nearly all functions to
# access the website
.global_vars <- new.env(parent = emptyenv())

var_names <- c(
  "ess_website",
  "path_login",
  "theme_index",
  "country_index",
  "sddf_index",
  "sddf_laterounds_dir",
  "all_codes"
)

codes <- c("6" = "Not applicable",
           "7" = "Refusal",
           "8" = "Don't know",
           "9" = "No answer",
           "9" = "Not available")

var_values <-
  list(
  "https://www.europeansocialsurvey.org",
  "/user/login",
  "/data/module-index.html",
  "/data/country_index.html",
  "/data/download_sample_data.html",
  "",
  codes
)

mapply(assign, var_names, var_values, list(envir = .global_vars))

# At some point I also added the show_* funs here so that I only ran them once
# and then I called .global_vars$ with the result of the show_ fun. I removed it
# because if a user called show_countries() in a script and later called
# an import_ fun that uses the show_countries() that was called from .global_vars$countries
# and if ess updated countries or rounds in that time then the result would be different
# and we wouldn't want contradictory results.


# Copied this from countrycode::codelist
country_lookup <- c(Afghanistan = "AF",
                    Albania = "AL",
                    Algeria = "DZ",
                    `American Samoa` = "AS",
                    Andorra = "AD",
                    Angola = "AO", 
                    Anguilla = "AI",
                    Antarctica = "AQ",
                    `Antigua & Barbuda` = "AG", 
                    Argentina = "AR",
                    Armenia = "AM",
                    Aruba = "AW",
                    Australia = "AU",
                    Austria = "AT",
                    `Austria-Hungary` = NA,
                    Azerbaijan = "AZ",
                    Baden = NA,
                    Bahamas = "BS",
                    Bahrain = "BH",
                    Bangladesh = "BD",
                    Barbados = "BB",
                    Bavaria = NA,
                    Belarus = "BY",
                    Belgium = "BE",
                    Belize = "BZ", 
                    Benin = "BJ",
                    Bermuda = "BM",
                    Bhutan = "BT",
                    Bolivia = "BO",
                    `Caribbean Netherlands` = "BQ",
                    `Bosnia & Herzegovina` = "BA",
                    Botswana = "BW",
                    `Bouvet Island` = "BV",
                    Brazil = "BR",
                    `British Indian Ocean Territory` = "IO",
                    Brunei = "BN",
                    Brunswick = NA,
                    Bulgaria = "BG",
                    `Burkina Faso` = "BF",
                    Burundi = "BI",
                    `Cape Verde` = "CV",
                    Cambodia = "KH",
                    Cameroon = "CM",
                    Canada = "CA",
                    `Cayman Islands` = "KY",
                    `Central African Republic` = "CF",
                    Chad = "TD",
                    `Channel Islands` = NA,
                    Chile = "CL",
                    China = "CN",
                    `Christmas Island` = "CX",
                    `Cocos (Keeling) Islands` = "CC",
                    Colombia = "CO",
                    Comoros = "KM",
                    `Congo - Brazzaville` = "CG",
                    `Cook Islands` = "CK",
                    `Costa Rica` = "CR",
                    Croatia = "HR",
                    Cuba = "CU",
                    Cyprus = "CY",
                    Czechia = "CZ",
                    Czechoslovakia = NA,
                    `North Korea` = "KP",
                    Denmark = "DK",
                    Djibouti = "DJ",
                    Dominica = "DM",
                    `Dominican Republic` = "DO",
                    Ecuador = "EC",
                    Egypt = "EG",
                    `El Salvador` = "SV",
                    `Equatorial Guinea` = "GQ",
                    Eritrea = "ER",
                    Estonia = "EE",
                    Ethiopia = "ET",
                    `Falkland Islands` = "FK",
                    `Faroe Islands` = "FO",
                    Fiji = "FJ",
                    Finland = "FI",
                    France = "FR",
                    `French Guiana` = "GF",
                    `French Polynesia` = "PF",
                    `French Southern Territories` = "TF",
                    Gabon = "GA",
                    Gambia = "GM",
                    Georgia = "GE",
                    Germany = "DE",
                    Ghana = "GH",
                    Gibraltar = "GI",
                    Greece = "GR",
                    Greenland = "GL",
                    Grenada = "GD",
                    Guadeloupe = "GP",
                    Guam = "GU",
                    Guatemala = "GT",
                    Guernsey = "GG",
                    Guinea = "GN",
                    `Guinea-Bissau` = "GW",
                    Guyana = "GY",
                    Haiti = "HT",
                    Hamburg = NA,
                    Hanover = NA,
                    `Heard & McDonald Islands` = "HM",
                    `Hesse Electoral` = NA,
                    `Hesse Grand Ducal` = NA,
                    `Vatican City` = "VA",
                    Honduras = "HN",
                    `Hong Kong SAR China` = "HK",
                    Hungary = "HU",
                    Iceland = "IS",
                    India = "IN",
                    Indonesia = "ID",
                    Iran = "IR",
                    Iraq = "IQ",
                    Ireland = "IE",
                    `Isle of Man` = "IM",
                    Israel = "IL",
                    Italy = "IT",
                    Jamaica = "JM",
                    Japan = "JP",
                    Jersey = "JE",
                    Jordan = "JO",
                    Kazakhstan = "KZ",
                    Kenya = "KE",
                    Kiribati = "KI",
                    Kosovo = "XK",
                    Kuwait = "KW",
                    Kyrgyzstan = "KG",
                    Laos = "LA",
                    Latvia = "LV",
                    Lebanon = "LB",
                    Lesotho = "LS",
                    Liberia = "LR",
                    Libya = "LY",
                    Liechtenstein = "LI",
                    Lithuania = "LT",
                    Luxembourg = "LU",
                    `Macau SAR China` = "MO",
                    Madagascar = "MG",
                    Malawi = "MW",
                    Malaysia = "MY",
                    Maldives = "MV",
                    Mali = "ML",
                    Malta = "MT",
                    `Marshall Islands` = "MH",
                    Martinique = "MQ",
                    Mauritania = "MR",
                    Mauritius = "MU",
                    Mayotte = "YT",
                    `Mecklenburg Schwerin` = NA,
                    Mexico = "MX",
                    Modena = NA,
                    Monaco = "MC",
                    Mongolia = "MN",
                    Montenegro = "ME",
                    Montserrat = "MS",
                    Morocco = "MA",
                    Mozambique = "MZ",
                    `Myanmar (Burma)` = "MM",
                    Namibia = "NA",
                    Nassau = NA,
                    Nauru = "NR",
                    Nepal = "NP",
                    Netherlands = "NL",
                    `Netherlands Antilles` = NA,
                    `New Caledonia` = "NC",
                    `New Zealand` = "NZ",
                    Nicaragua = "NI",
                    Niger = "NE",
                    Nigeria = "NG",
                    Niue = "NU",
                    `Norfolk Island` = "NF",
                    `Northern Mariana Islands` = "MP",
                    Norway = "NO",
                    Oldenburg = NA,
                    Oman = "OM",
                    Pakistan = "PK",
                    Palau = "PW",
                    `Palestinian Territories` = "PS",
                    Panama = "PA",
                    `Papua New Guinea` = "PG",
                    Paraguay = "PY",
                    Parma = NA,
                    Peru = "PE",
                    Philippines = "PH",
                    `Pitcairn Islands` = "PN",
                    Poland = "PL",
                    Portugal = "PT",
                    `Puerto Rico` = "PR",
                    Qatar = "QA",
                    `South Korea` = "KR",
                    Moldova = "MD",
                    Romania = "RO",
                    `Russian Federation` = "RU",
                    Rwanda = "RW",
                    `St. Helena` = "SH",
                    `St. Kitts & Nevis` = "KN",
                    `St. Lucia` = "LC",
                    `Saint Martin (French part)` = "MF",
                    `St. Pierre & Miquelon` = "PM",
                    `St. Vincent & Grenadines` = "VC",
                    Samoa = "WS",
                    `San Marino` = "SM",
                    `Saudi Arabia` = "SA",
                    Saxony = NA,
                    Senegal = "SN",
                    Serbia = "RS",
                    Seychelles = "SC",
                    `Sierra Leone` = "SL",
                    Singapore = "SG",
                    `Sint Maarten` = "SX",
                    Slovakia = "SK",
                    Slovenia = "SI",
                    `Solomon Islands` = "SB",
                    Somalia = "SO",
                    `South Africa` = "ZA",
                    `South Georgia & South Sandwich Islands` = "GS",
                    `South Sudan` = "SS",
                    Spain = "ES",
                    `Sri Lanka` = "LK",
                    Sudan = "SD",
                    Suriname = "SR",
                    `Svalbard & Jan Mayen` = "SJ",
                    Swaziland = "SZ",
                    Sweden = "SE",
                    Switzerland = "CH",
                    Syria = "SY",
                    Taiwan = "TW",
                    Tajikistan = "TJ",
                    Thailand = "TH",
                    Macedonia = "MK",
                    Togo = "TG",
                    Tokelau = "TK",
                    Tonga = "TO",
                    `Trinidad & Tobago` = "TT",
                    Tunisia = "TN",
                    Turkey = "TR",
                    Turkmenistan = "TM",
                    `Turks & Caicos Islands` = "TC",
                    Tuscany = NA,
                    Tuvalu = "TV",
                    `Two Sicilies` = NA,
                    Uganda = "UG",
                    Ukraine = "UA",
                    `United Arab Emirates` = "AE",
                    `United Kingdom` = "GB",
                    Tanzania = "TZ",
                    `United States` = "US",
                    Uruguay = "UY",
                    Uzbekistan = "UZ",
                    Vanuatu = "VU",
                    Venezuela = "VE",
                    Vietnam = "VN",
                    `British Virgin Islands` = "VG",
                    `U.S. Virgin Islands` = "VI",
                    `Wallis & Futuna` = "WF",
                    `Western Sahara` = "EH",
                    Wuerttemburg = NA,
                    Yemen = "YE",
                    Yugoslavia = NA,
                    Zambia = "ZM",
                    Zanzibar = NA,
                    Zimbabwe = "ZW")
