# Tests target unit_selector_impl(), the un-memoised worker, so they bypass the
# session cache created in .onLoad().

selector_fixture <- function() {
  list(
    list(
      Unit = list(
        code = "FF07RYKD00",
        typeName = "NATIONAL WILDLIFE REFUGE",
        fullName = "Yukon Delta National Wildlife Refuge",
        typeDisplay = "NATIONAL WILDLIFE REFUGE",
        subTypeDisplay = NULL,
        lifecycle = TRUE,
        stateCodes = "AK",
        regionCode = "R0007"
      ),
      DirectLinks = list(
        list(code = "FF07RYKD01", fullName = "Sub Office")
      ),
      DirectInactives = list(),
      IndirectLinks = list(),
      IndirectInactives = list()
    ),
    list(
      Unit = list(
        code = "FF01D00000",
        typeName = "ADMINISTRATION OFFICE",
        fullName = "Regional Director's Office-R1",
        typeDisplay = "ADMINISTRATION OFFICE",
        subTypeDisplay = NULL,
        lifecycle = TRUE,
        stateCodes = "OR",
        regionCode = "R0001"
      ),
      DirectLinks = list(),
      DirectInactives = list(),
      IndirectLinks = list(),
      IndirectInactives = list()
    )
  )
}

test_that("unit_selector_impl() maps PascalCase JSON to tidy columns", {
  local_mocked_bindings(
    unit_get = function(path, base_url = NULL) selector_fixture()
  )

  out <- unit_selector_impl()

  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 2L)
  expect_equal(out$code, c("FF07RYKD00", "FF01D00000"))
  expect_equal(out$full_name[1], "Yukon Delta National Wildlife Refuge")
  expect_equal(out$region_code, c("R0007", "R0001"))
})

test_that("linkage arrays are preserved as list-columns", {
  local_mocked_bindings(
    unit_get = function(path, base_url = NULL) selector_fixture()
  )

  out <- unit_selector_impl()

  expect_type(out$direct_links, "list")
  expect_length(out$direct_links[[1]], 1L)
  expect_length(out$direct_links[[2]], 0L)
  expect_equal(out$direct_links[[1]][[1]]$code, "FF07RYKD01")
})

test_that("NULL unit fields become NA", {
  local_mocked_bindings(
    unit_get = function(path, base_url = NULL) {
      list(list(
        Unit = list(code = "X", fullName = NULL),
        DirectLinks = list(),
        DirectInactives = list(),
        IndirectLinks = list(),
        IndirectInactives = list()
      ))
    }
  )

  out <- unit_selector_impl()
  expect_true(is.na(out$full_name))
  expect_true(is.na(out$type_name))
})
