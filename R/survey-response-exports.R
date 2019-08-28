
.build_temp_dir <- function() {
  tmpDir <- tempdir()
  tmpFil <- paste0(
    tmpDir,
    ifelse(
      substr(tmpDir, nchar(tmpDir), nchar(tmpDir)) == "/",
      "temp.zip",
      "/temp.zip"))

  return(list(tmpDir, tmpFil))
}

.get_export_status <- function(surveyId, exportId) {
  params <- c("surveys",surveyId,"export-responses",exportId)
  getresp <- .qualtrics_get(params, NULL, NULL)
  return(c(getresp$result$status,getresp$result$percentComplete,getresp$result$fileId))
}

.get_export_file <- function(surveyId, fileId, fileType, saveDir, filename) {

  tmps <- .build_temp_dir()
  params <- c("surveys",surveyId,"export-responses",fileId,"file")
  status <- .qualtrics_export(params, tmps[[2]])
  file <- utils::unzip(tmps[[2]], exdir = tmps[[1]])

  if (fileType=="json") {
    data <- jsonlite::fromJSON(file)
  }
  else if (fileType=="csv") {
    data <- readr::read_csv(file, col_types = readr::cols())
  }
  else if (fileType=="tsv") {
    data <- readr::read_tsv(file)
  }

  if (!is.null(saveDir)) {
    if (is.null(filename)) {
      file.copy(file, paste0(saveDir,surveyId,".",fileType))
    }
    else {
      file.copy(file, paste0(saveDir,filename,".",fileType))
    }
    cat(paste0("Survey was saved as ", saveDir, surveyId, ".", fileType), "\n")
  }

  file.remove(tmps[[2]])
  file.remove(file)
  return(data)
}

#' Export a survey's responses into R
#'
#' @description
#' Export survey responses into R and/or save exported file. Currently single
#' exports calls are limited to 1.8 GB. Above that size, we recommend you split
#' your export accross different date ranges. When exporting a large number of
#' surveys successively, we recommend using the more efficient \code{request_downloads} and
#' \code{download_requested} functions.
#'
#' @param survey_id the id of survey to copy
#' @param format file format json, by default (can be csv or tsv). We don't provide SPSS yet.
#' @param verbose default FALSE
#' @param saveDir path to a local directory to save the exported file. Default is a temporary file in rds format that is removed at the end of your session. Default name will be the surveyId.
#' @param filename specify filename for saving. If NULL, uses the survey id
#' @param ... a list of named parameters, see \url{https://api.qualtrics.com/reference} *Create Response Export* for parameter names
#' @examples
#' \dontrun{get_survey_responses("SV_012345678901234", "csv")}
#' \dontrun{get_survey_responses("SV_012345678901234", format = "csv", verbose = TRUE, saveDir = "./", filename = "name_export", useLabels = TRUE, limit = 10)}
#'
#' @return A status code
#' @export
get_survey_responses <- function(
  survey_id,
  format = "json",
  verbose = FALSE,
  saveDir = NULL,
  filename = NULL,
  ...) {

  # Check input parameters
  if (!is.null(saveDir)) saveDir <- .check_directory(saveDir)

  # Step 1: Creating Data Export
  params <- c("surveys", survey_id, "export-responses")
  body <- list("format" = format, ...)
  getcnt <- .qualtrics_post(params, NULL, body)

  # Step 2: Checking on Data Export Progress and waiting until export is ready

  if (verbose) pbar <- utils::txtProgressBar(min=0, max=100, style = 3)

  progressVec <- .get_export_status(survey_id, getcnt$result$progressId)
  while(progressVec[1] != "complete" & progressVec[1]!="failed") {
    progressVec <- .get_export_status(survey_id, getcnt$result$progressId)
    Sys.sleep(2)
  }

  if (verbose) close(pbar)

  #step 2.1: Check for error
  if (progressVec[1]=="failed")
    stop("export failed", call. = FALSE)

  # Step 3: Downloading file
  data <- .get_export_file(survey_id, progressVec[3], format, saveDir, filename)

  return(data)

}


#' @export
print.qualtrics_download <- function(x,...){
  counts <- table(x$success)
  t <- unname(counts["TRUE"])
  f <- unname(counts["FALSE"])
  cat(
    "Download Requests:\n",
    crayon::green(cli::symbol$tick), .na20(t), " Successful\n",
    crayon::red(cli::symbol$cross), .na20(f), " Unsuccessful\n"
  )
}

#' Success?
#'
#' Check which request was successful and which was not.
#'
#' @inheritParams bulk-download
#'
#' @examples
#' requests <- request_downloads(c(1,2))
#' success <- is_success(requests, TRUE)
#'
#' @name is_success
#' @export
is_success <- function(requests, verbose = FALSE) UseMethod("is_success")

