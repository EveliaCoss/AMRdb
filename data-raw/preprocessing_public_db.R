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

# --- STEP1: Import data -----
## --- Public metadata ------

# Define URL and local destination
public_url <- "https://raw.githubusercontent.com/EveliaCoss/CAMDA2025_metadatos/main/metadata/sra-metadata.csv"
destfile <- here("data-raw", "sra-metadata.csv")
targetfile <- here("inst", "extdata", "sra-metadata.csv")

# Download the compressed file
download.file(url = public_url, destfile = destfile, mode = "wb")

# Read the .csv file into R
sra_metadata <- readr::read_csv(destfile)

# Remove the file after importing
# file.remove(destfile)
# Move the file to inst/extdata/ instead of deleting it
file.rename(destfile, targetfile)

# Clean public metadata
sra_metadata_db <- sra_metadata %>%

  # Standardizes column names: converts them to lowercase,
  # replaces spaces and special characters with underscores
  janitor::clean_names() %>%

  # Select columns
  select(run, library_strategy, library_selection, library_source, platform,
         model, bio_project, bio_sample, scientific_name) %>%

  # Renames columns
  rename(accession = run, scientific_name_complete = scientific_name)

# Reduce name
sra_metadata_db$scientific_name_NCBI <- word(sra_metadata_db$scientific_name_complete, 1, 2)

##--- antibiogram files (antibiograms_db) ----

# Combined antibiogram dataset from NCBI, ENA, and BV-BRC
# from: https://zenodo.org/records/14876710

# Define URL and local destination
anti_url <- "https://zenodo.org/record/14876710/files/antibiograms.tsv.gz"
destfile <- here("data-raw", "antibiograms.tsv.gz")

# Download the compressed file
download.file(url = anti_url, destfile = destfile, mode = "wb")

# Read the .tsv.gz file into R
# Date: February 16, 2025
antibiograms_metadata <- readr::read_tsv(destfile)

# Remove the file after importing
file.remove(destfile)

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

## --- CAMDA 2025 datasets -----

# > trainig datasets
# Define the raw GitHub URL
training_url <- "https://raw.githubusercontent.com/EveliaCoss/CAMDA2025_metadatos/main/rawdata/TrainAndTest_dataset/training_dataset.csv"
destfile <- here("data-raw", "training_dataset.csv")
targetfile <- here("inst", "extdata", "training_dataset.csv")

# Download the compressed file
download.file(url = training_url, destfile = destfile, mode = "wb")

# Read the .csv file into R
training_metadata <- readr::read_csv(destfile)
# Rename species
training_metadata_db <- training_metadata %>%
  mutate(scientific_name_CAMDA = paste(genus, species, sep = " "))
# Rows: 6144 Columns: 16── Column

# Remove the file after importing
# file.remove(destfile)
# Move the file to inst/extdata/ instead of deleting it
file.rename(destfile, targetfile)

# > testing datasets
# Define the raw GitHub URL
test_url <- "https://raw.githubusercontent.com/EveliaCoss/CAMDA2025_metadatos/main/rawdata/TrainAndTest_dataset/testing_template.csv"
destfile <- here("data-raw", "testing_template.csv")
targetfile <- here("inst", "extdata", "testing_template.csv")

# Download the compressed file
download.file(url = test_url, destfile = destfile, mode = "wb")

# Read the .csv file into R
test_metadata <- readr::read_csv(destfile)
# Rename species
test_metadata_db <- test_metadata %>%
  mutate(scientific_name_CAMDA = paste(genus, species, sep = " "))
# Rows: 5345 Columns: 6── Column

# Remove the file after importing
# file.remove(destfile)
# Move the file to inst/extdata/ instead of deleting it
file.rename(destfile, targetfile)

# --- STEP 2. Cleaning metadata information ----

# The information for the SRA IDs in the test and training datasets was verified:

# 1.  SRA IDs found in both test and training sets were removed from the test set, keeping
# them only in the training set.
sraids_overlapping <- intersect(test_metadata_db$accession, training_metadata_db$accession)
# We detected that 1,290 SRA IDs are shared between both files.

# 2. Remove the test IDs that are shared with the training set
testing_metadata_cleaned <- test_metadata_db %>% filter(!(accession %in% training_metadata_db$accession))
nrow(testing_metadata_cleaned)
# 4055 SRA IDs accessions by row
# check: length(unique(testing_metadata_cleaned$accession))

# ----- STEP 3. Comparing the information of Specie and accession (SRA ID) -----

source("R/compare_sp_function.R")

# The resulting dataset includes two status columns: **`status`** and **`status_reference`**:
#
#   - **`status`** indicates how the species annotation from the CAMDA dataset compares to external sources:
#       -`Matched_NCBI_Antibiogram`: CAMDA matches both NCBI and antibiogram data.
#       -`Matched_NCBI`: CAMDA matches only NCBI data.
#       -`Matched_Antibiogram`: CAMDA matches only the antibiogram data.
#       -`Missing_All`: No sufficient external data available for comparison.
#    -   **`status_reference`** evaluates the consistency between the two external sources (NCBI and antibiogram):
#       -`Good_sources`: NCBI and antibiogram annotations agree with each other.
#       -`Verify_sources`: NCBI and antibiogram annotations disagree and require further manual verification to ensure data reliability.
#
# When the species annotations provided by NCBI and the antibiogram metadata do not match, it raises concerns about the accuracy of the sample's taxonomic identity. Such discrepancies may indicate mislabeling, contamination, or outdated records. Therefore, it is essential to verify the original sources to ensure the reliability of downstream analyses.

