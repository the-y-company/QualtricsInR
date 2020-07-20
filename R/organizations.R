#' Retrieve general information about an organization
#'
#' @description 
#' The organization is also called the brand. It is shown when you hover the mouse over the person icon at the top of your organization's qualtrics.com screen.
#' 
#' @note 
#' To use this call you must be a Qualtrics brand administrator
#' 
#' @param organization_id is the name of the organization
#'
#' @examples
#' \dontrun{get_organization_information("my organization")}
#'
#' @return A list.
#' @export
get_organization_information <- function(organization_id) {
  params <- c("organizations", gsub(" ", "%20", organization_id))
  .qualtrics_get(params)
}
