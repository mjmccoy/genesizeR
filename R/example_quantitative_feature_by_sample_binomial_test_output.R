#' Example quantitative feature by sample binomial test output
#'
#' An example dataframe of name, length_range, feature_range, n, total_trials, p_val, p_adj, and sign
#'
#' @format A data frame with 400 rows and 8 variables:
#' \describe{
#'   \item{name}{character, sample name}
#'   \item{length_range}{ord, gene length range}
#'   \item{feature_range}{ord, quantitative variable range}
#'   \item{n}{numeric, number of genes}
#'   \item{total_trials}{numeric, number of genes in the group and length_range}
#'   \item{p_val}{numeric, two-sided binomial test p-value}
#'   \item{p_adj}{numeric, BH adjusted p-value}
#'   \item{sign}{character, gene-size enrichement or depletion}
#'   ...
#' }
"example_quantitative_feature_by_sample_binomial_test_output"
