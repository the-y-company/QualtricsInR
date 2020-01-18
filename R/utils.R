
globalVariables(
	c(
		".",
    "token",
		"success",
		"surveyIds"
	)
)

# VALID_ENDPOINTS <- c(
#   "organizations",
#   "divisions",
#   "groups",
#   "users",
#   "surveys",
#   "sessions",
#   "responseexports",
#   "responses",
#   "responseimports",
#   "libraries",
#   "distributions",
#   "mailinglists",
#   "index_edition_series_tree",
#   "index_edition_data",
#   "eventsubscriptions",
#   "op-erase-personal-data"
#   )

.replace_na <- function(x) {
  ifelse(is.null(x), NA, x)
}

.na20 <- function(x) {
  ifelse(is.na(x), 0, x)
}

.check_directory <- function(dir) {

  if (stringr::str_sub(dir, start="-1") != "/") {
    dir <- paste0(dir,"/")
  }
  if (!dir.exists(dir)) {
    stop(paste0("wrong directory path ",dir), call. = FALSE)
  }

  return(dir)
}

.build_url <- function(params, ...) {
  url <- httr::parse_url(.get_url())
  url$scheme <- "https"
  url$path <- c("API", "v3", params)
  url$query <- list(...)
  httr::build_url(url)
}

#' Construct Token Object
#' Constructs and object for print method
#' @param token A list.
.construct_oauth <- function(token) {
  structure(token, class = c("list", "quatrics_token"))
}

#' Encrypt and Decrypt token
#' Encrypt and decrypt for security, not saving plain credentials to file.
#' @param token A list.
#' @rdname encryption
.encrypt <- function(token) {
  token$access_token <- charToRaw(token$access_token)
  token$id <- charToRaw(token$id)
  token$secret <- charToRaw(token$secret)
  token$data_center <- charToRaw(token$data_center)
  token$url <- charToRaw(token$url)
  return(token)
}

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
#' @rdname options
.get_opts <- function(opts = NULL) {
  getOption(opts)
}

#' @rdname options
.get_url <- function() {
  .get_opts("QUALTRICS_BASE_URL")
}

#' @rdname options
.get_data_center <- function() {
  .get_opts("QUALTRICS_DATA_CENTER")
}

#' Get Token
#' Gets token from options.
#' @details If \code{timeout} options is found then assesses whether refresh is required.
#' Note that we remove one minute from the current time to allow for small time differences between
#' token being fetched and call being made.
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

  if(is.null(timeout)) {
    token <- httr::add_headers(`x-api-token` = token)
  }
  else {
    token <- httr::add_headers("authorization" = paste("bearer", token))
  }

  return(token)
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

  postreq <- httr::GET(
    .build_url(params, ...),
    token_header
  )

  if (httr::status_code(postreq)!="200") {
    .qualtrics_http_errors(httr::content(postreq))
  }

  httr::content(postreq)
}

.qualtrics_export <- function(params, dir) {

  token_header <- .get_token()

  postreq <- httr::GET(
    .build_url(params),
    token_header,
    httr::write_disk(dir, overwrite = TRUE)
  )

  if (httr::status_code(postreq)!="200") {
    .qualtrics_http_errors(httr::content(postreq))
  }

  httr::status_code(postreq)
}

.qualtrics_post <- function(params, my_header, my_body, my_enc = "json") {

  token_header <- .get_token()


  postreq <- httr::POST(
    .build_url(params),
    token_header,
    httr::content_type_json(),
    httr::add_headers(
      .headers = my_header
    ),
    encode = my_enc,
    body = my_body
  )

  if (httr::status_code(postreq)!="200") {
    .qualtrics_http_errors(httr::content(postreq))
  }

  httr::content(postreq)

}

.qualtrics_delete <- function(params, my_header, my_body) {

  token_header <- .get_token()

  postreq <- httr::DELETE(
    .build_url(params),
    token_header,
    httr::add_headers(
      .headers = my_header
    ),
    encode = "json",
    body = my_body
  )

  if (httr::status_code(postreq)!="200") {
    .qualtrics_http_errors(httr::content(postreq))
  }

  httr::content(postreq)
}

.qualtrics_put <- function(params, my_header, my_body) {

  token_header <- .get_token()

  postreq <- httr::PUT(
    .build_url(params),
    token_header,
    httr::add_headers(
      .headers = my_header
    ),
    encode = "json",
    body = my_body
  )

  if (httr::status_code(postreq)!="200") {
    .qualtrics_http_errors(httr::content(postreq))
  }

  httr::content(postreq)

}


