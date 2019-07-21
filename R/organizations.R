#' get_organization retrieves organization level information
#'
#' @param organization_id is the name of the organization
#'
#' @examples
#' \dontrun{get_organization("example organization")}
#'
#' @return A list.
#' @export
get_organization <- function(organization_id) {
  params <- c("organizations",gsub(" ", "%20", organization_id))
  .qualtrics_get(params)
}
