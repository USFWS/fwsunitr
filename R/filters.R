#' Filter a unit tibble by code and/or name
#'
#' Keeps units matching any supplied `code` (exact, case-insensitive) or `name`
#' (normalized substring). With both `code` and `name` `NULL`, returns all
#' units. Warns for individual values that match nothing.
#'
#' @param units A tibble of units (from the cached unit listing).
#' @param code Optional character vector of unit codes.
#' @param name Optional character vector of unit names.
#' @return The matching subset of `units`.
#' @keywords internal
#' @noRd
filter_units <- function(units, code = NULL, name = NULL) {
  if (is.null(code) && is.null(name)) {
    return(units)
  }

  keep <- rep(FALSE, nrow(units))

  if (!is.null(code)) {
    code <- code[!is.na(code) & nzchar(trimws(code))]
    if (length(code) == 0L) {
      cli::cli_abort("{.arg code} contains no usable values.")
    }
    matched <- !is.na(units$unit_code) &
      toupper(units$unit_code) %in% toupper(code)
    unmatched <- code[!toupper(code) %in% toupper(units$unit_code[matched])]
    if (length(unmatched) > 0L) {
      cli::cli_warn("No unit matched code: {.val {unique(unmatched)}}.")
    }
    keep <- keep | matched
  }

  if (!is.null(name)) {
    name <- name[!is.na(name) & nzchar(trimws(name))]
    if (length(name) == 0L) {
      cli::cli_abort("{.arg name} contains no usable values.")
    }
    targets <- normalize_unit_name(units$unit_name)
    for (nm in name) {
      hit <- grepl(normalize_unit_name(nm), targets, fixed = TRUE)
      hit[is.na(hit)] <- FALSE
      if (!any(hit)) {
        cli::cli_warn("No unit matched name: {.val {nm}}.")
      }
      keep <- keep | hit
    }
  }

  units[keep, ]
}

#' Filter a unit tibble by state
#'
#' Keeps units whose `state_code` include any supplied state (case-insensitive).
#'
#' @param units A tibble of units.
#' @param state Character vector of two-letter state codes.
#' @return The matching subset of `units`.
#' @keywords internal
#' @noRd
filter_state <- function(units, state) {
  if (!is.character(state)) {
    cli::cli_abort("{.arg state} must be a character vector of state codes.")
  }
  st <- toupper(trimws(state))
  keep <- vapply(
    units$state_code,
    function(codes) {
      if (is.na(codes)) {
        return(FALSE)
      }
      toks <- toupper(trimws(strsplit(codes, "[^A-Za-z]+")[[1]]))
      any(st %in% toks)
    },
    logical(1)
  )
  units[keep, ]
}

#' Filter a unit tibble by FWS region
#'
#' Keeps units whose `region_code` matches any supplied region.
#'
#' @param units A tibble of units.
#' @param region Numeric or character vector of regions (e.g. `7` or `"R0007"`).
#' @return The matching subset of `units`.
#' @keywords internal
#' @noRd
filter_region <- function(units, region) {
  targets <- normalize_region(region)
  units[!is.na(units$region_code) & units$region_code %in% targets, ]
}

#' Filter a unit tibble by type
#'
#' Keeps units whose `unit_type` contains any supplied type (case-insensitive
#' substring match).
#'
#' @param units A tibble of units.
#' @param type Character vector of unit types (e.g. "refuge").
#' @return The matching subset of `units`.
#' @keywords internal
#' @noRd
filter_type <- function(units, type) {
  if (!is.character(type)) {
    cli::cli_abort("{.arg type} must be {.code NULL} or a character vector.")
  }
  ty <- tolower(trimws(type))
  keep <- vapply(
    units$unit_type,
    function(tn) {
      if (is.na(tn)) {
        return(FALSE)
      }
      any(vapply(ty, grepl, logical(1), x = tolower(tn), fixed = TRUE))
    },
    logical(1)
  )
  units[keep, ]
}

#' Normalize region input to the API's region-code format
#'
#' Accepts region numbers (e.g. `7`) or full codes (e.g. `"R0007"`) and returns
#' zero-padded codes like `"R0007"`.
#'
#' @param region Numeric or character vector of regions.
#' @return A character vector of region codes.
#' @keywords internal
#' @noRd
normalize_region <- function(region) {
  bad <- function() {
    cli::cli_abort(
      "{.arg region} must be region number(s) like {.val 7} or {.val R0007}."
    )
  }
  if (is.numeric(region)) {
    if (any(is.na(region)) || any(region != round(region)) || any(region < 1)) {
      bad()
    }
    num <- as.integer(region)
  } else {
    num <- suppressWarnings(as.integer(gsub(
      "[^0-9]",
      "",
      as.character(region)
    )))
    if (any(is.na(num)) || any(num < 1)) bad()
  }
  sprintf("R%04d", num)
}

#' Normalize a unit name for matching
#'
#' Lowercases, collapses "national wildlife refuge", "nwr", and "refuge" to a
#' single token, strips punctuation, and squishes whitespace.
#'
#' @param x Character vector of names.
#' @return A normalized character vector.
#' @importFrom rlang %||%
#' @keywords internal
#' @noRd
normalize_unit_name <- function(x) {
  x <- tolower(x %||% NA_character_)
  x <- gsub("national wildlife refuge", "nwr", x, fixed = TRUE)
  x <- gsub("\\brefuge\\b", "nwr", x)
  x <- gsub("[[:punct:]]+", " ", x)
  x <- gsub("\\s+", " ", x)
  trimws(x)
}

#' Names of the linkage list-columns
#'
#' @return A character vector of the four link column names.
#' @keywords internal
#' @noRd
link_columns <- function() {
  c("direct_links", "direct_inactives", "indirect_links", "indirect_inactives")
}
