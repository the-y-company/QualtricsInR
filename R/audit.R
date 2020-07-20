
#' Retrieve the type of activity events
#'
#' @examples
#' \dontrun{list_event_types()}
#' @return A \code{tibble}
#' @export
list_event_types <- function() {

  .build_df <- function(list) {
    df <- map_df(
      list, function(x) {
        tibble(
          "id" = .replace_na(x$name),
          "additionalFilters" = .replace_na(paste0(unlist(x$additionalFilters), collapse = "; ")),
        )
      })}

  params <- list("logs", "activitytypes")
  getcnt <- .qualtrics_get(params)
  dt <- .build_df(getcnt$result$elements)
  return(dt)
}

#' Retrieve the collection of logins events
#' 
#' @description
#' By default a given audit will return all historical events. This can be an unreasonnable number of events to return. The 
#' opitional paramets allow you to specific and start date and an enddate for the audit as well as other filters. See the [official
#' documentation](https://api.qualtrics.com/api-reference/reference/audits.json/paths/~1logs/get) for all available parameters.
#' 
#' @param ... a vector of named parameters.
#' 
#' @examples
#' \dontrun{get_logins_events()}
#' @return A \code{tibble} or a {json} with all return events
#' @export
get_logins_events <- function(...) {

  .build_df <- function(lst) {
    map_df(
      lst, function(x) {
        tibble(
          "id" = .replace_na(x$id),
          "timestamp" = .replace_na(x$timestamp),
          "datacenter" = .replace_na(x$datacenter),
          "source" = .replace_na(x$source),
          "userId" = .replace_na(x$descriptor$userId),
            "username" = .replace_na(x$descriptor$username),
            "brandId" = .replace_na(x$descriptor$brandId),
            "sessionId" = .replace_na(x$descriptor$sessionId),
            "isSuccessful" = .replace_na(x$descriptor$isSuccessful),
            "failureReason" = .replace_na(x$descriptor$failureReason),
            "isProxyLogin" = .replace_na(x$descriptor$isProxyLogin),
            "proxyDetails" = .replace_na(x$descriptor$proxyDetails),
            "url" = .replace_na(x$descriptor$url),
            "ipAddress" = .replace_na(x$descriptor$ipAddress),
            "location_countryCode" = .replace_na(x$descriptor$location$countryCode),
            "location_region" = .replace_na(x$descriptor$location$region),
            "location_city" = .replace_na(x$descriptor$location$city),
            "location_postalCode" = .replace_na(x$descriptor$location$postalCode),
            "location_latitude" = .replace_na(x$descriptor$location$latitude),
            "location_longitude" = .replace_na(x$descriptor$location$longitude),
            "location_dmaCode" = .replace_na(x$descriptor$location$dmaCode),
            "location_areaCode" = .replace_na(x$descriptor$location$areaCode),
            "location_metroCode" = .replace_na(x$descriptor$location$metroCode),
            "authentication" = .replace_na(x$descriptor$authentication),
            "platform_userAgent" = .replace_na(x$descriptor$platform$userAgent),
            "platform_userAgentVersion" = .replace_na(x$descriptor$platform$userAgent),
            "platform_operatingSystem" = .replace_na(x$descriptor$platform$operatingSystem),
            "platform_operatingSystemVersion" = .replace_na(x$descriptor$platform$operatingSystemVersion),
            "platform_deviceFamily" = .replace_na(x$descriptor$platform$deviceFamily)
        )})}

  offset <- 0
  params <- list("logs")
  getcnt <- .qualtrics_get(params, "activityType" = "logins", ...)

  if (length(getcnt$result$elements)>0) {

    df <- .build_df(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      skip_token <- as.character(getcnt$result$nextPage)
      getcnt <- .qualtrics_get(params, "activityType" = "logins", "skipToken" = skip_token, ...)
      df <- bind_rows(df, .build_df(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }
}

#' Retrieve the collection of logins events
#' 
#' @description
#' By default a given audit will return all historical events. This can be an unreasonnable number of events to return. The 
#' opitional paramets allow you to specific and start date and an enddate for the audit as well as other filters. See the [official
#' documentation](https://api.qualtrics.com/api-reference/reference/audits.json/paths/~1logs/get) for all available parameters.
#' 
#' @param ... a vector of named parameters.
#' 
#' @examples
#' \dontrun{get_session_creations_events()}
#' @return A \code{tibble} or a {json} with all return events
#' @export
get_session_creations_events <- function(...) {

  .build_df <- function(lst) {
    map_df(
      lst, function(x) {
        tibble(
          "id" = .replace_na(x$id),
          "timestamp" = .replace_na(x$timestamp),
          "datacenter" = .replace_na(x$datacenter),
          "source" = .replace_na(x$source),
          "userId" = .replace_na(x$descriptor$userId),
            "brandId" = .replace_na(x$descriptor$brandId),
            "sessionId" = .replace_na(x$descriptor$sessionId),
            "terminationTimestamp" = .replace_na(x$descriptor$terminationTimestamp),
            "ipAddress" = .replace_na(x$descriptor$ipAddress),
            "location_countryCode" = .replace_na(x$descriptor$location$countryCode),
            "location_region" = .replace_na(x$descriptor$location$region),
            "location_city" = .replace_na(x$descriptor$location$city),
            "location_postalCode" = .replace_na(x$descriptor$location$postalCode),
            "location_latitude" = .replace_na(x$descriptor$location$latitude),
            "location_longitude" = .replace_na(x$descriptor$location$longitude),
            "location_dmaCode" = .replace_na(x$descriptor$location$dmaCode),
            "location_areaCode" = .replace_na(x$descriptor$location$areaCode),
            "location_metroCode" = .replace_na(x$descriptor$location$metroCode)
        )})}

  offset <- 0
  params <- list("logs")
  getcnt <- .qualtrics_get(params, "activityType" = "session_creations", ...)

  if (length(getcnt$result$elements)>0) {

    df <- .build_df(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      skip_token <- as.character(getcnt$result$nextPage)
      getcnt <- .qualtrics_get(params, "activityType" = "session_creations", "skipToken" = skip_token, ...)
      df <- bind_rows(df, .build_df(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }
}

#' Retrieve the collection of session_terminations events
#' 
#' @description
#' By default a given audit will return all historical events. This can be an unreasonnable number of events to return. The 
#' opitional paramets allow you to specific and start date and an enddate for the audit as well as other filters. See the [official
#' documentation](https://api.qualtrics.com/api-reference/reference/audits.json/paths/~1logs/get) for all available parameters.
#' 
#' @param ... a vector of named parameters.
#' 
#' @examples
#' \dontrun{get_session_terminations_events()}
#' @return A \code{tibble} or a {json} with all return events
#' @export
get_session_terminations_events <- function(...) {

  .build_df <- function(lst) {
    map_df(
      lst, function(x) {
        tibble(
          "id" = .replace_na(x$id),
          "timestamp" = .replace_na(x$timestamp),
          "datacenter" = .replace_na(x$datacenter),
          "source" = .replace_na(x$source),
          "userId" = .replace_na(x$descriptor$userId),
            "brandId" = .replace_na(x$descriptor$brandId),
            "sessionId" = .replace_na(x$descriptor$sessionId),
            "terminationTimestamp" = .replace_na(x$descriptor$terminationTimestamp),
            "ipAddress" = .replace_na(x$descriptor$ipAddress),
            "location_countryCode" = .replace_na(x$descriptor$location$countryCode),
            "location_region" = .replace_na(x$descriptor$location$region),
            "location_city" = .replace_na(x$descriptor$location$city),
            "location_postalCode" = .replace_na(x$descriptor$location$postalCode),
            "location_latitude" = .replace_na(x$descriptor$location$latitude),
            "location_longitude" = .replace_na(x$descriptor$location$longitude),
            "location_dmaCode" = .replace_na(x$descriptor$location$dmaCode),
            "location_areaCode" = .replace_na(x$descriptor$location$areaCode),
            "location_metroCode" = .replace_na(x$descriptor$location$metroCode)
        )})}

  offset <- 0
  params <- list("logs")
  getcnt <- .qualtrics_get(params, "activityType" = "session_terminations", ...)

  if (length(getcnt$result$elements)>0) {

    df <- .build_df(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      skip_token <- as.character(getcnt$result$nextPage)
      getcnt <- .qualtrics_get(params, "activityType" = "session_terminations", "skipToken" = skip_token, ...)
      df <- bind_rows(df, .build_df(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }
}

#' Retrieve the collection of password_resets events
#' 
#' @description
#' By default a given audit will return all historical events. This can be an unreasonnable number of events to return. The 
#' opitional paramets allow you to specific and start date and an enddate for the audit as well as other filters. See the [official
#' documentation](https://api.qualtrics.com/api-reference/reference/audits.json/paths/~1logs/get) for all available parameters.
#' 
#' @param ... a vector of named parameters.
#' 
#' @examples
#' \dontrun{get_password_resets_events()}
#' @return A \code{tibble} or a {json} with all return events
#' @export
get_password_resets_events <- function(...) {

  .build_df <- function(lst) {
    map_df(
      lst, function(x) {
        tibble(
          "id" = .replace_na(x$id),
          "timestamp" = .replace_na(x$timestamp),
          "datacenter" = .replace_na(x$datacenter),
          "source" = .replace_na(x$source),
          "userId" = .replace_na(x$descriptor$userId),
            "brandId" = .replace_na(x$descriptor$brandId),
            "newPasswordHash" = .replace_na(x$descriptor$agentUserId),
            "previousPasswordHash" = .replace_na(x$descriptor$agentSessionId),
            "validationRules_maxPasswordAgeDays" = .replace_na(x$descriptor$validationRules$maxPasswordAgeDays),
            "validationRules_minPasswordLength" = .replace_na(x$descriptor$validationRules$minPasswordLength),
            "validationRules_minUpperCaseCharacters" = .replace_na(x$descriptor$validationRules$minUpperCaseCharacters),
            "validationRules_minLowerCaseCharacters" = .replace_na(x$descriptor$validationRules$minLowerCaseCharacters),
            "validationRules_minNumericCharacters" = .replace_na(x$descriptor$validationRules$minNumericCharacters),
            "validationRules_minNonAlphaNumericCharacters" = .replace_na(x$descriptor$validationRules$minNonAlphaNumericCharacters),
            "validationRules_minGenerationsWithoutRepeat" = .replace_na(x$descriptor$validationRules$minGenerationsWithoutRepeat),
            "reason" = .replace_na(x$descriptor$reason),
            "ipAddress" = .replace_na(x$descriptor$ipAddress),
            "location_countryCode" = .replace_na(x$descriptor$location$countryCode),
            "location_region" = .replace_na(x$descriptor$location$region),
            "location_city" = .replace_na(x$descriptor$location$city),
            "location_postalCode" = .replace_na(x$descriptor$location$postalCode),
            "location_latitude" = .replace_na(x$descriptor$location$latitude),
            "location_longitude" = .replace_na(x$descriptor$location$longitude),
            "location_dmaCode" = .replace_na(x$descriptor$location$dmaCode),
            "location_areaCode" = .replace_na(x$descriptor$location$areaCode),
            "location_metroCode" = .replace_na(x$descriptor$location$metroCode)
        )})}

  offset <- 0
  params <- list("logs")
  getcnt <- .qualtrics_get(params, "activityType" = "password_resets", ...)

  if (length(getcnt$result$elements)>0) {

    df <- .build_df(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      skip_token <- as.character(getcnt$result$nextPage)
      getcnt <- .qualtrics_get(params, "activityType" = "password_resets", "skipToken" = skip_token, ...)
      df <- bind_rows(df, .build_df(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }
}