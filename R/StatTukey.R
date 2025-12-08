
#' Tukey HSD Test
#'
#' @rdname Tukey
#'
#' @param trans_value A function that accept a vector as input and output a transformed vector. To be applied to y values before statistics test.
#' @param show.ns Should non-significant results be shown
#' @param text_size Size of the significance symbols, default 12pt
#' @param line_size Size of the lines spanning each group, default 1pt
#' @param linetype Type of the line spanning each group
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
    show.ns = FALSE,
    trans_value = NULL,
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
    return(params)
  },
  compute_panel = function(
    data, scales,
    step,
    trans_value,
    show.ns
  ) {
    # Make sure x-axis is a discrete scale
    .check_x_scale_ok(scales)

    y_positions = .get_y.position(data, 0)
    stat_results = data

    # Run the statistical test
    stat_results$x = as.character(stat_results$x)
    stat_results = .tukey_test(stat_results, trans_value)
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

#' @rdname Tukey
#'
#' @export
geom_tukey = function(
    mapping = NULL,
    data = NULL,
    stat = "tukey",
    position = "identity",
    inherit.aes = TRUE,
    show.ns = FALSE,
    trans_value = NULL,
    text_size = 12,
    line_size = 1,
    linetype = "solid",
    ...
) {
  layer(
    mapping = mapping,
    data = data,
    geom = GeomTukey,
    stat = stat,
    position = position,
    params = list(
      show.ns = show.ns,
      trans_value = trans_value,
      text_size = text_size,
      line_size = line_size,
      linetype = linetype,
      ...
    )
  )
}


#' @rdname Tukey
#'
#' @export
GeomTukey = ggproto(
  "GeomTukey",
  GeomBracket
)

#' @keywords internal
.tukey_test = function(data, trans_value) {
  data$y = trans_value(data$y)

  model = aov(formula = y ~ x, data = data)
  stat = TukeyHSD(model, conf.level = 0.95)

  stat = stat[[1]] %>%
    tibble::as_tibble(rownames = "contrast") %>%
    tidyr::separate(col = contrast, into = c("group1", "group2"), sep = "-", remove = FALSE) %>%
    rename(adj.p.value = `p adj`) %>%
    mutate(
      label = .label_p_value(adj.p.value)
    )

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
