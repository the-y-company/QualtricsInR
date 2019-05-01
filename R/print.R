#' @export
print.quatrics_token <- function(x, ...){
  t <- format(
    token$time + token$expires_in,
    "%d %b %y %H:%M"
  )
  cat("QualtricsInR token expiring at", t, ...)
}
