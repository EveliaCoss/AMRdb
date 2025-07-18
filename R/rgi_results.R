#' CARD RGI predictions for resistance gene content
#'
#' A data frame containing AMR gene predictions and associated metadata derived from CARD-RGI annotations.
#' Each row corresponds to a sample's phenotype and its predicted gene-level features based on known resistance determinants.
#'
#' @format A data frame with N rows and 15 columns:
#' \describe{
#'   \item{genus}{Genus name after cleaning}
#'   \item{species}{Species name after cleaning}
#'   \item{accession}{SRA identifier for each sample}
#'   \item{phenotype}{Interpretive label: `Resistant`, `Susceptible`, or `?`}
#'   \item{antibiotic}{Name of the antibiotic tested}
#'   \item{measurement_value}{Processed MIC or inhibition zone value}
#'   \item{categoria_recodificada}{Recoded phenotype category used in classification or binning}
#'   \item{aroXXXXXXX_*}{Binary or numeric indicator for gene variant presence; includes SNP-level and family-level predictions from CARD-RGI}
#' }
#'
#' @details
#' Columns prefixed with `aro` represent individual AMR gene families or variants predicted using CARD-RGI.
#' These may include point mutations (e.g., SNPs), protein homologs, or ontology-linked resistance mechanisms.
#' The column names follow the ARO ontology identifiers from CARD and are suitable for downstream modeling.
#'
#' @source Resistance gene calls generated via CARD-RGI pipeline vX.X on CAMDA 2025 challenge accessions
"rgi_results"
#' @examples NULL
