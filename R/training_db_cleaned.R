#' Cleaned antimicrobial metadata for training set samples
#'
#' A standardized data frame containing curated metadata for training samples from the CAMDA 2025 challenge.
#' Includes harmonized species names, phenotype labels, and genomic distance metrics suitable for modeling and exploratory analysis.
#'
#' @format A data frame with N rows and 10 columns:
#' \describe{
#'   \item{genus}{Cleaned genus annotation}
#'   \item{species}{Cleaned species name}
#'   \item{scientific_name_new}{Standardized full species name after cleaning}
#'   \item{accession}{SRA accession identifier for each sample}
#'   \item{genome}{Genome identifier or flag for genome availability}
#'   \item{phenotype}{Interpretive resistance label: `Susceptible`, `Resistant`, or `Intermediate`}
#'   \item{antibiotic}{Name of antibiotic compound tested}
#'   \item{measurement_value}{Processed MIC or inhibition zone value}
#'   \item{ani}{Average Nucleotide Identity score to reference genomes}
#'   \item{new_genus}{Genus-level label used for taxonomic binning or modeling}
#' }
#'
#' @source Cleaned and standardized from CAMDA 2025 training metadata
"training_db_cleaned"
#' @examples NULL
