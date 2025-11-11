

#' Dunnett Multiple Test
#'
#' @rdname Dunnett
#'
#' @param ref.group The reference group to be used. Default to the first level of x-axis (sort())
#' @param offset How much the label will offset from the data points. Default 0.2
#' @param trans_value A function that accept a vector as input and output a transformed vector. To be applied to y values before statistics test.
#' @param show.ns Should non-significant results be shown
#'
#' @description
#' Perform Dunnett's Multiple Test Against a Reference group.
#' Display the adjusted p-values on the figure.
#'
#' @seealso DescTools::DunnettTest()
#'
#' @export
stat_dunnett = function(
    mapping = NULL,
    data = NULL,
    geom = GeomText,
    position = "identity",
    na.rm = FALSE,
    show.legend = NA,
    inherit.aes = TRUE,
    ref.group = NULL,
    offset = NULL,
    trans_value = NULL,
    show.ns = TRUE,
    ...
) {
  layer(
    stat = StatDunnett,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ref.group = ref.group,
      offset = offset,
      trans_value = trans_value,
      show.ns = show.ns,
      ...
    )
  )
}


#' @rdname Dunnett
#'
#' @export
StatDunnett = ggproto(
  "StatDunnett", Stat,
  setup_params = function(data, params) {
    params$ref.group = params$ref.group %||% sort(data$x)[1]
    params$offset = params$offset %||% 0.1
    params$trans_value = params$trans_value %||% function(x) {x}
    return(params)
  },
  compute_panel = function(data, scales, ref.group, offset, trans_value, show.ns) {
    dunnett_stat_results = data
    dunnett_stat_results$x = as.character(dunnett_stat_results$x)
    ref.group = as.character(ref.group)
    dunnett_stat_results = .dunnett_test(dunnett_stat_results, ref.group, trans_value, show.ns)

    data = data %>%
      distinct(x, group, PANEL) %>%
      left_join(dunnett_stat_results, by = join_by(x == group)) %>%
      left_join(.get_y.position(data, offset), by = join_by(x))

    data
  },
  required_aes = c("x", "y")
)

#' @keywords internal
.get_y.position = function(data, offset) {
  data %>%
    group_by(x) %>%
    summarize(y = max(y) * (1+offset)) %>%
    ungroup()
}

#' @keywords internal
.dunnett_test = function(data, ref.group, trans_value, show.ns) {
  data$y = trans_value(data$y)
  stat = DescTools::DunnettTest(
    formula = y ~ x,
    data = data,
    control = ref.group
  )
  stat = stat[[1]] %>%
    tibble::as_tibble(rownames = "contrast") %>%
    tidyr::separate(col = contrast, into = c("group1", "group2"), sep = "-", remove = FALSE) %>%
    rename(
      adj.p.value = pval,
      ref.group = group2,
      group = group1
    ) %>%
    mutate(
      label = .label_p_value(adj.p.value),
      group = as.integer(group)
    )

  if (!show.ns) {
    stat = mutate(stat, label = ifelse(label == "ns", NA, label))
  }
  print(stat)
  return(stat)
}

#' @keywords internal
.label_p_value = function(x) {
  stats::symnum(
    x,
    cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1),
    symbols = c("****", "***", "**", "*", "ns"),
    na = ""
  )
}



