# get_unit() is backed by the cached unit listing; mock unit_selector_cached to
# avoid the API and the session cache.

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

test_that("get_unit() with no arguments returns all units without links", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  out <- get_unit()
  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 3L)
  expect_false("direct_links" %in% names(out))
})

test_that("links = TRUE appends the linkage list-columns", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  out <- get_unit(links = TRUE)
  expect_true(all(
    c(
      "direct_links",
      "direct_inactives",
      "indirect_links",
      "indirect_inactives"
    ) %in%
      names(out)
  ))
})

test_that("get_unit() filters by code, case-insensitively", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  expect_equal(get_unit(code = "FF07RYKD00")$code, "FF07RYKD00")
  expect_equal(get_unit(code = "ff07rykd00")$code, "FF07RYKD00")
  expect_setequal(
    get_unit(code = c("FF07RYKD00", "FF01D00000"))$code,
    c("FF07RYKD00", "FF01D00000")
  )
})

test_that("get_unit() filters by partial, case-insensitive name", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  expect_equal(get_unit(name = "kenai")$code, "FF07RKNA00")
  expect_equal(get_unit(name = "kenai refuge")$code, "FF07RKNA00")
})

test_that("code and name union", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  out <- get_unit(code = "FF01D00000", name = "kenai")
  expect_setequal(out$code, c("FF01D00000", "FF07RKNA00"))
})

test_that("get_unit() warns on values that match nothing", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  expect_warning(
    out <- get_unit(code = c("FF07RYKD00", "NOPE")),
    "No unit matched code"
  )
  expect_equal(out$code, "FF07RYKD00")
  expect_warning(get_unit(name = "atlantis"), "No unit matched name")
})

test_that("get_unit() filters by region number or code", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  expect_setequal(get_unit(region = 7)$code, c("FF07RYKD00", "FF07RKNA00"))
  expect_equal(get_unit(region = "R0007")$code, c("FF07RYKD00", "FF07RKNA00"))
  expect_equal(get_unit(region = 1)$code, "FF01D00000")
  expect_setequal(
    get_unit(region = c(1, 7))$code,
    c("FF07RYKD00", "FF07RKNA00", "FF01D00000")
  )
})

test_that("get_unit() filters by state, case-insensitively", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  expect_setequal(get_unit(state = "AK")$code, c("FF07RYKD00", "FF07RKNA00"))
  expect_equal(get_unit(state = "or")$code, "FF01D00000")
})

test_that("filters combine (code/name unioned, then region/state narrow)", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  expect_equal(get_unit(name = "kenai", state = "AK")$code, "FF07RKNA00")
  expect_setequal(
    get_unit(region = 7, state = "AK")$code,
    c("FF07RYKD00", "FF07RKNA00")
  )
  expect_warning(out <- get_unit(region = 1, state = "AK"), "No units matched")
  expect_equal(nrow(out), 0L)
})

test_that("get_unit() filters by type (e.g. refuge)", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  expect_setequal(get_unit(type = "refuge")$code, c("FF07RYKD00", "FF07RKNA00"))
  expect_equal(get_unit(type = "administration")$code, "FF01D00000")
  expect_setequal(
    get_unit(type = c("refuge", "office"))$code,
    c("FF07RYKD00", "FF07RKNA00", "FF01D00000")
  )
})

test_that("type narrows a name/code selection", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  out <- get_unit(region = 7, type = "refuge")
  expect_setequal(out$code, c("FF07RYKD00", "FF07RKNA00"))
})

test_that("get_unit() validates its input", {
  local_mocked_bindings(unit_selector_cached = function() selector_tbl())

  expect_error(get_unit(code = 123), "must be .*character vector")
  expect_error(get_unit(name = 123), "must be .*character vector")
  expect_error(get_unit(type = 123), "must be .*character vector")
  expect_error(get_unit(code = NA_character_), "no usable")
  expect_error(get_unit(code = "   "), "no usable")
  expect_error(get_unit(region = "north"), "must be region number")
})
