
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

Find the official documentation [here](https://qualtrics.psaouter.com/).

# QualtricsInR

The **QualtricsInR** package provides a general R wrapper for the
Qualtrics [API v3 references](https://api.qualtrics.com/reference). The
package is built accross the main API calls to manipulate survey objects
and responses, as well as general survey and account admnistration
functions.

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

## Getting Started

You can install QualtricsInR from github using the devtools package.

``` r
devtools::install_github('ppssphysics/QualtricsInR')
```

The package is made available on GitHub in order to collect feedback
from the community before we consider a submission to CRAN.

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
`QUALTRICSINR_TOKEN` and `QUALTRICSINR_DATA_CENTER` respectively. Upon
loading the QualtricsInR package, your credentials will be automatically
set as internal *encrypted* parameters.

You can always custom set your credentials by calling the
`set_qualtrics_opts()` function:

``` r
# set auth options assuming definition in .Renviron
set_qualtrics_opts()
# set auth options by hand
set_qualtrics_opts("9ssssss83jsl83282032932sds2", "mydatacenter")
```

If you use this method, you will have set your credentials for every new
session.

### Setting-up an OAuth Client Manager

To generate an OAuth application, follow the steps below in your
Qualtrics account:

1.  Go to Account Settings
2.  Create an OAuth application
3.  Use the client id, client secret, and data center id in
    `qualtrics_auth`, as below.

<!-- end list -->

``` r
qualtrics_auth(id = "xXxxX0X0x", secret = "xXxxX0X0x", data_center = "my.center")
```

This will authenticate you, returning a bearer token valid for one hour,
saving the *encrypted* credentials in a `.qualtrics-oauth` file, which
will be automatically loaded in all subsequent sessions and
automatically refreshed if need be. You should therefore only find the
need to run `qualtrics_auth` once.

## Development pipeline

There are close to 200 different API calls provides by Qualtrics.
Depending on interest, demand, and help from the community, efforts will
be dedicated to the testing and implementation of missing references.
Most of the XM Directory related calls are not implemented due to not
having access to this feature in our own account.
