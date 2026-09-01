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
[`refresh_units()`](https://usfws.github.io/fwsunitr/reference/refresh_units.md)).

## Examples

``` r
# \donttest{
get_unit()                              # all units
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
get_unit(name = "kenai")
#> # A tibble: 2 × 5
#>   unit_code  unit_type                          unit_name state_code region_code
#>   <chr>      <chr>                              <chr>     <chr>      <chr>      
#> 1 FF07CAKN00 FISH AND WILDLIFE CONSERVATION OF… Kenai Fi… AK         R0007      
#> 2 FF07RKNA00 NATIONAL WILDLIFE REFUGE           Kenai Na… AK         R0007      
get_unit(code = "FF07RYKD00")
#> # A tibble: 1 × 5
#>   unit_code  unit_type                unit_name           state_code region_code
#>   <chr>      <chr>                    <chr>               <chr>      <chr>      
#> 1 FF07RYKD00 NATIONAL WILDLIFE REFUGE Yukon Delta Nation… AK         R0007      
get_unit(name = "kenai nwr", code = "FF07RYKD00")
#> # A tibble: 2 × 5
#>   unit_code  unit_type                unit_name           state_code region_code
#>   <chr>      <chr>                    <chr>               <chr>      <chr>      
#> 1 FF07RKNA00 NATIONAL WILDLIFE REFUGE Kenai National Wil… AK         R0007      
#> 2 FF07RYKD00 NATIONAL WILDLIFE REFUGE Yukon Delta Nation… AK         R0007      
get_unit(state = "AK")
#> # A tibble: 78 × 5
#>    unit_code  unit_type                         unit_name state_code region_code
#>    <chr>      <chr>                             <chr>     <chr>      <chr>      
#>  1 FF07C00000 ADMINISTRATION OFFICE             Assistan… AK         R0007      
#>  2 FF07CAAN00 FISH AND WILDLIFE CONSERVATION O… Anchorag… AK         R0007      
#>  3 FF07CACG00 FISH AND WILDLIFE CONSERVATION O… Conserva… AK         R0007      
#>  4 FF07CAFB00 FISH AND WILDLIFE CONSERVATION O… Fairbank… AK         R0007      
#>  5 FF07CAJN00 FISH AND WILDLIFE CONSERVATION O… Juneau S… AK         R0007      
#>  6 FF07CAKN00 FISH AND WILDLIFE CONSERVATION O… Kenai Fi… AK         R0007      
#>  7 FF07CAMM00 FISH AND WILDLIFE CONSERVATION O… Marine M… AK         R0007      
#>  8 FF07CASA00 ADMINISTRATION OFFICE             Southern… AK         R0007      
#>  9 FF07D01000 ADMINISTRATION OFFICE             Admin Su… AK         R0007      
#> 10 FF07D02000 ADMINISTRATION OFFICE             Common  … AK         R0007      
#> # ℹ 68 more rows
get_unit(region = 7)
#> # A tibble: 73 × 5
#>    unit_code  unit_type                         unit_name state_code region_code
#>    <chr>      <chr>                             <chr>     <chr>      <chr>      
#>  1 FF07C00000 ADMINISTRATION OFFICE             Assistan… AK         R0007      
#>  2 FF07CAAN00 FISH AND WILDLIFE CONSERVATION O… Anchorag… AK         R0007      
#>  3 FF07CACG00 FISH AND WILDLIFE CONSERVATION O… Conserva… AK         R0007      
#>  4 FF07CAFB00 FISH AND WILDLIFE CONSERVATION O… Fairbank… AK         R0007      
#>  5 FF07CAJN00 FISH AND WILDLIFE CONSERVATION O… Juneau S… AK         R0007      
#>  6 FF07CAKN00 FISH AND WILDLIFE CONSERVATION O… Kenai Fi… AK         R0007      
#>  7 FF07CAMM00 FISH AND WILDLIFE CONSERVATION O… Marine M… AK         R0007      
#>  8 FF07CASA00 ADMINISTRATION OFFICE             Southern… AK         R0007      
#>  9 FF07D00000 ADMINISTRATION OFFICE             Regional… OR         R0007      
#> 10 FF07D01000 ADMINISTRATION OFFICE             Admin Su… AK         R0007      
#> # ℹ 63 more rows
get_unit(type = "refuge")               # refuges only
#> # A tibble: 681 × 5
#>    unit_code  unit_type                    unit_name      state_code region_code
#>    <chr>      <chr>                        <chr>          <chr>      <chr>      
#>  1 FF01R04000 REFUGE ADMINISTRATIVE OFFICE Visitor Servi… OR         R0001      
#>  2 FF01RANK00 NATIONAL WILDLIFE REFUGE     Ankeny Nation… OR         R0001      
#>  3 FF01RBDM00 NATIONAL WILDLIFE REFUGE     Bandon Marsh … OR         R0001      
#>  4 FF01RBIC00 REFUGE ADMINISTRATIVE OFFICE Big Island Na… HI         R0001      
#>  5 FF01RBKI00 NATIONAL WILDLIFE REFUGE     Baker Island … HI         R0001      
#>  6 FF01RBKS00 NATIONAL WILDLIFE REFUGE     Baskett Sloug… OR         R0001      
#>  7 FF01RBRL00 NATIONAL WILDLIFE REFUGE     Bear Lake Nat… ID         R0001      
#>  8 FF01RCMB00 NATIONAL WILDLIFE REFUGE     Columbia Nati… WA         R0001      
#>  9 FF01RCMS00 NATIONAL WILDLIFE REFUGE     Camas Nationa… ID         R0001      
#> 10 FF01RCNL00 NATIONAL WILDLIFE REFUGE     Conboy Lake N… WA         R0001      
#> # ℹ 671 more rows
get_unit(region = 7, type = "refuge")
#> # A tibble: 19 × 5
#>    unit_code  unit_type                    unit_name      state_code region_code
#>    <chr>      <chr>                        <chr>          <chr>      <chr>      
#>  1 FF07RAM000 NATIONAL WILDLIFE REFUGE     Alaska Mariti… AK         R0007      
#>  2 FF07RAP000 REFUGE ADMINISTRATIVE OFFICE Alaska Penins… AK         R0007      
#>  3 FF07RAPB00 NATIONAL WILDLIFE REFUGE     Becharof Nati… AK         R0007      
#>  4 FF07RAPN00 NATIONAL WILDLIFE REFUGE     Alaska Penins… AK         R0007      
#>  5 FF07RARC00 NATIONAL WILDLIFE REFUGE     Arctic Nation… AK         R0007      
#>  6 FF07RINN00 NATIONAL WILDLIFE REFUGE     Innoko Nation… AK         R0007      
#>  7 FF07RIZM00 NATIONAL WILDLIFE REFUGE     Izembek Natio… AK         R0007      
#>  8 FF07RKAN00 NATIONAL WILDLIFE REFUGE     Kanuti Nation… AK         R0007      
#>  9 FF07RKDK00 NATIONAL WILDLIFE REFUGE     Kodiak Nation… AK         R0007      
#> 10 FF07RKNA00 NATIONAL WILDLIFE REFUGE     Kenai Nationa… AK         R0007      
#> 11 FF07RKU000 REFUGE ADMINISTRATIVE OFFICE Koyukuk/Nowit… AK         R0007      
#> 12 FF07RKUK00 NATIONAL WILDLIFE REFUGE     Koyukuk Natio… AK         R0007      
#> 13 FF07RKUN00 NATIONAL WILDLIFE REFUGE     Nowitna Natio… AK         R0007      
#> 14 FF07RSWK00 NATIONAL WILDLIFE REFUGE     Selawik Natio… AK         R0007      
#> 15 FF07RTET00 NATIONAL WILDLIFE REFUGE     Tetlin Nation… AK         R0007      
#> 16 FF07RTGK00 NATIONAL WILDLIFE REFUGE     Togiak Nation… AK         R0007      
#> 17 FF07RYFY00 REFUGE ADMINISTRATIVE OFFICE Ft Yukon Admi… AK         R0007      
#> 18 FF07RYKD00 NATIONAL WILDLIFE REFUGE     Yukon Delta N… AK         R0007      
#> 19 FF07RYKF00 NATIONAL WILDLIFE REFUGE     Yukon Flats N… AK         R0007      
get_unit(code = "FF07RYKD00", links = TRUE)
#> # A tibble: 1 × 9
#>   unit_code  unit_type             unit_name state_code region_code direct_links
#>   <chr>      <chr>                 <chr>     <chr>      <chr>       <list>      
#> 1 FF07RYKD00 NATIONAL WILDLIFE RE… Yukon De… AK         R0007       <list [24]> 
#> # ℹ 3 more variables: direct_inactives <list>, indirect_links <list>,
#> #   indirect_inactives <list>
# }
```
