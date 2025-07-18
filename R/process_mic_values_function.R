#' Process MIC values and assign interpretive phenotypes by genus
#'
#' This function takes a data frame containing MIC measurements and assigns interpretive phenotypes
#' ("Susceptible" or "Resistant") based on predefined genus-specific lookup tables. MIC values are
#' first recategorized into discrete bins based on the specified maximum MIC threshold.
#'
#' @param df A data frame with the following columns:
#'   \code{measurement_value}, \code{accession}, \code{new_genus}, and optionally \code{phenotype}.
#' @param max_mic Numeric value defining the upper MIC threshold. Supported values: \code{64}, \code{256}, \code{1024}.
#'
#' @return A data frame with original columns plus:
#'   \itemize{
#'     \item \code{recategorized_mic}: discretized MIC values based on bin configuration.
#'     \item \code{phenotype_assigned}: interpretive phenotype inferred by genus, or fallback to original phenotype.
#'   }
#'
#' @examples
#' mic_sample <- data.frame(
#'   accession = c("SRR000001", "SRR000002", "SRR000003"),
#'   measurement_value = c(4, 32, 128),
#'   new_genus = c("Escherichia", "Klebsiella", "Pseudomonas"),
#'   phenotype = c("Resistant", NA, "Intermediate"),
#'   stringsAsFactors = FALSE
#' )
#' result <- process_mic_values(mic_sample, max_mic = 256)
#' head(result)
#'
#' @export
process_mic_values <- function(df, max_mic = 256) {
  # Defensive check: required columns
  required_cols <- c("measurement_value", "accession", "new_genus", "phenotype")
  missing_cols <- setdiff(required_cols, colnames(df))
  if (length(missing_cols) > 0) {
    stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
  }

  # Defensive check: valid measurement_value conversion
  df$measurement_value <- suppressWarnings(as.numeric(df$measurement_value))
  if (all(is.na(df$measurement_value))) {
    stop("All 'measurement_value' entries are NA after numeric conversion.")
  }

  # Supported MIC bin configurations
  mic_config <- list(
    "64" = list(
      bins = c(0, 0.09, 0.185, 0.375, 0.75, 1.5, 3, 6, 12, 24, 48, 10000),
      labels = c(0.06, 0.12, 0.25, 0.5, 1, 2, 4, 8, 16, 32, 64),
      pheno = list("s" = 7, "r" = 4)
    ),
    "256" = list(
      bins = c(0, 0.09, 0.185, 0.375, 0.75, 1.5, 3, 6, 12, 24, 48, 96, 192, 1200),
      labels = c(0.06, 0.12, 0.25, 0.5, 1, 2, 4, 8, 16, 32, 64, 128, 256),
      pheno = list("s" = 7, "r" = 6)
    ),
    "1024" = list(
      bins = c(0, 0.09, 0.185, 0.375, 0.75, 1.5, 3, 6, 12, 24, 48, 96, 192, 384, 768, 2000),
      labels = c(0.06, 0.12, 0.25, 0.5, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024),
      pheno = list("s" = 7, "r" = 8)
    )
  )

  # Defensive check: supported max_mic
  if (!as.character(max_mic) %in% names(mic_config)) {
    stop("Unsupported 'max_mic'. Valid options: 64, 256, 1024.")
  }

  # MIC binning and label mapping
  conf <- mic_config[[as.character(max_mic)]]
  df$recategorized_mic <- cut(df$measurement_value, breaks = conf$bins, labels = conf$labels, right = FALSE)

  # Phenotype code matrix construction
  s_count <- conf$pheno$s
  r_count <- conf$pheno$r
  base_code <- strsplit(paste0(strrep("s", s_count), strrep("r", r_count)), "")[[1]]

  phenotype_map <- list(
    "Klebsiella"     = base_code,
    "Escherichia"    = base_code,
    "Salmonella"     = base_code,
    "Streptococcus"  = strsplit(paste0(strrep("s", s_count - 3), strrep("r", r_count + 3)), "")[[1]],
    "Staphylococcus" = base_code,
    "Pseudomonas"    = strsplit(paste0(strrep("s", s_count + 2), strrep("r", r_count - 2)), "")[[1]],
    "Acinetobacter"  = strsplit(paste0(strrep("s", s_count + 1), strrep("r", r_count - 1)), "")[[1]],
    "Campylobacter"  = strsplit(paste0(strrep("s", s_count + 1), strrep("r", r_count - 1)), "")[[1]],
    "Neisseria"      = strsplit(paste0(strrep("s", s_count - 2), strrep("r", r_count + 2)), "")[[1]]
  )

  pheno_df <- as.data.frame(do.call(rbind, phenotype_map), stringsAsFactors = FALSE)
  rownames(pheno_df) <- names(phenotype_map)
  colnames(pheno_df) <- as.character(conf$labels)

  # Phenotype assignment logic
  df <- df %>%
    rowwise() %>%
    mutate(
      phenotype_assigned = {
        genus_use <- ifelse(!is.na(new_genus), new_genus, genus)
        mic_value <- as.character(recategorized_mic)
        if (!is.na(mic_value) &&
            genus_use %in% rownames(pheno_df) &&
            mic_value %in% colnames(pheno_df)) {
          val <- pheno_df[genus_use, mic_value]
          if (val == "s") "Susceptible"
          else if (val == "r") "Resistant"
          else NA_character_
        } else if (!is.na(phenotype)) {
          tools::toTitleCase(tolower(phenotype))
        } else {
          NA_character_
        }
      },
      phenotype_assigned = ifelse(phenotype_assigned == "Intermediate", "Susceptible", phenotype_assigned)
    ) %>%
    ungroup()

  return(df)
}
