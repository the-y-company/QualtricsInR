

#' List all survey questions
#'
#' @param survey_id the survey id
#' @examples
#' \dontrun{list_questions("SV_012345678901234")}
#' @return A list
#' @export
list_questions <- function(survey_id) {
  params <- c("survey-definitions", survey_id, "questions")
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Retrieve a survey question
#'
#' @param survey_id the survey id
#' @param question_id the question id see list_questions
#'
#' @examples
#' \dontrun{get_survey_question("SV_012345678901234","QID1")}
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
#' @param question_id the question id see list_questions
#' @examples
#' \dontrun{delete_survey_question("SV_012345678901234","QID1")}
#' @return A list
#' @export
delete_survey_question <- function(survey_id, question_id) {
  params <- c("survey-definitions", survey_id, "questions", question_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  getcnt$meta$httpStatus
}

#' Get survey question mapping
#' 
#' @description 
#' This function returns a tibble formatted result of the list_question result, allowing for an easy
#' inspection of the relation between question IDs and question export tags.
#'
#' @param survey_id the survey id
#' @examples
#' \dontrun{get_questions_mapping("SV_012345678901234")}
#' @return A list
#' @export
get_questions_mapping <- function(survey_id) {

  qmap <- list_questions(survey_id)

  do.call(
    bind_rows,
    lapply(
      qmap$elements,
      function(x) {
        tibble(
          "QuestionID" = x$QuestionID,
          "DataExportTag" = x$DataExportTag,
          "QuestionType" = x$QuestionType,
          "QuestionDescription" = x$QuestionDescription
        )
      }))

}
