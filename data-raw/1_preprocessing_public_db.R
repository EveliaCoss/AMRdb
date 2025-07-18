# Download and import public databasets
# Code adapted from the AMRdb package
# Author: Evelia Coss
# Date: July 1, 2025
# Data from: https://zenodo.org/records/14876710
# Github: https://github.com/EveliaCoss/AMRdb

#  --- Packages ----
library(tidyverse)
library(here)
library(janitor)
library(AMRdb)

# --- STEP1: Import data -----
##--- antibiogram files (antibiograms_db) ----

# Combined antibiogram dataset from NCBI, ENA, and BV-BRC
# from: https://zenodo.org/records/14876710
# published: July 4, 2025 v4

# Define URL and local destination
anti_url <- "https://zenodo.org/records/15809334/files/antibiograms.tsv.zip"
targetfile <- here("inst", "extdata", "antibiograms.tsv.zip")

# Download the compressed file
download.file(url = anti_url, destfile = targetfile, mode = "wb")
# Descomprimir el .zip
unzip(targetfile, exdir = "inst/extdata")
# Comprimir en gz
original_file <- here("inst/extdata", "antibiograms.tsv")
gz_file <- here("inst/extdata","antibiograms.tsv.gz")
R.utils::gzip(original_file, destname = gz_file, overwrite = TRUE)
# Remove the original file
file.remove(targetfile)

# Read the .tsv.gz file into R
# Date : July 11, 2025
antibiograms_metadata <- readr::read_tsv(here("inst/extdata","antibiograms.tsv.gz"))

# Clean antibiogram metadata
antibiograms_db <- antibiograms_metadata %>%
  # Standardizes column names: converts them to lowercase,
  # replaces spaces and special characters with underscores
  janitor::clean_names() %>%

  # Renames the columns
  rename(
    accession = reads,
    scientific_name_Antibiogram = species
  )

### --- Save ----
save(antibiograms_db, file = here("data", "antibiograms_db.rda"))

## ---- RGI results -----

rgi_results <- read_tsv(file= here("inst/extdata","2025_Training_and_testing_strict.tsv.gz")) %>%
  # Standardizes column names: converts them to lowercase,
  # replaces spaces and special characters with underscores
  janitor::clean_names()

### --- Save ----
save(rgi_results, file = here("data", "rgi_results.rda"))

## --- CAMDA 2025 datasets -----

# > trainig datasets
# Define the raw GitHub URL
training_url <- "https://raw.githubusercontent.com/EveliaCoss/CAMDA2025_metadatos/main/rawdata/TrainAndTest_dataset/training_dataset.csv"
targetfile <- here("inst", "extdata", "training_dataset.csv")

# Download the compressed file
download.file(url = training_url, destfile = targetfile, mode = "wb")

# Read the .csv file into R
training_metadata <- readr::read_csv(targetfile)
# Rename species
training_metadata_db <- training_metadata %>%
  mutate(scientific_name_CAMDA = paste(genus, species, sep = " "))
# Rows: 6144 Columns: 16── Column

### --- Save ----
save(training_metadata_db, file = here("data", "training_metadata_db.rda"))

# > testing datasets
# Define the raw GitHub URL
test_url <- "https://raw.githubusercontent.com/EveliaCoss/CAMDA2025_metadatos/main/rawdata/TrainAndTest_dataset/testing_template.csv"
targetfile <- here("inst", "extdata", "testing_template.csv")

# Download the compressed file
download.file(url = test_url, destfile = targetfile, mode = "wb")

# Read the .csv file into R
test_metadata <- readr::read_csv(targetfile)
# Rename species
test_metadata_db <- test_metadata %>%
  mutate(scientific_name_CAMDA = paste(genus, species, sep = " "))
# Rows: 5345 Columns: 6── Column

### --- Save ----
save(test_metadata_db, file = here("data", "test_metadata_db.rda"))

# ---- Download public information ------

## ---- Test dataset with GTDB ------
test_gtdb_result <- readr::read_csv(here("inst/extdata","test.ani.csv"))

## ----  Train dataset with GTDB ------
train_gtdb_result <- readr::read_csv(here("inst/extdata","train.ani.csv"))

# --- STEP 2. Cleaning metadata information ----

## ---- Test dataset ------
# The information for the SRA IDs in the test and training datasets was verified:
testing_metadata_cleaned <- test_metadata_db %>%
  # Remove the test IDs that are shared with the training set
  filter(!(accession %in% training_metadata_db$accession)) %>% # 1,290
  # Unir con la informacion de gtdb
  left_join(select(test_gtdb_result,
                   new_species, accession, genome, ani), by ="accession") %>%
  # redondear ANI
  mutate(ani = round(ani, 3))

#  4055 SRA IDs accessions by row
nrow(testing_metadata_cleaned) #4055

