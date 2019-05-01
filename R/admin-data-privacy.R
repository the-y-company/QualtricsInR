
#' create_user_api_token creates a users api token
#' @param list_emails A vector of emails.
#' @param search_only Set to \code{TRUE} to perform a dryrun (default).
#' @examples
#' \dontrun{create_erasing_request("ddd@@hotmail.com")}
#' \dontrun{create_erasing_request(c("person1@@themail.com", "person1@@theemail.com"),TRUE)}
#' @return A \code{data.frame}.
create_erasing_request <- function(list_emails, search_only=TRUE) {
  body <- list(
    "emails" = list_emails,
    "searchOnly" = search_only
  )
  getcnt <- .qualtrics_post("op-erase-personal-data", NULL, NULL)
  return(getcnt)
}

#' list_erasing_requests lists all erasing requests
#' @examples
#' \dontrun{list_erasing_requests()}
#' @return A \code{data.frame}.
list_erasing_requests <- function() {
  getcnt <- .qualtrics_get("op-erase-personal-data")
  return(getcnt)
}

#' get_erasing_request lists all erasing requests
#' @param request_id the id of the past erasing request
#' @examples
#' \dontrun{get_erasing_request("request_id")}
#' @return A \code{list}.
get_erasing_request <- function(request_id) {

  params <- c("op-erase-personal-data",request_id)
  getcnt <- .qualtrics_get(params)
  return(getcnt)

}
