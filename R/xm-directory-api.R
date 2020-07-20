#' List Directories for a Brand
#' 
#' @description 
#' Using this API, the client can retrieve a list of directories with summary information for each directory.
#' This API is paginated, but currently returns a single page of up to 5 results and a null next page token.
#' Pagination is handled automatically.
#'
#' @param page_size The maximum number of items to return per request (max and default is 5)
#' 
#' @examples
#' \dontrun{list_directory_contacts()}
#' 
#' @return A \code{tibble} of all mailing list with properties
#' @export
list_directory_contacts <- function(page_size = 5) {

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
  getcnt <- .qualtrics_get("directories", "pageSize" = page_size)

  if (length(getcnt$result$elements)>0) {
    df <- .build_list(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      skip_token <- as.character(getcnt$result$nextPage)
      getcnt <- .qualtrics_get("directories", "pageSize" = page_size, "skipToken" = skip_token)
      df <- rbind(df, .build_list(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }

  return(df)
}
