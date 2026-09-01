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
# \donttest{
refresh_units()
get_unit() # refetches from the API
#> # A tibble: 1,830 × 5
#>    unit_code  unit_type                        unit_name  state_code region_code
#>    <chr>      <chr>                            <chr>      <chr>      <chr>      
#>  1 FF01D00000 ADMINISTRATION OFFICE            Regional … OR         R0001      
#>  2 FF01D01000 ADMINISTRATION OFFICE            Admin Sup… OR         R0001      
#>  3 FF01D02000 ADMINISTRATION OFFICE            Common Pr… OR         R0001      
#>  4 FF01E00000 ADMINISTRATION OFFICE            Assistant… OR         R0001      
#>  5 FF01EIFW00 ECOLOGICAL SERVICES FIELD OFFICE Idaho Fis… OR         R0001      
#>  6 FF01EOFW00 ECOLOGICAL SERVICES FIELD OFFICE Oregon Fi… OR         R0001      
#>  7 FF01EPIF00 ECOLOGICAL SERVICES FIELD OFFICE Pacific I… OR         R0001      
#>  8 FF01EWFW00 ECOLOGICAL SERVICES FIELD OFFICE Washingto… OR         R0001      
#>  9 FF01F00000 ADMINISTRATION OFFICE            Assistant… OR         R0001      
#> 10 FF01F01000 ADMINISTRATION OFFICE            Cooperati… OR         R0001      
#> # ℹ 1,820 more rows
# }
```
