#' add_lengths
#'
#' @import dplyr
#' @import readr
#' @import ggplot2
#'
#' @param data.df a dataframe with gene_id (must match gene_id in gene coordinates) and either expression data or gene sets
#' @param lengths.df a dataframe with gene_id and gene lengths, either the package provided H. sapiens GRCh38.p14 Ensembl Release 110 or user provided with input_lengths()
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

  # Check if the required columns are present in the input dataframes
  required_columns <- c("gene_id", "length")
  if (!all("gene_id" %in% colnames(data.df))) {
    stop("Input data.df is missing required columns: ", paste(setdiff("gene_id", colnames(data.df)), collapse = ", "))
  }

  if (!all(required_columns %in% colnames(lengths.df))) {
    stop("Input lengths.df is missing required columns: ", paste(setdiff(required_columns, colnames(lengths.df)), collapse = ", "))
  }

  tryCatch({
    # Attempt to match gene_id and add lengths
    data.df <- data.df %>%
      mutate(length = lengths.df$length[match(gene_id, lengths.df$gene_id)])

  }, error = function(e) {
    # Handle errors gracefully
    warning("An error occurred while adding lengths. Details: ", conditionMessage(e))
    # Return the original data.df without modifications
    return(data.df)
  })

  return(data.df)
}
