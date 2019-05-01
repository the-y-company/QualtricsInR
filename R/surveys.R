
#' Retrieve the list of surveys for a given user account
#'
#' @examples
#' \dontrun{list_surveys()}
#' @return A \code{tibble}.
#' @export
list_surveys <- function() {

  .build_surveys_list <- function(list) {
    df <- purrr::map_df(
      list, function(x) {
        dplyr::tibble(
          "id" = .replace_na(x$id),
          "name" = .replace_na(x$name),
          "ownerId" = .replace_na(x$ownerId),
          "lastModified" = .replace_na(x$lastModified),
          "creationDate" = .replace_na(x$creationDate),
          "isActive" = .replace_na(x$isActive)
        )})
    }

  offset <- 0
  getcnt <- .qualtrics_get("surveys", "offset"=offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_surveys_list(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("surveys", "offset"=offset)
      df <- rbind(df,.build_surveys_list(getcnt$result$elements))
    }

    return(df)

  } else {
    return(NULL)
  }
}

#' Create a copy of a survey
#'
#' The survey can be copied within the same account or to another user account.
#' Default uses the user id returned by \code{\link{who_am_i}} function. When a survey gets
#' copied it will appear in the 'Uncategorized' folder
#'
#' @param survey_id the survey id to copy
#' @param copy_name the name of the survey copy
#' @param user_id if provided, copies the survey to another account
#' @examples
#' \dontrun{copy_survey("SV_012345678901234", "survey_copy")}
#' \dontrun{copy_survey("SV_012345678901234", "survey_copy", "UR_012345678912345")}
#' @return The id of the copied survey
#' @export
copy_survey <- function(survey_id, copy_name, user_id = NULL) {

  body <- list("projectName" = copy_name)
  header <- c(
    "X-COPY-SOURCE" = survey_id,
    "X-COPY-DESTINATION-OWNER" = ifelse(!is.null(user_id), user_id, who_am_i()$userId)
    )

  getcnt <- .qualtrics_post("surveys",header,body)
  getcnt$result$id

}

#' Import a survey into Qualtrics
#'
#' @param upload_name the name of the imported survey
#' @param file_path path to the file
#' @param file_type qsf, txt or doc
#' @examples
#' \dontrun{import_survey("test_name", "./survey.qsf", 1)}
#' \dontrun{import_survey("test_name", "./survey.txt", 2)}
#' @return Id of the imported survey
#' @export
import_survey <- function(upload_name, file_path, file_type = "qsf") {

  e_type <- "application/vnd.qualtrics.survey.qsf"

  if (file_type=="txt") {
    e_type <- "application/vnd.qualtrics.survey.txt"
  }
  else if (file_type=="doc") {
    e_type <- "application/vnd.qualtrics.survey.doc"
  }

  imp_file <- httr::upload_file(file_path, type = e_type)

  token_header <- .get_token()

  postreq <- httr::POST(
    .build_url("surveys"),
    token_header,
    encode = "multipart",
    body = list(
      name = upload_name,
      file = imp_file
    )
  )

  httr::content(postreq)$result$id

}


#' Import a survey into Qualtrics based on a file URL
#'
#' @param upload_name the name of the imported survey
#' @param file_url URL to file
#' @param file_type qsf, txt or doc
#' @examples
#' \dontrun{import_survey("Test", "https://www.example.com/mysurvey.qsf", 1)}
#' @return A status code
import_survey_fromurl <- function(upload_name, file_url, file_type = "qsf") {

  e_type <- "application/vnd.qualtrics.survey.qsf"

  if (file_type=="txt") {
    e_type <- "application/vnd.qualtrics.survey.txt"
  }
  else if (file_type=="doc") {
    e_type <- "application/vnd.qualtrics.survey.doc"
  }

  imp_file <- httr::upload_file(file_url, type = e_type)

  token_header <- .get_token()

  postreq <- httr::POST(
    .build_url("surveys"),
    token_header,
    encode = "multipart",
    body = list(
      name = upload_name,
      file = imp_file
    )
  )

  httr::content(postreq)$result$id

}


#' Share a survey with another account
#'
#' @param survey_id the id of survey to copy
#' @param user_id the user id of the account with whom you are sharing the survey
#' @param surv_permissions array of numbers for permissions activation
#'
#' @examples
#' \dontrun{share_survey("SV_012345678901234", "UR_012345678912345", 15)}
#' \dontrun{share_survey("SV_012345678901234", "UR_012345678912345", c(15, 23))}
#' @return A status execution code
#' @export
share_survey <- function(survey_id, user_id, surv_permissions) {

  .build_permissions <- function(user_id, lst_status) {
    status <- rep(FALSE, 25)
    status[lst_status] <- TRUE

    my_permissions <- list(
      "userId" = user_id,
      "permissions" =
        list(
          "surveyDefinitionManipulation" =
            list(
              "copySurveyQuestions" = status[1],
              "editSurveyFlow" = status[2],
              "useBlocks" = status[3],
              "useSkipLogic" = status[4],
              "useConjoint" = status[5],
              "useTriggers" = status[6],
              "useQuotas" = status[7],
              "setSurveyOptions" = status[8],
              "editQuestions" = status[9],
              "deleteSurveyQuestions" = status[10]
            ),
          "surveyManagement" =
            list(
              "editSurveys" = status[11],
              "activateSurveys" = status[12],
              "deactivateSurveys" = status[13],
              "copySurveys" = status[14],
              "distributeSurveys" = status[15],
              "deleteSurveys" = status[16],
              "translateSurveys" = status[17]
            ),
          "response" =
            list(
              "editSurveyResponses" = status[18],
              "createResponseSets" = status[19],
              "viewResponseId" = status[20],
              "useCrossTabs" = status[21]
            ),
          "result" =
            list(
              "downloadSurveyResults" = status[22],
              "viewSurveyResults" = status[23],
              "filterSurveyResults" = status[24],
              "viewPersonalData" = status[25]
            )
        )
    )
  }

  params <- c("surveys","id"=survey_id,"permissions","collaborations")
  body <- .build_permissions(user_id, surv_permissions)
  getcnt <- .qualtrics_post(params, NULL, body)
  getcnt$meta$httpStatus

}

