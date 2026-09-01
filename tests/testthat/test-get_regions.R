test_that("get_regions() returns one row per region with code and name", {
  fake <- list(
    code = "REG",
    name = "Region",
    units = list(
      list(code = "R0001", name = "Pacific"),
      list(code = "R0007", name = "Alaska")
    )
  )
  local_mocked_bindings(unit_get = function(path, call = NULL) fake)

  out <- get_regions()

  expect_s3_class(out, "tbl_df")
  expect_named(out, c("region_code", "region_name"))
  expect_equal(nrow(out), 2L)
  expect_equal(out$region_code, c("R0001", "R0007"))
  expect_equal(out$region_name, c("Pacific", "Alaska"))
})

test_that("get_regions() handles an empty region list", {
  local_mocked_bindings(
    unit_get = function(path, call = NULL) {
      list(code = "REG", name = "Region", units = list())
    }
  )

  out <- get_regions()
  expect_equal(nrow(out), 0L)
  expect_named(out, c("region_code", "region_name"))
})
