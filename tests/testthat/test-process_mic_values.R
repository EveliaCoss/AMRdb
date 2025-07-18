test_that("process_mic_values returns expected columns", {
  # Run example
  mic_sample <- data.frame(
     accession = c("SRR000001", "SRR000002", "SRR000003"),
     measurement_value = c(4, 32, 128),
     new_genus = c("Escherichia", "Klebsiella", "Pseudomonas"),
     phenotype = c("Resistant", NA, "Intermediate"),
     stringsAsFactors = FALSE
   )
   result <- process_mic_values(mic_sample, max_mic = 256)

   # Columnas esperadas
   expect_true(all(c("recategorized_mic", "phenotype_assigned") %in% colnames(result)))
   # Que me devuelva informacion por cada fila, si le. di 3 filas, me regresa 3.
   expect_equal(nrow(result), 3)
   # No debemos tener valores de intermediate en la nueva columna
   expect_false("Intermediate" %in% result$phenotype_assigned)
   # SIN NA en phenotype_assigned
   expect_false(any(is.na(result$phenotype_assigned)))

   # Estructura
   expect_type(result$accession, "character")
   expect_type(result$measurement_value, "double")
   expect_type(result$new_genus, "character")
   expect_type(result$phenotype, "character") # o factor, según tu diseño
   expect_type(result$recategorized_mic, "integer")
   expect_type(result$phenotype_assigned, "character")
})
