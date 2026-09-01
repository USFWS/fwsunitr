# get_geography() resolves via the cached unit listing and fetches WKT via
# fetch_all_geography(); mock both.

selector_tbl <- function() {
  tibble::tibble(
    code = c("FF07RYKD00", "FF07RKNA00", "FF01D00000"),
    type_name = c(
      "NATIONAL WILDLIFE REFUGE",
      "NATIONAL WILDLIFE REFUGE",
      "ADMINISTRATION OFFICE"
    ),
    full_name = c(
      "Yukon Delta National Wildlife Refuge",
      "Kenai National Wildlife Refuge",
      "Regional Director's Office-R1"
    ),
    type_display = NA_character_,
    sub_type_display = NA_character_,
    lifecycle = TRUE,
    state_codes = c("AK", "AK", "OR"),
    region_code = c("R0007", "R0007", "R0001"),
    direct_links = list(list(), list(), list()),
    direct_inactives = list(list(), list(), list()),
    indirect_links = list(list(), list(), list()),
    indirect_inactives = list(list(), list(), list())
  )
}

geo_tbl <- function() {
  tibble::tibble(
    code = c("FF07RYKD00", "FF07RKNA00", "FF01D00000"),
    geography = c(
      "POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))",
      "MULTIPOLYGON (((0 0, 2 0, 2 2, 0 2, 0 0)))",
      NA_character_ # no geography for this unit
    )
  )
}

mock_geo <- function() {
  local_mocked_bindings(
    unit_selector_cached = function() selector_tbl(),
    fetch_all_geography = function() geo_tbl(),
    .env = parent.frame()
  )
}

test_that("no arguments returns all units as sf", {
  mock_geo()
  expect_warning(out <- get_geography(), "No geography")

  expect_s3_class(out, "sf")
  expect_equal(nrow(out), 3L)
  expect_named(out, c("code", "full_name", "geometry"))
})

test_that("geometry column is uniformly MULTIPOLYGON", {
  mock_geo()
  expect_warning(out <- get_geography(), "No geography")

  cls <- vapply(sf::st_geometry(out), function(g) class(g)[2], character(1))
  expect_true(all(cls == "MULTIPOLYGON"))
})

test_that("lookup by code returns one feature", {
  mock_geo()
  out <- get_geography(code = "FF07RYKD00")

  expect_s3_class(out, "sf")
  expect_equal(out$code, "FF07RYKD00")
  expect_equal(nrow(out), 1L)
})

test_that("lookup by name resolves via normalized matching", {
  mock_geo()
  out <- get_geography(name = "kenai")
  expect_equal(out$code, "FF07RKNA00")
})

test_that("code and name inputs union", {
  mock_geo()
  out <- get_geography(code = "FF07RYKD00", name = "kenai nwr")
  expect_setequal(out$code, c("FF07RYKD00", "FF07RKNA00"))
})

test_that("type filters geography to refuges", {
  mock_geo()
  out <- get_geography(type = "refuge")
  expect_setequal(out$code, c("FF07RYKD00", "FF07RKNA00"))
})

test_that("region filters geography", {
  mock_geo()
  out <- get_geography(region = 7)
  expect_setequal(out$code, c("FF07RYKD00", "FF07RKNA00"))
  expect_equal(get_geography(region = 1)$code, "FF01D00000")
})

test_that("state filters geography", {
  mock_geo()
  out <- get_geography(state = "AK")
  expect_setequal(out$code, c("FF07RYKD00", "FF07RKNA00"))
  expect_equal(get_geography(state = "or")$code, "FF01D00000")
})

test_that("missing geography yields an empty geometry with a warning", {
  mock_geo()
  expect_warning(out <- get_geography(code = "FF01D00000"), "No geography")
  expect_true(sf::st_is_empty(out))
})

test_that("unmatched code warns", {
  mock_geo()
  expect_warning(
    out <- get_geography(code = "atlantis"),
    "No unit matched code"
  )
  expect_equal(nrow(out), 0L)
})

test_that("geometry = FALSE returns a plain WKT tibble", {
  mock_geo()
  out <- get_geography(code = "FF07RYKD00", geometry = FALSE)

  expect_s3_class(out, "tbl_df")
  expect_false(inherits(out, "sf"))
  expect_true("geography" %in% names(out))
})

test_that("invalid code is rejected", {
  mock_geo()
  expect_error(get_geography(code = 123), "must be .*character vector")
  expect_error(get_geography(code = NA_character_), "no usable")
})
