#' Retrieve the list of all user accounts for the brand
#'
#' @examples
#' \dontrun{list_users()}
#' @return A \code{tibble}.
#' @export
list_users <- function() {

  .build_users_list <- function(list) {
    df <- map_df(
      list, function(x) {
        tibble(
          "id" = .replace_na(x$id),
          "divisionId" = .replace_na(x$divisionId),
          "username" = .replace_na(x$username),
          "firstName" = .replace_na(x$firstName),
          "lastName" = .replace_na(x$lastName),
          "email" = .replace_na(x$email),
          "accountStatus" = .replace_na(x$accountStatus)
        )
      })}

  offset <- 0
  getcnt <- .qualtrics_get("users", "offset"=offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_users_list(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("users", "offset"=offset)
      df <- rbind(df,.build_users_list(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }
}

#' Retrieve a user account's information
#'
#' @param user_id the user id
#' @examples
#' \dontrun{get_user("UR_012345678912345")}
#' @return A \code{list} of the account parameters definitions.
#' @export
get_user <- function(user_id) {
  params <- c("users", user_id)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Create a new user account
#'
#' @param params a named list of account parameters
#'
#' @section Account parameters: user settings that can be passed are user_name,
#' first_name, last_name, user_type, email, password, language, time_zone,
#' division_id, account_expiration_date. Currently Qualtrics does not provide
#' an endpoint to retrieve user types so you must infer them from other calls
#' such as \code{get_user}.
#'
#' @examples
#' \dontrun{
#' params <- list(
#' "username" = "firt.last@qualtrics.com",
#' "firstName" = "first name",
#' "lastName" = "last name",
#' "userType" = "UT_012345678912345",
#' "email" = "firt.last@qualtrics.com",
#' "password" = "$123456789!",
#' "language" = "en",
#' "timeZone" = NULL,
#' "divisionId" = NULL,
#' "accountExpirationDate" = NULL
#' )
#' create_user(params)}
#' @return The created user id
#' @export
create_user <- function(params) {
  body <- params
  getcnt <- .qualtrics_post("users", NULL, body)
  user_id <- getcnt$result$id
}

#' Update a user's account parameters
#'
#' @param user_id id of the user account to update
#' @param ... a named list of account parameters to update
#' @section Account parameters:
#' user settings that can be possed are user_name, first_name, last_name,
#' user_type, language, time_zone, division_id, account_expiration_date,
#' status and permissions
#' @examples
#' \dontrun{update_user("UR_012345678912345", c("status" = "Enabled", "language" = "EN"))}
#' @return A status execution code
#' @export
update_user <- function(user_id, ...) {
  body <- list(...)
  params <- c("users", user_id)
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
}

#' Delete a user account
#'
#' @param user_id the user account id to delete
#' @examples
#' \dontrun{delete_user("UR_012345678912345")}
#' @return A status execution code
#' @export
delete_user <- function(user_id) {
  params <- c("users", user_id)
  getcnt <- .qualtrics_delete(params,NULL,NULL)
  status <- getcnt$meta$httpStatus
}

#' Returns the active api token for an account
#'
#' @param user_id the user account id
#' @examples
#' \dontrun{get_user_api_token("UR_012345678912345")}
#' @return An api token value
#' @export
get_user_api_token <- function(user_id) {
  params <- c("users", user_id, "apitoken")
  getcnt <- .qualtrics_get(params)
  getcnt$result$apiToken
}

#' Create an api token for a user account
#'
#' @param user_id the user id
#' @examples
#' \dontrun{create_user_api_token("UR_012345678912345")}
#' @return An new api token value
#' @export
create_user_api_token <- function(user_id) {
  params <- c("users", user_id, "apitoken")
  getcnt <- .qualtrics_post(params, NULL, NULL)
  getcnt$result$apiToken
}

#' Determine the user ID and other user information associated with an Qualtrics
#' API token or a Qualtrics OAuth access token.
#'
#' @examples
#' \dontrun{who_am_i()}
#' @return A \code{list} of related account information.
#' @export
who_am_i <- function() {
  .qualtrics_get("whoami", NULL, NULL)
}
