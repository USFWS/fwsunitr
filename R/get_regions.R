#' Get FWS regions
#'
#' Retrieves the FWS regions from `/api/Unit/subtypes`, returned as a tibble
#' with one row per region (its code and name). The endpoint serves the Region
#' ("REG") subtype; each entry under it is a region.
#'
#' The API host is set with `options(fwsunitr.base_url = "https://host")`; it
#' defaults to the FWS production host.
#'
#' @return A tibble with columns `region_code` and `region_name`, one row per
#'   FWS region.
#' @importFrom rlang %||%
#' @export
#' @examples
#' \dontrun{
#' get_regions()
#' }
get_regions <- function() {
  res <- unit_get("subtypes")

  regions <- res$units %||% list()
  tibble::tibble(
    region_code = purrr::map_chr(regions, ~ .x$code %||% NA_character_),
    region_name = purrr::map_chr(regions, ~ .x$name %||% NA_character_)
  )
}
