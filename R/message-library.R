
#' List all messages from a given library
#' 
#' @description
#' The call returns a list with all available mesage ids,
#' descriptions and category.
#' 
#' @param library_id The library id can be one of the following IDs: User ID, Group ID, ThreeSixty ID (see 'list_libraries')
#' 
#' @examples
#' \dontrun{
#'  list_messages("UR_0NXtl92JJWqfWcJ")
#' }
#' 
#' @details 
#' The library id can be found using the 'list_libraries'
#' call.
#' 
#' @return A \code{tibble}.
#' 
#' @export
list_messages <- function(library_id) {

  .build_message_list <- function(list) {
    tibble(
      id = map_chr(list, "id", .default = NA),
      description = map_chr(list, "description", .default = NA),
      category = map_chr(list, "category")
    )
  }

  offset <- 0
  params <- c("libraries", library_id, "messages")
  getcnt <- .qualtrics_get(params, "offset" = offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_message_list(getcnt$result$elements)
    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, "offset"=offset)
      df <- rbind(df,.build_message_list(getcnt$result$elements))
    }
  } else {
    df <- NULL
  }

  return(df)

}

#' Retrieve a message from the library
#' 
#' @description
#' The call returns a list with the message category, the message description
#' and the message in the various translated languages.
#' 
#' @param library_id The library id can be one of the following IDs: User ID, Group ID, ThreeSixty ID (see 'list_libraries')
#' @param message_id the message_id
#' 
#' @examples
#' \dontrun{
#'  get_message("UR_0NXtl92JJWqfWcJ", "MS_0fddN2xI3J0nGQZ")
#' }
#' 
#' @return A \code{list}.
#' 
#' @export
get_message <- function(library_id, message_id) {

  params <- c("libraries", library_id, "messages", message_id)
  getcnt <- .qualtrics_get(params)

  return(getcnt$result)

}

#' Create a new message in the library
#' 
#' @description
#' You can create messages with advanced features such as piped text and
#' custom look and feel as long as you provide the former using the Qualtrics
#' format and html for the second. The best is to use the 'get_message function'
#' in order to view the structure of an existing message.
#' 
#' @param library_id The library id can be one of the following IDs: User ID, Group ID, ThreeSixty ID (see 'list_libraries')
#' @param category invite, inactiveSurvey, reminder, thankYou, endOfSurvey, general, validation, lookAndFeel, emailSubject, smsInvite
#' @param description defines a description for the message
#' @param messages A JSON object - mapping language codes to messages
#' 
#' @examples 
#' \dontrun{
#'  message = list(
#'  "en" = "Thank you for taking this survey.", 
#'  "fr" = "Merci de participer à cette enquête.")
#'  create_message("UR_0NXtl92JJWqfWcJ", "invite", "My New Invite Message", message)
#' }
#' 
#' @return id of created message
#' 
#' @export
create_message <- function(
  library_id,
  category,
  description,
  messages) {

  params <- c("libraries", library_id, "messages")

  body <- list(
    "category" = category,
    "description" = description,
    "messages" = messages
  )

  getcnt <- .qualtrics_post(params, NULL, body)

  return(getcnt$result$id)

}

#' Update an existing library message
#' 
#' @description 
#' This call is particularly useful is you want to update the translations and/or languages
#' available for a given library message. 
#' 
#' @param library_id The Library ID can be one of the following IDs: User ID, Group ID, ThreeSixty ID
#' @param message_id Message ID
#' @param description defines a description for the message
#' @param messages A JSON object mapping language codes to messages. Existing languages will be replaced; others will be added
#' 
#' @details 
#' The message id can be found using the 'list_messages' call.
#' 
#' @examples 
#'  \dontrun{
#'    message = list(
#'      "en" = "Thank you again for taking this survey.", 
#'       "es" = "Gracias por participar en esta encuesta")
#'    update_message(
#'      "UR_0NXtl92JJWqfWcJ", 
#'      "MS_3qR8d4mAkgD0fKl", 
#'      "My Most Recent Invite Message", 
#'      message)
#' }
#' 
#' @return A \code{tibble}.
#' 
#' @export
update_message <- function(
  library_id,
  message_id,
  description,
  messages
) {

  params <- c("libraries", library_id, "messages", message_id)

  body <- list(
    "description" = description,
    "messages" = messages
  )

  getcnt <- .qualtrics_put(params, NULL, body)

  return(getcnt$meta$httpStatus)

}

#' Delete a library message
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
