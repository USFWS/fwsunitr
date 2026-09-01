# Get FWS regions

Retrieves the FWS regions from `/api/Unit/subtypes`, returned as a
tibble with one row per region (its code and name). The endpoint serves
the Region ("REG") subtype; each entry under it is a region.

## Usage

``` r
get_regions()
```

## Value

A tibble with columns `region_code` and `region_name`, one row per FWS
region.

## Details

The API host is set with `options(fwsunitr.base_url = "https://host")`;
it defaults to the FWS production host.

## Examples

``` r
if (FALSE) { # \dontrun{
get_regions()
} # }
```
