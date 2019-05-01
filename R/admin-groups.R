
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
