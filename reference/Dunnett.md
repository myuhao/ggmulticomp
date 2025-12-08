# Dunnett Multiple Test

Perform Dunnett's Multiple Test Against a Reference group. Display the
adjusted p-values on the figure.

## Usage

``` r
stat_dunnett(
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
)

StatDunnett
```

## Format

An object of class `StatDunnett` (inherits from `Stat`, `ggproto`, `gg`)
of length 4.

## Arguments

- ref.group:

  The reference group to be used. Default to the first level of x-axis
  (sort())

- offset:

  How much the label will offset from the data points. Default 0.1

- trans_value:

  A function that accept a vector as input and output a transformed
  vector. To be applied to y values before statistics test.

- show.ns:

  Should non-significant results be shown

## See also

DescTools::DunnettTest()
