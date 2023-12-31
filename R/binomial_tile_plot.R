#' binomial_tile_plot()
#'
#' This is a function named 'binomial_tile_plot'
#' which generates a binomial gene size enrichment/depletion tile plot
#'
#' @import dplyr
#' @import ggplot2
#'
#' @param binomial.df a dataframe output from binomial_test()
#' @param by_sample should data be grouped by sample?
#' @param categorical is group categorical?
#'
#' @return returns a gene size enrichment tile plot
#' @export
#'
#' @examples
#' data(example_quantitative_feature_binomial_test_output)
#' binomial_tile_plot(
#'   binomial.df = example_quantitative_feature_binomial_test_output)
#'
#' data(example_quantitative_feature_by_sample_binomial_test_output)
#' binomial_tile_plot(
#'   binomial.df = example_quantitative_feature_by_sample_binomial_test_output,
#'   by_sample = TRUE)
#'
#' data(example_categorical_binomial_test_output)
#' binomial_tile_plot(
#'   binomial.df = example_categorical_binomial_test_output,
#'   categorical = TRUE)

binomial_tile_plot <- function(
    binomial.df, by_sample = FALSE, categorical = FALSE){
  length_range <- feature_range <- n <- sign <- name <- group <- NULL
  if(by_sample == TRUE & categorical == FALSE){
    binomial.df %>%
      ggplot(aes(x = length_range, y = feature_range, fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature") +
      facet_grid(~name)
  } else if(by_sample == FALSE & categorical == FALSE){
    binomial.df %>%
      ggplot(aes(x = length_range, y = feature_range, fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      coord_equal() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature")
  } else if(categorical == TRUE){
    binomial.df %>%
      ggplot(aes(x = length_range, y = reorder(group, n), fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      coord_equal() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature")
  }
}
