#' @title Raw antimicrobial metadata for training set samples
#'
#' @description
#' Unprocessed metadata for samples in the training partition of the CAMDA 2025 dataset.
#' Includes taxonomy, antibiotic susceptibility information, and experimental metadata prior to cleaning or standardization.
#'
#' @format A data frame with N rows and 17 columns:
#' \describe{
#'   \item{genus}{Genus classification as originally annotated}
#'   \item{species}{Species name from original metadata}
#'   \item{accession}{SRA accession identifier for each training sample}
#'   \item{phenotype}{Original interpretive result (e.g., `Resistant`, `Susceptible`, `Intermediate`)}
#'   \item{antibiotic}{Name of antibiotic tested}
#'   \item{measurement_sign}{Operator for MIC or zone value (e.g., `>`, `=`, `<`)}
#'   \item{measurement_value}{Reported MIC or inhibition zone value}
#'   \item{measurement_unit}{Units of resistance measurement (e.g., µg/ml, mm)}
#'   \item{laboratory_typing_method}{Method used for antimicrobial susceptibility testing}
#'   \item{laboratory_typing_platform}{Platform or instrument used}
#'   \item{testing_standard}{Resistance testing standard (e.g., CLSI, EUCAST)}
#'   \item{testing_standard_year}{Year associated with the testing guideline}
#'   \item{publication}{Link or reference to associated publication}
#'   \item{isolation_source}{Source material from which the isolate was obtained}
#'   \item{isolation_country}{Country where the sample was collected}
#'   \item{collection_date}{Date of sample isolation or sequencing}
#'   \item{scientific_name_CAMDA}{Full species name provided by CAMDA metadata}
#' }
#'
#' @source CAMDA 2025 challenge metadata files (training partition)
"training_metadata_db"
#' @examples NULL
