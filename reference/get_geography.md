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

An sf object (or tibble if `geometry = FALSE`) with columns `unit_code`,
`unit_name`, and geometry (or a WKT `geography` column). Units with no
geography yield empty geometries.

## Examples

``` r
# \donttest{
get_geography()                        # all units
#> Warning: No geography available for 1144 units.
#> Simple feature collection with 1830 features and 2 fields (with 1144 geometries empty)
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -180 ymin: -14.55975 xmax: 180 ymax: 70.17047
#> Geodetic CRS:  WGS 84
#> # A tibble: 1,830 × 3
#>    unit_code  unit_name                                                 geometry
#>    <chr>      <chr>                                           <MULTIPOLYGON [°]>
#>  1 FF04R03400 ARMY FIRE SUPPORT                                            EMPTY
#>  2 FF01FABR00 Abernathy Fish Technology Center (((-123.1568 46.22274, -123.1419…
#>  3 FF09G21000 Acquisition Branch                                           EMPTY
#>  4 FF01D01000 Admin Support-R1                                             EMPTY
#>  5 FF02D01000 Admin Support-R2                                             EMPTY
#>  6 FF03D01000 Admin Support-R3                                             EMPTY
#>  7 FF04D01000 Admin Support-R4                                             EMPTY
#>  8 FF05D01000 Admin Support-R5                                             EMPTY
#>  9 FF06D01000 Admin Support-R6                                             EMPTY
#> 10 FF07D01000 Admin Support-R7                                             EMPTY
#> # ℹ 1,820 more rows
get_geography(name = "kenai")
#> Warning: No geography available for 1 unit.
#> Simple feature collection with 2 features and 2 fields (with 1 geometry empty)
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -151.2159 ymin: 59.4328 xmax: -149.7153 ymax: 61.03903
#> Geodetic CRS:  WGS 84
#> # A tibble: 2 × 3
#>   unit_code  unit_name                                                  geometry
#>   <chr>      <chr>                                            <MULTIPOLYGON [°]>
#> 1 FF07CAKN00 Kenai Fish and Wildlife Conservation Off…                     EMPTY
#> 2 FF07RKNA00 Kenai National Wildlife Refuge            (((-151.2159 59.4328, -1…
get_geography(code = "FF07RYKD00")
#> Simple feature collection with 1 feature and 2 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -167.8523 ymin: 59.63253 xmax: -159.137 ymax: 63.48838
#> Geodetic CRS:  WGS 84
#> # A tibble: 1 × 3
#>   unit_code  unit_name                                                  geometry
#>   <chr>      <chr>                                            <MULTIPOLYGON [°]>
#> 1 FF07RYKD00 Yukon Delta National Wildlife Refuge (((-167.8523 59.63253, -159.1…
get_geography(state = "AK")
#> Warning: No geography available for 62 units.
#> Simple feature collection with 78 features and 2 fields (with 62 geometries empty)
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -179.1501 ymin: 51.20993 xmax: 179.7751 ymax: 70.17047
#> Geodetic CRS:  WGS 84
#> # A tibble: 78 × 3
#>    unit_code  unit_name                                                 geometry
#>    <chr>      <chr>                                           <MULTIPOLYGON [°]>
#>  1 FF07D01000 Admin Support-R7                                             EMPTY
#>  2 FF07RAM000 Alaska Maritime National Wildlife Refuge (((-179.1501 51.20993, 1…
#>  3 FF07M01000 Alaska Migratory Bird Co-Management                          EMPTY
#>  4 FF07RAPN00 Alaska Peninsula National Wildlife Refu… (((-163.3779 54.80768, -…
#>  5 FF07RAP000 Alaska Peninsula/Becharof National Wild…                     EMPTY
#>  6 FF07CAAN00 Anchorage Fish and Wildlife Conservatio…                     EMPTY
#>  7 FF07RARC00 Arctic National Wildlife Refuge          (((-149.3872 66.74213, -…
#>  8 FF07G08000 Assistant Regional Director-Budget and …                     EMPTY
#>  9 FF07C00000 Assistant Regional Director-Ecological …                     EMPTY
#> 10 FF07X00000 Assistant Regional Director-External Af…                     EMPTY
#> # ℹ 68 more rows
get_geography(region = 7)
#> Warning: No geography available for 57 units.
#> Simple feature collection with 73 features and 2 fields (with 57 geometries empty)
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -179.1501 ymin: 51.20993 xmax: 179.7751 ymax: 70.17047
#> Geodetic CRS:  WGS 84
#> # A tibble: 73 × 3
#>    unit_code  unit_name                                                 geometry
#>    <chr>      <chr>                                           <MULTIPOLYGON [°]>
#>  1 FF07D01000 Admin Support-R7                                             EMPTY
#>  2 FF07RAM000 Alaska Maritime National Wildlife Refuge (((-179.1501 51.20993, 1…
#>  3 FF07M01000 Alaska Migratory Bird Co-Management                          EMPTY
#>  4 FF07RAPN00 Alaska Peninsula National Wildlife Refu… (((-163.3779 54.80768, -…
#>  5 FF07RAP000 Alaska Peninsula/Becharof National Wild…                     EMPTY
#>  6 FF07CAAN00 Anchorage Fish and Wildlife Conservatio…                     EMPTY
#>  7 FF07RARC00 Arctic National Wildlife Refuge          (((-149.3872 66.74213, -…
#>  8 FF07G08000 Assistant Regional Director-Budget and …                     EMPTY
#>  9 FF07C00000 Assistant Regional Director-Ecological …                     EMPTY
#> 10 FF07X00000 Assistant Regional Director-External Af…                     EMPTY
#> # ℹ 63 more rows
get_geography(type = "refuge")         # refuges only
#> Warning: No geography available for 135 units.
#> Simple feature collection with 681 features and 2 fields (with 135 geometries empty)
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -180 ymin: -14.55975 xmax: 180 ymax: 70.17047
#> Geodetic CRS:  WGS 84
#> # A tibble: 681 × 3
#>    unit_code  unit_name                                                 geometry
#>    <chr>      <chr>                                           <MULTIPOLYGON [°]>
#>  1 FF03RAGS00 Agassiz National Wildlife Refuge         (((-96.07054 48.26533, -…
#>  2 FF06RALM00 Alamosa National Wildlife Refuge         (((-108.734 37.04275, -1…
#>  3 FF07RAM000 Alaska Maritime National Wildlife Refuge (((-179.1501 51.20993, 1…
#>  4 FF07RAPN00 Alaska Peninsula National Wildlife Refu… (((-163.3779 54.80768, -…
#>  5 FF07RAP000 Alaska Peninsula/Becharof National Wild…                     EMPTY
#>  6 FF04RNAR00 Alligator River National Wildlife Refuge (((-76.12011 35.57058, -…
#>  7 FF05RAMG00 Amagansett National Wildlife Refuge      (((-72.13115 40.96685, -…
#>  8 FF08RANH00 Anaho Island National Wildlife Refuge    (((-119.5222 39.94405, -…
#>  9 FF01RANK00 Ankeny National Wildlife Refuge          (((-123.1003 44.76322, -…
#> 10 FF08RATD00 Antioch Dunes National Wildlife Refuge   (((-121.8004 38.01239, -…
#> # ℹ 671 more rows
get_geography(code = "FF07RYKD00", geometry = FALSE) # raw WKT tibble
#> # A tibble: 1 × 3
#>   unit_code  unit_name                            geography                     
#>   <chr>      <chr>                                <chr>                         
#> 1 FF07RYKD00 Yukon Delta National Wildlife Refuge POLYGON ((-167.852297728 59.6…
# }
```
