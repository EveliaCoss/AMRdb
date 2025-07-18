test_that("compare_genus returns expected columns and types", {
  # Run example
   df <- data.frame(
     old_species = c("Staphylococcus aureus", "Escherichia coli"),
     new_species = c("Staphylococcus epidermidis", "Klebsiella pneumoniae")
   )
   result <- compare_genus(df)

   # Estructura y tipos
   expect_true(all(c("old_genus", "new_genus", "genus_match") %in% names(result)))
   expect_type(result$old_genus, "character")
   expect_type(result$new_genus, "character")
   expect_s3_class(result$genus_match, "factor")

   # comparación correcta de géneros
   expect_equal(as.character(result$genus_match), c("TRUE", "FALSE"))
})

test_that("compare_genus works with custom column names", {
  df <- data.frame(
    original_name = c("Bacillus subtilis", "Listeria monocytogenes"),
    updated_name = c("Bacillus cereus", "Listeria ivanovii"),
    stringsAsFactors = FALSE
  )

  result <- compare_genus(df, old_col = "original_name", new_col = "updated_name")

  expect_equal(result$old_genus, c("Bacillus", "Listeria"))
  expect_equal(as.character(result$genus_match), c("TRUE", "TRUE"))
})