#' Retrieve a survey
#'
#' @param survey_id the id of survey to retrieve
#' @examples
#' \dontrun{get_survey("SV_012345678901234")}
#' @return A \code{list} of survey elements
#' @export
get_survey <- function(survey_id) {
  params <- c("surveys","id"=survey_id)
  .qualtrics_get(params)
}

#' Retrieve the list of languages in which a survey is available
#' @param survey_id the id of survey to copy
#' @examples
#' \dontrun{get_survey_languages("SV_012345678901234")}
#' @return A \code{list} of available languages
#' @export
get_survey_languages <- function(survey_id) {
  params <- c("surveys",survey_id,"languages")
  getcnt <- .qualtrics_get(params)
  getcnt$result$AvailableLanguages
}

#' get_survey_translations retrieves the full translation
#' @param survey_id the id of survey to copy
#' @param language_code is the code for the language of translation
#'
#' @examples
#' \dontrun{get_survey_translations("SV_012345678901234", "EN")}
#' @return A \code{list} of survey elements in requested language
#' @export
get_survey_translations <- function(survey_id, language_code) {
  params <- c("surveys","id" = survey_id, "translations",language_code)
  getcnt <- .qualtrics_get(params)
  getcnt$result
}

#' Update a surve's name, status or expiration date
#'
#' @param survey_id the id of survey to copy
#' @param status is the activity status of the survey (true or false)
#' @param new_name is the edited name of the survey
#' @param expiration_dates an array with startDate and endDate (format "2016-01-01T01:00:00Z")
#'
#' @examples
#' \dontrun{update_survey("SV_012345678901234", true)}
#' \dontrun{update_survey("SV_012345678901234", true, "new_name", c("2016-01-01T01:00:00Z","2016-03-01T01:00:00Z"))}
#' @return A execution status code
#' @export
update_survey <- function(
  survey_id,
  status,
  new_name = NULL,
  expiration_dates = NULL) {

  params <- c("surveys","id" = survey_id)
  body <- list(
    "name" = new_name,
    "isActive" = status,
    "expiration" = list(
      "startDate" = as.character(expiration_dates[1]),
      "endDate" =  as.character(expiration_dates[2]))
    )

  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
}


#' Delete a survey
#'
#' @param survey_id The survey ID of the survey you want to delete
#' @examples
#' \dontrun{delete_survey("SV_012345678901234")}
#' @return A execution status code
#' @export
delete_survey <- function(survey_id) {
  params <- c("surveys", survey_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  getcnt$meta$httpStatus
}

#' Insert embedded data fields into a survey
#'
#' @param survey_id The survey ID of the survey you want to insert embedded data fields into.
#' @param list_fields A list of list
#'
#' @examples
#' \dontrun{insert_embedded_data("SV_012345678901234", "sss")}
#' @export
insert_embedded_data <- function(survey_id, list_fields) {
  params <- c("surveys", survey_id, "embeddeddatafields")
  body <- list("embeddedDataFields" = list_fields)
  getcnt <- .qualtrics_post(params, NULL, body)
  getcnt$meta$httpStatus
}

#' get_survey_quota retrieves the full translation
#' @param survey_id the id of survey to retrieve quota for
#' @return A \code{tibble}
#' @export
get_survey_quota <- function(survey_id) {

  .build_quota <- function(list) {
    df <- purrr::map_df(
      list, function(x) {
        dplyr::tibble(
          "id" = .replace_na(x$id),
          "name" = .replace_na(x$divisionId),
          "count" = .replace_na(x$username),
          "quota" = .replace_na(x$firstName),
          "logicType" = .replace_na(x$lastName)
        )})
  }

  offset <- 0
  params <- c("surveys", survey_id, "quotas")
  getcnt <- .qualtrics_get(params, "offset" = offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_quota(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- httr::parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, "offset"=offset)
      df <- rbind(df,.build_quota(getcnt$result$elements))
    }

    return(df)

  } else {
    return(NULL)
  }
}


#' Update the list of available survey languages for a survey
#'
#' Enabling a new survey language is needed before being able to add a
#' translation for that language.
#'
#' @param survey_id the id of survey to copy
#' @param language_codes Array of language codes to enable
#'
#' @examples
#' \dontrun{update_survey_languages("SV_1873930DS2", c("EN", "ES"))}
#' @return A \code{status}.
#' @export
update_survey_languages <- function(survey_id, language_codes) {
  params <- c("surveys", survey_id, "languages")
  body <- list("AvailableLanguages" = language_codes)
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
  }

#' Update the survey translation for a given language
#'
#' @param survey_id the id of survey to copy
#' @param language_code the language code
#' @param survey_field need to be inferred from retrieving a translation first
#'
#' @details
#' To understand which the field names to provide as translated input, the
#' most simple approach is to run the get_survey_translations function for the
#' corresponding language and built the list of fields the response.
#'
#' @examples
#' \dontrun{update_survey_translations(id, "EN", list("QID1_QuestionText" = "Uno"))}
#' @return A \code{status}.
#' @export
update_survey_translations <- function(survey_id, language_code, survey_field) {
  params <- c("surveys", survey_id, "translations",language_code)
  body <- survey_field
  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
  }
