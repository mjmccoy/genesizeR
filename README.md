
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/README-sizeR_logo.svg" width="20%" />

# sizeR

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `sizeR` is to provide a collection of computational tools to
analyze gene sizes within expression data or gene sets.

## Requirements

The `sizeR` package works with R version \>= 3.6.3 and several packages
from `tidyverse`. Either `tidyverse` can be installed and loaded, or
these individual packages can be installed and loaded:

-   `dplyr` version \>= 1.0.9
-   `tidyr` version \>= 1.2.0
-   `readr` version \>= 2.1.2
-   `ggplot2` version \>= 3.3.6

## Installation

You can install the development version of `sizeR` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mjmccoy/sizeR")
```

## Example usage

This is series of examples which shows how to perform gene size
enrichment analysis with either quantitative or categorical variables:

### Load libraries

``` r
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(sizeR)
```

### Load user-specified gene lengths

``` r
# Load user_specified gene lengths
lengths.df <- gene_lengths(filepath = "inst/extdata/hsap_GRCh38.p14_ensembl_release_110_gene_lengths.txt")
```

### Estimate gene size enrichment for quantitative variables

``` r
################################################
# Example 1: Gene size v. quantitative feature #
################################################

# Load data
data.df <- read_csv(file = "inst/extdata/example_expression_data.csv")

# Append gene lengths
data.df <- add_lengths(data.df, lengths.df)

# Binomial test
binomial.df <- binomial_test(data.df, feature_name = "log2FC")

# Binomial tile plot
binomial_tile_plot(binomial.df)
```

<img src="man/figures/README-quantitative variables-1.png" width="100%" />

``` r
# Binomial bar plot
binomial_bar_plot(binomial.df)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

### Estimate gene size enrichment for quantitative variables by sample

``` r
##########################################################
# Example 2: Gene size v. quantitative feature by sample #
##########################################################

# Load data
data.df <- read_csv(file = "inst/extdata/example_expression_by_sample_data.csv")

# Append gene lengths
data.df <- add_lengths(data.df, lengths.df)

# Binomial test
binomial.df <- binomial_test(data.df, by_sample = T)

# Binomial tile plot
binomial_tile_plot(binomial.df, by_sample = T)
```

<img src="man/figures/README-quantitative variable by sample-1.png" width="100%" />

``` r
# Binomial bar plot
binomial_bar_plot(binomial.df, by_sample = T)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
# sizeR line plot
sizeR_line_plot(data.df) +
  scale_color_manual(values = c("HS.r1" = "firebrick", "HS.r2" = "firebrick", "NHS.r1" = "black", "NHS.r2" = "black"))
#> Warning: Removed 196 rows containing non-finite values (stat_summary).
#> Removed 196 rows containing non-finite values (stat_summary).
#> No summary function supplied, defaulting to `mean_se()`
#> Warning: Removed 196 rows containing non-finite values (stat_summary).
#> No summary function supplied, defaulting to `mean_se()`
```

<img src="man/figures/README-sizeR_line_plot-1.png" width="100%" />

### Estimate gene size enrichment for categorical variables

``` r
##################################################
# Example 3: Gene size v. gene set (categorical) #
##################################################

# Load gene set data
data.df <- read_csv(file = "inst/extdata/example_gene_set_data.csv")

# Append gene lengths
data.df <- add_lengths(data.df, lengths.df)

# Binomial test
binomial.df <- binomial_test(data.df, categorical = T)

# Binomial tile plot
binomial_tile_plot(binomial.df, categorical = T)
```

<img src="man/figures/README-categorical variable-1.png" width="100%" />

``` r
# Binomial bar plot
binomial_bar_plot(binomial.df, categorical = T)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