#' @rdname is_success
#' @method is_success qualtrics_download
#' @export
is_success.qualtrics_download <- function(requests, verbose = FALSE){
  ids <- requests %>%
    mutate(
      surveyIds = ifelse(success == TRUE, crayon::green(surveyIds), crayon::red(surveyIds))
    ) %>%
    pull(surveyIds)

  if(isTRUE(verbose))
    ids %>%
    paste0(collapse = "\n") %>%
    cat("\n")

  class(requests) <- "data.frame"
  return(requests)
}

#' Request downloads
#'
#' Request survey response downloads.
#'
#' @param surveyIds A vector of survey ids.
#' @inheritParams get_survey_responses
#' @param requests Requests, as returned by \code{request_downloads}
#' @param ... Any other option.
#'
#' @details The \href{https://www.qualtrics.com}{Qualtrics} API takes some time to prepare a downloads, hence
#' \code{\link{download_requested}} taking a some time to download the requested data. What actually happens
#' is that first a download is \emph{requested}, after the request Qualtrics prepares a file that
#' \code{\link{download_requested}} downloads when it is ready. It is therefore more efficient,
#' when the user wants to download data from multiple surveys, more efficient to request each and every
#' download before checking whether they are ready. Those performances will headvily depend on the number
#' of surveys and the amount of data the ultimately user wants to obtain.
#'
#' @section Functions:
#' \itemize{
#'   \item{\code{request_downloads}: Request download (prepares files).}
#'   \item{\code{download_requested}: Download requested files.}
#' }
#'
#' @examples
#' (requests <- request_downloads(c(1,2)))
#' data <- download_requested(requests)
#'
#' @return A \code{request_downloads} returns object of class \code{qualtrics_download} while
#' \code{download_requested} returns a \code{list}.
#' @importFrom methods new
#' @import dplyr
#' @name bulk-download
#' @export
request_downloads <- function(surveyIds) {
  if(missing(surveyIds))
    stop("missing surveyIds", call. = FALSE)

  requests <- purrr::map(
    surveyIds,
    function(x){
      params <- c("surveys", x, "export-responses")
      body <- list(format = "csv")
      resp <- tryCatch(
        .qualtrics_post(params, NULL, body),
        error = function(e) e
      )

      # convert to logical
      if(inherits(resp, "error"))
        FALSE
      else
        TRUE
    }
  ) %>%
    unlist()

  structure(
    tibble(surveyIds = surveyIds, success = requests),
    class = c("qualtrics_download", "data.frame")
  )
}

#' @rdname bulk-download
#' @export
download_requested <- function(
  requests,
  format = "csv",
  saveDir = NULL,
  verbose = FALSE,
  ...
){
  UseMethod("download_requested")
}

#' @rdname bulk-download
#' @method download_requested qualtrics_download
#' @export
download_requested.qualtrics_download <- function(
  requests,
  format = "csv",
  saveDir = NULL,
  verbose = FALSE,
  ...
){

  # Check input parameters
  if (!is.null(saveDir)) saveDir <- .check_directory(saveDir)

  valid <- requests %>%
    filter(success == TRUE)

  invalid <- requests %>%
    anti_join(valid, by = "surveyIds")

  if(nrow(invalid))
    cat(
      crayon::red(cli::symbol$cross),
      "Not downloading unsuccessful surveyIds:\n",
      paste0(invalid$surveyIds, collapse = "\n"), "\n"
    )

  data <- purrr::map(
    valid$surveyIds,
    function(surveyId, format, verbose, ...){
      # Step 1: Creating Data Export
      params <- c("surveys",surveyId,"export-responses")
      body <- list(format = "csv", ...)
      getcnt <- .qualtrics_post(params, NULL, body)

      # Step 2: Checking on Data Export Progress and waiting until export is ready

      if (verbose) pbar <- utils::txtProgressBar(min = 0, max = 100, style = 3)

      progressVec <- .get_export_status(surveyId, getcnt$result$progressId)
      while(progressVec[1] != "complete" & progressVec[1]!="failed") {
        progressVec <- .get_export_status(surveyId, getcnt$result$progressId)
        Sys.sleep(2)
      }

      if (verbose) close(pbar)

      #step 2.1: Check for error
      if (progressVec[1]=="failed")
        stop("export failed", call. = FALSE)

      # Step 3: Downloading file
      data <- .get_export_file(surveyId, progressVec[3], format, saveDir, NULL)

      return(data)
    },
    format = format,
    verbose = verbose,
    ...
  )

  names(data) <- valid$surveyIds

  return(data)
}
