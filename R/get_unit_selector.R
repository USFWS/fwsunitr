#' Fetch and tidy all units (internal worker)
#'
#' Retrieves all units from `/api/Unit/unitselector` and tidies them into a
#' tibble with linkage list-columns. Backs the public [get_unit()] and
#' [get_geography()]. Memoised for the session in `.onLoad()`; clear the
#' cache with [refresh_units()].
#'
#' @return A tibble with columns `unit_code`, `unit_type`, `unit_name`,
#'   `state_code`, `region_code`, plus list-columns `direct_links`,
#'   `direct_inactives`, `indirect_links`, and `indirect_inactives`.
#' @importFrom rlang %||%
#' @keywords internal
#' @noRd
unit_selector_impl <- function() {
  res <- unit_get("unitselector")
  u <- purrr::map(res, "Unit")

  tibble::tibble(
    unit_code = purrr::map_chr(u, ~ .x$code %||% NA_character_),
    unit_type = purrr::map_chr(u, ~ .x$typeName %||% NA_character_),
    unit_name = purrr::map_chr(u, ~ .x$fullName %||% NA_character_),
    state_code = purrr::map_chr(u, ~ .x$stateCodes %||% NA_character_),
    region_code = purrr::map_chr(u, ~ .x$regionCode %||% NA_character_),
    direct_links = purrr::map(res, ~ .x$DirectLinks %||% list()),
    direct_inactives = purrr::map(res, ~ .x$DirectInactives %||% list()),
    indirect_links = purrr::map(res, ~ .x$IndirectLinks %||% list()),
    indirect_inactives = purrr::map(res, ~ .x$IndirectInactives %||% list())
  )
}

# Memoised at load time in .onLoad(); see zzz.R.
unit_selector_cached <- NULL
