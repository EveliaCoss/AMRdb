#' Combined antibiogram dataset from NCBI, ENA, and BV-BRC
#'
#' A data frame containing curated antibiogram data compiled from NCBI, ENA, and BV-BRC.
#' Each row represents a unique antibiotic susceptibility test (AST) performed on a specific sample
#' against a particular antibiotic.
#'
#' @format The dataset comprises 1,404,850 observations across 13 columns, capturing both phenotypic results and relevant metadata:
#'
#' \describe{
#'   \item{biosample}{A unique identifier for the sample from the NCBI BioSample database.}
#'   \item{scientific_name_Antibiogram}{The species the sample belongs to, and, in some cases, with subspecies information.}
#'   \item{antibiotic}{The name of the antibiotic against which the sample is tested.}
#'   \item{phenotype}{The interpreted phenotype from the AST standard used during testing.}
#'   \item{measurement_sign}{If given, corresponds to the sign of the raw result from the AST. Its interpretation depends on the typing method.}
#'   \item{measurement_value}{If given, corresponds to the value of the raw result from the AST. Its interpretation depends on the typing method.}
#'   \item{measurement_units}{If given, corresponds to the units of the raw result from the AST.}
#'   \item{typing_method}{Name of the technique used for AST.}
#'   \item{typing_platform}{Name of the platform used for AST.}
#'   \item{standard}{Testing standard used for the interpretation of the phenotype.}
#'   \item{genomes}{Space-separated list of genome identifiers from the NCBI Genome database.}
#'   \item{accession}{Space-separated list of read run identifiers from the NCBI SRA database.}
#'   \item{read_type}{Space-separated list with the same length as the reads column, storing the type of read of each corresponding read run.}
#' }
#'
#' @source <https://zenodo.org/records/14876710>
"antibiograms_db"
#' @examples NULL