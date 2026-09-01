#' Fetch and tidy all units (internal worker)
#'
#' Retrieves all units from `/api/Unit/unitselector` and tidies them into a
#' tibble with linkage list-columns. Backs the public [get_unit()] and
#' [get_geography()]. Memoised for the session in `.onLoad()`; clear the
#' cache with [refresh_units()].
#'
#' @return A tibble with unit fields plus list-columns `direct_links`,
#'   `direct_inactives`, `indirect_links`, and `indirect_inactives`.
#' @importFrom rlang %||%
#' @keywords internal
#' @noRd
unit_selector_impl <- function() {
  res <- unit_get("unitselector")

  purrr::map_dfr(res, function(x) {
    u <- x$Unit %||% list()
    tibble::tibble(
      code = u$code %||% NA_character_,
      type_name = u$typeName %||% NA_character_,
      full_name = u$fullName %||% NA_character_,
      type_display = u$typeDisplay %||% NA_character_,
      sub_type_display = u$subTypeDisplay %||% NA_character_,
      lifecycle = u$lifecycle %||% NA,
      state_codes = u$stateCodes %||% NA_character_,
      region_code = u$regionCode %||% NA_character_,
      direct_links = list(x$DirectLinks %||% list()),
      direct_inactives = list(x$DirectInactives %||% list()),
      indirect_links = list(x$IndirectLinks %||% list()),
      indirect_inactives = list(x$IndirectInactives %||% list())
    )
  })
}

# Memoised at load time in .onLoad(); see zzz.R.
unit_selector_cached <- NULL
