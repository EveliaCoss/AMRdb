
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AMRdb

<!-- badges: start -->

[![GitHub
issues](https://img.shields.io/github/issues/EveliaCoss/AMRdb)](https://github.com/EveliaCoss/AMRdb/issues)
[![GitHub
pulls](https://img.shields.io/github/issues-pr/EveliaCoss/AMRdb)](https://github.com/EveliaCoss/AMRdb/pulls)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![check-bioc](https://github.com/EveliaCoss/AMRdb/actions/workflows/check-bioc.yml/badge.svg)](https://github.com/EveliaCoss/AMRdb/actions/workflows/check-bioc.yml)
[![Codecov test
coverage](https://codecov.io/gh/EveliaCoss/AMRdb/graph/badge.svg)](https://app.codecov.io/gh/EveliaCoss/AMRdb)
<!-- badges: end -->

The goal of `AMRdb` is to provide a curated, high-quality dataset that
supports the analysis, visualization, and modeling of antimicrobial
resistance (AMR). Specifically, AMRdb enables researchers and data
scientists to:

- Analyze outputs from Machine Learning and Deep Learning models,
  particularly those related to MIC (Minimum Inhibitory Concentration)
  predictions and phenotypic classification (Resistant, Intermediate,
  Susceptible).

- Explore clinical and genomic metadata associated with microbial
  isolates.

- Integrate structured data into reproducible workflows for
  computational AMR surveillance and comparative genomics.

The data included in this package are sourced from publicly available
repositories such as the European Nucleotide Archive (ENA), BV-BRC, and
NCBI, offering a harmonized foundation for predictive modeling and
downstream resistance profiling.

## Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `AMRdb` from
[Github](https://github.com/EveliaCoss/AMRdb) using the following code:

``` r
if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
}

remotes::install_github("EveliaCoss/AMRdb")
```

Or you can install `AMRdb` from [Bioconductor](http://bioconductor.org/)
using the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install("AMRdb")
```

And the development version from
[GitHub](https://github.com/EveliaCoss/AMRdb) with:

``` r
BiocManager::install("EveliaCoss/AMRdb")
```

## Example

## Citation

Below is the citation output from using `citation('AMRdb')` in R. Please
run this yourself to check for any updates on how to cite **AMRdb**.

``` r
print(citation('AMRdb'), bibtex = TRUE)
#> To cite package 'AMRdb' in publications use:
#> 
#>   EveliaCoss (2025). _Mi articulo_. doi:10.18129/B9.bioc.AMRdb
#>   <https://doi.org/10.18129/B9.bioc.AMRdb>,
#>   https://github.com/EveliaCoss/AMRdb/AMRdb - R package version 0.1.0,
#>   <http://www.bioconductor.org/packages/AMRdb>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {Mi articulo},
#>     author = {{EveliaCoss}},
#>     year = {2025},
#>     url = {http://www.bioconductor.org/packages/AMRdb},
#>     note = {https://github.com/EveliaCoss/AMRdb/AMRdb - R package version 0.1.0},
#>     doi = {10.18129/B9.bioc.AMRdb},
#>   }
#> 
#>   EveliaCoss (2025). "Mi articulo." _bioRxiv_. doi:10.1101/TODO
#>   <https://doi.org/10.1101/TODO>,
#>   <https://www.biorxiv.org/content/10.1101/TODO>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {Mi articulo},
#>     author = {{EveliaCoss}},
#>     year = {2025},
#>     journal = {bioRxiv},
#>     doi = {10.1101/TODO},
#>     url = {https://www.biorxiv.org/content/10.1101/TODO},
#>   }
```

Please note that the `AMRdb` was only made possible thanks to many other
R and bioinformatics software authors, which are cited either in the
vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the `AMRdb` project is released with a [Contributor
Code of Conduct](http://bioconductor.org/about/code-of-conduct/). By
contributing to this project, you agree to abide by its terms.

## Development tools

- Continuous code testing is possible thanks to [GitHub
  actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/)
  through *[usethis](https://CRAN.R-project.org/package=usethis)*,
  *[remotes](https://CRAN.R-project.org/package=remotes)*, and
  *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)* customized
  to use [Bioconductor’s docker
  containers](https://www.bioconductor.org/help/docker/) and
  *[BiocCheck](https://bioconductor.org/packages/3.21/BiocCheck)*.
- Code coverage assessment is possible thanks to
  [codecov](https://codecov.io/gh) and
  *[covr](https://CRAN.R-project.org/package=covr)*.
- The [documentation website](http://EveliaCoss.github.io/AMRdb) is
  automatically updated thanks to
  *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
- The code is styled automatically thanks to
  *[styler](https://CRAN.R-project.org/package=styler)*.
- The documentation is formatted thanks to
  *[devtools](https://CRAN.R-project.org/package=devtools)* and
  *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

This package was developed using
*[biocthis](https://bioconductor.org/packages/3.21/biocthis)*.
