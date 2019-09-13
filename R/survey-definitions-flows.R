

#' Retrieve a survey question
#'
#' @param survey_id the survey id
#' @examples
#' \dontrun{get_survey_flow("SV_012345678901234")}
#' @return A list
#' @export
get_survey_flow <- function(survey_id) {
  params <- c("survey-definitions", survey_id, "flow")
  getcnt <- .qualtrics_get(params)
  getcnt$result
}
