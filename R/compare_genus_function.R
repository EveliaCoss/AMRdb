#' Compare taxonomic genera between two columns of species names
#'
#' This function compares the genus part of scientific species names between two columns in a data frame.
#' It returns the original data frame with additional columns: `old_genus`, `new_genus`, and `genera_match`.
#'
#' @param df A data frame containing two columns with scientific species names (e.g., "Staphylococcus aureus").
#' @param old_col Character string. The name of the column with the original species names. Default: `"old_species"`.
#' @param new_col Character string. The name of the column with the new species names. Default: `"new_species"`.
#'
#' @return A data frame with three additional columns:
#' - `old_genus`: the genus extracted from `old_col`.
#' - `new_genus`: the genus extracted from `new_col`.
#' - `genus_match`: a logical column indicating whether the genera match (`TRUE`) or not (`FALSE`).
#'
#' @examples
#' df <- data.frame(
#'   old_species = c("Staphylococcus aureus", "Escherichia coli"),
#'   new_species = c("Staphylococcus epidermidis", "Klebsiella pneumoniae")
#' )
#' compare_genus(df)
#'
#' @export
compare_genus <- function(df, old_col = "old_species", new_col = "new_species") {
  extract_genus <- function(x) sub(" .*", "", x)

  message("Extracting genus from species names")
  df$old_genus <- extract_genus(df[[old_col]])
  df$new_genus <- extract_genus(df[[new_col]])

  message("Identifying mismatched genera")
  df$genus_match <- ifelse(is.na(df$old_genus) | is.na(df$new_genus),"NA",
    ifelse(df$old_genus == df$new_genus, "TRUE", "FALSE"))

  message("Adding classification flags")
  df$genus_match <- factor(df$genus_match, levels = c("TRUE", "FALSE", "NA"))

  return(df)
}
