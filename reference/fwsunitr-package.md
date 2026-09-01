# fwsunitr: Interface to the FWS Unit REST API

Retrieve U.S. Fish and Wildlife Service organizational unit information
from the FWS Unit REST API (<https://iris.fws.gov/APPS/Unit>). Responses
are returned as tibbles.

## Functions

- [`get_regions()`](https://usfws.github.io/fwsunitr/reference/get_regions.md):

  The FWS regions (code and name for each).

- [`get_unit()`](https://usfws.github.io/fwsunitr/reference/get_unit.md):

  Unit records, filtered by name, code, state, region, or type.

- [`get_geography()`](https://usfws.github.io/fwsunitr/reference/get_geography.md):

  Geography (as sf) for all units or by name, code, state, region, or
  type.

- [`refresh_units()`](https://usfws.github.io/fwsunitr/reference/refresh_units.md):

  Clear the session cache of unit data.

## Options

The API host defaults to `https://iris.fws.gov`. Override it for a
session with `options(fwsunitr.base_url = "https://staging-fws-host")`.

## See also

Useful links:

- <https://github.com/USFWS/fwsunitr>

- Report bugs at <https://github.com/USFWS/fwsunitr/issues>

## Author

**Maintainer**: McCrea Cobb <mccrea_cobb@fws.gov>
([ORCID](https://orcid.org/0000-0001-9412-1468))

Authors:

- McCrea Cobb <mccrea_cobb@fws.gov>
  ([ORCID](https://orcid.org/0000-0001-9412-1468))
