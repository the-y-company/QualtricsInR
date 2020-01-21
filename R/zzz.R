.onAttach <- function(libname, pkgname) {

  msg <- paste0(crayon::blue(cli::symbol$info)," Remember to setup your token with set_qualtrics_opts()")

  if (file.exists(".qualtrics-oauth")) {
    token <- get(load(".qualtrics-oauth"))
    token <- .construct_oauth(token)
    token <- .decrypt(token)
    options(
      QUALTRICS_BASE_URL = token$url,
      QUALTRICS_API_TOKEN = token$token,
      QUALTRICS_TOKEN_TIMEOUT = token$time + token$expires_in
    )
    msg <- paste0(crayon::green(cli::symbol$tick), " OAuth token successfully loaded from file!")
  } else if (Sys.getenv("QUALTRICSINR_TOKEN") != "") {
    set_qualtrics_opts()
    msg <- paste0(crayon::green(cli::symbol$tick), " API token successfully loaded!")
  }

  packageStartupMessage(msg)
}

.onDetach <- function(libpath) {
  options(QUALTRICS_API_TOKEN = NULL, QUALTRICS_BASE_URL = NULL)
}
