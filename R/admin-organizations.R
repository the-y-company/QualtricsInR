#' get_organization retrieves organization level information
#' @examples
#' \dontrun{get_organization()}
#' @return A \code{data.frame}.
get_organization <- function() {
  params <- c("organizations","World%20Economic%20Forum%20Global")
  getcnt <- .qualtrics_get(params)
}
