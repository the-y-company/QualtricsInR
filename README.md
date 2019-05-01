# QualtricsInR

The QualtricsInR package provides a general wraper for the Qualtrics v3 API references. The package is built accross the main API calls to manipulate survey objects and responses.

The package was created in order to address the need of large scale surveys at the World Economic Forum where the use of the API allowed the automate many time consuming processes and ensure robust execution processes.

- [Installation](#installation)
- [Authenticatication](#authentication)
- [Retrieving Survey Responses](#retrieving-survey-responses)
- [Manipulating Survey Objects](#manipulating-survey-objects)
- [Brand Administration](#brand-sdministration)

## Installation

You can install QualtricsInR from github using the devtools package. However, since the package is hosted on a private GitHub repository, you will need to use an authentication key (ask pierre.saouter@weforum.org for a key).

The package will eventually become public.

``` r
devtools::install_github('ppssphysics/QualtricsInR', auth_token='key')
```

## Authentication

Two ways are provided to set-up your Qualtrics credentials:

1. Using a plain Token
2. Using the OAuth 2.0

Both are valid methods. All information on how to retrieve identification parameters and 
generete tokens from your Qualtrics account can be found [here](https://api.qualtrics.com/v3/docs/api-general-instructions).

### Setting a plain text API Token

You can set options for user authentication in your Qualtrics account by generating a new API token. You will also 
need your data center id. You can then set your authentication credentials with `set_qualtrics_opts`.

```r
set_qualtrics_opts(api_token = "xXxxX0X0x", data_center_id = "my.center")
```

If you use this methods, you will have set your credentials for every new session.

### Setting-up an OAuth Client Manager

To generate an OAuth application, follow the steps below in your Qualtrics account:

1. Go to Account Settings
2. Create an OAuth application
3. Use the client id, client secret, and data center id in `qualtrics_auth`, as below.

```r
qualtrics_auth(id = "xXxxX0X0x", secret = "xXxxX0X0x", data_center = "my.center")
```

This will authenticate you, returning a bearer token valid for an hour, saving the _encrypted_ credentials in a `.qualtrics-oauth` file, which will be automatically loaded in all subsequent sessions and automatically refreshed if need be. You should therefore only find the need to run `qualtrics_auth` once.

## Retrieving Survey Responses

The package offers the possiblity to retrieve survey responses. However, the API does not allow
to fetch the data directly but requieres to send a export creation request to download the data (more information
can be found [here](https://api.qualtrics.com/docs/getting-survey-responses-new)). QualtricsInR automates
running through the various steps.

``` r
# export survey as json file
get_survey_responses(surveyId)
# export survey as csv file (can also be tsv) and save in local directory ./Data/
get_survey_responses(surveyId, format="csv", saveDir="./Data")
```

Internally, when using `get_survey_responses`, QualtricsInR has 1) request the data from Qualtrics, 2) wait while the data is being prepared, 3) download the data. It may therefore be more efficient, if downloading responses from multiple surveys to 1) request the downloads 2) then download the prepared files.


```r
# get multiple survey at once.
ids <- c(1,2,3)

# request downloads
requests <- request_downloads(ids)

# Which request was successful?
is_it <- is_success(requests, TRUE)

# download data
data <- download_requested(requests)
```

By default, the above queries return the full export of responses. There is however a limit of 1.8GB for
exports after which you will need to split your exports using the availble options.

``` r
# ask an export for all responses after April 1st, 2016 and before April 25 2016
get_survey_responses(surveyId, startDate="2016-04-01T07:31:43Z", endDate="2016-04-25T07:31:43Z")
```

where the dates specifications followm the ISO 8601 standard YYYY-MM-DD (more information [here](https://api.qualtrics.com/docs/dates-and-times)). There are many more options you can set to retrieve your data. All options xan be found in the corresponding [API reference page](https://api.qualtrics.com/reference/create-response-export-new).

## Manipulating Survey Objects

Using the Qualtrics API, you can peform a number of manipulations of survey objects in your Qualtrics account. You can check all available actions at the Qualtrics API reference webpage [here](https://api.qualtrics.com/reference/get-brand-info). We provide below a brief descriptions of a non exhaustive list of actions available in the package for the manipulation of surveys:

* List surveys
* Retrieving a survey
* Updating a survey
* Deleting a survey
* Importing a survey
* Copying a survey within an account and to other accounts
* Sharing a survey with other accounts

### Listing surveys in Account

You can easily retrieve the full list of surveys available in your account:

``` r
my_surveys <- list_surveys()
```

This allows you to easily search for the survey_id of the survey of interest in order to interact with the object remotely.

For example, you can copy a survey within your account or to another account:

``` r
# Copy a survey in your own account
copy_survey(my_surveys[1], "New_Copy")
# Copy a survey to another user's account
copy_survey(my_surveys[1], "New_Copy",user_id)
```

You might not want to copy a survey into another person's account but would rather share the project defining a specific set
of permissions. By default, without any specification, your project will be shared with all permissions disabled. You can easily decide which permissions to enable by providing an array of numbers indicating the permissions you want to enable. The available options are listed below:

``` r
"1"="copySurveyQuestions"
"2"="editSurveyFlow"
"3"="useBlocks"
"4"="useSkipLogic"
"5"="useConjoint"
"6"="useTriggers"
"7"="useQuotas"
"8"="setSurveyOptions"
"9"="editQuestions"
"10"="deleteSurveyQuestions"
"11"="editSurveys"
"12"="activateSurveys"
"13"="deactivateSurveys"
"14"="copySurveys"
"15"="distributeSurveys"
"16"="deleteSurveys"
"17"="translateSurveys"
"18"="editSurveyResponses"
"19"="createResponseSets"
"20"="viewResponseId"
"21"="useCrossTabs"
"22"="downloadSurveyResults"
"23"="viewSurveyResults"
"24"="filterSurveyResults"
"25"="viewPersonalData"
```

For example, to share the survey with only distribution rights enabled, you could use the following call:

``` r
share_survey(my_surveys[1], user_id, 15)
```

Previous calls are overridden by any new permissions setting so you must make sure to set every permission each time. To add permissions to visualize the data, do:

``` r
share_survey(my_surveys[1], user_id, c(15,23))
```

If you want to remove the permission to visualize data but keep the distribution right:

``` r
share_survey(my_surveys[1], user_id, c(15))
```

## Brand Administration

If you are a brand administrator, you can leverage the Qualtrics API to manage 
your organization's Qualtrics' account. This can be extremely useful for creating, 
setting and updating user permissions. You can only use the functions described
below if you possess brand adminstrator permissions.

A non-exhaustive list of actions you can automate are:
* Get overall information about your Qualtrics' organizations account
* Manage groups
* Manage users

For example, retrieve all users and their account information using the simple function below. 
If you have a large organization with thousands of accounts, this query can take time.

``` r
list_users()
```

In the context of the recent GDPR regulation, one important set of functions provided by the 
Qualtrics API are the data privacy functions. You can:
* Create an erasing request (will erase all data matching an email)
* List your erasing requests
* Retrieve a given erasing request
