#' gene_lengths: a function that allows users to input their own ensembl gene
#'  list to calculate gene lengths
#'
#' @import dplyr
#' @import readr
#'
#' @param filepath a filepath to a tab-delimited file with chromosome,
#'  start position, end positions, and ensembl gene id (in that order)
#' @param gene_id name of gene_id column (e.g. `Gene stable ID`).
#'  This must match the gene_id name in data.
#' @param delim delimiter in file
#'
#' @return returns dataframe with gene lengths for user provided genes
#' @export
#'
#' @examples
#' lengths.df <- gene_lengths(
#'   file = system.file(
#'     "extdata",
#'     "example_gene_coordinates.tsv",
#'     package = "genesizeR"),
#'   gene_id = "Gene stable ID",
#'   delim = "\t")
gene_lengths <- function(filepath, gene_id, delim) {

  tryCatch({
    # Attempt to read the file
    data.df <- read_delim(filepath, delim = delim)

    # Check if the provided gene_id exists in the dataframe
    if (!gene_id %in% colnames(data.df)) {
      stop("The specified gene_id '", gene_id, "' does not match any column names in the input data.")
    }

    # Calculate gene lengths
    data.df <- data.df %>%
      dplyr::rename(gene_id = !!{{gene_id}}) %>%
      mutate(length = data.df[[3]] - data.df[[2]] + 1) %>%
      filter(!is.na(length)) %>%
      select(gene_id, length)
  }, error = function(e) {
    # Handle errors gracefully
    warning("An error occurred while processing gene_lengths. Details: ", conditionMessage(e))
    # Return an empty data.frame
    return(data.frame())
  })

  return(data.df)
}
