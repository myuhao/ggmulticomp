#' Dunnett's Test
#'
#' @rdname Dunnett
#'
#' @param ref.group The reference group to be used. Default to the first level of x-axis (sort())
#' @param trans_value A function that accept a vector as input and output a transformed vector. To be applied to y values before statistics test.
#' @param show.ns Should non-significant results be shown?
#' @param text_size Size of the significance symbols, default 12pt
#' @param line_size Size of the lines spanning each group, default 1pt
#' @param linetype Type of the line spanning each group
#' @param p.format The format of the pvalue to display. This should be a function that accept dbl as input, and return a chr to be displayed. Default to show stars
#' @param offset How much the label will offset from the data points. Default 0.1
#' @param p.y_align A number of 1, 2, 3 to specify how p-values are presented
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
    p.format = NULL,
    p.y_align = NULL,
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
      p.format = p.format,
      p.y_align = p.y_align,
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
    params$p.format = params$p.format %||% .label_p_value
    params$p.y_align= params$p.y_align %||% 1
    return(params)
  },
  compute_panel = function(data, scales, ref.group, offset, trans_value, show.ns, p.format, p.y_align) {

    y_positions = .get_y.position(data, offset)
    stat_results = data

    # Run statistic test
    stat_results$x = as.character(stat_results$x)
    ref.group = as.character(ref.group)
    stat_results = .dunnett_test(stat_results, ref.group, trans_value, show.ns)
    # Annotate p values
    stat_results$label = p.format(stat_results$adj.p.value)

    # Convert comparison bacl to numbers
    stat_results$x = as.integer(stat_results$group1)
    stat_results$xend = as.integer(stat_results$group2)

    # Add y positions
    stat_results = left_join(stat_results, y_positions, join_by(group1 == x))
    stat_results = left_join(stat_results, y_positions, join_by(group2 == x), suffix = c(".1", ".2"))
    stat_results$y = stat_results$y.1 # Default

    if (p.y_align == 2) {stat_results$y = max(stat_results$y.1)}
    if (p.y_align == 3) {stat_results$y = pmax(stat_results$y.1, stat_results$y.2)}

    # data = data %>%
    #   distinct(x, group, PANEL) %>%
    #   left_join(stat_results, by = join_by(x == group)) %>%
    #   left_join(.get_y.position(data, offset), by = join_by(x))

    # Remove ns if not needing them
    if (!show.ns) {
      stat_results = filter(stat_results, adj.p.value < 0.05)
    }
    # Remove label for the ref group to remove warning message
    # data = filter(data, x != ref.group)
    stat_results
  },
  required_aes = c("x", "y")
)


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
      adj.p.value = pval
    ) %>%
    mutate(
      ref.group = group2,
      group = group1,
      group = as.integer(group)
    )

  return(stat)
}




