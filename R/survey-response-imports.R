#' start_response_import imports a survey based on a loacl survey file
#' @param surveyId the name of the survey where to import responses
#' @param format default CSV Allowed values are CSV or TSV
#' @param filePath The URL of the import file. Only HTTP and HTTPS URLs are supported. The largest file you can import is limited to 5 MB.
#' @param charset Allowed values are UTF-8 or UTF-16
#' @examples
#' \dontrun{start_response_import("SV_012345678912345", "./data.csv", "CSV")}
#' @return A status code
#' @export
start_response_import <- function(surveyId, filePath, format="CSV", charset="UTF-8") {

  params <- c("surveys",surveyId,"import-responses")
  e_format <- "text/csv"
  if (format=="TSV") e_format <- "text/tsv"

  my_header <- c(
    "Content-Type" = e_format,
    "charset" = charset
  )

  postreq <- POST(
    .build_url(params),
    .get_token(),
    body = list(
      file = upload_file(filePath)
    ),
    add_headers(
      .headers = my_header
    )
  )

  content(postreq$result)

}

#' start_response_import_url imports a survey based on a loacl survey file
#' @param surveyId the name of the survey where to import responses
#' @param format default CSV Allowed values are CSV or TSV
#' @param fileUrl The URL of the import file. Only HTTP and HTTPS URLs are supported. The largest file you can import is limited to 5 MB.
#' @param charset Allowed values are UTF-8 or UTF-16
#' @examples
#' \dontrun{start_response_import_url("SV_012345678912345", "./data.csv", "CSV")}
#' @return A \code{list}
#' @export
start_response_import_url <- function(surveyId, fileUrl, format="CSV", charset="UTF-8") {

  params <- c("surveys",surveyId,"import-responses")
  e_format <- "text/csv"
  if (format=="TSV") e_format <- "text/tsv"

  my_body <- list(
    "format" = e_format,
    "fileUrl" = fileUrl
  )

  postreq <- POST(
    .build_url(params),
    .get_token(),
    body = my_body
  )

  content(postreq$result)

}

#' start_response_import_url imports a survey based on a loacl survey file
#' @param surveyId the name of the survey where to import responses
#' @param progressId id of the response import
#' @examples
#' \dontrun{start_response_import_url("SV_1873930DS2", "11-00-22")}
#' @return A \code{list}
#' @export
get_response_import_progress <- function(surveyId, progressId) {

  params <- c("surveys", surveyId, "import-responses", progressId)
  getcnt <- .qualtrics_get(params, NULL, NULL)

  content(getcnt$result)

}

