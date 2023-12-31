#' gene_lengths: a function that allows users to input their own ensembl gene
#'  list to calculate gene lengths
#'
#' @import dplyr
#' @import readr
#'
#' @param filepath a filepath to a tab-delimited file with chromosome,
#'  start position, end positions, and ensembl gene id (in that order)
#'  for each gene
#'
#' @return returns dataframe with gene lengths for user provided genes
#' @export
#'
#' @examples
#' lengths.df <- gene_lengths(
#'   file = system.file(
#'     "extdata",
#'     "example_gene_coordinates.tsv",
#'     package = "sizeR"))
gene_lengths <- function(filepath) {
  data.df <- read_tsv(filepath)
  data.df <- data.df %>%
    mutate(length = data.df[[3]] - data.df[[2]] + 1) %>%
    filter(!is.na(length))
  return(data.df)
}
