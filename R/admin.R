#' get_organization retrieves organization level information
#' @examples
#' \dontrun{get_organization()}
#' @return A \code{data.frame}
#' @export
get_organization <- function() {
  params <- c("organizations","World%20Economic%20Forum%20Global")
  getcnt <- .qualtrics_get(params)
}

#' Create a new division
#'
#' @param name group id
#' @param division_admins A list of of user ids to make division admins
#' @param permissions A list defining the division permissions.
#'
#' @description
#' When setting permissions, any permissions left undefined will be enabled by
#' default. If no permissions are included at all, then a default set of
#' predefined permissions will be used. If a division permission is disabled at
#' the organization level, then it will be disabled at the division level
#' regardless of its state.
#'
#' @examples
#' \dontrun{create_division("DV_1234567890AbCdE")}
#' @return The id of the created division
#' @export
create_division <- function(name, division_admins = NULL, permissions = NULL) {

  body <- list(
    "name" = name,
    "divisionAdmins" = division_admins,
    "permissions" = permissions
  )

  getcnt <- .qualtrics_get("divisions", NULL, NULL)
  getcnt$result$id
}

#' Retrieve a given division
#'
#' @param division_id group id
#'
#' @examples
#' \dontrun{get_division("DV_1234567890AbCdE")}
#' @return A \code{list} of division definition parameters
#' @export
get_division <- function(division_id) {
  params <- c("divisions", division_id)
  getcnt <- .qualtrics_get(params, NULL, NULL)
  getcnt$result
}

#' Update a division's settings
#'
#' @param division_id id of the division to update
#' @param name New division name
#' @param status New status of the division, can be "Active", "Disabled"
#' @param permissions JSON object with permissions to update
#'
#' @examples
#' \dontrun{update_division("DV_1234567890AbCdE")}
#' @return id of created message
#' @export
update_division <- function(
  division_id,
  name = NULL,
  status = NULL,
  permissions = NULL) {

  params <- c("groups", division_id)

  body <- list(
    "name" = name,
    "status" = status,
    "permissions" = permissions
  )

  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus

}


#' List all existing groups for the organization
#'
#' @examples
#' \dontrun{list_groups()}
#' @return A \code{tibble} of available groups.
#' @export
list_groups <- function() {

  .build_groups <- function(list) {
    df <- purrr::map_df(
      list, function(x) {
        dplyr::tibble(
          "id" = .replace_na(x$id),
          "name" = .replace_na(x$name)
        )
      })
  }

  offset <- 0
  getcnt <- .qualtrics_get("groups", "offset" = offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_groups(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("groups", "offset"=offset)
      df <- rbind(df,.build_groups(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }


}

#' Create a new group
#'
#' @param type Group Type. Currently this is a GAP as you cannot create group
#'   types with an API nor look them up. But you need that to create a Group.
#' @param name Name of group to be created
#' @param division_id default NULL but specific division id can be specified
#' @return id of newly created group
create_group <- function(
  type,
  name,
  division_id = NULL) {

  body <- list(
    "type" = type,
    "name" = name,
    "divisionId" = ifelse(!is.null(division_id), division_id, NULL)
  )

  getcnt <- .qualtrics_post("groups", NULL, body)
  getcnt$result$id

}

#' Retrieve group information
#'
#' @param group_id group id
#'
#' @examples
#' \dontrun{update_group("GR_1234567890AbCdE")}
#' @return A \code{list} of group definition parameters
#' @export
get_group <- function(group_id) {
  params <- c("groups", group_id)
  getcnt <- .qualtrics_get(params, NULL, NULL)
  getcnt$result
}

#' Update group's definition parameters
#'
#' @param group_id id of group to update
#' @param type new group type
#' @param name new name of the group to update
#' @param division_id default NULL but specific division id can be specified to
#'   automatically assign the division properties
#' @examples
#' \dontrun{update_group("GR_1234567890AbCdE", name = "New Name")}
#' @return A status execution code
update_group <- function(
  group_id,
  type = NULL,
  name = NULL,
  division_id = NULL) {

  params <- c("groups", group_id)

  body <- list(
    "type" = type,
    "name" = name,
    "divisionId" = ifelse(!is.null(division_id), division_id, NULL)
  )

  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus

}

#' Delete a group
#'
#' @param group_id id of the group to delete
#' @examples
#' \dontrun{delete_group("GR_1234567890AbCdE")}
#' @return A status execution code
delete_group <- function(group_id) {
  params <- c("groups", group_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  getcnt$meta$httpStatus
}

#' Add a new user to a given group
#'
#' @param group_id group id
#' @param user_id id of the user account to add to a group
#' @examples
#' \dontrun{add_user_group("GR_1234567890AbCdE", "UR_1234567890AbCdE")}
#' @return A status code
#' @export
add_user_group <- function(group_id, user_id) {
  params <- c("groups", group_id, "members")
  body <- list("userId" = user_id)
  getcnt <- .qualtrics_post(params, NULL, body)
  getcnt$meta$httpStatus
}

#' Remove a user from a given group
#'
#' @param group_id group id
#' @param user_id id of the user account to remove from the group
#' @examples
#' \dontrun{remove_user_group("GR_1234567890AbCdE", "UR_1234567890AbCdE")}
#' @return A status code
remove_user_group <- function(group_id, user_id) {
  params <- c("groups", group_id, "members",user_id)
  getcnt <- .qualtrics_delete(params, NULL)
  getcnt$meta$httpStatus
}

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
