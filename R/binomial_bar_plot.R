#' binomial_bar_plot()
#'
#' @import dplyr
#' @import ggplot2
#'
#' @param binomial.df a dataframe output from binomial_test()
#' @param by_sample should data be grouped by sample?
#' @param categorical is group categorical?
#'
#' @return returns a gene size enrichment bar plot
#' @export
#'
#' @examples
#' # quantitative feature
#' data(example_quantitative_feature_binomial_test_output)
#' binomial_bar_plot(
#'   binomial.df = example_quantitative_feature_binomial_test_output)
#'
#' # quantitative feature by sample
#' data(example_quantitative_feature_by_sample_binomial_test_output)
#' binomial_bar_plot(
#'   binomial.df = example_quantitative_feature_by_sample_binomial_test_output,
#'   by_sample = TRUE)
#'
#' # categorical feature
#' data(example_categorical_binomial_test_output)
#' binomial_bar_plot(
#'   binomial.df = example_categorical_binomial_test_output, categorical = TRUE)
binomial_bar_plot <- function(
    binomial.df,
    by_sample = FALSE,
    categorical = FALSE){
  length_range <- feature_range <- n <- mean_n <- sign <- name <- group <- NULL
  if(by_sample == TRUE & categorical == FALSE){
    binomial.df %>%
      ggplot(aes(x = length_range, y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = binomial.df %>%
                   group_by(name, feature_range) %>%
                   summarise(mean_n = mean(n)),
                 aes(yintercept = mean_n),
                 linetype = "dotted") +
      scale_fill_manual(
        name = "Binomial", values = c("+" = "firebrick", "-" = "skyblue")) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Genes") +
      facet_grid(feature_range~name)
  } else if(by_sample == FALSE & categorical == FALSE){
    binomial.df %>%
      ggplot(aes(x = length_range, y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = binomial.df %>%
                   group_by(feature_range) %>%
                   summarise(mean_n = mean(n)),
                 aes(yintercept = mean_n),
                 linetype = "dotted") +
      scale_fill_manual(
        name = "Binomial", values = c("+" = "firebrick", "-" = "skyblue")) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Genes") +
      facet_grid(~feature_range)
  } else if(categorical == TRUE){
    binomial.df %>%
      ggplot(aes(x = length_range, y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = binomial.df %>%
                   group_by(group) %>%
                   summarise(mean_n = mean(n)),
                 aes(yintercept = mean_n),
                 linetype = "dotted") +
      scale_fill_manual(
        name = "Binomial", values = c("+" = "firebrick", "-" = "skyblue")) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Genes") +
      facet_grid(~group)
  }
}
