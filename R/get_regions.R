#' Get regions and their units
#'
#' Retrieves the Region subtype from `/api/Unit/subtypes`, returned as a long
#' tibble with one row per unit in the region subtype. The API currently serves
#' only the Region ("REG") subtype.
#'
#' The API host is set with `options(fwsunitr.base_url = "https://host")`; it
#' defaults to the FWS production host.
#'
#' @return A tibble with columns `subtype_code`, `subtype_name`, `unit_code`,
#'   and `unit_name`.
#' @importFrom rlang %||%
#' @export
#' @examples
#' \dontrun{
#' get_regions()
#' }
get_regions <- function() {
  res <- unit_get("subtypes")

  units <- res$units %||% list()
  tibble::tibble(
    subtype_code = res$code %||% NA_character_,
    subtype_name = res$name %||% NA_character_,
    unit_code = purrr::map_chr(units, ~ .x$code %||% NA_character_),
    unit_name = purrr::map_chr(units, ~ .x$name %||% NA_character_)
  )
}
