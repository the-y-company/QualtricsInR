#' Retrieve a survey
#'
#' @param survey_id the survey id
#' @examples
#' \dontrun{get_survey("SV_012345678901234")}
#' @return A json survey object file
#' @export
get_survey <- function(survey_id) {
  params <- c("survey-definitions","id"=survey_id)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Retrieve Survey Meta Data
#'
#' @param survey_id the survey id
#'
#' @examples
#' \dontrun{get_options("SV_012345678901234")}
#' @return A list
#' @export
get_survey_meta_data <- function(survey_id) {
  params <- c("survey-definitions", survey_id, "metadata")
  getcnt <- .qualtrics_get(params, NULL, NULL)
  getcnt$result
}


#' Delete a survey
#'
#' @param survey_id the survey id
#' @examples
#' \dontrun{delete_survey("SV_012345678901234")}
#' @return A execution status code
#' @export
delete_survey <- function(survey_id) {
  params <- c("survey-definitions", survey_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  getcnt$meta$httpStatus
}

#' Create a survey
#'
#' @param survey_name the survey name
#' @param language creation language, default is EN
#' @param project_category default is CORE (can be CX, EX, BX, PX)
#' @examples
#' \dontrun{delete_survey("SV_012345678901234")}
#' @return A execution status code
#' @export
create_survey <- function(survey_name, language = "EN", project_category = "CORE") {
  params <- "survey-definitions"
  body <- list(
    "SurveyName" = survey_name,
    "Language" = language,
    "ProjectCategory" = project_category
  )
  getcnt <- .qualtrics_post(params, NULL, body)
  getcnt$result
}

