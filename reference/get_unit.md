# Get unit information

Returns unit records as a tibble. With no arguments, returns all units.
Arguments filter the set: `name` matches unit names, `code` matches unit
codes, `state` matches the unit's state code(s), `region` matches the
FWS region, and `type` matches the unit type (e.g. "refuge"). Units
matching any supplied `name` or `code` are kept, then narrowed to those
also matching `state`, `region`, and `type`. Name and type matching are
case-insensitive and tolerant of partial values; name matching also
treats "national wildlife refuge", "nwr", and "refuge" as equivalent.

## Usage

``` r
get_unit(
  name = NULL,
  code = NULL,
  state = NULL,
  region = NULL,
  type = NULL,
  links = FALSE
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

- links:

  Logical. If `TRUE`, include the direct and indirect link list-columns
  (`direct_links`, `direct_inactives`, `indirect_links`,
  `indirect_inactives`). Defaults to `FALSE`.

## Value

A tibble of unit fields. When `links = TRUE`, four linkage list-columns
are appended.

## Details

The API's `/api/Unit/{code}` endpoint is documented as experimental and
returns a placeholder for every input, so it is not used. Units are
looked up in the authoritative `/api/Unit/unitselector` listing, which
is cached for the session (clear it with
[`refresh_units()`](https://stunning-adventure-qw67g82.pages.github.io/reference/refresh_units.md)).

## Examples

``` r
if (FALSE) { # \dontrun{
get_unit()                              # all units
get_unit(name = "kenai")
get_unit(code = "FF07RYKD00")
get_unit(name = "kenai nwr", code = "FF07RYKD00")
get_unit(state = "AK")
get_unit(region = 7)
get_unit(type = "refuge")               # refuges only
get_unit(region = 7, type = "refuge")
get_unit(code = "FF07RYKD00", links = TRUE)
} # }
```
