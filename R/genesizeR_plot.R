#' genesizeR_plot()
#'
#' @import dplyr
#' @import ggplot2
#'
#' @param data.df a dataframe output from binomial_test()
#' @param by_sample should data be grouped by sample?
#' @param categorical is group categorical?
#' @param type geom type (i.e. bar, tile, line)
#' @param quantiles should x and y values be quantiles?
#'
#' @return returns a genesizeR plot
#' @export
#'
#' @examples
#'
#' ###################
#' # genesizeR bar plots #
#' ###################
#'
#' # quantitative feature
#' data(example_quantitative_feature_binomial_test_output)
#' genesizeR_plot(
#'   data.df = example_quantitative_feature_binomial_test_output,
#'   quantiles = FALSE,
#'   type = "bar")
#'
#' # quantitative feature by sample
#' data(example_quantitative_feature_by_sample_binomial_test_output)
#' genesizeR_plot(
#'   data.df = example_quantitative_feature_by_sample_binomial_test_output,
#'   by_sample = TRUE,
#'   quantiles = FALSE,
#'   type = "bar")
#'
#' # categorical feature
#' data(example_categorical_binomial_test_output)
#' genesizeR_plot(
#'   data.df = example_categorical_binomial_test_output, categorical = TRUE,
#'   quantiles = FALSE,
#'   type = "bar")
#'
#' ####################
#' # genesizeR tile plots #
#' ####################
#'
#' data(example_quantitative_feature_binomial_test_output)
#' genesizeR_plot(
#'   data.df = example_quantitative_feature_binomial_test_output,
#'   quantiles = FALSE,
#'   type = "tile")
#'
#' data(example_quantitative_feature_by_sample_binomial_test_output)
#' genesizeR_plot(
#'   data.df = example_quantitative_feature_by_sample_binomial_test_output,
#'   by_sample = TRUE,
#'   quantiles = FALSE,
#'   type = "tile")
#'
#' data(example_categorical_binomial_test_output)
#' genesizeR_plot(
#'   data.df = example_categorical_binomial_test_output,
#'   categorical = TRUE,
#'   quantiles = FALSE,
#'   type = "tile")
#'
#' ###################
#' # genesizeR line plot #
#' ###################
#'
#' data(example_quantitative_feature_by_sample_binomial_test_input)
#' genesizeR_plot(
#'   data.df = example_quantitative_feature_by_sample_binomial_test_input,
#'   quantiles = FALSE,
#'   type = "line")

