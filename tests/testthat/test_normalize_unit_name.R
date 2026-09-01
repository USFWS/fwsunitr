test_that("normalize_unit_name() collapses variants and punctuation", {
  expect_equal(
    normalize_unit_name("Kenai National Wildlife Refuge"),
    "kenai nwr"
  )
  expect_equal(normalize_unit_name("Kenai Refuge"), "kenai nwr")
  expect_equal(normalize_unit_name("kenai nwr"), "kenai nwr")
  expect_equal(normalize_unit_name("A.B, C"), "a b c")
})

test_that("normalize_unit_name() lowercases and squishes whitespace", {
  expect_equal(normalize_unit_name("  Yukon   Delta  "), "yukon delta")
  expect_equal(normalize_unit_name("YUKON DELTA"), "yukon delta")
})
