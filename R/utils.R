
globalVariables(
	c(
		".",
    "token",
		"success",
		"surveyIds",
    "contact_id"
	)
)

#' @importFrom httr content upload_file parse_url POST GET DELETE PUT add_headers 
#' @importFrom httr content_type_json status_code build_url write_disk authenticate
#' @importFrom httr stop_for_status
#' @importFrom dplyr bind_rows filter tibble
#' @importFrom purrr discard map_df map_chr
#' @importFrom stringr str_sub str_sub
#' @importFrom stringi stri_rand_strings
#' @importFrom utils unzip txtProgressBar
#' @importFrom readr read_csv cols read_tsv
#' @importFrom jsonlite fromJSON
#' @importFrom crayon blue green yellow red
#' @importFrom cli symbol

.replace_na <- function(x) {
  ifelse(is.null(x), NA, x)
}

.na20 <- function(x) {
  ifelse(is.na(x), 0, x)
}

.check_directory <- function(dir) {

  if (str_sub(dir, start="-1") != "/") {
    dir <- paste0(dir,"/")
  }
  if (!dir.exists(dir)) {
    stop(paste0("wrong directory path ",dir), call. = FALSE)
  }

  return(dir)
}

.build_url <- function(params, ...) {
  url <- parse_url(.get_url())
  url$scheme <- "https"
  url$path <- c("API", "v3", params)
  url$query <- list(...)
  build_url(url)
}

#' Construct Token Object
#' Constructs and object for print method
#' @param token A list.
#' @keywords internal
.construct_oauth <- function(token) {
  structure(token, class = c("list", "quatrics_token"))
}

#' Encrypt and Decrypt token
#' Encrypt and decrypt for security, not saving plain credentials to file.
#' @param token A list.
#' @rdname encryption
#' @keywords internal
.encrypt <- function(token) {
  token$access_token <- charToRaw(token$access_token)
  token$id <- charToRaw(token$id)
  token$secret <- charToRaw(token$secret)
  token$data_center <- charToRaw(token$data_center)
  token$url <- charToRaw(token$url)
  return(token)
}

#' @keywords internal
#' @rdname encryption
.decrypt <- function(token) {
  token$access_token <- rawToChar(token$access_token)
  token$id <- rawToChar(token$id)
  token$secret <- rawToChar(token$secret)
  token$data_center <- rawToChar(token$data_center)
  token$url <- rawToChar(token$url)
  return(token)
}

#' Check if token file is in working directory
.check_token_file <- function() {
  token_file <- ".qualtrics-oauth"

  if(!file.exists(token_file))
    stop("no ", token_file, " file in working directory", call. = FALSE)
}

#' Load credentials file
.get_token_file <- function() {
  get(load(".qualtrics-oauth"))
}

#' Convenience function
#' Fetches option.
#' @param opts Name of option.
#' @details \code{.get_url} and \code{.get_data_center} are simple convenience
#' as these are used often.
#' @keywords internal
#' @rdname options
.get_opts <- function(opts = NULL) {
  getOption(opts)
}

#' @keywords internal
#' @rdname options
.get_url <- function() {
  .get_opts("QUALTRICS_BASE_URL")
}

#' @keywords internal
#' @rdname options
.get_data_center <- function() {
  .get_opts("QUALTRICS_DATA_CENTER")
}

INVALID_TOKEN <- "Invalid token, see `set_qualtrics_opts`"

#' Get Token
#' Gets token from options.
#' @details If \code{timeout} options is found then assesses whether refresh is required.
#' Note that we remove one minute from the current time to allow for small time differences between
#' token being fetched and call being made.
#' @keywords internal
.get_token <- function(){

  token <- .get_opts("QUALTRICS_API_TOKEN")
  refresh <- FALSE # defaults to FALSE
  timeout <- .get_opts("QUALTRICS_TOKEN_TIMEOUT")

  if(!is.null(timeout)) {
    if(timeout < Sys.time() - 60) refresh <- TRUE
  }

  if(isTRUE(refresh)){
    refresh_oauth()
    token <- .get_opts("QUALTRICS_API_TOKEN")
  }

  if(is.null(token))
    stop(INVALID_TOKEN, call. = FALSE)

  if(is.null(timeout)) {
    token <- add_headers(`x-api-token` = token)
  } else {
    token <- add_headers("authorization" = paste("bearer", token))
  }

  return(token)
}

.catch_token_error <- function(obj){
  if(inherits(obj, "error"))
    if(isTRUE(obj[1] == INVALID_TOKEN))
      stop(INVALID_TOKEN, call. = FALSE)

  invisible()
}

# Print http error message
.qualtrics_http_errors <- function(resp) {
  stop(paste0(
    "call returned HTTP status \"",
    resp$meta$httpStatus,
    "\" with message \"", 
    resp$meta$error$errorMessage,"\""),
    call. = FALSE)
}

.qualtrics_get <- function(params, ...) {

  token_header <- .get_token()

  postreq <- GET(
    .build_url(params, ...),
    token_header
  )

  if (status_code(postreq)!="200") {
    .qualtrics_http_errors(content(postreq))
  }

  content(postreq)
}

.qualtrics_export <- function(params, dir) {

  token_header <- .get_token()

  postreq <- GET(
    .build_url(params),
    token_header,
    write_disk(dir, overwrite = TRUE)
  )

  if (status_code(postreq)!="200") {
    .qualtrics_http_errors(content(postreq))
  }

  status_code(postreq)
}

.qualtrics_post <- function(params, my_header, my_body, my_enc = "json") {

  token_header <- .get_token()

  postreq <- POST(
    .build_url(params),
    token_header,
    content_type_json(),
    add_headers(
      .headers = my_header
    ),
    encode = my_enc,
    body = my_body
  )

  if (status_code(postreq)!="200") {
    .qualtrics_http_errors(content(postreq))
  }

  content(postreq)

}

.qualtrics_delete <- function(params, my_header, my_body) {

  token_header <- .get_token()

  postreq <- DELETE(
    .build_url(params),
    token_header,
    add_headers(
      .headers = my_header
    ),
    encode = "json",
    body = my_body
  )

  if (status_code(postreq)!="200") {
    .qualtrics_http_errors(content(postreq))
  }

  content(postreq)
}

.qualtrics_put <- function(params, my_header, my_body) {

  token_header <- .get_token()

  postreq <- PUT(
    .build_url(params),
    token_header,
    add_headers(
      .headers = my_header
    ),
    encode = "json",
    body = my_body
  )

  if (status_code(postreq)!="200") {
    .qualtrics_http_errors(content(postreq))
  }

  content(postreq)

}


