
#' List all distributions associated to a survey
#'
#' @param survey_id the id of survey
#' 
#' @examples 
#' \dontrun{
#'   list_distributions("SV_erkBAsHrvoJyeYB")
#' }
#' 
#' @return A \code{tibble}.
#' @export
list_distributions <- function(survey_id) {

  .build_distribution <- function(lst) {
    
    do.call(
      bind_rows,
      lapply(
        lst,
        function(x) {
          tibble(
            "id" = .replace_na(x$id),
            "parentDistributionId" = .replace_na(x$parentDistributionId),
            "ownerId" = .replace_na(x$ownerId),
            "organizationId" = .replace_na(x$organizationId),
            "requestStatus" = .replace_na(x$requestStatus),
            "requestType" = .replace_na(x$requestType),
            "createdDate" = .replace_na(x$createdDate),
            "modifiedDate" = .replace_na(x$modifiedDate),
            "fromEmail" = .replace_na(x$headers$fromEmail),
            "replyToEmail" = .replace_na(x$headers$replyToEmail),
            "fromName" = .replace_na(x$headers$fromName),
            "mailingListId" = .replace_na(x$recipients$mailingListId),
            "contactId" = .replace_na(x$recipients$contactId),
            "libraryId" = .replace_na(x$recipients$libraryId),
            "surveyId" = .replace_na(x$surveyLink$surveyId),
            "sampleId" = .replace_na(x$surveyLink$sampleId),
            "expirationDate" = .replace_na(x$surveyLink$expirationDate),
            "linkType" = .replace_na(x$surveyLink$linkType),
            "sent" = .replace_na(x$stats$sent),
            "failed" = .replace_na(x$stats$failed),
            "started" = .replace_na(x$stats$started),
            "bounced" = .replace_na(x$stats$bounced),
            "opened" = .replace_na(x$stats$opened),
            "skipped" = .replace_na(x$stats$skipped),
            "finished" = .replace_na(x$stats$finished),
            "complaints" = .replace_na(x$stats$complaints),
            "blocked" = .replace_na(x$stats$blocked)
          )
        }
    ))}

  offset <- 0
  getcnt <- .qualtrics_get("distributions", "surveyId" = survey_id, "offset" = offset)

  if (length(getcnt$result)>0) {
    df <- .build_distribution(getcnt$result$elements)
  
    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get("distributions", "surveyId"=survey_id, "offset" = offset)
      df <- rbind(df,.build_distribution(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

}

#' Retrieve a given survey distribution object
#'
#' @param distribution_id the distribution id
#' @param survey_id the id of the associated survey
#' 
#' @return A \code{list}.
#' 
#' @export
get_distribution <- function(distribution_id, survey_id) {

  .build_distribution <- function(list) {
    df <- map_df(
      list, function(x) {
        tibble(
          "id" = .replace_na(x$id),
          "parentDistributionId" = .replace_na(x$parentDistributionId),
          "ownerId" = .replace_na(x$ownerId),
          "organizationId" = .replace_na(x$organizationId),
          "requestStatus" = .replace_na(x$requestStatus),
          "requestType" = .replace_na(x$requestType),
          "sendDate" = .replace_na(x$sendDate),
          "createdDate" = .replace_na(x$createdDate),
          "modifiedDate" = .replace_na(x$modifiedDate),
          "headers.fromEmail" = .replace_na(x$headers$fromEmail),
          "headers.replyToEmail" = .replace_na(x$headers$replyToEmail),
          "headers.fromName" = .replace_na(x$headers$fromName),
          "headers.subject" = .replace_na(x$headers$subject),
          "recipients.mailingListId" = .replace_na(x$recipients$mailingListId),
          "recipients.contactId" = .replace_na(x$recipients$contactId),
          "recipients.libraryId" = .replace_na(x$recipients$libraryId),
          "recipients.sampleId" = .replace_na(x$recipients$sampleId),
          "message.libraryId" = .replace_na(x$message$libraryId),
          "message.messageId" = .replace_na(x$message$messageId),
          "message.messageText" = .replace_na(x$message$messageText),
          "surveyLink.surveyId" = .replace_na(x$surveyLink$surveyId),
          "surveyLink.expirationDate" = .replace_na(x$surveyLink$expirationDate),
          "surveyLink.linkType" = .replace_na(x$surveyLink$linkType),
          "stats.sent" = .replace_na(x$stats$sent),
          "stats.failed" = .replace_na(x$stats$failed),
          "stats.started" = .replace_na(x$stats$started),
          "stats.bounced" = .replace_na(x$stats$bounced),
          "stats.opened" = .replace_na(x$stats$opened),
          "stats.skipped" = .replace_na(x$stats$skipped),
          "stats.finished" = .replace_na(x$stats$finished),
          "stats.complaints" = .replace_na(x$stats$complaints),
          "stats.blocked" = .replace_na(x$stats$blocked)
        )})
    }

  offset <- 0
  params <- c("distributions", distribution_id)
  getcnt <- .qualtrics_get(params, "surveyId"=survey_id)

  if (length(getcnt$result$elements)>0) {
    df <- .build_distribution(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, "surveyId"=survey_id)
      df <- rbind(df,.build_distribution(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

}

#' Delete a survey distribution
#'
#' @param distribution_id the distribution id
#' @examples
#' \dontrun{delete_distribution("EMD_012345678901234")}
#' @return A status execution code
#' @export
delete_distribution <- function(distribution_id) {
  params <- c("distributions", distribution_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  getcnt$meta$httpStatus
}

#' Create an email distribution or generate distribution links
#' 
#' @description 
#' Using this API call, you can either schedule an email distribution
#' using the Qualtrics email server, or generate distribution links
#' that you can then use to share the link to your survey using your own
#' email solution.
#'
#' @param survey_id the survey id
#' @param library_id the library id where the message is saved (see 'list_libraries')
#' @param message_id id of the message item
#' @param from_email sender email, default is \email{noreply@@qualtrics.com}
#' @param from_name appearing sender name, default is Qualtrics
#' @param subject email subject, default is "Survey Distribution"
#' @param send_date date for distribution to be sent (if not supplied will be set to +1 day)
#' @param mailing_list_id optional, mailing list is, or set transaction_batch_id
#' @param transaction_batch_id optional, transaction batch, or set mailing_list_id
#' @param contact_id optional, optional contact lookup ID for individual distribution
#' @param reply_to_email optional, reply email, default is \email{noreply@@qualtrics.com}
#' @param type optional, allowed values: Individual, Multiple, Anonymous
#' @param expiration_date expiration date
#' 
#' @details
#' In order to create a new email distribution using the API, you need
#' to have the body of your email already created as a message in your
#' Qualtrics message library (see 'list_messages'). If you want to send the 
#' distribution to only one contact in the mailing list, specific the contact_id 
#' field in addition to the mailing_list_id (see 'list_contacts').
#' 
#' @details
#' Note that our Qualtrics account may be set with a different time zone than your
#' local environment. Make sure to specificy your date fields accordingly.
#'
#' @examples 
#' \dontrun{
#'  create_email_distribution(
#'    "SV_erkBAsHrvoJyeYB",
#'    "UR_0NXtl92JJWqfWcJ", 
#'    "MS_0fddN2xI3J0nGQZ", 
#'    "ML_7aoriSKinHh8MfP", 
#'    "john.doe@qualtrics.com", 
#'    "John Doe", 
#'    "Participate in this awesome survey")
#' }
#' @return The created distribution id
#' @export
create_email_distribution <- function(
  survey_id,
  library_id,
  message_id,
  mailing_list_id,
  from_email = "noreply@qualtrics.com",
  from_name = "Qualtrics",
  subject = "Participate in this survey",
  send_date = paste0(Sys.Date()+1, "T00:00:00Z"),
  transaction_batch_id = NULL,
  contact_id = NULL,
  reply_to_email = "noreply@qualtrics.com",
  type = NULL,
  expiration_date = NULL
  ) {

  body_message <- list(
      "libraryId" = library_id,
      "messageId" = message_id
    ) %>%
    discard(is.null)

  body_header <- list(
      "fromEmail" = from_email,
      "fromName" = from_name,
      "replyToEmail" = reply_to_email,
      "subject" = subject
    ) %>%
    discard(is.null)

  body_recipients <- list(
    "contactId" = contact_id,
    "mailingListId" = mailing_list_id,
    "transactionBatchId" = transaction_batch_id
  ) %>%
    discard(is.null)

  body_survey_link <- list(
    "surveyId" = survey_id,
    "expirationDate" = expiration_date,
    "type" = type
  ) %>%
    discard(is.null)

  body <- list(
    "message" = body_message,
    "recipients" = body_recipients,
    "header" = body_header,
    "surveyLink" = body_survey_link,
    "sendDate"= send_date
  )

  getcnt <- .qualtrics_post("distributions", NULL, body)
  getcnt$result$id

}

#' Create a reminder distribution for an existing email distribution
#'
#' @description 
#' Based on an existing email distribution, create a reminder to 
#' take a survey for recipients with non completed surveys. 
#' Recipients who have opted out will not receive the reminder.
#'
#' @param parent_distribution_id id of the library item
#' @param library_id Library ID of the message
#' @param message_id id of the message item
#' @param subject email subject, default is "Reminder - Participate to the survey"
#' @param send_date date for distribution to be sent (default to time + 1 day)
#' @param from_email sender email, default is \email{noreply@@qualtrics.com}
#' @param from_name appearing sender name, default is Qualtrics
#' @param reply_to_email reply email, default is \email{noreply@@qualtrics.com}
#'
#' @details
#' The parent distribution id can be found using the 
#' 'list_distributions' call. The sender email parameter 
#' can only be sent from another email if
#' the organization authorizes a send on its behalf.
#' 
#' @examples
#' \dontrun{
#'   create_reminder_distribution(
#'     "EMD_6yYmF6vopfUz4gn",
#'     library_id = "UR_0NXtl92JJWqfWcJ",
#'     message_id = "MS_0fddN2xI3J0nGQZ"
#' )
#' }
#' 
#' @return The reminder distribution id
create_reminder_distribution <- function(
  parent_distribution_id,
  library_id,
  message_id,
  subject = "Reminder - Participate to the survey",
  send_date = paste0(Sys.Date()+1, "T00:00:00Z"),
  from_email = "noreply@qualtrics.com",
  from_name = "Qualtrics",
  reply_to_email = "noreply@qualtrics.com"
  ) {

  body <- list(
    "header" = list(
      "fromName" = from_name,
      "replyToEmail" = reply_to_email,
      "fromEmail" = from_email,
      "subject" = subject
    ),
    "message" = list(
      "libraryId" = library_id,
      "messageId" = message_id
    ),
    "sendDate"= send_date
  )

  params <- c("distributions", parent_distribution_id, "reminders")
  getcnt <- .qualtrics_post(params, NULL, body)
  return(getcnt$result$distributionId)
}

#' Create a thank you distribution for an exisiting email distribution
#' 
#' @description 
#' The thank you email is sent to all respondents who have finished
#' the survey.
#'
#' @param parent_distribution_id id of the library item
#' @param library_id Library ID of the message
#' @param message_id id of the message item
#' @param send_date date for distribution to be sent
#' @param from_email sender email, default is \email{noreply@@qualtrics.com}
#' @param from_name appearing sender name, default is Qualtrics
#' @param reply_to_email reply email, default is \email{noreply@@qualtrics.com}
#' @param subject email subject, default is "Thank you for your participation"
#' 
#' @examples 
#' \dontrun{
#'  create_thankyou_distribution(
#'    "EMD_6yYmF6vopfUz4gn",
#'    "UR_0NXtl92JJWqfWcJ",
#'    "MS_0fddN2xI3J0nGQZ"
#' )
#' }
#' 
#' @return The thank you distribution id
create_thankyou_distribution <- function(
  parent_distribution_id,
  library_id,
  message_id,
  send_date = paste0(Sys.Date()+1, "T00:00:00Z"),
  from_email = "noreply@qualtrics.com",
  from_name = "Qualtrics",
  reply_to_email = "noreply@qualtrics.com",
  subject = "Thank you for your participation") {

  body <- list(
    "header" = list(
      "fromName" = from_name,
      "replyToEmail" = reply_to_email,
      "fromEmail" = from_email,
      "subject" = subject
    ),
    "message" = list(
      "libraryId" = library_id,
      "messageId" = message_id
    ),
    "sendDate"= send_date
  )

  params <- c("distributions",parent_distribution_id,"thankyous")
  getcnt <- .qualtrics_post(params, NULL, body)
  getcnt$result$distributionId
}

#' Generate survey distribution links
#'
#' @description 
#' Create a distribution without sending any emails. The created distribution
#' will be of type "GeneratedInvite". The survey must be active before you can
#' generate a distribution invite. Refer to the documentation below for further
#' information regarding usage of this API's result.
#'
#' @param action default is CreateDistribution. To generate transaction distribution links, value must be "CreateTransactionBatchDistribution"
#' @param survey_id the distribution id
#' @param mailinglist_id the distribution id
#' @param description the distribution id
#' @param expirationdate the id of survey
#' @param linktype the id of survey
#' 
#' @details 
#' To retrieve the actual links, use the 'list_distribution_links' call.
#' 
#'  @examples 
#' \dontrun{
#'  generate_distribution_links(
#'    "SV_erkBAsHrvoJyeYB",
#'    "ML_7aoriSKinHh8MfP", 
#'    "Survey Respondents Generated Links"
#' }
#' 
#' @return The id of the created distribution
#' @export
generate_distribution_links <- function(
  survey_id,
  mailinglist_id,
  description = "Generated Links",
  linktype = "Individual",
  action = "CreateDistribution",
  expirationdate = NULL) {

  body <- list(
    "action" = action,
    "surveyId" = survey_id,
    "mailingListId" = mailinglist_id,
    "description" = description,
    "expirationDate" = expirationdate,
    "linkType" = linktype
  )

  getcnt <- .qualtrics_post("distributions", NULL, body)
  getcnt$result$id

}

#' List the survey links associated with a distribution
#'
#' @description 
#' Distribution links can only be generated for distribution ids associated
#' with mailing lists. It is not possible to retrieve survey links for
#' distributions to only one contact id.
#'
#' @param survey_id the id of survey
#' @param distribution_id the distribution id
#' 
#' @examples
#' \dontrun{
#'  lst_distri <- list_distributions("SV_dg0P0pcZoDYvpNX")
#'  df <- list_distribution_links("EMD_3rrDZa8AQBnACYl", "SV_dg0P0pcZoDYvpNX")   
#' }
#' 
#' @return A \code{tibble}.
#' @export
list_distribution_links <- function(distribution_id, survey_id) {

  .build_df <- function(list) {
    df <- map_df(
      list, function(x) {
        tibble(
          "contactId" = .replace_na(x$contactId),
          "link" = .replace_na(x$link),
          "exceededContactFrequency" = .replace_na(x$exceededContactFrequency),
          "linkExpiration" = .replace_na(x$linkExpiration),
          "status" = .replace_na(x$status),
          "lastName" = .replace_na(x$lastName),
          "firstName" = .replace_na(x$firstName),
          "externalDataReference" = .replace_na(x$externalDataReference),
          "email" = .replace_na(x$email),
          "unsubscribed" = .replace_na(x$unsubscribed)
        )})
  }

  skip_token <- 0
  params <- c("distributions", distribution_id, "links")
  getcnt <- .qualtrics_get(params, "surveyId" = survey_id, "skipToken" = skip_token)

  if (length(getcnt$result$elements)>0) {
    df <- .build_df(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      skip_token <- parse_url(getcnt$result$nextPage)$query$skipToken
      getcnt <- .qualtrics_get(params, "surveyId" = survey_id, "skipToken" = skip_token)
      df <- rbind(df, .build_df(getcnt$result$elements))
    }

    return(df)
  } else {
    return(NULL)
  }

}

#' Send Email to Mailing List
#'
#' @description 
#' You can use this call to send an email to a mailing list without
#' having to create the email message in Qualtrics first.
#'
#' @param mailingListId the id of survey
#' @param sendDate the date to send the email (default is +1 day)
#' @param fromEmail sender email, default is \email{noreply@@qualtrics.com}
#' @param fromName the send name default is Qualtrics
#' @param replyToEmail reply email, default is \email{noreply@@qualtrics.com}
#' @param subject the email subject
#' @param messageText email text body
#' 
#' @examples
#' \dontrun{
#'  create_distribution(
#'    "ML_7aoriSKinHh8MfP", 
#'    "john.doe@qualtrics.com", 
#'    "John Doe", 
#'    "Participate in this awesome survey")
#' }
#'
#' @return The email distribution id
#' @export
send_email_mailinglist <- function(
  mailingListId,
  sendDate = paste0(Sys.Date()+1, "T00:00:00Z"),
  subject = "Take this survey",
  messageText = "Hello, take this survey",
  fromEmail = "noreply@qualtrics.com",
  fromName = "Qualtrics",
  replyToEmail = "noreply@qualtrics.com"
  ) {

  body <- list(
    "header" = list(
      "fromEmail" = fromEmail,
      "fromName" = fromName,
      "replyToEmail" = replyToEmail,
      "subject" = subject
    ),
    "message" = list(
      "messageText" = messageText
    ),
    "recipients" = list(
      "mailingListId" = mailingListId
    ),
    "sendDate"= sendDate
  )

  getcnt <- .qualtrics_post("distributions", NULL, body)
  getcnt$meta$httpStatus

}

#' Create a new survey distribution via SMS
#'
#' @param send_date date for distribution to be sent
#' @param method Determines how the survey will be sent out via SMS. Can be
#'   either Invite, Interactive, Reminder or Thankyou.
#' @param survey_id the id of survey to copy
#' @param name Name for the SMS distribution
#' @param message_id ID of the message. The messageId is required in conjunction
#'   with the libraryId if no messageText is supplied. A message object is only
#'  required with the Invite, Reminder, and Thankyou methods.
#' @param library_id Library ID of the message. libraryId is required in
#'   conjunction with the messageId if no messageText is supplied. A message
#'    object is only required by "Invite" method.
#' @param messagetext Custom message text. Either messageText or messageId must
#'   be provided but not both. A message object is only required with the Invite,
#'   Reminder, and Thankyou methods.
#' @param mailinglist_id Mailing List ID for a batch distribution - Required for
#'   Invite and Interactive method. Cannot be provided for Reminder and Thankyou
#' @param contact_id Contact ID for an individual distribution. Cannot be
#'   provided for Reminder and Thankyou
#' @param parentdistribution_id ID of the distribution to send a Reminder or
#'   Thankyou distribution. Can be used only with these two methods.
#' @return A \code{list}
create_sms_distribution <- function(
  send_date,
  method,
  survey_id,
  name,
  mailinglist_id,
  message_id = NULL,
  library_id = NULL,
  messagetext=NULL,
  contact_id = NULL,
  parentdistribution_id = NULL
  ) {

  body <- list(
    "sendDate"= send_date,
    "method" = method,
    "surveyId" = survey_id,
    "name" = name,
    "recipients" = list(
      "mailingListId" = mailinglist_id,
      "contactId" = ifelse(!is.null(contact_id),contact_id,NULL)
    ),
    "message" = ifelse(
      method!="Interactive",
      list(
        "libraryId" = library_id,
        "messageId" = ifelse(is.null(messagetext),message_id, NULL),
        "messagetext" = ifelse(!is.null(messagetext), messagetext, NULL)
      ),
      NULL
      )
    )

  params <- ifelse((method=="Reminder" | method=="Thankyou") & !is.null(parentdistribution_id),
                   c("distributions",parentdistribution_id,"sms"),
                   c("distributions","sms"))
  .qualtrics_post(params, NULL, body)

}

#' Retrieve an sms survey distribution object
#'
#' @param smsdistribution_id the distribution id
#' @param survey_id the distribution id
#' @examples
#' \dontrun{get_sms_distribution("SMSD_012345678901234", "SV_012345678901234")}
#' @return A \code{list}
get_sms_distribution <- function(smsdistribution_id, survey_id) {
  params <- c("distributions","sms", smsdistribution_id)
  .qualtrics_get(params, "surveyId"=survey_id, NULL)
}

#' Delete an sms survey distribution
#'
#' @param smsdistribution_id the distribution id
#' @examples
#' \dontrun{delete_sms_distribution("SMSD_012345678901234")}
#' @return A status execution code
delete_sms_distribution <- function(smsdistribution_id) {
  params <- c("distributions","sms", smsdistribution_id)
  getcnt <- .qualtrics_delete(params, NULL, NULL)
  getcnt$meta$httpStatus
}

#' List all sms distributions associated to a survey
#'
#' @param survey_id the distribution id
#' @examples
#' \dontrun{list_sms_distributions("SV_012345678901234")}
#' @return A \code{list}
list_sms_distributions <- function(survey_id) {

  .build_sms_distribution <- function(list) {
    df <- map_df(
      list, function(x) {
        tibble(
          "id" = .replace_na(x$id),
          "name" = .replace_na(x$name),
          "ownerId" = .replace_na(x$ownerId),
          "organizationId" = .replace_na(x$organizationId),
          "requestStatus" = .replace_na(x$requestStatus),
          "requestType" = .replace_na(x$requestType),
          "sendDate" = .replace_na(x$sendDate),
          "surveyId" = .replace_na(x$surveyId),
          "recipients.mailingListId" = .replace_na(x$recipients$mailingListId),
          "recipients.contactId" = .replace_na(x$recipients$contactId),
          "recipients.libraryId" = .replace_na(x$recipients$libraryId),
          "message.libraryId" = .replace_na(x$message$libraryId),
          "message.messageId" = .replace_na(x$message$messageId),
          "message.messageText" = .replace_na(x$message$messageText),
          "stats.sent" = .replace_na(x$stats$sent),
          "stats.failed" = .replace_na(x$stats$failed),
          "stats.started" = .replace_na(x$stats$started),
          "stats.finished" = .replace_na(x$stats$finished),
          "stats.credits" = .replace_na(x$stats$credits),
          "stats.segments" = .replace_na(x$stats$segments)
        )})
  }

  params <- c("distributions","sms")
  getcnt <- .qualtrics_get(params, "surveyId"=survey_id)
  return(getcnt)

  offset <- 0
  getcnt <- .qualtrics_get(params, "surveyId" = survey_id, "offset" = offset)

  if (length(getcnt$result$elements)>0) {
    df <- .build_sms_distribution(getcnt$result$elements)

    while (!is.null(getcnt$result$nextPage)) {
      offset <- parse_url(getcnt$result$nextPage)$query$offset
      getcnt <- .qualtrics_get(params, "surveyId" = survey_id, "offset" = offset)
      df <- rbind(df,.build_sms_distribution(getcnt$result$elements))
    }
    return(df)
  } else {
    return(NULL)
  }

}


