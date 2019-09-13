.onAttach <- function(libname = find.package("oRion"), pkgname = "oRion") {

  if (Sys.getenv("QUALTRICSINR_TOKEN") != "") {
    set_qualtrics_opts()
    packageStartupMessage(crayon::green("API token successfully loaded!"))
  }
  else if(file.exists(".qualtrics-oauth")) {
    token <- get(load(".qualtrics-oauth"))
    token <- .construct_oauth(token)
    token <- .decrypt(token)
    options(
      QUALTRICS_BASE_URL = token$url,
      QUALTRICS_API_TOKEN = token$token,
      QUALTRICS_TOKEN_TIMEOUT = token$time + token$expires_in
    )
    packageStartupMessage(crayon::green("Oauth token successfully loaded!"))
  } else {
    packageStartupMessage(crayon::green("Remember to setup your token with set_qualtrics_opts()"))
  }
}

.onDetach <- function(libpath = find.package("oRion")) {
  options(QUALTRICS_API_TOKEN = NULL, QUALTRICS_BASE_URL = NULL)
}
