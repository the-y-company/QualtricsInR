#' Retrieve Survey Options
#'
#' @param survey_id the survey id
#'
#' @examples
#' \dontrun{get_options("SV_012345678901234")}
#' @export
get_options <- function(survey_id) {
  params <- c("survey-definitions", survey_id, "options")
  getcnt <- .qualtrics_get(params, NULL, NULL)
  getcnt$meta$httpStatus
}

#' Update Survey Options
#'
#' @description
#' All available options can be found at \url{https://api.qualtrics.com/reference#update-options}
#' @param survey_id the survey id
#' @param options list of named option defintions
#'
#' @examples
#' \dontrun{update_options("SV_012345678901234", "sss")}
#' @export
update_options <- function(survey_id, options) {
  params <- c("survey-definitions", survey_id, "options")
  body <- list(options)
  getcnt <- .qualtrics_post(params, NULL, body)
  getcnt$meta$httpStatus
}



