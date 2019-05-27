# QualtricsInR

The QualtricsInR package provides a general wraper for the Qualtrics v3 API references. The package is built accross the main API calls to manipulate survey objects and responses, as well as general admnistration functions and access to library items.

The package was created in order to address the need of large scale surveys at the World Economic Forum where the use of the API allowed the automate many time consuming processes and ensure robust execution processes.

- [Installation](#installation)
- [Authenticatication](#authentication)
- [Example](#example)
- [What's missing](#what-is-missing)

There are other important R packages available to automate different aspects of survey manipulation in Qualtrics. The [qualtRics](https://github.com/ropensci/qualtRics) R package implements the retrieval of survey data using the Qualtrics API and is currently the only package on CRAN that offers such functionality, and is included in the official Qualtrics API documentation.

Other related packages available trhough Github. [Jason Bryer's](https://github.com/jbryer/qualtrics) R package to work with the previous version of the Qualtrics API. [QualtricsTools](https://github.com/emmamorgan-tufts/QualtricsTools/) creates automatic reports in shiny and [qsurvey](https://github.com/jamesdunham/qsurvey), by James Dunham, focuses on testing and review of surveys before fielding, as well as the analysis of responses afterward.

**The [QualtricsInR](https://github.com/ppssphysics/QualtricsInR) package is an effort to provide in one package wrappers for all API references provided by Qualtrics.**

## Installation

You can install QualtricsInR from github using the devtools package. However, since the package is hosted on a private GitHub repository, you will need to use an authentication key (ask pierre.saouter@weforum.org for a key).

The package will eventually become public.

``` r
devtools::install_github('ppssphysics/QualtricsInR', auth_token='key')
```

We expect to submit the package to CRAN.

## Authentication

We provide two authentication methods to set-up your Qualtrics credentials:

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

If you use this method, you will have set your credentials for every new session.

### Setting-up an OAuth Client Manager

To generate an OAuth application, follow the steps below in your Qualtrics account:

1. Go to Account Settings
2. Create an OAuth application
3. Use the client id, client secret, and data center id in `qualtrics_auth`, as below.

```r
qualtrics_auth(id = "xXxxX0X0x", secret = "xXxxX0X0x", data_center = "my.center")
```

This will authenticate you, returning a bearer token valid for an hour, saving the _encrypted_ credentials in a `.qualtrics-oauth` file, which will be automatically loaded in all subsequent sessions and automatically refreshed if need be. You should therefore only find the need to run `qualtrics_auth` once.

### Example


### What is missing
