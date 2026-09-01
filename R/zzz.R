.onLoad <- function(libname, pkgname) {
  op <- options()
  defaults <- list(
    fwsunitr.base_url = "https://iris.fws.gov"
  )
  toset <- !(names(defaults) %in% names(op))
  if (any(toset)) {
    options(defaults[toset])
  }

  # Cache the unit data for the session. It returns ~1,800 units and backs
  # get_unit(), get_code(), and get_geography(). Clear it with refresh_units().
  unit_selector_cached <<- memoise::memoise(unit_selector_impl)

  invisible()
}
