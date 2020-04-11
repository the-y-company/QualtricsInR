
.build_message_list <- function(list) {
  list %>%
    dplyr::tibble(
      id = purrr::map_chr(., "id", .default = NA),
      description = purrr::map_chr(., "description", .default = NA),
      category = purrr::map_chr(., "category")
    )
}


#' list_messages retrieves a full survey object
#' @param library_id the library_id
#' @return A \code{tibble}.
#' @export
list_messages <- function(library_id) {

  offset <- 0
  params <- c("libraries",library_id,"messages")
  getcnt <- .qualtrics_get(params, "offset"=offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_message_list(getcnt$result$elements)
    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, "offset"=offset)
      df <- rbind(df,.build_message_list(getcnt$result$elements))
    }
  } else {
    df <- NULL
  }

  return(df)

}

#' get_message retrieve a message
#' @param library_id the library_id
#' @param message_id the message_id
#' @return A \code{list}.
#' @export
get_message <- function(library_id, message_id) {

  params <- c("libraries", library_id, "messages", message_id)
  getcnt <- .qualtrics_get(params)

  return(getcnt$result)

}

#' create_message creates a message
#' @param description defines a description for the message
#' @param messages A JSON object - mapping language codes to messages
#' @param category invite, inactiveSurvey, reminder, thankYou, endOfSurvey, general, validation, lookAndFeel, emailSubject, smsInvite
#' @param library_id The Library ID can be one of the following IDs: User ID, Group ID, ThreeSixty ID
#' 
#' @return id of created message
#' 
#' @export
create_message <- function(
  description,
  messages,
  category,
  library_id) {

  params <- c("libraries", library_id, "messages")

  body <- list(
    "description" = description,
    "messages" = messages,
    "category" = category
  )

  getcnt <- .qualtrics_post(params, NULL, body)

  return(getcnt$result$id)

}

#' update_message creates a message
#' @param description defines a description for the message
#' @param messages A JSON object mapping language codes to messages. Existing languages will be replaced; others will be added
#' @param library_id The Library ID can be one of the following IDs: User ID, Group ID, ThreeSixty ID
#' @param message_id Message ID
#' @return A \code{tibble}.
#' @export
update_message <- function(
  description,
  messages,
  library_id,
  message_id
) {

  params <- c("libraries", library_id, "messages", message_id)

  body <- list(
    "description" = description,
    "messages" = messages
  )

  getcnt <- .qualtrics_put(params, NULL, body)

  return(getcnt$meta$httpStatus)

}

#' delete_message creates a message
#' @param library_id The Library ID can be one of the following IDs: User ID, Group ID, ThreeSixty ID
#' @param message_id Message Id run list_messages
#' @return A \code{tibble}.
#' @export
delete_message <- function(
  library_id,
  message_id
) {

  params <- c("libraries", library_id, "messages", message_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)

  return(getcnt$meta$httpStatus)

}
