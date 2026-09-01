#' Get geography for units by name, code, state, region, or type
#'
#' Returns unit geography from the FWS Unit REST API as an \pkg{sf} object. With
#' no arguments, returns geography for all units. Otherwise keeps units matching
#' any supplied `name` or `code`, then narrows to those also matching `state`,
#' `region`, and `type`. Name and type matching are case-insensitive and
#' tolerant of partial values; name matching also treats "national wildlife
#' refuge", "nwr", and "refuge" as equivalent.
#'
#' @param name Optional character vector of full or partial unit names (e.g.
#'   `"kenai"`, `"kenai nwr"`).
#' @param code Optional character vector of unit codes (e.g. `"FF07RYKD00"`).
#'   Case-insensitive.
#' @param state Optional two-letter state code(s) to filter by (e.g. `"AK"`).
#'   A unit matches if any of its state codes matches any supplied value.
#'   Case-insensitive; vectors match any.
#' @param region Optional FWS region(s) to filter by. Accepts the region number
#'   (e.g. `7`) or the full region code (e.g. `"R0007"`); vectors match any.
#' @param type Optional unit type(s) to filter by, matched against the
#'   `type_name` field (e.g. `"refuge"`). Case-insensitive substring match;
#'   vectors match any.
#' @param crs Coordinate reference system for the returned geometries, passed to
#'   [sf::st_sf()]. Defaults to `4326` (WGS84), the CRS of the API's WKT output.
#' @param geometry Logical. If `TRUE` (default), return an \pkg{sf} object. If
#'   `FALSE`, return a plain tibble with the raw WKT `geography` column.
#' @return An \pkg{sf} object (or tibble if `geometry = FALSE`) with columns
#'   `unit_code`, `unit_name`, and geometry (or a WKT `geography` column).
#'   Units with no geography yield empty geometries.
#' @importFrom cli cli_abort cli_warn
#' @export
#' @examples
#' \dontrun{
#' get_geography()                        # all units
#' get_geography(name = "kenai")
#' get_geography(code = "FF07RYKD00")
#' get_geography(state = "AK")
#' get_geography(region = 7)
#' get_geography(type = "refuge")         # refuges only
#' get_geography(code = "FF07RYKD00", geometry = FALSE) # raw WKT tibble
#' }
get_geography <- function(
  name = NULL,
  code = NULL,
  state = NULL,
  region = NULL,
  type = NULL,
  crs = 4326,
  geometry = TRUE
) {
  if (!is.null(name) && !is.character(name)) {
    cli_abort("{.arg name} must be {.code NULL} or a character vector.")
  }
  if (!is.null(code) && !is.character(code)) {
    cli_abort("{.arg code} must be {.code NULL} or a character vector.")
  }

  units <- unit_selector_cached()
  resolved <- filter_units(units, code = code, name = name)
  if (!is.null(state)) {
    resolved <- filter_state(resolved, state)
  }
  if (!is.null(region)) {
    resolved <- filter_region(resolved, region)
  }
  if (!is.null(type)) {
    resolved <- filter_type(resolved, type)
  }
  resolved <- resolved[, c("unit_code", "unit_name")]

  if (nrow(resolved) == 0L) {
    cli_warn("No units matched the supplied filters.")
  }

  geo <- fetch_all_geography()
  out <- dplyr::left_join(resolved, geo, by = c("unit_code" = "code"))
  out <- out[order(out$unit_name), ]

  missing_geo <- out$unit_code[!is.na(out$unit_code) & is.na(out$geography)]
  if (length(missing_geo) > 0L) {
    cli_warn("No geography available for {length(missing_geo)} unit{?s}.")
  }

  if (!geometry) {
    return(out)
  }
  as_geography_sf(out, crs = crs)
}

#' Fetch geography for all units (internal)
#'
#' Retrieves the raw geography listing from `/api/Unit/AllGeography`.
#'
#' @return A tibble with columns `code` and `geography` (WKT).
#' @importFrom rlang %||%
#' @keywords internal
#' @noRd
fetch_all_geography <- function() {
  res <- unit_get("AllGeography")

  purrr::map_dfr(
    res,
    ~ tibble::tibble(
      code = .x$code %||% NA_character_,
      geography = .x$geography %||% NA_character_
    )
  )
}

#' Convert a resolved geography tibble to an sf object
#'
#' Geometries are returned as `MULTIPOLYGON` for a uniform geometry column:
#' `POLYGON` values are promoted, and rows with missing WKT become empty
#' `MULTIPOLYGON` geometries.
#'
#' @param df A tibble with `unit_code`, `unit_name`, and WKT `geography`.
#' @param crs Coordinate reference system passed to [sf::st_sf()].
#' @return An \pkg{sf} object with a `MULTIPOLYGON` geometry column.
#' @keywords internal
#' @noRd
as_geography_sf <- function(df, crs) {
  wkt <- df$geography
  geoms <- vector("list", length(wkt))
  for (i in seq_along(wkt)) {
    geoms[[i]] <- if (is.na(wkt[i]) || !nzchar(wkt[i])) {
      sf::st_multipolygon()
    } else {
      g <- sf::st_as_sfc(wkt[i], crs = crs)[[1]]
      if (inherits(g, "POLYGON")) sf::st_multipolygon(list(g)) else g
    }
  }
  sfc <- sf::st_sfc(geoms, crs = crs)
  sf::st_sf(
    df[, c("unit_code", "unit_name")],
    geometry = sfc,
    stringsAsFactors = FALSE
  )
}
