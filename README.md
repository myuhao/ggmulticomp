
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggmulticomp

<!-- badges: start -->

<!-- badges: end -->

ggmulticomp provides several ggplot2 stat layer for multiple comparison.

## Installation

You can install ggmulticomp like so:

``` r
remote::install_github("myuhao/ggmulticomp")
```

## Example

``` r
library(ggplot2)
library(ggmulticomp)

iris |>
  tidyr::pivot_longer(-Species) |>
  dplyr::mutate(
    y = value, x = Species
  ) |>
  ggplot(aes(x = Species, y = value)) +
  geom_point() +
  stat_summary(geom = GeomCol) +
  stat_dunnett(color = "red") +
  facet_grid(rows = vars(name), cols = vars("a"), scale = "free_y")
#> No summary function supplied, defaulting to `mean_se()`
#> # A tibble: 2 × 8
#>   contrast group ref.group  diff lwr.ci upr.ci adj.p.value label    
#>   <chr>    <int> <chr>     <dbl>  <dbl>  <dbl>       <dbl> <noquote>
#> 1 2-1          2 1          2.80   2.61   2.99    2.22e-16 ****     
#> 2 3-1          3 1          4.09   3.90   4.28    3.33e-16 ****     
#> # A tibble: 2 × 8
#>   contrast group ref.group  diff lwr.ci upr.ci adj.p.value label    
#>   <chr>    <int> <chr>     <dbl>  <dbl>  <dbl>       <dbl> <noquote>
#> 1 2-1          2 1          1.08  0.989   1.17   -2.22e-16 ****     
#> 2 3-1          3 1          1.78  1.69    1.87    2.22e-16 ****     
#> # A tibble: 2 × 8
#>   contrast group ref.group  diff lwr.ci upr.ci adj.p.value label    
#>   <chr>    <int> <chr>     <dbl>  <dbl>  <dbl>       <dbl> <noquote>
#> 1 2-1          2 1          0.93  0.700   1.16    1.78e-15 ****     
#> 2 3-1          3 1          1.58  1.35    1.81    4.44e-16 ****     
#> # A tibble: 2 × 8
#>   contrast group ref.group   diff lwr.ci upr.ci adj.p.value label    
#>   <chr>    <int> <chr>      <dbl>  <dbl>  <dbl>       <dbl> <noquote>
#> 1 2-1          2 1         -0.658 -0.810 -0.506    2.22e-16 ****     
#> 2 3-1          3 1         -0.454 -0.606 -0.302    9.07e-10 ****
#> Warning: Removed 4 rows containing missing values or values outside the scale range
#> (`geom_text()`).
```

<img src="man/figures/README-example-1.png" width="100%" />
