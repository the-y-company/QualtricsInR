.onAttach <- function(libname = find.package("oRion"), pkgname = "oRion") {

  if(file.exists(".qualtrics-oauth")) {
    token <- get(load(".qualtrics-oauth"))
    token <- .construct_oauth(token)
    token <- .decrypt(token)
    options(
      QUALTRICS_BASE_URL = token$url,
      QUALTRICS_API_TOKEN = token$token,
      QUALTRICS_TOKEN_TIMEOUT = token$time + token$expires_in
    )
    packageStartupMessage("Token loaded!")
  } else {
    packageStartupMessage("No token, setup with set_qualtrics_opts and qualtrics_auth.")
  }

}

.onDetach <- function(libpath = find.package("oRion")) {
  options(QUALTRICS_API_TOKEN = NULL, QUALTRICS_BASE_URL = NULL)
}
