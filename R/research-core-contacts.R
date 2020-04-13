
#' Retrieve all mailing lists from account
#'
#' @examples
#' \dontrun{list_mailinglists()}
#' @return A \code{tibble} of all mailing list with properties
#' @export
list_mailinglists <- function() {

  .build_mailing_lists <- function(list) {
    map_df(
      list, function(x) {
        tibble(
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
      offset <- parse_url(getcnt$result$nextPage)$query$offset
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
  getcnt <- .qualtrics_delete(params, NULL, NULL)
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
    map_df(
      list, function(x) {
        tibble(
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
      offset <- parse_url(getcnt$result$nextPage)$query$offset
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

#' Create a new contact in a mailing list
#'
#' @description create a new contact in a mailing list. In addition to the mailing
#' list id, you can pass a named list of parameters to define your contact. All
#' parameters are optional but empty parameters cannot be passed. Parameters are:
#' firstName, lastName, email, externalDataRef, language, unsubscribed and embeddedData. The
#' embeddedData element must a string representation of a JSON object.
#'
#' @param mailinglist_id ID of the mailing list in which to create the contact
#' @param contact_options list of new contact information
#'
#' @examples
#' \dontrun{
#' new_contact <- list(
#' "firstName" = "James",
#' "lastName" = "Paddignton",
#' "email" = "james.pad@gmailing.com")
#' new_contact_id <- create_contact("ML_0HT4q2Ni634kLhH", new_contact)}
#' @return The id of the created mailing list
#' @export
create_contact <- function(mailinglist_id, contact_options) {

  body <- contact_options

  params <- list("mailinglists", mailinglist_id, "contacts")
  getcnt <- .qualtrics_post(params, NULL, body)
  getcnt$result$id
}

#' Updates a contact's information in a mailing list
#'
#' @description update a contact's information in a mailing list. You can pass a named
#' list of parameters to define your contact. All parameters are optional but empty parameters
#' cannot be passed. Parameters are: firstName, lastName, email, externalDataRef, language,
#' unsubscribed and embeddedData. The embeddedData element must a string representation of a JSON object.
#'
#' @param mailinglist_id ID of the mailing list in which to create the contact
#' @param contact_id ID of the contact to update (see list_contacts)
#' @param contact_options list of new contact information
#'
#' @examples
#' \dontrun{
#' updated_contact <- list("firstName" = "James William")
#' update_contact("ML_0HT4q2Ni634kLhH", "MLRP_eaI7CCX9bxAbRt3", updated_contact)}
#' @return The status code
#' @export
update_contact <- function(mailinglist_id, contact_id, contact_options) {

  body <- contact_options

  params <- list("mailinglists", mailinglist_id, "contacts", contact_id)
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
}


#' Delete a contact from a mailing list
#'
#' @param mailinglist_id the id of mailing list to delete
#' @param contact_id ID of the contact to update (see list_contacts)
#'
#' @examples
#' \dontrun{delete_contact("ML_1234567890AbCdE","MLRP_eaI7CCX9bxAbRt3")}
#' @return A status code
#' @export
delete_contact <- function(mailinglist_id, contact_id) {
  params <- list("mailinglists", mailinglist_id, "contacts", contact_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  getcnt$meta$httpStatus
}


#' List samples associated with a mailing list
#'
#' @param mailinglist_id the id of mailing list to delete
#' @examples
#' \dontrun{list_samples("ML_0HT4q2Ni634kLhH")}
#' @return A \code{tibble} of all samnple ids and names
#' @export
list_samples <- function(mailinglist_id) {

  .build_sample_list <- function(list) {
    map_df(
      list, function(x) {
        tibble(
          "id" = .replace_na(x$id),
          "name" = .replace_na(x$name)
        )})
  }

  offset <- 0
  params <- c("mailinglists", mailinglist_id, "samples")
  getcnt <- .qualtrics_get(params, "offset" = offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_sample_list(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("mailinglists", "offset"=offset)
      df <- rbind(df,.build_sample_list(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }
}

#' Retrieve a sample from a mailing list
#'
#' @param mailinglist_id the mailing list id
#' @param sample_id the contact id
#' @examples
#' \dontrun{get_sample("ML_0HT4q2Ni634kLhH", "PL_8C7RS264INboiMJ")}
#' @return A \code{list} with all sample contacts and their respective email histories
#' @export
get_sample <- function(mailinglist_id, sample_id) {

  offset <- 0
  params <- list("mailinglists", mailinglist_id, "samples", sample_id)
  getcnt <- .qualtrics_get(params, "offset" = offset)

  if (length(getcnt$result$elements)>0) {

    list_sample_contacts <- getcnt$result

    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, "offset" = offset)
      list_sample_contacts <- c(list_sample_contacts, getcnt$result)
    }

    return(list_sample_contacts)
  } else {
    return(NULL)
  }

}