# > Training vs public data
# Run function
training_completeInfo_db <- compare_sp(training_metadata_db, sra_metadata_db, antibiograms_db)

# Check information
table(training_completeInfo_db$status)
# Matched_Antibiogram             Matched_NCBI Matched_NCBI_Antibiogram      Mismatch_with_CAMDA
# 359                      922                     3892                        3
# Missing_All
# 263

# Check source
training_verify_data <- training_completeInfo_db %>%
  filter(status_reference == "Verify_sources")
#check informartion
table(training_completeInfo_db$status_reference)
# Good_sources     No_sources Verify_sources
# 3892            263           1303

# > Test vs public data
test_completeInfo_db <- compare_sp(testing_metadata_cleaned, sra_metadata_db, antibiograms_db)

# Check information
table(test_completeInfo_db$status)
# Matched_Antibiogram      Matched_NCBI    Matched_NCBI_Antibiogram              Missing_All
#  115                     1728                     1390                      822

# Join information
test_db_cleaned <- testing_metadata_cleaned %>%
  left_join(select(test_completeInfo_db, -scientific_name_CAMDA), by = "accession")

# Check source
test_verify_data <- test_db_cleaned %>%
  filter(status_reference == "Verify_sources")
# check information
table(test_completeInfo_db$status_reference)
#  Good_sources     No_sources Verify_sources
#.   1390            822           1843

#  ----- STEP 4: Relabel samples and remove misannotated species -----

# Identify SRA IDs with inconsistent annotations that require verification
SRA_IDs_rare_db <- training_completeInfo_db %>%
  # Keep only entries where external sources (NCBI and/or antibiogram) do not fully agree
  filter(status_reference == "Verify_sources") %>%
  # Ensure the NCBI scientific name is available
  filter(!is.na(scientific_name_NCBI)) %>%
  # Exclude entries that already match the NCBI annotation
  filter(status != "Matched_NCBI")

# Additionally, SRA IDs ERR1218638 and ERR1218722 will be reassigned to *Klebsiella pneumoniae*,
# a species included in the study.
# These samples were previously annotated in the dataset as *Escherichia coli*.

SRA_IDs_edited <- SRA_IDs_rare_db %>%
  # Si alguno de los nombre reales encontrados en NCBI puede ser util para renombrarlo
  filter(scientific_name_NCBI %in% unique(training_completeInfo_db$scientific_name_CAMDA))

# only accession IDs
SRA_IDs_edited <- SRA_IDs_edited$accession
# [1] "ERR1218638" "ERR1218722"

# Based on the information obtained from public datasets, we have decided to remove SRA IDs
# "SRR2101499", "SRR960879", "SRR850995", "ERR1218771", "SRR5386043" and "SRR6985679", as they
# correspond to species that are not relevant or appropriate for the scope of this study and are
# considered sources of noise in the identification of antimicrobial resistance genes.

SRA_IDs_removed <- SRA_IDs_rare_db %>%
  # IDs que no se encuentran en NCBI y que estan mal, nos meten ruido
  filter(!(scientific_name_NCBI %in% unique(training_completeInfo_db$scientific_name_CAMDA)))
# only accession IDs
SRA_IDs_removed <- SRA_IDs_removed$accession
# [1] "SRR2101499" "SRR960879"  "SRR850995"  "ERR1218771" "SRR5386043" "SRR6985679"

# Join
SRA_IDs_allremoved <- c(SRA_IDs_edited, SRA_IDs_removed)

# Edits
training_cleanedInfo_db <- training_completeInfo_db %>%
  # Remove misannotated species (6 SRA IDs)
  filter(!(accession %in% SRA_IDs_allremoved))

# Join information
training_db_cleaned <- training_cleanedInfo_db %>%
  left_join(select(training_metadata_db, -scientific_name_CAMDA), by = "accession") %>%
  # Order columns
  select(genus, species, accession, phenotype:collection_date, scientific_name_CAMDA:status_reference) %>%
  # Remove duplicates (only rows)
  distinct()

# Check information
table(training_cleanedInfo_db$status)
# Matched_Antibiogram             Matched_NCBI Matched_NCBI_Antibiogram              Missing_All
# 354                      922                     3892                      263

# With different information related with MIC
table(training_db_cleaned$status)
# Matched_Antibiogram             Matched_NCBI Matched_NCBI_Antibiogram              Missing_All
# 361                     1008                     4024                      309

# --- Save ----
save(antibiograms_db, testing_metadata_cleaned, test_db_cleaned, training_metadata_db, training_db_cleaned, sra_metadata_db, file= here("data", "public_db.rda"))
