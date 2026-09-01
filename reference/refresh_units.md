# Clear the cached unit selector

Forgets the session cache of unit data used by
[`get_unit()`](https://stunning-adventure-qw67g82.pages.github.io/reference/get_unit.md)
and
[`get_geography()`](https://stunning-adventure-qw67g82.pages.github.io/reference/get_geography.md),
so the next call fetches fresh data from the API.

## Usage

``` r
refresh_units()
```

## Value

Invisibly `TRUE` if a cache was cleared, `FALSE` otherwise.

## Examples

``` r
if (FALSE) { # \dontrun{
refresh_units()
get_unit() # refetches from the API
} # }
```
