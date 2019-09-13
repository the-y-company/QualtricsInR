.onAttach <- function(libname = find.package("oRion"), pkgname = "oRion") {

  if (file.exists(".qualtrics-oauth")) {
    token <- get(load(".qualtrics-oauth"))
    token <- .construct_oauth(token)
    token <- .decrypt(token)
    options(
      QUALTRICS_BASE_URL = token$url,
      QUALTRICS_API_TOKEN = token$token,
      QUALTRICS_TOKEN_TIMEOUT = token$time + token$expires_in
    )
    packageStartupMessage(crayon::green(cli::symbol$tick), " OAuth token successfully loaded from file!")
  } else if (Sys.getenv("QUALTRICSINR_TOKEN") != "") {
    set_qualtrics_opts()
    packageStartupMessage(crayon::green(cli::symbol$tick), " API token successfully loaded!")
    } else {
    packageStartupMessage(crayon::blue(cli::symbol$info)," Remember to setup your token with set_qualtrics_opts()")
  }
}

.onDetach <- function(libpath = find.package("oRion")) {
  options(QUALTRICS_API_TOKEN = NULL, QUALTRICS_BASE_URL = NULL)
}
