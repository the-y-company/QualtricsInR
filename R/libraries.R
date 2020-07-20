#' List all available libraries in the account
#'
#' @examples
#' \dontrun{
#'  list_libraries()
#' }
#' @return A \code{list}.
#' @export
list_libraries <- function() {

  .build_df <- function(list) {
    df <- map_df(
      list, function(x) {
        tibble(
          "libraryId" = .replace_na(x$libraryId),
          "libraryName" = .replace_na(x$libraryName)
        )
      })}

  offset <- 0
  getcnt <- .qualtrics_get("libraries", NULL, "offset" = offset)

  if (length(getcnt$result)>0) {
    df <- .build_df(getcnt$result$elements)
  
    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("libraries", NULL, "offset" = offset)
      df <- rbind(df, .build_df(getcnt$result$elements))
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
#' @examples
#' \dontrun{
#'  list_library_blocks("UR_0NXtl92JJWqfWcJ")
#' }
#' @return A \code{tibble}
#' @export
list_library_blocks <- function(library_id) {

  .build_df <- function(lst) {
    
    lst_names <- do.call(rbind,lapply(lst, function(x) tibble(directory = names(x))))

    i <- 0

    do.call(
      bind_rows,
      apply(
        lst_names,
        1,
        function(x) {
          
          i <<- i+1

          tibble(
            "dir_name" = as.character(x),
            "library_block_id" = names(lst[[i]][[as.character(x)]]),
            "library_block_name" = unlist(lst[[i]][[as.character(x)]])
          )

        }
    ))
    
    }

  offset <- 0
  params <- c("libraries", library_id, "survey", "blocks")
  getcnt <- .qualtrics_get(params, NULL, "offset" = offset)

  if (length(getcnt$result)>0) {
    df <- .build_df(getcnt$result$elements)
  
    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, NULL, "offset" = offset)
      df <- rbind(df, .build_df(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

}

#' Lists the library questions for the caller of this API.
#'
#' @param library_id the library id (see 'list_libraries')
#' 
#' @examples
#' \dontrun{
#'  list_library_questions("UR_0NXtl92JJWqfWcJ")
#' }
#' @return A \code{tibble}
#' @export
list_library_questions <- function(library_id) {

  .build_df <- function(lst) {
    
    lst_names <- do.call(rbind,lapply(lst, function(x) tibble(directory = names(x))))

    i <- 0

    do.call(
      bind_rows,
      apply(
        lst_names,
        1,
        function(x) {
          
          i <<- i+1

          tibble(
            "dir_name" = as.character(x),
            "library_question_id" = names(lst[[i]][[as.character(x)]]),
            "library_question_name" = unlist(lst[[i]][[as.character(x)]])
          )

        }
    ))
    
    }

  offset <- 0
  params <- c("libraries", library_id, "survey", "questions")
  getcnt <- .qualtrics_get(params, NULL, "offset" = offset)

  if (length(getcnt$result)>0) {
    df <- .build_df(getcnt$result$elements)
  
    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, NULL, "offset" = offset)
      df <- rbind(df,.build_df(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

}

#' Lists the library surveys for the caller of this API.
#'
#' @param library_id the library id (see 'list_libraries')
#' 
#' @examples
#' \dontrun{
#'  list_library_surveys("UR_0NXtl92JJWqfWcJ")
#' }
#' @return A tibble
#' @export
list_library_surveys <- function(library_id) {

  .build_df <- function(lst) {
    
    lst_names <- do.call(rbind,lapply(lst, function(x) tibble(directory = names(x))))

    i <- 0

    do.call(
      bind_rows,
      apply(
        lst_names,
        1,
        function(x) {
          
          i <<- i+1

          tibble(
            "dir_name" = as.character(x),
            "library_survey_id" = names(lst[[i]][[as.character(x)]]),
            "library_survey_name" = unlist(lst[[i]][[as.character(x)]])
          )

        }
    ))
    
    }

  offset <- 0
  params <- c("libraries", library_id, "survey", "surveys")
  getcnt <- .qualtrics_get(params, NULL, "offset" = offset)

  if (length(getcnt$result)>0) {
    df <- .build_df(getcnt$result$elements)
  
    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, NULL, "offset" = offset)
      df <- rbind(df,.build_df(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

}


