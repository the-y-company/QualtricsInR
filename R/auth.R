#' Authenticate
#'
#' Generate a Qualtrics token valid for an hour.
#'
#' @param api_token Your client id and generated token.
#' @param id,secret Your client id and secret.
#' @param data_center Your data center id, if \code{NULL} then the functions attempts to
#' get it from \code{\link{set_qualtrics_opts}}.
#' @param cache Whether to set the token as option (\code{\link{set_qualtrics_opts}})
#' and cache the results to file.
#'
#' @details Obtains a bearer token valid for an hour and saved it to the working
#' directory in a hidden file named \code{qualtrics-oauth}. Note that this token
#' will be automatically loaded in future sessions, and refreshed if needed.
#'
#' @section Functions:
#' \itemize{
#'   \item{\code{qualtrics_auth}: Authenticate.}
#'   \item{\code{load_oauth}: Load locally saved token.}
#'   \item{\code{refresh_oauth}: Refresh locally saved token.}
#'   \item{\code{set_qualtrics_opts}: Set \code{token} and \code{data_center} options.}
#' }
#'
#' @return if \code{cache} is \code{FALSE} then returns an object of class \code{quatrics_token}.
#'
#' @examples
#' \dontrun{
#'   # OAUth 2.0
#'   qualtrics_auth("xXxX0x0X0xxX0", "xXxX0x0X0xxX0", "data.center")
#'
#'   # Set token and data_center options
#'   set_qualtrics_opts("xXxX0x0X0xxX0xXxX0x0X0xxX0", "myCenter.eu")
#' }
#'
#' @rdname oauth
#' @export
qualtrics_auth <- function(id = Sys.getenv("QUALTRICSINR_ID"), 
  secret = Sys.getenv("QUALTRICSINR_SECRET"), 
  data_center = Sys.getenv("QUALTRICSINR_DATA_CENTER"), cache = TRUE){

  if(!nchar(id) >= 1)
    stop("missing id", call. = FALSE)

  if(!nchar(secret) >= 1)
    stop("missing secret", call. = FALSE)

  # if data_center not passed, attempts to fetch from general options
  if(!nchar(data_center) >= 1)
    stop("missing data_center", call. = FALSE)

  # get token
  resp <- POST(
    sprintf("https://%s.qualtrics.com/oauth2/token", data_center),
    authenticate(
      id, secret
    ),
    body = list(
      grant_type = "client_credentials"
    ),
    encode = "form"
  )

  stop_for_status(resp) # stop if error

  token <- content(resp)

  # append extra variables needed for refresh
  extras <- list(
    time = Sys.time(),
    secret = secret,
    id = id,
    data_center = data_center,
    url = sprintf("https://%s.qualtrics.com", data_center)
  )
  token <- append(token, extras)

  # store options while we're at it
  options(QUALTRICS_BASE_URL = extras$url)
  options(QUALTRICS_TOKEN_TIMEOUT = extras$time + token$expires_in)
  options(QUALTRICS_API_TOKEN = token$access_token)

  # if cache TRUE encrypt and save
  if(isTRUE(cache)){
    token <- .encrypt(token)
    save(token, file = ".qualtrics-oauth")
    cat(green(symbol$tick), "Token successfully saved\n")
  } else {
    .construct_oauth(token)
  }

  invisible()
}

#' @rdname oauth
#' @export
load_oauth <- function(){
  .check_token_file() # check if file exists
  token <- .get_token_file()

  # construct for method to hide sensitive credentials on print
  .construct_oauth(token)
}

#' @rdname oauth
#' @export
refresh_oauth <- function(){
  token <- load_oauth()
  token <- .decrypt(token)

  # simply rerun auth with cache = TRUE to re-save/overwrite current file
  qualtrics_auth(token$id, token$secret, token$data_center, cache = TRUE)
}

#' @rdname oauth
#' @export
set_qualtrics_opts <- function(
  api_token = Sys.getenv("QUALTRICSINR_TOKEN"),
  data_center = Sys.getenv("QUALTRICSINR_DATA_CENTER")){

  if(nchar(api_token)==0)
    stop(crayon::red("token variable is undefined"), call. = FALSE)

  if(nchar(data_center)==0)
    warning(crayon::yellow("data_center is undefined"), call. = FALSE)

  # Added in the event that data_center is not required by API
  if(nchar(data_center)>0)
    data_center <- sprintf("%s.", data_center)

  options(
    QUALTRICS_TOKEN_TIMEOUT = NULL, # set to null to avoid token clash
    QUALTRICS_BASE_URL = sprintf("https://%squaltrics.com", data_center),
    QUALTRICS_API_TOKEN = api_token,
    QUALTRICS_DATA_CENTER = data_center
  )

  invisible()
}
