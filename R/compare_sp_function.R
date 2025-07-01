#' Compare species annotations across CAMDA, NCBI, and antibiogram datasets
#'
#' This function compares species annotations from the CAMDA dataset against metadata from
#' NCBI and antibiograms. It returns a dataset that includes consistency status between CAMDA
#' and the external sources, as well as a comparison between the external sources themselves.
#'
#' @param metadata_db A data frame containing CAMDA species annotations.
#'        Must include the columns: `accession` and `scientific_name_CAMDA`.
#'        Example datasets included in the package: `training_metadata_db`, `testing_metadata_cleaned`.
#' @param sra_metadata_db A data frame containing metadata from NCBI.
#'        Must include the columns: `accession` and `scientific_name_NCBI`.
#'        A sample dataset is preloaded in the package as `sra_metadata_db`.
#' @param antibiograms_db A data frame containing species annotations from antibiograms.
#'        Must include the columns: `accession` and `scientific_name_Antibiogram`.
#'        A sample dataset is preloaded in the package as `antibiograms_db`.
#'
#' @return A data frame with the following columns:
#' \itemize{
#'   \item \code{accession}: Unique sample identifier.
#'   \item \code{scientific_name_CAMDA}: Species annotation from the CAMDA dataset.
#'   \item \code{scientific_name_NCBI}: Species annotation from NCBI metadata.
#'   \item \code{scientific_name_Antibiogram}: Species annotation from antibiogram metadata.
#'   \item \code{status}: Consistency between CAMDA and external sources, with values:
#'     \describe{
#'       \item{Matched_NCBI_Antibiogram}{CAMDA matches both NCBI and antibiogram.}
#'       \item{Matched_NCBI}{CAMDA matches only NCBI.}
#'       \item{Matched_Antibiogram}{CAMDA matches only the antibiogram.}
#'       \item{Mismatch_with_CAMDA}{At least one source has data, but CAMDA does not match either.}
#'       \item{Missing_All}{No data available from NCBI or antibiogram.}
#'     }
#'   \item \code{status_reference}: Consistency between NCBI and antibiogram sources, with values:
#'     \describe{
#'       \item{Good_sources}{Both sources are present and agree.}
#'       \item{Verify_sources}{At least one source is present and sources disagree or are partially missing.}
#'       \item{No_sources}{Both NCBI and antibiogram are missing.}
#'     }
#' }
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' result <- compare_sp(metadata_db = training_metadata_db, sra_metadata_db, antibiograms_db)
#'

compare_sp <- function(metadata_db = NULL,
                       sra_metadata_db = NULL,
                       antibiograms_db = NULL) {
  # Load defaults if any are NULL
  if (is.null(metadata_db)) {
    message("Using default 'training_metadata_db' from package.")
    metadata_db <- training_metadata_db
  }
  if (is.null(sra_metadata_db)) {
    message("Using default 'sra_metadata_db' from package.")
    sra_metadata_db <- sra_metadata_db
  }
  if (is.null(antibiograms_db)) {
    message("Using default 'antibiograms_db' from package.")
    antibiograms_db <- antibiograms_db
  }

  # Validate required columns
  required_cols <- list(
    training_metadata_db = c("accession", "scientific_name_CAMDA"),
    sra_metadata_db = c("accession", "scientific_name_NCBI"),
    antibiograms_db = c("accession", "scientific_name_Antibiogram")
  )

  for (df_name in names(required_cols)) {
    df <- get(df_name)
    missing_cols <- setdiff(required_cols[[df_name]], colnames(df))
    if (length(missing_cols) > 0) {
      stop(sprintf("Data frame '%s' is missing required columns: %s",
                   df_name, paste(missing_cols, collapse = ", ")))
    }
  }

  # Paso 1: Unir con datos de metadat, NCBI y Antibiogram
  # Join and analyze
  base_all <- left_join(training_metadata_db, sra_metadata_db, by = "accession", relationship = "many-to-many") %>%
    left_join(antibiograms_db, by = "accession", relationship = "many-to-many") %>%
    select(accession, scientific_name_CAMDA, scientific_name_NCBI, scientific_name_Antibiogram) %>%
    distinct() # eliminar filas repetidas

  # Paso 2: Analizar la informacion con NCBI y antiograms y colocar un estatus
  base_status <- base_all %>%
    mutate(status = case_when(
      # CAMDA matches both NCBI and Antibiogram
      !is.na(scientific_name_NCBI) & !is.na(scientific_name_Antibiogram) &
        scientific_name_CAMDA == scientific_name_NCBI &
        scientific_name_CAMDA == scientific_name_Antibiogram ~ "Matched_NCBI_Antibiogram",

      # CAMDA matches only NCBI
      !is.na(scientific_name_NCBI) &
        scientific_name_CAMDA == scientific_name_NCBI ~ "Matched_NCBI",

      # CAMDA matches only Antibiogram
      !is.na(scientific_name_Antibiogram) &
        scientific_name_CAMDA == scientific_name_Antibiogram ~ "Matched_Antibiogram",

      # CAMDA does not match any, but at least one source has info
      (!is.na(scientific_name_NCBI) | !is.na(scientific_name_Antibiogram)) &
        (scientific_name_CAMDA != scientific_name_NCBI) ~ "Mismatch_with_CAMDA",

      # No useful data in either source
      is.na(scientific_name_NCBI) & is.na(scientific_name_Antibiogram) ~ "Missing_All"
    )) %>%
    # Paso 3: analizar fuentes de informqcion
    mutate(status_reference = case_when(
      # Ambos tienen información y no coinciden
      !is.na(scientific_name_NCBI) & !is.na(scientific_name_Antibiogram) &
        scientific_name_NCBI != scientific_name_Antibiogram ~ "Verify_sources",

      # Solo NCBI tiene información, Antibiogram es NA
      !is.na(scientific_name_NCBI) & is.na(scientific_name_Antibiogram) ~ "Verify_sources",

      # Solo Antibiogram tiene información, NCBI es NA
      is.na(scientific_name_NCBI) & !is.na(scientific_name_Antibiogram) ~ "Verify_sources",

      # Ambos están vacíos
      is.na(scientific_name_NCBI) & is.na(scientific_name_Antibiogram) ~ "No_sources",

      # Ambos existen y coinciden
      !is.na(scientific_name_NCBI) & !is.na(scientific_name_Antibiogram) &
        scientific_name_NCBI == scientific_name_Antibiogram ~ "Good_sources"
    ))

  # Obtain results
  return(base_status)
}
