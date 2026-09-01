#' Build and perform a request to the Unit REST API
#'
#' Internal helper that constructs a request against the FWS Unit service,
#' performs it, and returns parsed JSON. HTTP and network failures are
#' translated into informative cli errors. The API host is read from the
#' `fwsunitr.base_url` option, defaulting to the FWS production host.
#'
#' @param path Character. Path appended after the API base (e.g. `"subtypes"`).
#' @param call Environment. The calling context, used so errors are reported
#'   against the user-facing function.
#' @return A parsed JSON object (list).
#' @importFrom rlang caller_env
#' @keywords internal
#' @noRd
unit_get <- function(path, call = caller_env()) {
  base_url <- getOption("fwsunitr.base_url", "https://iris.fws.gov")
  if (!nzchar(base_url)) {
    cli::cli_abort(
      "No API host set. Set {.code options(fwsunitr.base_url = \"https://host\")}.",
      call = call
    )
  }

  req <- httr2::request(base_url) |>
    httr2::req_url_path_append("APPS", "Unit", "api", "Unit", path) |>
    httr2::req_headers(Accept = "application/json") |>
    httr2::req_user_agent("fwsunitr R package")

  resp <- tryCatch(
    httr2::req_perform(req),
    httr2_http_404 = function(cnd) {
      cli::cli_abort(
        c(
          "Resource not found at {.url {req$url}}.",
          "i" = "The requested unit or endpoint may not exist."
        ),
        parent = cnd,
        call = call
      )
    },
    httr2_http = function(cnd) {
      cli::cli_abort(
        "The Unit API request to {.url {req$url}} failed.",
        parent = cnd,
        call = call
      )
    },
    httr2_failure = function(cnd) {
      cli::cli_abort(
        c(
          "Could not reach the Unit API.",
          "i" = "Check your connection or the {.code fwsunitr.base_url} option."
        ),
        parent = cnd,
        call = call
      )
    }
  )

  httr2::resp_body_json(resp, simplifyVector = FALSE)
}
