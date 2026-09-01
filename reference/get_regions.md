# Get regions and their units

Retrieves the Region subtype from `/api/Unit/subtypes`, returned as a
long tibble with one row per unit in the region subtype. The API
currently serves only the Region ("REG") subtype.

## Usage

``` r
get_regions()
```

## Value

A tibble with columns `subtype_code`, `subtype_name`, `unit_code`, and
`unit_name`.

## Details

The API host is set with `options(fwsunitr.base_url = "https://host")`;
it defaults to the FWS production host.

## Examples

``` r
if (FALSE) { # \dontrun{
get_regions()
} # }
```
