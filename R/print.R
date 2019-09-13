#' @export
print.quatrics_token <- function(x, ...){
  t <- format(
    token$time + token$expires_in,
    "%d %b %y %H:%M"
  )
  cat(
    crayon::blue(cli::symbol$info),
    "QualtricsInR token expiring at", t, ..., "\n"
  )
}
