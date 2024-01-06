#' sizeR_plot()
#'
#' @import dplyr
#' @import ggplot2
#'
#' @param data.df a dataframe output from binomial_test()
#' @param by_sample should data be grouped by sample?
#' @param categorical is group categorical?
#' @param type geom type (i.e. bar, tile, line)
#'
#' @return returns a sizeR plot
#' @export
#'
#' @examples
#'
#' ###################
#' # sizeR bar plots #
#' ###################
#'
#' # quantitative feature
#' data(example_quantitative_feature_binomial_test_output)
#' sizeR_plot(
#'   data.df = example_quantitative_feature_binomial_test_output,
#'   type = "bar")
#'
#' # quantitative feature by sample
#' data(example_quantitative_feature_by_sample_binomial_test_output)
#' sizeR_plot(
#'   data.df = example_quantitative_feature_by_sample_binomial_test_output,
#'   by_sample = TRUE,
#'   type = "bar")
#'
#' # categorical feature
#' data(example_categorical_binomial_test_output)
#' sizeR_plot(
#'   data.df = example_categorical_binomial_test_output, categorical = TRUE,
#'   type = "bar")
#'
#' ####################
#' # sizeR tile plots #
#' ####################
#'
#' data(example_quantitative_feature_binomial_test_output)
#' sizeR_plot(
#'   data.df = example_quantitative_feature_binomial_test_output,
#'   type = "tile")
#'
#' data(example_quantitative_feature_by_sample_binomial_test_output)
#' sizeR_plot(
#'   data.df = example_quantitative_feature_by_sample_binomial_test_output,
#'   by_sample = TRUE,
#'   type = "tile")
#'
#' data(example_categorical_binomial_test_output)
#' sizeR_plot(
#'   data.df = example_categorical_binomial_test_output,
#'   categorical = TRUE,
#'   type = "tile")
#'
#' ###################
#' # sizeR line plot #
#' ###################
#'
#' data(example_quantitative_feature_by_sample_binomial_test_input)
#' sizeR_plot(
#'   data.df = example_quantitative_feature_by_sample_binomial_test_input,
#'   type = "line") +
#'   scale_color_manual(values = c("condition1.r1" = "firebrick", "condition1.r2" = "firebrick", "condition2.r1" = "black", "condition2.r2" = "black"))

sizeR_plot <- function(
    data.df,
    by_sample = FALSE,
    categorical = FALSE,
    type){
  length_range <- feature_range <- n <- mean_n <- sign <- name <- group <- NULL
  if(by_sample == TRUE & categorical == FALSE & type == "bar"){
    data.df %>%
      ggplot(aes(x = length_range, y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = data.df %>%
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
  } else if(by_sample == FALSE & categorical == FALSE & type == "bar"){
    data.df %>%
      ggplot(aes(x = length_range, y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = data.df %>%
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
  } else if(categorical == TRUE & type == "bar"){
    data.df %>%
      ggplot(aes(x = length_range, y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = data.df %>%
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
  } else if(by_sample == TRUE & categorical == FALSE & type == "tile"){
    data.df %>%
      ggplot(aes(x = length_range, y = feature_range, fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature") +
      facet_grid(~name)
  } else if(by_sample == FALSE & categorical == FALSE & type == "tile"){
    data.df %>%
      ggplot(aes(x = length_range, y = feature_range, fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      coord_equal() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature")
  } else if(categorical == TRUE & type == "tile"){
    data.df %>%
      ggplot(aes(x = length_range, y = reorder(group, n), fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      coord_equal() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature")
  } else if(type == "line"){
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
}
