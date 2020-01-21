
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

# QualtricsInR

The **QualtricsInR** package provides a general R wrapper for the
Qualtrics v3 API references. The package is built accross the main API
calls to manipulate survey objects and responses, as well as general
admnistration functions and access to library items.

The package was created in order to address the needs of large scale
survey projects where the management and handling of multiple surveys
can benefit from automation through the API.

  - [Installation](#installation)
  - [Authenticatication](#authentication)
  - [Development Pipeline](#dev-pipeline)

There are other important R packages available to automate different
aspects of survey manipulation in Qualtrics. The
[qualtRics](https://github.com/ropensci/qualtRics) R package implements
the retrieval of survey data using the Qualtrics API and is currently
the only package on CRAN that offers such functionality.

Other related packages are available through Github. [Jason
Bryer’s](https://github.com/jbryer/qualtrics) R package to work with
the previous version of the Qualtrics API.
[QualtricsTools](https://github.com/emmamorgan-tufts/QualtricsTools/)
creates automatic reports in shiny and
[qsurvey](https://github.com/jamesdunham/qsurvey), by James Dunham,
focuses on testing and review of surveys before fielding, as well as the
analysis of responses afterward.

**The QualtricsInR package is an effort to provide in one package
wrapper functions for all [API v3
references](https://api.qualtrics.com/reference) provided by Qualtrics
as well occasional custom utility functions.**

## Getting Started

You can install QualtricsInR from github using the devtools package.

``` r
devtools::install_github('ppssphysics/QualtricsInR')
```

### Authentication

We provide two authentication methods to set-up your Qualtrics
credentials:

1.  Using a plain Token
2.  Using the OAuth 2.0

Both are valid methods. All information on how to retrieve
identification parameters and generete tokens from your Qualtrics
account can be found
[here](https://api.qualtrics.com/v3/docs/api-general-instructions).

### Setting a plain text API Token

For convenience, we recommend you define your API token and Qualtrics
Data Center ID (optional) in your .Renviron with the names
QUALTRICSINR\_TOKEN and QUALTRICSINR\_DATA\_CENTER respectively. Upon
loading the QualtricsInR package, your credentials will be automatically
set as internal encrypted parameters.

You can however set your credentials by hand using the
`set_qualtrics_opts` function:

``` r
# set auth options assuming definition in .Renviron
set_qualtrics_opts()

# set auth options by hand
set_qualtrics_opts("9ssssss83jsl83282032932sds2", "mydatacenter")

# set auth options with custom envrionment variable names in .Renviron
set_qualtrics_opts(Sys.getenv("VAR1"), Sys.getenv("VAR2"))
```

If you use this method, you will have set your credentials for every new
session.

### Setting-up an OAuth Client Manager

To generate an OAuth application, follow the steps below in your
Qualtrics account:

1.  Go to Account Settings
2.  Create an OAuth application
3.  Use the client id, client secret, and data center id in
    `qualtrics_auth`, as
below.

<!-- end list -->

``` r
qualtrics_auth(id = "xXxxX0X0x", secret = "xXxxX0X0x", data_center = "my.center")
```

This will authenticate you, returning a bearer token valid for an hour,
saving the *encrypted* credentials in a `.qualtrics-oauth` file, which
will be automatically loaded in all subsequent sessions and
automatically refreshed if need be. You should therefore only find the
need to run `qualtrics_auth` once.

## Development pipeline

There are close to 200 different API calls provides by Qualtrics. The
table below presents a summary of the status of implementation. Despite
certain calls having been implemented, a full testing is sometimes
challenging. Depending on interest and help from the community, efforts
will be dedicated to the testing and implementation of missing
references.

The XM Directory related calls are not implemented due to not having
access to this feature in our own account.

<table>

<thead>

<tr>

<th style="text-align:left;">

Category

</th>

<th style="text-align:left;">

Call

</th>

<th style="text-align:left;">

Implemented

</th>

<th style="text-align:left;">

Tested

</th>

<th style="text-align:left;">

Comments

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

ORGANIZATIONS

</td>

<td style="text-align:left;">

Get Organization

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Says we dont have enough rights

</td>

</tr>

<tr>

<td style="text-align:left;">

DIVISIONS

</td>

<td style="text-align:left;">

Create Division

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DIVISIONS

</td>

<td style="text-align:left;">

Get Division

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DIVISIONS

</td>

<td style="text-align:left;">

Update Division

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GROUPS

</td>

<td style="text-align:left;">

List Groups

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GROUPS

</td>

<td style="text-align:left;">

Create Group

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GROUPS

</td>

<td style="text-align:left;">

Get Group

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GROUPS

</td>

<td style="text-align:left;">

Update Group

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GROUPS

</td>

<td style="text-align:left;">

Delete Group

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GROUPS

</td>

<td style="text-align:left;">

Add User to Group

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GROUPS

</td>

<td style="text-align:left;">

Remove User from Group

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

USERS

</td>

<td style="text-align:left;">

List Users

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

USERS

</td>

<td style="text-align:left;">

Get User

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

USERS

</td>

<td style="text-align:left;">

Create User

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

USERS

</td>

<td style="text-align:left;">

Update User

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

USERS

</td>

<td style="text-align:left;">

Delete User

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

USERS

</td>

<td style="text-align:left;">

Get User API Token

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

USERS

</td>

<td style="text-align:left;">

Create User API Token

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

USERS

</td>

<td style="text-align:left;">

Who Am I

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - QUESTIONS

</td>

<td style="text-align:left;">

Get Question

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - QUESTIONS

</td>

<td style="text-align:left;">

List Question

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - QUESTIONS

</td>

<td style="text-align:left;">

Create Question

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - QUESTIONS

</td>

<td style="text-align:left;">

Update Question

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - QUESTIONS

</td>

<td style="text-align:left;">

Delete Question

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - FLOWS

</td>

<td style="text-align:left;">

Update Flow

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - FLOWS

</td>

<td style="text-align:left;">

Get Flow

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - FLOWS

</td>

<td style="text-align:left;">

Update Flow Element

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - BLOCKS

</td>

<td style="text-align:left;">

Get Block

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - BLOCKS

</td>

<td style="text-align:left;">

Update Block

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - BLOCKS

</td>

<td style="text-align:left;">

Delete Block

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - BLOCKS

</td>

<td style="text-align:left;">

Create Block

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - OPTIONS

</td>

<td style="text-align:left;">

Get Options

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - OPTIONS

</td>

<td style="text-align:left;">

Update Options

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - SURVEY

</td>

<td style="text-align:left;">

Get Survey

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - SURVEY

</td>

<td style="text-align:left;">

Get Survey Metadata

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - SURVEY

</td>

<td style="text-align:left;">

Delete Survey

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - SURVEY

</td>

<td style="text-align:left;">

Create Survey

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - LANGUAGES

</td>

<td style="text-align:left;">

Get Survey Languages

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - LANGUAGES

</td>

<td style="text-align:left;">

Get Survey Translations

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - LANGUAGES

</td>

<td style="text-align:left;">

Update Survey Languages

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - LANGUAGES

</td>

<td style="text-align:left;">

Update Survey Translations

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - VERSIONS

</td>

<td style="text-align:left;">

Create Survey Version

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - VERSIONS

</td>

<td style="text-align:left;">

List Survey Versions

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY DEFINITIONS - VERSIONS

</td>

<td style="text-align:left;">

Get Survey Version

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

List Surveys

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Get Survey

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Better Response Needed

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Update Survey

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Delete Survey

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Import Survey

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Need cleaner implementation using utils.R? How do we handle copying to a
different userId

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Import Survey From URL

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Need cleaner implementation using utils.R? How do we handle copying to a
different userId

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Copy Survey

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Share Survey

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Issue when removing all permissions, survey stays in account

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Insert Embedded Data Fields

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Get Survey Quotas

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

No clear what next page parameter is

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Get Survey Languages

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Get Survey Translations

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Update Survey Languages

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEYS

</td>

<td style="text-align:left;">

Update Survey Translations

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY SESSIONS

</td>

<td style="text-align:left;">

Create Session

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY SESSIONS

</td>

<td style="text-align:left;">

Update Session

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY SESSIONS

</td>

<td style="text-align:left;">

Get Session

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY SESSIONS

</td>

<td style="text-align:left;">

Delete Session

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY SESSIONS

</td>

<td style="text-align:left;">

Close Session

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY RESPONSE EXPORTS

</td>

<td style="text-align:left;">

Create Response Export

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Need to solve encoding issue

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY RESPONSE EXPORTS

</td>

<td style="text-align:left;">

Get Response Export Progress

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Need to solve encoding issue

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY RESPONSE EXPORTS

</td>

<td style="text-align:left;">

Get Response Export File

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Need to solve encoding issue

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY RESPONSE IMPORTS

</td>

<td style="text-align:left;">

Start Response Import

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Qualtrics Doc is screwed up

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY RESPONSE IMPORTS

</td>

<td style="text-align:left;">

Start Response Import By URL

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

SURVEY RESPONSE IMPORTS

</td>

<td style="text-align:left;">

Get Response Import Progress

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

LEGACY RESPONSE EXPORTS

</td>

<td style="text-align:left;">

Legacy Create Response Export

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Being deprecated

</td>

</tr>

<tr>

<td style="text-align:left;">

LEGACY RESPONSE EXPORTS

</td>

<td style="text-align:left;">

Legacy Get Response Export Progress

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Being deprecated

</td>

</tr>

<tr>

<td style="text-align:left;">

LEGACY RESPONSE EXPORTS

</td>

<td style="text-align:left;">

Legacy Get Response Export File

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Being deprecated

</td>

</tr>

<tr>

<td style="text-align:left;">

RESPONSES

</td>

<td style="text-align:left;">

Update Response

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESPONSES

</td>

<td style="text-align:left;">

Delete Response

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

LEGACY RESPONSE IMPORTS

</td>

<td style="text-align:left;">

Import Responses

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Being deprecated

</td>

</tr>

<tr>

<td style="text-align:left;">

LEGACY RESPONSE IMPORTS

</td>

<td style="text-align:left;">

Import Responses from URL

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Being deprecated

</td>

</tr>

<tr>

<td style="text-align:left;">

LEGACY RESPONSE IMPORTS

</td>

<td style="text-align:left;">

Get Response Import Progress

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Being deprecated

</td>

</tr>

<tr>

<td style="text-align:left;">

MESSAGE LIBRARY

</td>

<td style="text-align:left;">

List Library Message

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

MESSAGE LIBRARY

</td>

<td style="text-align:left;">

Get Library Message

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Better Response Needed

</td>

</tr>

<tr>

<td style="text-align:left;">

MESSAGE LIBRARY

</td>

<td style="text-align:left;">

Create Library Message

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

MESSAGE LIBRARY

</td>

<td style="text-align:left;">

Update Library Message

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

MESSAGE LIBRARY

</td>

<td style="text-align:left;">

Delete Library Message

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GRAPHIC LIBRARY

</td>

<td style="text-align:left;">

Upload Graphic

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GRAPHIC LIBRARY

</td>

<td style="text-align:left;">

Upload Graphic From URL

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

GRAPHIC LIBRARY

</td>

<td style="text-align:left;">

Delete Graphic

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Create Distribution

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Better Understanding Needed

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Create Reminder Distribution

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Create Thank You Distribution

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

List Distributions

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Get Distribution

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Generate Distribution Links

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

List Distribution Links

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Send Email to Mailing List

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Delete Distribution

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Create SMS Survey Distribution

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

Get SMS Distribution

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

DISTRIBUTIONS

</td>

<td style="text-align:left;">

List SMS Distributions

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Get Mailing List

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

List Mailing Lists

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Create Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Update Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Delete Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

List Contacts

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Get Contact

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Create Contact

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Update Contact

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Delete Contact

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Create Contacts Import

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Create Contacts Import From URL

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Get Contacts Import Progress

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Get Contacts Import Progress Summary

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

List Samples

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

RESEARCH CORE CONTACTS

</td>

<td style="text-align:left;">

Get Sample

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

EVENT SUBSCRIPTION

</td>

<td style="text-align:left;">

List Subscriptions

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

EVENT SUBSCRIPTION

</td>

<td style="text-align:left;">

Get Subscription

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

EVENT SUBSCRIPTION

</td>

<td style="text-align:left;">

Create Subscription

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY API

</td>

<td style="text-align:left;">

Get contacts in a maiing list who have had an email bounce

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY API

</td>

<td style="text-align:left;">

Get contacts in a maiing list who have opted out

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY API

</td>

<td style="text-align:left;">

List directories for a brand

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS

</td>

<td style="text-align:left;">

List Directory Contacts

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS

</td>

<td style="text-align:left;">

Get Directory Contact

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS

</td>

<td style="text-align:left;">

Get Contact History

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS

</td>

<td style="text-align:left;">

Create Directory Contact

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS

</td>

<td style="text-align:left;">

Update Directory Contact

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS

</td>

<td style="text-align:left;">

Delete Directory Contact

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS

</td>

<td style="text-align:left;">

Search Contacts

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY MAILING LISTS

</td>

<td style="text-align:left;">

List Mailing Lists

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY MAILING LISTS

</td>

<td style="text-align:left;">

Get Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY MAILING LISTS

</td>

<td style="text-align:left;">

Create Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY MAILING LISTS

</td>

<td style="text-align:left;">

Update Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY MAILING LISTS

</td>

<td style="text-align:left;">

Delete XM Directory Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS MAILING LISTS

</td>

<td style="text-align:left;">

List Contacts in Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS MAILING LISTS

</td>

<td style="text-align:left;">

Get Contact in Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS MAILING LISTS

</td>

<td style="text-align:left;">

Get Contact History in Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS MAILING LISTS

</td>

<td style="text-align:left;">

Create Contact in Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS MAILING LISTS

</td>

<td style="text-align:left;">

Update Contact in Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACTS MAILING LISTS

</td>

<td style="text-align:left;">

Delete Contact in Mailing List

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLES

</td>

<td style="text-align:left;">

List Samples

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLES

</td>

<td style="text-align:left;">

Get Sample

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLES

</td>

<td style="text-align:left;">

Perform Sample on Mailing List/Batch

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLES

</td>

<td style="text-align:left;">

Update Sample

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLES

</td>

<td style="text-align:left;">

Delete Sample

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLES

</td>

<td style="text-align:left;">

Get Sample Contacts

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLES

</td>

<td style="text-align:left;">

Get Create Sample Progess

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLE DEFINITIONS

</td>

<td style="text-align:left;">

List Sample Definitions

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLE DEFINITIONS

</td>

<td style="text-align:left;">

Get Sample Definition

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLE DEFINITIONS

</td>

<td style="text-align:left;">

Create Sample Definition

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLE DEFINITIONS

</td>

<td style="text-align:left;">

Update Sample Definition

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY SAMPLE DEFINITIONS

</td>

<td style="text-align:left;">

Delete Sample Definition

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACT TRANSACTION

</td>

<td style="text-align:left;">

List Contact Transactions

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACT TRANSACTION

</td>

<td style="text-align:left;">

Get Contact Transaction

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACT TRANSACTION

</td>

<td style="text-align:left;">

Create Contact Transactions

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACT TRANSACTION

</td>

<td style="text-align:left;">

Append Contact Transactions

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACT TRANSACTION

</td>

<td style="text-align:left;">

Update Contact Transaction

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CONTACT TRANSACTION

</td>

<td style="text-align:left;">

Delete Contact Transaction

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY TRANSACTION BATCHES

</td>

<td style="text-align:left;">

Get Transaction Batches in a Directory

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY TRANSACTION BATCHES

</td>

<td style="text-align:left;">

Get Transactiions in a Batch

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY TRANSACTION BATCHES

</td>

<td style="text-align:left;">

Get Transaction Batch

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY TRANSACTION BATCHES

</td>

<td style="text-align:left;">

Create Transaction Batch

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY TRANSACTION BATCHES

</td>

<td style="text-align:left;">

Update Transaction Batch

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY TRANSACTION BATCHES

</td>

<td style="text-align:left;">

Delete Transaction Batch

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY TRANSACTION BATCHES

</td>

<td style="text-align:left;">

Add Transactions to a Batch

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY TRANSACTION BATCHES

</td>

<td style="text-align:left;">

Remove Transaction from a Batch

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY DISTRIBUTIONS

</td>

<td style="text-align:left;">

Create Survey Distribution for XM Directory

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY DISTRIBUTIONS

</td>

<td style="text-align:left;">

Create Transaction Batch Survey Distribution

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY DISTRIBUTIONS

</td>

<td style="text-align:left;">

Generate Transaction Batch Distribution Links

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY DISTRIBUTIONS

</td>

<td style="text-align:left;">

List Transactional Distribution Links

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XR DIRECTORY IMPORT

</td>

<td style="text-align:left;">

Import Contacts into Mailing List with Transactions

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XR DIRECTORY IMPORT

</td>

<td style="text-align:left;">

Transaction Contacts Import Status

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XR DIRECTORY IMPORT

</td>

<td style="text-align:left;">

Transaction Contacts Import Summary

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

TICKETS

</td>

<td style="text-align:left;">

Get Tickets

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CUSTOM CONTACT FREQUENCY

</td>

<td style="text-align:left;">

Create Contact-Frequency Rule

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CUSTOM CONTACT FREQUENCY

</td>

<td style="text-align:left;">

List Contact-Frequency Rules

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CUSTOM CONTACT FREQUENCY

</td>

<td style="text-align:left;">

Get Frequency Rule

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CUSTOM CONTACT FREQUENCY

</td>

<td style="text-align:left;">

Update Contact-Frequency Rule

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

XM DIRECTORY CUSTOM CONTACT FREQUENCY

</td>

<td style="text-align:left;">

Delete Contact-Frequency Rule

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

LOGGING EVENTS

</td>

<td style="text-align:left;">

Get Activity Types

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

LOGGING EVENTS

</td>

<td style="text-align:left;">

Get Activity Log

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Problem with offset pagination

</td>

</tr>

<tr>

<td style="text-align:left;">

DATA PRIVACY

</td>

<td style="text-align:left;">

Create Erasure Request

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Will be hard to test

</td>

</tr>

<tr>

<td style="text-align:left;">

DATA PRIVACY

</td>

<td style="text-align:left;">

List Erasure Requests

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Will be hard to test

</td>

</tr>

<tr>

<td style="text-align:left;">

DATA PRIVACY

</td>

<td style="text-align:left;">

Get Erasure Request

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Will be hard to test

</td>

</tr>

</tbody>

</table>
