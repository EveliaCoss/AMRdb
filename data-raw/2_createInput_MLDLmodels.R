# Asignar nuevos valores de MIC y generacion del archivo Input para ML y DL models
# Code adapted from the AMRdb package
# Author: Evelia Coss
# Date: July 17, 2025
# Data from: https://zenodo.org/records/14876710
# Github: https://github.com/EveliaCoss/AMRdb

#  --- Packages ----
library(tidyverse)
library(here)
library(janitor)
library(AMRdb)

# --- STEP1: Asignar nuevo valor de MIC -----
training_new_mic_db <- process_mic_values(training_db_cleaned, max_mic = 256)

str(training_new_mic_db)

# --- STEP 2: Unir archivos de test y training ----

# 1. Remove columns from testing
test_inputfile <- test_db_cleaned
test_inputfile$type <- "test"
test_inputfile$phenotype_assigned <- 0
test_inputfile$recategorized_mic <- 0
dim(test_inputfile) # [1] 4055    12

# Unificar orden de las columnas
global_cols <- colnames(test_inputfile)

# 2. Unique IDs
# Join New MIC values (accession, phenotype_assigned, mic_new)
training_inputfile <- training_new_mic_db %>%
  select(-new_genus)
training_inputfile$type <- "training"
# reordenar las columnas
training_inputfile <- training_inputfile %>%
  select(any_of(global_cols))
dim(training_inputfile) # [1] 5720    12

# 3. Join files
training_and_test_inputfile <- rbind(training_inputfile, test_inputfile)

# --- STEP 3: RGI results ----

training_and_test_inputfile_complete <- training_and_test_inputfile %>%
  # Join rgi results
  left_join(select(rgi_results, -genus, -species, -phenotype,
                   -antibiotic, -measurement_value, -categoria_recodificada), by = "accession") %>%
  mutate(antibiotic = if_else( antibiotic == "tetracycline", "TET", antibiotic))

# unique(training_and_test_inputfile$antibiotic)
# [1] "TET" "ERY" "GEN" "CAZ"

# Dimensions
dim(training_and_test_inputfile_complete) # 9610 1081

# Cambiar NA por ceros, excepto de algunas columnas
training_and_test_inputfile_complete <- training_and_test_inputfile_complete %>%
  mutate(across(
    .cols = -c(genome, measurement_value, ani, phenotype_assigned, recategorized_mic),
    .fns  = ~ ifelse(is.na(.), 0, .)
  ))

# save file
write_tsv(training_and_test_inputfile_complete, file = here("inst/extdata", "training_and_test_inputfile_cleaned.tsv.gz"))

# --- Save ----
save(training_and_test_inputfile_complete,  file = here("data", "training_and_test_inputfile_complete.rda"))
