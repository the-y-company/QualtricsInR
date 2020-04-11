#' List all available libraries in the account
#'
#' @example
#' \dontrun{
#'  list_libraries()
#' }
#' @return A \code{list}.
#' @export
list_libraries <- function() {

  .build_libraries <- function(lst) {
    
    do.call(
      dplyr::bind_rows,
      lapply(
        lst,
        function(x) {
          dplyr::tibble(
            "libraryId" = .replace_na(x$libraryId),
            "libraryName" = .replace_na(x$libraryName)
          )
        }
    ))}

  offset <- 0
  getcnt <- .qualtrics_get("libraries", NULL, "offset" = offset)

  if (length(getcnt$result)>0) {
    df <- .build_libraries(getcnt$result$elements)
  
    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("libraries", NULL, "offset" = offset)
      df <- rbind(df,.build_libraries(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

}

#' Lists the library blocks for the caller of this API.
#'
#' @param library_id the library id (see 'list_libraries')
#' 
#' @example
#' \dontrun{
#'  list_library_blocks("UR_0NXtl92JJWqfWcJ")
#' }
#' @return A \code{list}.
#' @export
list_library_blocks <- function(library_id) {

  .build_library_blocks <- function(lst) {
    
    lst_names <- do.call(rbind,lapply(lst, function(x) tibble(directory = names(x))))

    i <- 1

    do.call(
      bind_rows,
      apply(
        lst_names,
        1,
        function(x) {
          
          dplyr::tibble(
            "dir_name" = as.character(x),
            "library_block_id" = names(lst[[i]][[as.character(x)]]),
            "library_block_name" = unlist(lst[[i]][[as.character(x)]])
          )

          i <<- i+1
        }
    ))
    
    }

  offset <- 0
  params <- c("libraries", library_id, "survey", "blocks")
  getcnt <- .qualtrics_get(params, NULL, "offset" = offset)

  if (length(getcnt$result)>0) {
    df <- .build_library_blocks(getcnt$result$elements)
  
    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, NULL, "offset" = offset)
      df <- rbind(df,.build_library_blocks(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

}
