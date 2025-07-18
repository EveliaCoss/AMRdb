#' Raw antimicrobial metadata for test set samples
#'
#' Unprocessed metadata from CAMDA 2025 test set, including taxonomic labels, antibiotic names,
#' and resistance metrics prior to cleaning. This table supports validation, reproducibility,
#' and exploration of original resistance annotations.
#'
#' @format A data frame with N rows and 7 columns:
#' \describe{
#'   \item{genus}{Genus classification as originally annotated}
#'   \item{species}{Species name from original metadata}
#'   \item{accession}{SRA accession identifier for each test sample}
#'   \item{phenotype}{Original resistance label (e.g., `Susceptible`, `Resistant`, `Intermediate`)}
#'   \item{antibiotic}{Name of antibiotic tested}
#'   \item{measurement_value}{Reported MIC or inhibition zone value}
#'   \item{scientific_name_CAMDA}{Full scientific name as received from CAMDA metadata}
#' }
#'
#' @source CAMDA 2025 challenge metadata files (test partition)
"test_metadata_db"
#' @examples NULL
