#' sizeR_line_plot()
#'
#' This is a function named 'sizeR_line_plot'
#' which generates a gene size versus expression line plot
#'
#' @import dplyr
#' @import ggplot2
#'
#' @param data.df a dataframe containing gene length and expression values
#'
#' @return returns a gene size versus expression line plot
#' @export
#'
#' @examples
#' data(example_quantitative_feature_by_sample_binomial_test_input)
#' sizeR_line_plot(
#'   data.df = example_quantitative_feature_by_sample_binomial_test_input)
sizeR_line_plot <- function(data.df){
  length_bins <- length <- name <- NULL
  data.df %>%
    pivot_longer(!c(gene_id, length)) %>%
    mutate(length_bins = ntile(length, n = 100)) %>%
    group_by(length_bins) %>%
    mutate(
      length = mean(length)
    ) %>%
    ggplot(aes(x = length/1e3, y = sqrt(value), col = name, group = name)) +
    stat_summary(geom = "ribbon", fun.data = mean_cl_normal, alpha = 0.1, aes(col = NULL)) +
    stat_summary(geom = "point", size = 0.1) +
    stat_summary(geom = "line") +
    theme_bw() +
    labs(x = "Gene size (kb)", y = "Gene expression") +
    scale_x_log10() +
    annotation_logticks(sides = "b")
}
