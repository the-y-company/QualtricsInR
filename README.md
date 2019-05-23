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

