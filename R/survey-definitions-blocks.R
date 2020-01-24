

#' Retrieve a survey block
#' 
#' @description 
#' To retrieve a specific survey block, you need to pass the survey id and the block id. The latter
#' can be retrieved using the get_survey_flow function or the get_survey function.
#'
#' @param survey_id the survey id
#' @param block_id the block id
#'
#' @examples
#' \dontrun{
#' get_block("SV_012345678901234", "BL_723z35LY23KCZ4p")
#' }
#' @return A list
#' @export
get_block <- function(survey_id, block_id) {
  params <- c("survey-definitions", survey_id, "blocks", block_id)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Update a block
#' 
#' @description 
#' You can update an existing block, including the blocks meta information and the the block's elements. 
#' If you update the block elements and you add for example a new question, you must make sure the question
#' exisists in the survey (see list_questions and create_question).
#'
#' @param survey_id the survey id
#' @param block_id the block id
#' @param type block type
#' @param description block description
#' @param id a unique block id identifier (should be of form BL_FakeBlockID1234)
#' @param options list of block options
#' @param elements list of block elements
#'
#' @examples
#' \dontrun{
#' update_block("SV_012345678901234", "BL_723z35LY23KCZ4p")
#' }
#' @return A list
#' @export
update_block <- function(survey_id, block_id, type = "Standard", description = "New Block", id = NULL, options, elements) {
  params <- c("survey-definitions", survey_id, "blocks", block_id)
  body <- list(
    "Options" = list(
      options
    ),
    "BlockElements" = list(
      elements
    )
  )
  getcnt <- .qualtrics_put(params, NULL, ...)
  getcnt$result
}

#' Delete a block
#'
#' @param survey_id the survey id
#' @param block_id the block id
#'
#' @examples
#' \dontrun{
#' delete_block("SV_012345678901234", "BL_723z35LY23KCZ4p")
#' }
#' @return An execution status code
#' @export
delete_block <- function(survey_id, block_id) {
  params <- c("survey-definitions", survey_id, "blocks", block_id)
  getcnt <- .qualtrics_delete(params)
  getcnt$result
}

#' Create a new block
#' 
#' @description 
#' To retrieve a specific survey block, you need to pass the survey id and the block id. The latter
#' can be retrieved using the get_survey_flow function or the get_survey function.
#'
#' @param survey_id the survey id
#' @param type block type (Standard, Default or Trash)
#' @param description block description
#' @param ... block options
#'
#' @examples
#' \dontrun{
#' create_block(
#' "SV_012345678901234", 
#' "Standard",
#' "New Block",
#' "BlockLocking": "false",
#' "RandomizeQuestions": "false",
#' "BlockVisibility": "Collapsed"
#' )
#' }
#' @return A list with the associated block id and flow id
#' @export
create_block <- function(survey_id, type = "Standard", description = "Block", ...) {
  params <- c("survey-definitions", survey_id, "blocks")
  getcnt <- .qualtrics_post(params, NULL, ...)
  getcnt$result
}

#' List all block ids
#' 
#' @description 
#' This is convenience function that uses the get_survey function to return the list of all
#' block ids in a survey
#'
#' @param survey_id the survey id
#'
#' @examples
#' \dontrun{
#' list_blocks(
#' "SV_012345678901234", 
#' )
#' }
#' @return A tibble with blocks' information
#' @export
list_blocks <- function(survey_id) {
  survey <- get_survey(survey_id)

  do.call(
    bind_rows, 
    lapply(
      survey$Blocks,
      function(x) {
        tibble(
          "Type" = x$Type,
          "Description" = x$Description,
          "ID" = x$ID
        )
      }
    )
    )
}


#' Generate a compatible block id
#' 
#' @description 
#' When updating a block (update_block) or creating a new block (create_block), it can be convenient to control the creation
#' of the block id locally. This convenience function returns a block id that is unique and does not overlap with
#' existing block ids in the survey.
#'
#' @param survey_id the survey id
#'
#' @examples
#' \dontrun{
#' generate_block_id(
#' "SV_012345678901234", 
#' )
#' }
#' @return A string of the form BL_FakeBlockID1234
#' @export
generate_block_id <- function(survey_id) {
  list_blocks <- list_blocks(survey_id)

  id <- stri_rand_strings(1, 15, pattern = "[A-Za-z0-9]")
  
  while(id %in% list_blocks$ID) {
    id <- stri_rand_strings(1, 15, pattern = "[A-Za-z0-9]")
  }

  return(paste0("BL_", id))

}
