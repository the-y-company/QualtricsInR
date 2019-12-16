

#' Retrieve the flow structure of a survey
#'
#' @description
#' This call will return the complete flow strcuture of your survey as a
#' nestedlist of flow elements reflecting all layers of logic built into the
#' survey.
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

#' Update the survey flow
#'
#' @description
#' This call allows you to modify the existing flow strcuture of a survey. Performing this
#' operation through the API requires you understand the details of the full structure of a
#' Qualtrics survey since creating new flow elements, e..g, will require that these elements
#' refere to survey elements, like Blocks, that exist, i.e. were previously created through
#' other calls. For a detailed example, see the official package documentation.
#'
#' @param survey_id the survey id
#' @param flow_id a string the flow element id
#' @param flow_type a string  the flow element type (see docs for available types)
#' @param flow_object an object the root flow strcuture
#' @param flow_properties an object the flow element properties
#'
#' @return A list
#' @export
update_survey_flow <- function(survey_id, flow_id, flow_type, flow_object, flow_properties) {

  type <- match.arg(
    flow_type,
    choices = c(
    "Authenticator", "Block", "BlockRandomizer", "Branch",
    "Conjoint", "EmbeddedData", "EndSurvey", "Group", "QuotaCheck",
    "ReferenceSurvey", "Root", "Standard", "SupplementalData",
    "TableOfContents", "WebService"),
    several.ok = FALSE
  )

  params <- c("survey-definitions", survey_id, "flow")
  body <- list(
    "FlowID" = flow_id,
    "Type" = type,
    "Flow" = flow_object,
    "Properties" = flow_properties
  )

  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$result
}

#' Update a specific survey flow element
#'
#' @description
#' This call allows only limited action on a flow element. It allows only to update the
#' type of a flow element as well as its id. Such functionalities are useful only if you
#' have a detailing understanding of the whole structure of Qualtrics surveys, which is best
#' understood spending time understanding exported qsf files.
#'
#' @param survey_id the survey id
#' @param flow_id the flow element id
#' @param new_flow_id the new flow id
#' @param flow_type the flow element type (see docs for available types)
#'
#' @return A list
#' @export
update_flow_element <- function(survey_id, flow_id, new_flow_id, flow_type) {

  type <- match.arg(
    flow_type,
    choices = c(
      "Authenticator", "Block", "BlockRandomizer", "Branch",
      "Conjoint", "EmbeddedData", "EndSurvey", "Group", "QuotaCheck",
      "ReferenceSurvey", "Root", "Standard", "SupplementalData",
      "TableOfContents", "WebService"),
    several.ok = FALSE
  )

  params <- c("survey-definitions", survey_id, "flow", flow_id)
  body <- c(
    "FlowID" = flow_id,
    "Type" = type
  )

  getcnt <- .qualtrics_get(params, NULL, body)
  getcnt$result
}

