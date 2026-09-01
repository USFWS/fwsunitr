test_that("get_regions() parses the Region subtype into a long tibble", {
  fake <- list(
    code = "REG",
    name = "Region",
    units = list(
      list(code = "R0001", name = "Pacific"),
      list(code = "R0007", name = "Alaska")
    )
  )
  local_mocked_bindings(unit_get = function(path, base_url = NULL) fake)

  out <- get_regions()

  expect_s3_class(out, "tbl_df")
  expect_named(out, c("subtype_code", "subtype_name", "unit_code", "unit_name"))
  expect_equal(nrow(out), 2L)
  expect_equal(out$subtype_code, c("REG", "REG"))
  expect_equal(out$unit_code, c("R0001", "R0007"))
  expect_equal(out$unit_name, c("Pacific", "Alaska"))
})

test_that("get_regions() handles an empty units list", {
  local_mocked_bindings(
    unit_get = function(path, base_url = NULL) {
      list(code = "REG", name = "Region", units = list())
    }
  )

  out <- get_regions()
  expect_equal(nrow(out), 0L)
  expect_named(out, c("subtype_code", "subtype_name", "unit_code", "unit_name"))
})
