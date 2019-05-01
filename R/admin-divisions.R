
#' Create a new division
#'
#' @param name group id
#' @param division_admins A JSON array array of user ids to make division admins
#' @param permissions JSON object defining the division permissions.
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
