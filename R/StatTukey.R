#' Tukey HSD Test
#'
#' @rdname Tukey
#'
#' @param trans_value A function that accept a vector as input and output a transformed vector. To be applied to y values before statistics test.
#' @param show.ns Should non-significant results be shown
#' @param text_size Size of the significance symbols, default 12pt
#' @param line_size Size of the lines spanning each group, default 1pt
#' @param linetype Type of the line spanning each group
#' @param p.format The format of the pvalue to display. This should be a function that accept dbl as input, and return a chr to be displayed. Default to show stars
#' @param comparisons A list of selected comparisons to plot
#'
#' @description
#' Perform Tukey HSD Test.
#' Display the adjusted p-values on the figure.
#'
#' @export
stat_tukey = function(
    mapping = NULL,
    data = NULL,
    geom = GeomBracket,
    position = "identity",
    inherit.aes = TRUE,
    show.ns = TRUE,
    trans_value = NULL,
    p.format = NULL,
    ...
) {
  layer(
    stat = StatTukey,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    inherit.aes = inherit.aes,
    params = list(
      trans_value = trans_value,
      show.ns = show.ns,
      p.format = p.format,
      ...
    )
  )
}



#' @rdname Tukey
#'
#' @export
StatTukey = ggproto(
  "StatTukey", Stat,
  required_aes = c("x", "y"),
  setup_params = function(data, params) {
    params$show.ns = params$show.ns %||% FALSE
    params$trans_value = params$trans_value %||% function(x) {x}
    params$p.format = params$p.format %||% .label_p_value
    return(params)
  },
  compute_panel = function(
    data, scales,
    step,
    trans_value,
    show.ns,
    p.format
  ) {
    # Make sure x-axis is a discrete scale
    .check_x_scale_ok(scales)

    y_positions = .get_y.position(data, 0)
    stat_results = data

    # Run the statistical test
    stat_results$x = as.character(stat_results$x)
    stat_results = .tukey_test(stat_results, trans_value)
    # Annotate p values
    stat_results$label = p.format(stat_results$adj.p.value)
    # Convert comparison back to numbers so ggplot can handle its x positions
    stat_results$x = as.integer(stat_results$group1)
    stat_results$xend = as.integer(stat_results$group2)

    # Add y positions back
    stat_results = left_join(stat_results, y_positions, join_by(group1 == x))
    stat_results = left_join(stat_results, y_positions, join_by(group2 == x), suffix = c(".1", ".2"))
    stat_results = mutate(stat_results, y = pmax(y.1, y.2))


    # Remove ns if not needing them
    if (!show.ns) {
      stat_results = filter(stat_results, adj.p.value < 0.05)
    }

    stat_results

  }
)



#' @keywords internal
.tukey_test = function(data, trans_value) {
  data$y = trans_value(data$y)

  model = aov(formula = y ~ x, data = data)
  stat = TukeyHSD(model, conf.level = 0.95)

  stat = stat[[1]] %>%
    tibble::as_tibble(rownames = "contrast") %>%
    tidyr::separate(col = contrast, into = c("group1", "group2"), sep = "-", remove = FALSE) %>%
    rename(adj.p.value = `p adj`)

  return(stat)
}

#' @keywords internal
.check_x_scale_ok = function(scales) {
  if (!isTRUE(scales$x$is_discrete())) {
    cli::cli_abort(
      c(
        "x-axis has to be discrete values"
      )
    )
  }
}
