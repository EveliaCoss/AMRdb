# Download and import public databasets
# Code adapted from the AMRdb package
# Author: Evelia Coss
# Data from: https://zenodo.org/records/14876710
# Github: https://github.com/EveliaCoss/AMRdb

#  --- Packages ----
library(tidyverse)
library(here)
library(janitor)

#--- antibiogram files (antibiograms_db) ----

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

# --- Save ----
save(antibiograms_db, file= here("data", "antibiogram_db.rda"))
