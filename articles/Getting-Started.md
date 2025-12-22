# Getting Started

``` r
library(ggplot2)
library(ggmulticomp)


df = iris |>
  tidyr::pivot_longer(-Species )

base_plot = df |>
  ggplot(aes(x = Species, y = value)) +
  geom_boxplot() +
  facet_wrap(vars(name), scales = "free")

base_plot
```

![](Getting-Started_files/figure-html/setup-1.png)

## Tukey Test

Simply add
[`stat_tukey()`](http://www.myuhao.com/ggmulticomp/reference/Tukey.md)
layer to your ggplot object. It will run Tukey test and show statistical
significance for you. You will have to play around with
[`ggplot2::scale_y_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
so the significance marker is present.

``` r
base_plot +
  stat_tukey() +
  scale_y_continuous(expand = expansion(mult = c(0.1, 0.5)))
```

![](Getting-Started_files/figure-html/unnamed-chunk-2-1.png)

You can use the `p.format` argument to change how p-values are
presented. Two common options are
[`scales::label_pvalue()`](https://scales.r-lib.org/reference/label_pvalue.html)
or
[`scales::label_number_auto()`](https://scales.r-lib.org/reference/label_number_auto.html).

``` r
base_plot +
  stat_tukey(p.format = scales::label_pvalue()) +
  scale_y_continuous(expand = expansion(mult = c(0.1, 0.5)))
```

![](Getting-Started_files/figure-html/unnamed-chunk-3-1.png)

You can also implement your own function to format it. This function
should accept double as input, and return a character to be displayed.

``` r

my_format = function(x) {
  dplyr::case_when(
    x < 0.001 ~ "very significant",
    x < 0.05 ~ "significant",
    TRUE ~  "not significant"
  )
}


base_plot +
  stat_tukey(p.format = my_format) +
  scale_y_continuous(expand = expansion(mult = c(0.1, 0.5)))
```

![](Getting-Started_files/figure-html/unnamed-chunk-4-1.png)

By default, `stat_tukey` perform statistical tests on the values that
are being presented in ggplot. That is, if you add `scale_y_log2()` to
your ggplot, the statistic results will be performed on the
log2-transformed y-values. If this is not a desired behavior, the
`trans_value` argument allow you to apply a transformation function to
the y-values before running the statistical test.

``` r

base_plot +
  stat_tukey(p.format = scales::label_scientific()) + 
  scale_y_continuous(expand = expansion(mult = c(0.1, 0.5))) +
  labs(title = "No y transformation")
```

![](Getting-Started_files/figure-html/unnamed-chunk-5-1.png)

``` r

base_plot +
  stat_tukey(trans_value = log2, p.format = scales::label_scientific()) + 
  scale_y_continuous(expand = expansion(mult = c(0.1, 0.5)))  +
  labs(title = "Y values transformed before stat test")
```

![](Getting-Started_files/figure-html/unnamed-chunk-5-2.png)

You can fine tune some of the aesthetic parameters in case they do not
look good by default.

``` r
base_plot +
  stat_tukey(text_size = 5, line_size = 0.5, linetype = 2) + 
  scale_y_continuous(expand = expansion(mult = c(0.1, 0.5)))
```

![](Getting-Started_files/figure-html/unnamed-chunk-6-1.png)

## Dunnett

Dunnett test works similar to Tukey test. The parameter should work
similarly. One key distinction is that
[`stat_dunnett()`](http://www.myuhao.com/ggmulticomp/reference/Dunnett.md)
shows the p-values at the top of the group

``` r
base_plot +
  stat_dunnett()
```

![](Getting-Started_files/figure-html/unnamed-chunk-7-1.png)

A different style of alignment can be used.

``` r
base_plot +
  stat_dunnett(p.y_align = 2)
```

![](Getting-Started_files/figure-html/unnamed-chunk-8-1.png)

If you want explicitly show which comparisons are made, use
`GeomBracket` as the geom.

``` r

base_plot +
  stat_dunnett(geom = "bracket") + 
  scale_y_continuous(expand = expansion(mult = c(0.1, 0.5)))
```

![](Getting-Started_files/figure-html/unnamed-chunk-9-1.png)
