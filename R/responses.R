#' Update the value of an embedded data field in a survey response
#'
#' @param surveyId the id of survey to copy
#' @param responseId ID of the response to be deleted
#' @param embeddedData JSON object representing the embedded data fields to set.
#' @param resetRecordedDate Default: true - Sets the recorded date to the current
#' time. If false, the recorded date will be incremented by one millisecond.
#' @examples
#' \dontrun{update_response("SV_012345678912345", "R_012345678912345",
#' {"EDField": "EDValue"}, FALSE)}
#' @return A \code{status}.
#' @export
update_response <- function(
  surveyId,
  responseId,
  embeddedData,
  resetRecordedDate=TRUE) {

  params <- c("responses", responseId)
  body <- list(
    "surveyId" = surveyId,
    "embeddedData" = embeddedData,
    "resetRecordedDate" = resetRecordedDate
    )

  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
  }

#' Delete a survey response
#'
#' @param surveyId ID of the survey to delete the response from
#' @param responseId ID of the response to be deleted
#' @param decrementQuotas If true, any relevant quotas will be decremented
#'
#' @examples
#' \dontrun{delete_response("SV_012345678912345", "R_012345678912345", TRUE)}
#' @return A \code{status}.
#' @export
delete_response <- function(
  surveyId,
  responseId,
  decrementQuotas) {

  params <- c("responses", responseId)
  getcnt <- .qualtrics_delete(params, list("surveyId"=surveyId, "decrementQuotas" = decrementQuotas), NULL)
  getcnt$meta$httpStatus
}
