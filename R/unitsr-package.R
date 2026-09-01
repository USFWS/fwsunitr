#' fwsunitr: Interface to the FWS Unit REST API
#'
#' Retrieve U.S. Fish and Wildlife Service organizational unit information from
#' the FWS Unit REST API (\url{https://iris.fws.gov/APPS/Unit}). Responses are
#' returned as tibbles.
#'
#' @section Functions:
#' \describe{
#'   \item{[get_regions()]}{Regions and the units within the region subtype.}
#'   \item{[get_unit()]}{Unit records, filtered by name, code, state, region, or type.}
#'   \item{[get_geography()]}{Geography (as \pkg{sf}) for all units or by name, code, state, region, or type.}
#'   \item{[refresh_units()]}{Clear the session cache of unit data.}
#' }
#'
#' @section Options:
#' The API host defaults to `https://iris.fws.gov`. Override it for a session
#' with `options(fwsunitr.base_url = "https://staging-fws-host")`.
#'
#' @keywords internal
"_PACKAGE"
