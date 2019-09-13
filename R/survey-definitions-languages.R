#' Retrieve the list of languages in which a survey is available
#' @param survey_id the survey id
#' @examples
#' \dontrun{get_survey_languages("SV_012345678901234")}
#' @return A \code{list} of available languages
#' @export
get_survey_languages <- function(survey_id) {
  params <- c("survey-definitions",survey_id,"languages")
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
  params <- c("survey-definitions","id" = survey_id, "translations",language_code)
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
  params <- c("survey-definitions", survey_id, "languages")
  body <- list("AvailableLanguages" = language_codes)
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
}

#' Update the survey translation for a given language
#'
#' @param survey_id the survey id
#' @param language_code the language code
#' @param survey_field need to be inferred from retrieving a translation first
#'
#' @details
#' To understand which the field names to provide as translated input, the
#' most simple approach is to run the get_survey_translations function for the
#' corresponding language and built the list of fields the response.
#'
#' @examples
#' \dontrun{update_survey_translations(id, "EN", list("QID1_QuestionText" = "Uno"))}
#' @return A \code{status}.
#' @export
update_survey_translations <- function(survey_id, language_code, survey_field) {
  params <- c("survey-definitions", survey_id, "translations",language_code)
  body <- survey_field
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
}
