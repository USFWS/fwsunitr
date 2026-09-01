# Get geography for units by name, code, state, region, or type

Returns unit geography from the FWS Unit REST API as an sf object. With
no arguments, returns geography for all units. Otherwise keeps units
matching any supplied `name` or `code`, then narrows to those also
matching `state`, `region`, and `type`. Name and type matching are
case-insensitive and tolerant of partial values; name matching also
treats "national wildlife refuge", "nwr", and "refuge" as equivalent.

## Usage

``` r
get_geography(
  name = NULL,
  code = NULL,
  state = NULL,
  region = NULL,
  type = NULL,
  crs = 4326,
  geometry = TRUE
)
```

## Arguments

- name:

  Optional character vector of full or partial unit names (e.g.
  `"kenai"`, `"kenai nwr"`).

- code:

  Optional character vector of unit codes (e.g. `"FF07RYKD00"`).
  Case-insensitive.

- state:

  Optional two-letter state code(s) to filter by (e.g. `"AK"`). A unit
  matches if any of its state codes matches any supplied value.
  Case-insensitive; vectors match any.

- region:

  Optional FWS region(s) to filter by. Accepts the region number (e.g.
  `7`) or the full region code (e.g. `"R0007"`); vectors match any.

- type:

  Optional unit type(s) to filter by, matched against the `type_name`
  field (e.g. `"refuge"`). Case-insensitive substring match; vectors
  match any.

- crs:

  Coordinate reference system for the returned geometries, passed to
  [`sf::st_sf()`](https://r-spatial.github.io/sf/reference/sf.html).
  Defaults to `4326` (WGS84), the CRS of the API's WKT output.

- geometry:

  Logical. If `TRUE` (default), return an sf object. If `FALSE`, return
  a plain tibble with the raw WKT `geography` column.

## Value

An sf object (or tibble if `geometry = FALSE`) with columns `code`,
`full_name`, and geometry (or a WKT `geography` column). Units with no
geography yield empty geometries.

## Examples

``` r
if (FALSE) { # \dontrun{
get_geography()                        # all units
get_geography(name = "kenai")
get_geography(code = "FF07RYKD00")
get_geography(state = "AK")
get_geography(region = 7)
get_geography(type = "refuge")         # refuges only
get_geography(code = "FF07RYKD00", geometry = FALSE) # raw WKT tibble
} # }
```
