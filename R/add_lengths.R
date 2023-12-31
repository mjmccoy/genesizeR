#' add_lengths
#'
#' @import dplyr
#' @import readr
#' @import ggplot2
#'
#' @param data.df a dataframe with gene_id from Ensembl and either expression data or gene sets
#' @param lengths.df a dataframe with gene_id from Ensembl and gene lengths, either the package provided H. sapiens GRCh38.p14 Ensembl Release 110 or user provided with input_lengths()
#'
#' @return returns a dataframe with gene lengths appended
#' @export
#'
#' @examples
#' data(example_expression_data)
#' data(example_lengths)
#' data.df <- add_lengths(data.df = example_expression_data,
#'                        lengths.df = example_lengths)
add_lengths <- function(data.df, lengths.df) {
  length <- gene_id <- NULL
  data.df <- data.df %>%
    mutate(length = lengths.df$length[match(gene_id, lengths.df$`Gene stable ID`)])
  return(data.df)
}
