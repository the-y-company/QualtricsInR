
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

# QualtricsInR

The QualtricsInR package provides a general wrapper for the Qualtrics v3
API references. The package is built accross the main API calls to
manipulate survey objects and responses, as well as general
admnistration functions and access to library items.

The package was created in order to address the need of large scale
surveys at the World Economic Forum where the use of the API allowed the
automate many time consuming processes and ensure robust execution
processes.

  - [Installation](#installation)
  - [Authenticatication](#authentication)
  - [What’s missing](#what-is-missing)

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
references](https://api.qualtrics.com/reference) provided by
Qualtrics.**

## Installation

You can install QualtricsInR from github using the devtools package.
However, since the package is hosted on a private GitHub repository, you
will need to use an authentication key (ask <pierre.saouter@weforum.org>
for a key).

The package will eventually become public.

``` r
devtools::install_github('ppssphysics/QualtricsInR', auth_token='key')
```

We expect to submit the package to CRAN.

## Authentication

We provide two authentication methods to set-up your Qualtrics
credentials:

1.  Using a plain Token
2.  Using the OAuth 2.0

Both are valid methods. All information on how to retrieve
identification parameters and generete tokens from your Qualtrics
account can be found
[here](https://api.qualtrics.com/v3/docs/api-general-instructions).

### Setting a plain text API Token

You can set options for user authentication in your Qualtrics account by
generating a new API token. You will also need your data center id if
you are running under an entreprise account. You can then set your
authentication credentials with `set_qualtrics_opts`. By default, the
function looks for the variables QUALTRICSINR\_TOKEN and
QUALTRICSINR\_DATA\_CENTER (optional) in your .Renviron file, but you
can specify these as you wish.

``` r
# set auth options assuming definition in .Renviron
set_qualtrics_opts()

# set auth options by hand
set_qualtrics_opts("983282032932sds2","mydatacenter")

# set auth options with custom .Renviron names
set_qualtrics_opts(Sys.getenb("VAR1"),Sys.getenb("VAR2"))
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

## What’s missing

A number of things.
