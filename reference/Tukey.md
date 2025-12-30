# Tukey HSD Test

Perform Tukey HSD Test. Display the adjusted p-values on the figure.

## Usage

``` r
stat_tukey(
  mapping = NULL,
  data = NULL,
  geom = GeomBracket,
  position = "identity",
  inherit.aes = TRUE,
  show.ns = TRUE,
  trans_value = NULL,
  p.format = NULL,
  ...
)

StatTukey
```

## Format

An object of class `StatTukey` (inherits from `Stat`, `ggproto`, `gg`)
of length 4.

## Arguments

- show.ns:

  Should non-significant results be shown

- trans_value:

  A function that accept a vector as input and output a transformed
  vector. To be applied to y values before statistics test.

- p.format:

  The format of the pvalue to display. This should be a function that
  accept dbl as input, and return a chr to be displayed. Default to show
  stars

- text_size:

  Size of the significance symbols, default 12pt

- line_size:

  Size of the lines spanning each group, default 1pt

- linetype:

  Type of the line spanning each group

- comparisons:

  A list of selected comparisons to plot
