
#' Plot brackets
#'
#' @rdname Bracket
#'
#' @description
#' Base geom to plot brackets for pairwise comparisons. Takes location of the
#' brackets and plot the segment. Add the label. The y position of each
#' bracket is automatically increased to dodge each other.
#'
#'
#' @param text_size Fontsize, in pt
#' @param line_size Size of the bracket line
#' @param linetype Format of the line.
#'
#' @keywords internal
#'
geom_bracket = function(
    mapping = NULL,
    data = NULL,
    stat = "identity",
    position = "identity",
    inherit.aes = TRUE,
    text_size = 12,
    line_size = 1,
    linetype = "solid",
    ...
) {
  layer(
    mapping = mapping,
    data = data,
    geom = GeomBracket,
    stat = stat,
    position = position,
    params = list(
      text_size = text_size,
      line_size = line_size,
      linetype = linetype,
      ...
    )
  )
}


#' @rdname Bracket
#'
#' @keywords internal
GeomBracket = ggproto(
  "GeomBracket",
  Geom,
  required_aes = c("x", "xend", "y", "label"),
  setup_params = function(data, params) {
    params$text_size = params$text_size  %||% 12
    params$line_size = params$line_size  %||% 1
    params$linetype = params$linetype  %||% "solid"

    return(params)
  },
  draw_panel = function(data, panel_params, coord, text_size, line_size, linetype) {
    coords <- coord$transform(data, panel_params)
    # https://www.rdocumentation.org/packages/grid/versions/3.6.2/topics/gpar
    # https://www.rdocumentation.org/packages/grid/versions/3.6.2/topics/unit
    line_height = unit(text_size * grid::get.gpar("cex")[[1]], units = "pt")
    # Increment each label by character height
    coords$y = max(coords$y)
    coords$y = unit(coords$y, "npc") + 0:(nrow(coords)-1) * line_height

    # vjust according to the text
    vjust = ifelse(coords$adj.p.value < 0.05, 0.15, -0.2)

    grid::gList(
      grid::segmentsGrob(
        x0 = coords$x, x1 = coords$xend,
        y0 = coords$y, y1 = coords$y,
        gp = grid::gpar(
          lty = linetype,
          lwd = unit(line_size, "pt")
        )
      ),
      grid::textGrob(
        label = coords$label,
        y = coords$y,
        x = (coords$xend + coords$x) / 2,
        vjust = vjust,
        gp = grid::gpar(
          fontsize = unit(text_size, "pt")
        )
      )
    )

  }
)

