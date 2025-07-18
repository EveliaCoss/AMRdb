#' Unified input matrix for AMR modeling
#'
#' A curated data frame combining cleaned metadata, phenotype labels, and gene-level features
#' across both training and testing samples. Designed for downstream use in machine learning
#' and deep learning pipelines.
#'
#' @format A data frame with N rows and M variables. Key columns include:
#' \describe{
#'   \item{accession}{SRA identifier for each sample}
#'   \item{scientific_name_new}{Standardized species name}
#'   \item{new_genus}{Genus classification used for MIC binning}
#'   \item{phenotype_assigned}{Resistance label: `Susceptible`, `Resistant`, or `?` (unknown for test)}
#'   \item{source_db}{Indicates whether sample originated from training or test metadata}
#'   \item{ARO_XXXXXXX}{Binary or numeric indicators for resistance genes or SNPs derived from CARD}
#'   \item{...}{Additional metadata fields and feature annotations used in modeling}
#' }
#'
#' @source Assembled from CAMDA 2025 metadata and gene family outputs from CARD-RGI
"training_and_test_inputfile_complete"
#' @examples NULL
