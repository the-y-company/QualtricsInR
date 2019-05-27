
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
#' For any entity discovered the service will erase any
#' responses to surveys they have submitted, along with any tickets that may have
#' originated from their responses before erasing the entity itself.
#'
#' @examples
#' \dontrun{create_erasure_request("ddd@@hotmail.com")}
#' \dontrun{create_erasure_request(c("person1@@themail.com", "person1@@theemail.com"), FALSE)}
#'
#' @return A \code{data.frame}.
create_erasure_request <- function(list_emails, search_only = TRUE) {
  body <- list(
    "emails" = list_emails,
    "searchOnly" = search_only
  )
  getcnt <- .qualtrics_post("op-erase-personal-data", NULL, NULL)
  return(getcnt)
}

#' List all erasure request for a brand
#'
#' @examples
#' \dontrun{list_erasing_requests()}
#'
#' @return A \code{data.frame}.
list_erasure_requests <- function() {
  getcnt <- .qualtrics_get("op-erase-personal-data")
  return(getcnt)
}

#' Retrieve a given erasure request
#'
#' @param request_id the id of the past erasing request
#'
#' @examples
#' \dontrun{get_erasing_request("request_id")}
#' @return A \code{list}.
get_erasure_request <- function(request_id) {

  params <- c("op-erase-personal-data",request_id)
  getcnt <- .qualtrics_get(params)
  return(getcnt)

}