## ---- training dataset ------
training_metadata_cleaned <- training_metadata_db %>%
  # Unir con la informacion de gtdb
  left_join(select(train_gtdb_result,
                   new_species, accession, genome, ani),
            by ="accession", relationship = "many-to-many") %>%
  # redondear ANI
  mutate(ani = round(ani, 3)) %>%
  # Eliminar filas duplicadas
  distinct()

#  5458 SRA IDs accessions by row
nrow(training_metadata_cleaned) #5729

# Accession number
# Numero de accesiones
length(unique(training_metadata_cleaned$accession))#5458

# ----- STEP 3. Comparing the information of Specie and accession (SRA ID) -----
source("R/compare_genus_function.R")

## ---- test dataset - scientific_name_new -------
# Detect different genus between species using GTDB dataset
test_completeinfo_cleaned_db <- compare_genus(testing_metadata_cleaned,
                                              old_col = "scientific_name_CAMDA",
                                              new_col = "new_species")

table(test_completeinfo_cleaned_db$genus_match)
#  TRUE FALSE    NA
#  3906     6   143

# agregar nueva clasificacion en los nombres de las especies
test_completeinfo_cleaned_db$scientific_name_new <- ifelse(
  # Si new_species es NA, mantiene scientific_name_CAMDA.
  is.na(test_completeinfo_cleaned_db$new_species),
  test_completeinfo_cleaned_db$scientific_name_CAMDA,
  # Si son iguales, conserva scientific_name_CAMDA.
  ifelse(
    test_completeinfo_cleaned_db$scientific_name_CAMDA == test_completeinfo_cleaned_db$new_species,
    test_completeinfo_cleaned_db$scientific_name_CAMDA,
    test_completeinfo_cleaned_db$new_species))

dim(test_completeinfo_cleaned_db) #4055 14

# Hay 6 SRA con problemas en la especie
test_completeinfo_cleaned_db %>%
  filter(genus_match == "FALSE")

# global information
global_cols <- c("genus", "species", "scientific_name_new", "accession", "genome", "phenotype", "antibiotic", "measurement_value", "ani")

# test informacion
test_db_cleaned <- test_completeinfo_cleaned_db %>%
  select(any_of(global_cols))

# Save
write_tsv(test_db_cleaned, file = here("inst/extdata", "testing_metadata_cleaned.tsv"), quote = "none")

### --- Save ----
save(test_db_cleaned, file = here("data", "test_db_cleaned.rda"))

## ---- training dataset - scientific_name_new -------
# Detect different genus between species using GTDB dataset
training_completeinfo_cleaned_db <- compare_genus(training_metadata_cleaned, old_col = "scientific_name_CAMDA", new_col = "new_species") %>%
  # Delete problems with species
  filter(genus_match != FALSE)

table(training_completeinfo_cleaned_db$genus_match)
#  TRUE FALSE    NA
#  5497     0  1874

# agregar nueva clasiifacion en los nombres de las especies
training_completeinfo_cleaned_db$scientific_name_new <- ifelse(
  # Si new_species es NA, mantiene scientific_name_CAMDA.
  is.na(training_completeinfo_cleaned_db$new_species),
  training_completeinfo_cleaned_db$scientific_name_CAMDA,
  # Si son iguales, conserva scientific_name_CAMDA.
  ifelse(
    training_completeinfo_cleaned_db$scientific_name_CAMDA == training_completeinfo_cleaned_db$new_species,
    training_completeinfo_cleaned_db$scientific_name_CAMDA,
    training_completeinfo_cleaned_db$new_species))

dim(training_completeinfo_cleaned_db)
# [1] 5720   24

table(training_completeinfo_cleaned_db$scientific_name_new)
# Acinetobacter baumannii  Acinetobacter courvalinii
# 564                          1
# Acinetobacter nosocomialis       Campylobacter jejuni
# 3                        537
# Escherichia coli        Klebsiella africana
# 507                          1
# Klebsiella pneumoniae Klebsiella quasipneumoniae
# 767                         11
# Klebsiella variicola      Neisseria gonorrhoeae
# 12                        751
# Pseudomonas aeruginosa        Salmonella enterica
# 571                        715
# Staphylococcus aureus   Streptococcus pneumoniae
# 573                        707

columns_to_select <- c(global_cols, "old_genus", "new_genus")

# test informacion
training_db_cleaned <- training_completeinfo_cleaned_db %>%
  select(any_of(columns_to_select)) %>%
  # Si new_genus tiene NA, colocar la informacion de old_genus y si no, dejar igual
  mutate(new_genus = if_else(is.na(new_genus),old_genus, new_genus )) %>%
  select(-old_genus)

dim(training_db_cleaned) # 5720   10

# Save data
write_tsv(training_db_cleaned, file = here("inst/extdata", "training_metadata_cleaned.tsv"), quote = "none")

### --- Save ----
save(training_db_cleaned, file = here("data", "training_db_cleaned.rda"))

# --- Save ----
#save(antibiograms_db,  rgi_results, test_db_cleaned, training_db_cleaned,
#     training_metadata_db, test_metadata_db,  file = here("data", "public_db.rda"))
