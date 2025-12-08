library(ggplot2)

base_plot = iris |>
  tidyr::pivot_longer(-Species, values_to = "y") |>
  group_by(Species) |>
  ggplot(aes(x = stringr::str_c(Species, name), y = y)) +
  stat_summary(geom = GeomCol) +
  geom_point() +
  scale_y_continuous(expand = expansion(mult = c(0.1, 2)))

test_that(
  "Test StatTukey", {
    vdiffr::expect_doppelganger(
      "Base stat_tukey works",
      base_plot + stat_tukey()
    )

    vdiffr::expect_doppelganger(
      "stat_tukey can show ns",
      base_plot + stat_tukey(show.ns = TRUE)
    )

    vdiffr::expect_doppelganger(
      "Transformation works",
      base_plot + stat_tukey(trans_value = function(x) {1})
    )
  }
)
