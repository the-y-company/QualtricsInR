#' Retrieve the list of languages in which a survey is available
#' 
#' @param survey_id the survey id
#' 
#' @examples
#' \dontrun{get_survey_languages("SV_012345678901234")}
#' 
#' @return A \code{list} of available languages
#' 
#' @export
get_survey_languages <- function(survey_id) {
  params <- c("surveys", survey_id, "languages")
  getcnt <- .qualtrics_get(params)
  getcnt$result$AvailableLanguages
}

#' get_survey_translations retrieves the full translation
#' @param survey_id the survey id
#' @param language_code is the code for the language of translation
#'
#' @examples
#' \dontrun{get_survey_translations("SV_012345678901234", "EN")}
#' @return A \code{list} of survey elements in requested language
#' @export
get_survey_translations <- function(survey_id, language_code) {
  params <- c("surveys", survey_id, "translations", language_code)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Update the list of available survey languages for a survey
#'
#' Enabling a new survey language is needed before being able to add a
#' translation for that language.
#'
#' @param survey_id the survey id
#' @param language_codes Array of language codes to enable
#'
#' @examples
#' \dontrun{update_survey_languages("SV_1873930DS2", c("EN", "ES"))}
#' @return A \code{status}.
#' @export
update_survey_languages <- function(survey_id, language_codes) {
  params <- c("surveys", survey_id, "languages")
  body <- list("AvailableLanguages" = language_codes)
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
}

#' Update survey translation
#'
#' @param survey_id the survey id
#' @param language_code the language code
#' @param survey_translation list with all translated survey fields (see `get_survey_translations`)
#'
#' @details
#' Update a surveys translation by provind a list of survey elements' translations for a
#' given language.
#'
#' @examples
#' \dontrun{
#' # retrieve translation from a survey
#' srv_transl_pt <- get_survey_translations("SV_dnEGNjwrSTQXxiZ", "PT")
#' # create pt translation in other survey
#' update_survey_languages("SV_6fj3YgWt6ocXL1A", "PT")
#' # update the PT translation
#' update_survey_translations(id, "PT", srv_transl_pt)
#' }
#' @return A \code{status}.
#' @export
update_survey_translations <- function(survey_id, language_code, survey_translation) {
  params <- c("surveys", survey_id, "translations", language_code)
  body <- survey_translation
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
}
