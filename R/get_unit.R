#' Get unit information
#'
#' Returns unit records as a tibble. With no arguments, returns all units.
#' Arguments filter the set: `name` matches unit names, `code` matches unit
#' codes, `state` matches the unit's state code(s), `region` matches the FWS
#' region, and `type` matches the unit type (e.g. "refuge"). Units matching any
#' supplied `name` or `code` are kept, then narrowed to those also matching
#' `state`, `region`, and `type`. Name and type matching are case-insensitive
#' and tolerant of partial values; name matching also treats "national wildlife
#' refuge", "nwr", and "refuge" as equivalent.
#'
#' @details
#' The API's `/api/Unit/{code}` endpoint is documented as experimental and
#' returns a placeholder for every input, so it is not used. Units are looked up
#' in the authoritative `/api/Unit/unitselector` listing, which is cached for
#' the session (clear it with [refresh_units()]).
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
#' @param links Logical. If `TRUE`, include the direct and indirect link
#'   list-columns (`direct_links`, `direct_inactives`, `indirect_links`,
#'   `indirect_inactives`). Defaults to `FALSE`.
#' @return A tibble of unit fields. When `links = TRUE`, four linkage
#'   list-columns are appended.
#' @export
#' @examples
#' \donttest{
#' get_unit()                              # all units
#' get_unit(name = "kenai")
#' get_unit(code = "FF07RYKD00")
#' get_unit(name = "kenai nwr", code = "FF07RYKD00")
#' get_unit(state = "AK")
#' get_unit(region = 7)
#' get_unit(type = "refuge")               # refuges only
#' get_unit(region = 7, type = "refuge")
#' get_unit(code = "FF07RYKD00", links = TRUE)
#' }
get_unit <- function(
  name = NULL,
  code = NULL,
  state = NULL,
  region = NULL,
  type = NULL,
  links = FALSE
) {
  if (!is.null(name) && !is.character(name)) {
    cli::cli_abort("{.arg name} must be {.code NULL} or a character vector.")
  }
  if (!is.null(code) && !is.character(code)) {
    cli::cli_abort("{.arg code} must be {.code NULL} or a character vector.")
  }

  units <- unit_selector_cached()
  if (!links) {
    units <- units[, !names(units) %in% link_columns()]
  }

  units <- filter_units(units, code = code, name = name)
  if (!is.null(state)) {
    units <- filter_state(units, state)
  }
  if (!is.null(region)) {
    units <- filter_region(units, region)
  }
  if (!is.null(type)) {
    units <- filter_type(units, type)
  }

  if (nrow(units) == 0L) {
    cli::cli_warn("No units matched the supplied filters.")
  }

  units
}
