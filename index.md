# fwsunitr

> **Note:** This project was developed with the assistance of Claude, a
> generative AI tool developed by Anthropic. AI-generated content has
> been reviewed and edited by the package maintainer, who takes
> responsibility for the final content.

## Overview

**fwsunitr** is an R interface to the U.S. Fish and Wildlife Service
Unit REST API. It provides functions to retrieve FWS organizational unit
information and related lookup values from the public Unit web services.

Current functionality (read-only) includes:

- [`get_regions()`](https://usfws.github.io/fwsunitr/reference/get_regions.md):
  retrieve the FWS regions, returned as one row per region with its code
  and name.
- [`get_unit()`](https://usfws.github.io/fwsunitr/reference/get_unit.md):
  retrieve unit records. With no arguments, returns all units; otherwise
  filters by name, code, state, region, and/or type (e.g.
  `type = "refuge"`). Direct and indirect links are omitted by default;
  include them with `links = TRUE`.
- [`get_geography()`](https://usfws.github.io/fwsunitr/reference/get_geography.md):
  retrieve geography as an `sf` object (WGS84). With no arguments,
  returns all units; otherwise filters by name, code, state, region, or
  type.
- [`refresh_units()`](https://usfws.github.io/fwsunitr/reference/refresh_units.md):
  clear the session cache so the next call fetches fresh data.

Responses are returned as tibbles.

## Installation

Install the development version from GitHub:

``` r

# install.packages("pak")
pak::pak("USFWS/fwsunitr")
```

## Usage

``` r

library(fwsunitr)

# Regions (code and name for each FWS region)
get_regions()

# Unit records: all units, or filtered by name, code, state, region, or type
get_unit()
get_unit(name = "kenai")
get_unit(code = "FF07RYKD00")
get_unit(state = "AK")
get_unit(region = 7)
get_unit(type = "refuge")
get_unit(region = 7, type = "refuge")

# Geography as an sf object: all units, or filtered by name, code, state, region, or type
get_geography()
get_geography(name = "kenai")
get_geography(code = "FF07RYKD00")
get_geography(state = "AK")
get_geography(region = 7)
get_geography(type = "refuge")
```

The default API host can be overridden for a session (e.g. to target a
staging environment) via the `unitsr.base_url` option:

``` r

options(fwsunitr.base_url = "https://staging-fws-host")
```

## Getting help

Contact the [project maintainer](mailto:mccrea_cobb@fws.gov) for help
with this repository. If you have general questions on creating
repositories in the USFWS DGEC, reach out to a USFWS DGEC
[owner](https://github.com/orgs/USFWS/people?query=role%3Aowner).

## Contribute

Contact the project maintainer for information about contributing to
this repository. Submit a [GitHub
Issue](https://github.com/USFWS/fwsunitr/issues) to report a bug or
request a feature or enhancement.

------------------------------------------------------------------------

![](https://i.creativecommons.org/l/zero/1.0/88x31.png) This work is
licensed under a [Creative Commons Zero Universal v1.0
License](https://creativecommons.org/publicdomain/zero/1.0/).
