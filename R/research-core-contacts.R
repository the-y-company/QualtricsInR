
#' Retrieve all mailing lists from account
#'
#' @examples
#' \dontrun{list_mailinglists()}
#' @return A \code{tibble} of all mailing list with properties
#' @export
list_mailinglists <- function() {

  .build_mailing_lists <- function(list) {
    purrr::map_df(
      list, function(x) {
        dplyr::tibble(
          "libraryId" = .replace_na(x$libraryId),
          "id" = .replace_na(x$id),
          "name" = .replace_na(x$name),
          "category" = .replace_na(x$category),
          "folder" = .replace_na(x$folder)
        )})
  }

  offset <- 0
  getcnt <- .qualtrics_get("mailinglists", "offset"=offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_mailing_lists(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("mailinglists", "offset"=offset)
      df <- rbind(df,.build_mailing_lists(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }
}

#' Retrieve a specific mailing list
#'
#' @param mailinglist_id the mailing list id
#' @examples
#' \dontrun{get_mailinglist("ML_1234567890AbCdE")}
#' @return A \code{list} with the mailing list information
#' @export
get_mailinglist <- function(mailinglist_id) {
  params <- list("mailinglists", mailinglist_id)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Create a new mailing list
#'
#' @param library_id the library_id
#' @param name Name of the new mailing list
#' @param category Category in which to create the new mailing list
#' @examples
#' \dontrun{create_mailinglist("UR_1234567890AbCdE","New Emails")}
#' @return The id of the created mailing list
#' @export
create_mailinglist <- function(library_id, name, category = NULL) {

  body <- list(
    "category" = category,
    "libraryId" = library_id,
    "name" = name
  )
  getcnt <- .qualtrics_post("mailinglists", NULL, body)
  getcnt$result$id
}

#' Update an existing mailing list
#'
#' @param mailinglist_id the library_id
#' @param library_id the library_id if moved to a different library id
#' @param name Name of the new mailing list
#' @param category Category in which to create the new mailing list
#' @examples
#' \dontrun{update_mailinglist("ML_1234567890AbCdE", name = "New Name")}
#' @return A \code{list}.
#' @export
update_mailinglist <- function(mailinglist_id, library_id = NULL, name = NULL, category = NULL) {

  body <- list(
    "category" = category,
    "libraryId" = library_id,
    "name" = name
  )
  params <- c("mailinglists",mailinglist_id)
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
}

#' Delete an existing mailing list
#'
#' @param mailinglist_id the id of mailing list to delete
#' @examples
#' \dontrun{delete_mailinglist("ML_1234567890AbCdE")}
#' @return A status code
#' @export
delete_mailinglist <- function(mailinglist_id) {
  params <- c("mailinglists",mailinglist_id)
  getcnt <- .qualtrics_post(params, NULL, NULL)
  getcnt$meta$httpStatus
}

#' Retrieve all contacts in a mailing list
#'
#' @param mailinglist_id the id of mailing list to delete
#' @examples
#' \dontrun{list_contacts("ML_1234567890AbCdE")}
#' @return A \code{tibble} of all mailing list contacts
#' @export
list_contacts <- function(mailinglist_id) {

  .build_contact_list <- function(list) {
    purrr::map_df(
      list, function(x) {
        dplyr::tibble(
          "id" = .replace_na(x$id),
          "firstName" = .replace_na(x$firstName),
          "lastName" = .replace_na(x$lastName),
          "email" = .replace_na(x$email),
          "externalDataReference" = .replace_na(x$externalDataReference),
          "embeddedData" = .replace_na(x$embeddedData),
          "language" = .replace_na(x$language),
          "unsubscribed" = .replace_na(x$unsubscribed),
          "responseHistory" = .replace_na(x$responseHistory),
          "emailHistory" = .replace_na(x$emailHistory)
        )})
  }

  offset <- 0
  params <- c("mailinglists", mailinglist_id, "contacts")
  getcnt <- .qualtrics_get(params, "offset" = offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_contact_list(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("mailinglists", "offset"=offset)
      df <- rbind(df,.build_contact_list(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }
}

#' Retrieve a the information related to a certain contact
#'
#' @description
#' This call allows to retrieve all the information regarding a certain contact id. The call returns an
#' email history for the contact
#'
#' @param mailinglist_id the mailing list id
#' @param contact_id the contact id
#' @examples
#' \dontrun{get_contact("ML_0HT4q2Ni634kLhH", "MLRP_bwwuYtDMPdK2Scl")}
#' @return A \code{list} with the mailing list information
#' @export
get_contact <- function(mailinglist_id, contact_id) {
  params <- list("mailinglists", mailinglist_id, "contacts", contact_id)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

