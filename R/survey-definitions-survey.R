#' Retrieve a survey
#'
#' @param survey_id the id of survey to retrieve
#' @examples
#' \dontrun{get_survey("SV_012345678901234")}
#' @return A \code{list} of survey elements
#' @export
get_survey <- function(survey_id) {
  params <- c("surveys","id"=survey_id)
  .qualtrics_get(params)
}

#' Delete a survey
#'
#' @param survey_id The survey ID of the survey you want to delete
#' @examples
#' \dontrun{delete_survey("SV_012345678901234")}
#' @return A execution status code
#' @export
delete_survey <- function(survey_id) {
  params <- c("surveys", survey_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  getcnt$meta$httpStatus
}
