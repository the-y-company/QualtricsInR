#' List all directory contacts
#'
#' @examples
#' \dontrun{list_directory_contacts()}
#' @return A \code{tibble} of all mailing list with properties
list_directory_contacts <- function() {

  .build_list <- function(list) {
    map_df(
      list, function(x) {
        tibble(
          "directoryId" = .replace_na(x$directoryId),
          "name" = .replace_na(x$name),
          "contactCount" = .replace_na(x$contactCount),
          "isDefault" = .replace_na(x$isDefault),
          "deduplicationCriteria_firstName" = .replace_na(x$deduplicationCriteria$firstName),
          "deduplicationCriteria_lastName" = .replace_na(x$deduplicationCriteria$lastName),
          "deduplicationCriteria_email" = .replace_na(x$deduplicationCriteria$email),
          "deduplicationCriteria_phone" = .replace_na(x$deduplicationCriteria$phone),
          "deduplicationCriteria_externalDataReference" = .replace_na(x$deduplicationCriteria$externalDataReference)
        )})
  }

  offset <- 0
  getcnt <- .qualtrics_get("directories", "offset"=offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_list(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("directories", "offset" = offset)
      df <- rbind(df, .build_list(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }

  return(df)
}
