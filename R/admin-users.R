
#' Retrieve the list of all user accounts
#'
#' @examples
#' \dontrun{list_users()}
#' @return A \code{tibble}.
#' @export
list_users <- function() {

  .build_users_list <- function(list) {
    df <- purrr::map_df(
      list, function(x) {
        dplyr::tibble(
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
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
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
#' @return A \code{list} of the different available account parameters.
#' @export
get_user <- function(user_id) {
  params <- c("users", user_id)
  .qualtrics_get(params)
}

#' Create a new user account
#'
#' @param ... a named list of account parameters to update
#' @section Account parameters:
#' user settings that can be possed are user_name, first_name, last_name,
#' user_type, language, time_zone, division_id, account_expiration_date,
#' status and permissions
#'
#' @examples
#' \dontrun{create_user(c("status" = "Enabled", "language" = "EN"))}
#' @return The created user id
#' @export
create_user <- function(...) {
  body <- list(...)
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
  status <- getcnt$meta$httpStatus
}

#' Delete a user account
#'
#' @param user_id the user account id to delete
#' @examples
#' \dontrun{delete_user("UR_012345678912345")}
#' @return A status execution code
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
  api_token <- getcnt$result$apiToken
}

#' Create an api token for a user account
#'
#' @param user_id the user id
#' @examples
#' \dontrun{create_user_api_token("UR_012345678912345")}
#' @return An new api token value
create_user_api_token <- function(user_id) {
  params <- c("users", user_id, "apitoken")
  getcnt <- .qualtrics_post(params, NULL, NULL)
  api_token <- getcnt$result$apiToken
}

#' Determine the user ID and other user information associated with an Qualtrics
#' API token or a Qualtrics OAuth access token.
#'
#' @examples
#' \dontrun{who_am_i()}
#' @return A \code{list} of related account information.
who_am_i <- function() {

  getcnt <- .qualtrics_get("whoami", NULL, NULL)

  list(
    "userId" = getcnt$result$userId,
    "userName" = getcnt$result$userName,
    "firstName" = getcnt$result$firstName,
    "lastName" = getcnt$result$lastName,
    "email" = getcnt$result$email
  )

}
