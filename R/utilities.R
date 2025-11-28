#'
#' Turn a pvalue into its corresponding label
#' @keywords internal
#'
.label_p_value = function(x) {
  stats::symnum(
    x,
    cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1),
    symbols = c("****", "***", "**", "*", "ns"),
    na = ""
  )
}


#' Calculate per-group y position
#' @keywords internal
.get_y.position = function(data, offset) {
  data %>%
    group_by(x) %>%
    summarize(y = max(y) * (1+offset)) %>%
    ungroup()
}
