#' Create a new division
#'
#' @param name the division name
#' @param division_admins A JSON array of user ids to make division admins
#' @param permissions A JSON object defining the division permissions.
#'
#' @description
#' When setting permissions, any permissions left undefined will be enabled by
#' default. If no permissions are included at all, then a default set of
#' predefined permissions will be used. If a division permission is disabled at
#' the organization level, then it will be disabled at the division level
#' regardless of its state.
#'
#' @examples
#' \dontrun{create_division("newdivision", "DV_1234567890AbCdE")}
#' \dontrun{
#' admins <- list("UR_1234567890AbCdE", "UR_1234567890AbCdS")
#' create_division("newdivision", "DV_1234567890AbCdE", admins)
#' }
#' @return The id of the created division
#' @export
create_division <- function(name, division_admins = NULL, permissions = NULL) {

  body <- list(
    "name" = name,
    "divisionAdmins" = division_admins,
    "permissions" = permissions
  )

  getcnt <- .qualtrics_post("divisions", NULL, body)
  getcnt$result$id
}

#' Returns general information about a division
#'
#' @param division_id the division id
#'
#' @examples
#' \dontrun{get_division("DV_1234567890AbCdE")}
#'
#' @return A \code{list} of division definition parameters
#' @export
get_division <- function(division_id) {
  params <- c("divisions", division_id)
  getcnt <- .qualtrics_get(params, NULL, NULL)
  getcnt$result
}

#' Update a division's settings
#'
#' @param division_id the id of the division to update
#' @param name the new division name
#' @param status the new status of the division, can be "Active", "Disabled"
#' @param permissions a JSON object with permissions to update
#'
#' @examples
#' \dontrun{update_division("DV_1234567890AbCdE", name = "newdivisionname")}
#' \dontrun{
#' perms <- list(
#' "controlPanel" = list(
#'   "surveyPermissions" = list(
#'     "editSurveyFlow" = list("state" = "off"))))
#' update_division("DV_1234567890AbCdE", permissions = perms)
#' }
#'
#' @return id of created message
#' @export
update_division <- function(
  division_id,
  name = NULL,
  status = NULL,
  permissions = NULL) {

  params <- c("divisions", division_id)

  body <- list(
    "name" = name,
    "status" = status,
    "permissions" = permissions
  )

  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus

}
