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
#'   \item{sra_biosample}{BioSample ID linked to the SRA run, if different from biosample}
#'   \item{scientific_name_Antibiogram}{The species the sample belongs to, and, in some cases, with subspecies information.}
#'   \item{antibiotic}{The name of the antibiotic against which the sample is tested.}
#'   \item{phenotype}{The interpreted phenotype from the AST standard used during testing.}
#'   \item{measurement_sign}{Qualifier for the numeric value (e.g., <=, >, =). Its interpretation depends on the typing method.}
#'   \item{measurement_value}{Numerical value of the measurement (e.g., MIC, zone diameter). Its interpretation depends on the typing method.}
#'   \item{measurement_units}{Units for the measurement (e.g., mm, ug/mL).}
#'   \item{typing_method}{Method used to determine resistance (e.g., disk difussio, broth dilution).}
#'   \item{typing_platform}{Name of the platform used for AST.}
#'   \item{standard}{Testing standard used for the interpretation of the phenotype.}
#'   \item{genomes}{Space-separated list of genome identifiers from the NCBI Genome database.}
#'   \item{accession}{Space-separated list of read run identifiers from the NCBI SRA database.}
#'   \item{read_type}{Sequencing read type and plataform (e.g.,PAIRED_ILLUMINA SINGLE_ILLUMINA)}
#' }
#'
#' @source <https://zenodo.org/records/14876710>
"antibiograms_db"
#' @examples NULL
