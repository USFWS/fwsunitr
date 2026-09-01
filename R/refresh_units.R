#' Clear the cached unit selector
#'
#' Forgets the session cache of unit data used by [get_unit()] and
#' [get_geography()], so the next call fetches fresh data from the API.
#'
#' @return Invisibly `TRUE` if a cache was cleared, `FALSE` otherwise.
#' @importFrom memoise forget is.memoised
#' @export
#' @examples
#' \dontrun{
#' refresh_units()
#' get_unit() # refetches from the API
#' }
refresh_units <- function() {
  if (is.memoised(unit_selector_cached)) {
    forget(unit_selector_cached)
  } else {
    invisible(FALSE)
  }
}
