#' upload_graphic imports a survey based on a loacl survey file
#' @param libraryId the name of the survey where to import responses
#' @param filename Name of the graphic
#' @param filePath Path to the file to import
#' @param type image/jpeg, image/gif, image/png
#' @param folder The folder where the graphic will be located
#' @examples
#' \dontrun{upload_graphic("SV_012345678912345", "./data.csv", "CSV")}
#' @return the id of the uploaded graphic
#' @export
upload_graphic <- function(
  libraryId,
  filename,
  filePath,
  type,
  folder = NULL) {

  params <- c("libraries",libraryId,"graphics")

  my_body <- c(
    file = upload_file(filePath),
    "filename" = filename,
    "type" = type,
    "folder" = ifelse(!is.null(folder), folder, NULL)
  )

  token_header <- .get_token()

  getcnt <- POST(
    .build_url(params),
    token_header,
    encode = "multipart",
    body = my_body
  )

  #getcnt <- .qualtrics_post(params, NULL, body)


  return(getcnt)

}

#' upload_graphic_fromurl imports a survey based on a loacl survey file
#' @param libraryId the name of the survey where to import responses
#' @param name Name of the graphic
#' @param fileUrl URL to the file to import
#' @param contentType image/jpeg, image/gif, image/png
#' @param folder The folder where the graphic will be located
#' @examples
#' \dontrun{upload_graphic("SV_012345678912345", "./data.csv", "CSV")}
#' @return the id of the uploaded graphic
#' @export
upload_graphic_fromurl <- function(
  libraryId,
  name,
  fileUrl,
  contentType,
  folder = NULL) {

  params <- c("libraries",libraryId,"graphics")

  my_body <- c(
    file = upload_file(fileUrl),
    "name" = name,
    "type" = contentType,
    "folder" = ifelse(!is.null(folder), folder, NULL)
  )

  token_header <- .get_token()

  getcnt <- POST(
    .build_url(params),
    token_header,
    encode = "multipart",
    body = my_body
  )

  #getcnt <- .qualtrics_post(params, NULL, body)


  return(getcnt)

}

#' delete_graphic retrieves a full survey object
#' @param libraryId the distribution id
#' @param graphicId the distribution id
#' @examples
#' \dontrun{delete_graphic("UR_6xMwYO5zW4FklUh", "IM_6s1QFALhGhB8zVr")}
#' @return A status code
#' @export
delete_graphic <- function(libraryId, graphicId) {

  params <- c("libraries", libraryId, "graphics", graphicId)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  return(getcnt$meta$httpStatus)

}

