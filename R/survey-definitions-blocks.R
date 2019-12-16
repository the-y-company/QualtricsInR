

#' Retrieve a given survey block
#'
#' @param survey_id the survey id
#' @param block_id the block id
#'
#' @examples
#' \dontrun{get_block("SV_012345678901234","BL_723z35LY23KCZ4p")}
#' @return A list
#' @export
get_block <- function(survey_id, block_id) {
  params <- c("survey-definitions", survey_id, "blocks", block_id)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}
