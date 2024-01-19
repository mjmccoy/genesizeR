#' sizeR_input: a function to input gene expression or gene set data
#'
#' @import dplyr
#' @import readr
#'
#' @param filepath a filepath to a tab-delimited file with gene_id and
#'  expression data or gene set data
#' @param gene_id name of gene_id column (e.g. `Gene stable ID`).
#'  This must match the gene_id name in data.
#' @param delim delimiter in file (e.g. "\t", or ",")
#'
#' @return returns dataframe with gene_id and expression or gene set data
#' @export
#'
#' @examples
#' data.df <- sizeR_input(
#'   file = system.file(
#'     "extdata",
#'     "example_gene_coordinates.tsv",
#'     package = "sizeR"),
#'   gene_id = "Gene stable ID",
#'   delim = "\t")
sizeR_input <- function(filepath, gene_id, delim) {

  tryCatch({
    # Attempt to read the file
    data.df <- read_delim(filepath, delim = delim)

    # Check if the provided gene_id exists in the dataframe
    if (!gene_id %in% colnames(data.df)) {
      stop("The specified gene_id '", gene_id, "' does not match any column names in the input data.")
    }

    # Calculate gene lengths
    data.df <- data.df %>%
      dplyr::rename(gene_id := {{gene_id}})
  }, error = function(e) {
    # Handle errors gracefully
    warning("An error occurred while processing sizeR_input. Details: ", conditionMessage(e))
    # Return an empty data.frame
    return(data.frame())
  })

  return(data.df)
}
