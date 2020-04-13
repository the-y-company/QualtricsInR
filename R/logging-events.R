
#' Retrieve the type of logging (activity) events
#'
#' @examples
#' \dontrun{get_activity_type()}
#' @return A \code{list} with the mailing list information
#' @export
get_activity_type <- function() {
  params <- list("logs", "activitytypes")
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Retrieve the type of logging (activity) events
#'
#' @param activity_name Name of activity to retrieve.
#' @examples
#' \dontrun{get_activity_log("session_creations")}
#' @return A \code{list} with the mailing list information
#' @export
get_activity_log <- function(activity_name) {

  offset <- 0
  params <- list("logs")
  getcnt <- .qualtrics_get(params, "activityType" = activity_name, "offset" = offset)

  if (length(getcnt$result$elements)>0) {

    total_list_actions <- getcnt$results

    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      #cat(blue("Retrieved",length(getcnt$result$elements),"elements --> offset",offset,"\n"))
      getcnt <- .qualtrics_get(params, "activityType" = activity_name, "offset" = offset)
      total_list_actions <- c(total_list_actions, getcnt$result)
    }

    return(total_list_actions)
  } else {
    return(NULL)
  }
}
