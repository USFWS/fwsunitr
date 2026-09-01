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
# \donttest{
get_regions()
#> # A tibble: 9 × 2
#>   region_code region_name                              
#>   <chr>       <chr>                                    
#> 1 R0001       Pacific Region, Region 1                 
#> 2 R0002       Southwest Region, Region 2               
#> 3 R0003       Great Lakes - Big Rivers Region, Region 3
#> 4 R0004       Southeast Region, Region 4               
#> 5 R0005       Northeast Region, Region 5               
#> 6 R0006       Mountain - Prairie Region, Region 6      
#> 7 R0007       Alaska Region, Region 7                  
#> 8 R0008       Pacific Southwest Region, Region 8       
#> 9 R0009       Washington Office, Region 9              
# }
```
