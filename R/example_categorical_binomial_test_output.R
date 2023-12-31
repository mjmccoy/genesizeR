#' Example categorical binomial test output
#'
#' An example dataframe of length_range, group, n, total_trials, p_val, p_adj, and sign
#'
#' @format A data frame with 20 rows and 7 variables:
#' \describe{
#'   \item{length_range}{ord, gene length range}
#'   \item{group}{character, categorical variable}
#'   \item{n}{numeric, number of genes}
#'   \item{total_trials}{numeric, number of genes in the group and length_range}
#'   \item{p_val}{numeric, two-sided binomial test p-value}
#'   \item{p_adj}{numeric, BH adjusted p-value}
#'   \item{sign}{character, gene-size enrichement or depletion}
#'   ...
#' }
"example_categorical_binomial_test_output"
