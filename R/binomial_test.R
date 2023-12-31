#' binomial_test
#'
#' @import dplyr
#' @import ggplot2
#' @import tidyr
#' @importFrom stats binom.test na.omit p.adjust reorder
#'
#' @param data.df a dataframe containing gene_id, length, and either gene set or expression data
#' @param by_sample should data be grouped by sample?
#' @param categorical is group categorical?
#' @param feature_name the exact feature name in the data (e.g. log2FC)
#'
#' @return returns a dataframe with estimates for gene size enrichment by binomial test
#' @export
#'
#' @examples
#' # quantitative feature
#' data(example_quantitative_feature_binomial_test_input)
#' data.df <- binomial_test(
#'   data.df = example_quantitative_feature_binomial_test_input,
#'   feature_name = "log2FC")
#'
#' # quantitative feature by sample
#' data(example_quantitative_feature_by_sample_binomial_test_input)
#' data.df <- binomial_test(
#'   data.df = example_quantitative_feature_by_sample_binomial_test_input,
#'   by_sample = TRUE)
#'
#' # categorical feature
#' data(example_categorical_binomial_test_input)
#' data.df <- binomial_test(
#'   data.df = example_categorical_binomial_test_input, categorical = TRUE)
binomial_test <- function(
    data.df,
    by_sample = FALSE,
    categorical = FALSE,
    feature_name = NULL){
  gene_id <- value <- length_bins <- length_range <- feature_range <- NULL
  feature_bins <- name <- total_trials <- p_val <- feature <- group <- NULL
  if(categorical == FALSE & by_sample == TRUE){
    data.df %>%
      na.omit() %>%
      pivot_longer(!c(length, gene_id)) %>%
      mutate(
        length_bins = ntile(length, n = 10),
        feature_bins = ntile(value, n = 10)) %>%
      group_by(length_bins) %>%
      mutate(length_range = paste0(
        "[",
        min(length) %>%round(1),
        ":",
        max(length) %>% round(1),
        "]")) %>%
      ungroup() %>%
      arrange(length_bins) %>%
      mutate(length_range = factor(
        length_range, levels = unique(length_range), ordered = TRUE)) %>%
      group_by(feature_bins) %>%
      mutate(feature_range = paste0(
        "[",
        min(value) %>% round(1),
        ":",
        max(value) %>% round(1),
        "]")) %>%
      ungroup() %>%
      arrange(feature_bins) %>%
      mutate(feature_range = factor(
        feature_range, levels = unique(feature_range), ordered = TRUE)) %>%
      dplyr::count(name, length_range, feature_range) %>%
      complete(name, length_range, feature_range) %>%
      ungroup() %>%
      mutate(n = ifelse(is.na(n), 0, n)) %>%
      group_by(name, feature_range) %>%
      mutate(
        total_trials = sum(n)) %>%
      ungroup() %>%
      rowwise() %>%
      mutate(
        p_val = ifelse(
          total_trials > 0,
          binom.test(
            x = n,
            n = total_trials,
            p = 0.1,
            alternative = "two.sided")$p.value, NA)) %>%
      ungroup() %>%
      mutate(
        p_adj = p.adjust(p_val, method = "BH"),
        sign = case_when(
          p_adj < 0.005 & n > (0.1*total_trials) ~ "+",
          p_adj < 0.005 & n < (0.1*total_trials) ~ "-",
          TRUE ~ ""))
  } else if(categorical == FALSE & by_sample == FALSE){
    data.df %>%
      dplyr::rename(feature = all_of(feature_name)) %>%
      na.omit() %>%
      mutate(
        length_bins = ntile(length, n = 10),
        feature_bins = ntile(feature, n = 10)) %>%
      group_by(length_bins) %>%
      mutate(length_range = paste0(
        "[",
        min(length) %>% round(1),
        ":",
        max(length) %>% round(1),
        "]")) %>%
      ungroup() %>%
      arrange(length_bins) %>%
      mutate(length_range = factor(
        length_range,
        levels = unique(length_range), ordered = TRUE)) %>%
      group_by(feature_bins) %>%
      mutate(feature_range = paste0(
        "[",
        min(feature) %>% round(1),
        ":",
        max(feature) %>% round(1),
        "]")) %>%
      ungroup() %>%
      arrange(feature_bins) %>%
      mutate(feature_range = factor(
        feature_range, levels = unique(feature_range), ordered = TRUE)) %>%
      dplyr::count(length_range, feature_range) %>%
      complete(length_range, feature_range) %>%
      ungroup() %>%
      mutate(n = ifelse(is.na(n), 0, n)) %>%
      group_by(feature_range) %>%
      mutate(
        total_trials = sum(n)) %>%
      ungroup() %>%
      rowwise() %>%
      mutate(
        p_val = ifelse(
          total_trials > 0,
          binom.test(
            x = n,
            n = total_trials,
            p = 0.1,
            alternative = "two.sided")$p.value, NA)) %>%
      ungroup() %>%
      mutate(
        p_adj = p.adjust(p_val, method = "BH"),
        sign = case_when(
          p_adj < 0.005 & n > (0.1*total_trials) ~ "+",
          p_adj < 0.005 & n < (0.1*total_trials) ~ "-",
          TRUE ~ ""))
  } else if(categorical == TRUE){
    data.df %>%
      na.omit() %>%
      mutate(length_bins = ntile(length, n = 10)) %>%
      group_by(length_bins) %>%
      mutate(
        length_range = paste0(
          "[",
          min(length) %>% round(1),
          ":",
          max(length) %>% round(1),
          "]")) %>%
      ungroup() %>%
      arrange(length_bins) %>%
      mutate(length_range = factor(
        length_range, levels = unique(length_range), ordered = TRUE)) %>%
      dplyr::count(length_range, group) %>%
      complete(length_range, group) %>%
      ungroup() %>%
      mutate(n = ifelse(is.na(n), 0, n)) %>%
      group_by(group) %>%
      mutate(
        total_trials = sum(n)) %>%
      ungroup() %>%
      rowwise() %>%
      mutate(
        p_val = ifelse(
          total_trials > 0,
          binom.test(
            x = n,
            n = total_trials,
            p = 0.1,
            alternative = "two.sided")$p.value, NA)) %>%
      ungroup() %>%
      mutate(
        p_adj = p.adjust(p_val, method = "BH"),
        sign = case_when(
          p_adj < 0.005 & n > (0.1*total_trials) ~ "+",
          p_adj < 0.005 & n < (0.1*total_trials) ~ "-",
          TRUE ~ ""))
  }
}
