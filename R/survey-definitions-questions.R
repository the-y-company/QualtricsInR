

#' List all survey questions
#'
#' @param survey_id the survey id
#' @examples
#' \dontrun{list_survey_questions("SV_012345678901234")}
#' @return A list
#' @export
list_survey_questions <- function(survey_id) {
  params <- c("survey-definitions", survey_id, "questions")
  getcnt <- .qualtrics_get(params)
  getcnt$result
}


#' Retrieve a survey question
#'
#' @param survey_id the survey id
#' @param question_id the question id (see list_survey_questions)
#' @examples
#' \dontrun{get_survey_question("SV_012345678901234","QID1)}
#' @return A list
#' @export
get_survey_question <- function(survey_id, question_id) {
  params <- c("survey-definitions", survey_id, "questions", question_id)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Delete a survey question
#'
#' @param survey_id the survey id
#' @param question_id the question id (see list_survey_questions)
#' @examples
#' \dontrun{delete_survey_question("SV_012345678901234","QID1)}
#' @return A list
#' @export
delete_survey_question <- function(survey_id, question_id) {
  params <- c("survey-definitions", survey_id, "questions", question_id)
  getcnt <- .qualtrics_delete(params)
  getcnt$meta$httpStatus
}