genesizeR_plot <- function(
    data.df,
    by_sample = FALSE,
    categorical = FALSE,
    quantiles = TRUE,
    type){
  length_range <- length_bins <- value <- gene_id <- feature_range <- NULL
  n <- mean_n <- sign <- name <- group <- NULL
  if(by_sample == TRUE & categorical == FALSE & quantiles == FALSE &
     type == "bar"){
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
  } else if(by_sample == TRUE & categorical == FALSE & quantiles == TRUE &
            type == "bar"){
    data.df %>%
      mutate(
        length_range = as.integer(length_range),
        feature_range = as.integer(feature_range)) %>%
      ggplot(aes(x = as.factor(length_range), y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = data.df %>%
                   mutate(
                     length_range = as.integer(length_range),
                     feature_range = as.integer(feature_range)) %>%
                   group_by(name, feature_range) %>%
                   summarise(mean_n = mean(n)),
                 aes(yintercept = mean_n),
                 linetype = "dotted") +
      scale_fill_manual(
        name = "Binomial", values = c("+" = "firebrick", "-" = "skyblue")) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size quantiles", y = "Genes") +
      facet_grid(feature_range~name)
  } else if(by_sample == FALSE & categorical == FALSE & quantiles == FALSE &
            type == "bar"){
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
  } else if(by_sample == FALSE & categorical == FALSE & quantiles == TRUE &
            type == "bar"){
    data.df %>%
      mutate(
        length_range = as.integer(length_range),
        feature_range = as.integer(feature_range)) %>%
      ggplot(aes(x = as.factor(length_range), y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = data.df %>%
                   mutate(
                     length_range = as.integer(length_range),
                     feature_range = as.integer(feature_range)) %>%
                   group_by(feature_range) %>%
                   summarise(mean_n = mean(n)),
                 aes(yintercept = mean_n),
                 linetype = "dotted") +
      scale_fill_manual(
        name = "Binomial", values = c("+" = "firebrick", "-" = "skyblue")) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size quantiles", y = "Genes") +
      facet_grid(~feature_range)
  } else if(categorical == TRUE & quantiles == FALSE & type == "bar"){
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
  } else if(categorical == TRUE & quantiles == TRUE & type == "bar"){
    data.df %>%
      mutate(length_range = as.integer(length_range)) %>%
      ggplot(aes(x = as.factor(length_range), y = n, fill = sign)) +
      geom_col(col = "black") +
      geom_hline(data = data.df %>%
                   mutate(length_range = as.integer(length_range)) %>%
                   group_by(group) %>%
                   summarise(mean_n = mean(n)),
                 aes(yintercept = mean_n),
                 linetype = "dotted") +
      scale_fill_manual(
        name = "Binomial", values = c("+" = "firebrick", "-" = "skyblue")) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size quantiles", y = "Genes") +
      facet_grid(~group)
  } else if(by_sample == TRUE & categorical == FALSE & quantiles == FALSE &
            type == "tile"){
    data.df %>%
      ggplot(aes(x = length_range, y = feature_range, fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature") +
      facet_grid(~name)
  } else if(by_sample == TRUE & categorical == FALSE & quantiles == TRUE &
            type == "tile"){
    data.df %>%
      mutate(
        length_range = as.integer(length_range),
        feature_range = as.integer(feature_range)) %>%
      ggplot(aes(x = as.factor(length_range), y = as.factor(feature_range),
                 fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size quantiles", y = "Feature quantiles") +
      facet_grid(~name)
  } else if(by_sample == FALSE & categorical == FALSE & quantiles == FALSE &
            type == "tile"){
    data.df %>%
      ggplot(aes(x = length_range, y = feature_range, fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      coord_equal() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature")
  } else if(by_sample == FALSE & categorical == FALSE & quantiles == TRUE &
            type == "tile"){
    data.df %>%
      mutate(
        length_range = as.integer(length_range),
        feature_range = as.integer(feature_range)) %>%
      ggplot(aes(x = as.factor(length_range), y = as.factor(feature_range),
                 fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      coord_equal() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size quantiles", y = "Feature quantiles")
  } else if(categorical == TRUE & quantiles == FALSE & type == "tile"){
    data.df %>%
      ggplot(aes(x = length_range, y = reorder(group, n), fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      coord_equal() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size (kb)", y = "Feature")
  } else if(categorical == TRUE & quantiles == TRUE & type == "tile"){
    data.df %>%
      mutate(
        length_range = as.integer(length_range)) %>%
      ggplot(aes(x = as.factor(length_range), y = reorder(group, n),
                 fill = n)) +
      geom_tile() +
      geom_text(aes(label = sign)) +
      scale_fill_distiller(name = "Genes", palette = "RdGy") +
      coord_equal() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
      labs(x = "Gene size quantiles", y = "Feature")
  } else if(quantiles == FALSE & type == "line"){
    data.df %>%
      pivot_longer(!c(gene_id, length)) %>%
      mutate(length_bins = ntile(length, n = 100)) %>%
      group_by(length_bins) %>%
      mutate(
        length = mean(length)
      ) %>%
      ggplot(aes(x = length/1e3, y = sqrt(value), col = name, group = name)) +
      stat_summary(geom = "ribbon", fun.data = mean_cl_normal, alpha = 0.1,
                   aes(col = NULL)) +
      stat_summary(geom = "point", size = 0.1) +
      stat_summary(geom = "line") +
      theme_bw() +
      labs(x = "Gene size (kb)", y = "Gene expression") +
      scale_x_log10() +
      annotation_logticks(sides = "b")
  } else if(quantiles == TRUE & type == "line"){
    data.df %>%
      pivot_longer(!c(gene_id, length)) %>%
      mutate(length_bins = ntile(length, n = 100)) %>%
      ggplot(aes(x = length_bins, y = sqrt(value), col = name, group = name)) +
      stat_summary(geom = "ribbon", fun.data = mean_cl_normal, alpha = 0.1,
                   aes(col = NULL)) +
      stat_summary(geom = "point", size = 0.1) +
      stat_summary(geom = "line") +
      theme_bw() +
      labs(x = "Gene size quantiles", y = "Gene expression")
  }
}
