
globalVariables(c(
  "op", "erase", "data", "x", "personal"))

#' Create an erasing request
#'
#' @param list_emails A vector of emails.
#' @param search_only Set to \code{TRUE} to perform a dryrun (set to FALSE to erase)
#'
#' @description
#' When processed, the request will search for any entities within Qualtrics that
#' match any of the supplied emails; these entities include
#' - Users
#' - MailingList & XM Directory contacts
#' - People
#' For any entity discovered the service will erase any responses to surveys
#' they have submitted, along with any tickets that may have originated from
#' their responses before erasing the entity itself.
#'
#' @examples
#' \dontrun{create_erasure_request("ddd@@hotmail.com")}
#' \dontrun{create_erasure_request(c("person1@@themail.com", "person1@@theemail.com"), FALSE)}
#'
#' @return A the request id
#' @export
create_erasure_request <- function(list_emails, search_only = TRUE) {
  body <- list(
    "emails" = list_emails,
    "searchOnly" = search_only
  )
  getcnt <- .qualtrics_post("op-erase-personal-data", NULL, body)
  return(getcnt$result$requestId)
}

#' List all erasure request for a brand
#'
#' @examples
#' \dontrun{list_erasing_requests()}
#'
#' @return A \code{tibble}.
#' @export
list_erasure_requests <- function() {

  .build_request <- function(list) {
    df <- purrr::map_df(
      list, function(x) {
        dplyr::tibble(
          "requestid" = .replace_na(x$requestid),
          "status" = .replace_na(x$status),
          "user" = .replace_na(x$user),
          "numEmailsRequested" = .replace_na(x$numEmailsRequested),
          "emailsNotFound" = .replace_na(x$emailsNotFound),
          "emailList" = .replace_na(paste0(x$emailList, collapse = ", ")),
          "searchOnly" = .replace_na(x$searchOnly),
          "failureReason" = .replace_na(x$failureReason),
          "created" = .replace_na(x$created),
          "updated" = .replace_na(x$updated)
        )
      })}

  offset <- 0
  getcnt <- .qualtrics_get("op-erase-personal-data")

  if (length(getcnt$result$elements)>0) {
    df <- .build_request(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(op-erase-personal-data)
      df <- dplyr::bind_rows(df,.build_request(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

  return(df)
}

#' Retrieve a given erasure request
#'
#' @param request_id the id of the past erasing request
#'
#' @note
#' As long as the erasure request does not have a Completed status, you will
#' not be able to retrieve the request.
#'
#' @examples
#' \dontrun{get_erasing_request("request_id")}
#' @return A \code{list}.
#' @export
get_erasure_request <- function(request_id) {

  .build_request <- function(list) {
    df <- dplyr::tibble(
        "requestid" = .replace_na(x$requestid),
        "status" = .replace_na(x$status),
        "user" = .replace_na(x$user),
        "numEmailsRequested" = .replace_na(x$numEmailsRequested),
        "emailsNotFound" = .replace_na(x$emailsNotFound),
        "emailList" = .replace_na(paste0(x$emailList, collapse = ", ")),
        "searchOnly" = .replace_na(x$searchOnly),
        "failureReason" = .replace_na(x$failureReason),
        "created" = .replace_na(x$created),
        "updated" = .replace_na(x$updated)
        )}

  params <- c("op-erase-personal-data", request_id)
  getcnt <- .qualtrics_get(params)
  df <- .build_request(getcnt$result)
  return(df)

}

