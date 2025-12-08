# Plot brackets

Base geom to plot brackets for pairwise comparisons. Takes location of
the brackets and plot the segment. Add the label. The y position of each
bracket is automatically increased to dodge each other.

## Usage

``` r
geom_bracket(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  inherit.aes = TRUE,
  text_size = 12,
  line_size = 1,
  linetype = "solid",
  ...
)

GeomBracket
```

## Format

An object of class `GeomBracket` (inherits from `Geom`, `ggproto`, `gg`)
of length 4.

## Arguments

- text_size:

  Fontsize, in pt

- line_size:

  Size of the bracket line

- linetype:

  Format of the line.
