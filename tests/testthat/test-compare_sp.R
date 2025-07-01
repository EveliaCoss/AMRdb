test_that("multiplication works", {
  # Run example
  result <- compare_sp(metadata_db = training_metadata_db, sra_metadata_db, antibiograms_db)

  # Expected value
  expect_equal(class(result), c("tbl_df","tbl","data.frame"))

})
