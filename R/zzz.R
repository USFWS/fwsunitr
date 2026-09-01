.onLoad <- function(libname, pkgname) {
  # Cache the unit data for the session. It returns ~1,800 units and backs
  # get_unit() and get_geography(). Clear it with refresh_units().
  unit_selector_cached <<- memoise::memoise(unit_selector_impl)
  invisible()
}
