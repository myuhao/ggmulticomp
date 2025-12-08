library(ggplot2)

base_plot = iris |>
  tidyr::pivot_longer(-Species, values_to = "y") |>
  group_by(Species) |>
  ggplot(aes(x = stringr::str_c(Species, name), y = y)) +
  stat_summary(geom = GeomCol) +
  geom_point() +
  scale_y_continuous(expand = expansion(mult = c(0.1, 2)))



test_that(
  "Test GeomTukey", {
    vdiffr::expect_doppelganger(
      "Base geom_bracket works",
      base_plot + geom_tukey()
    )

    vdiffr::expect_doppelganger(
      "geom_tukey change linetype",
      base_plot + geom_tukey(linetype = 2)
    )

    vdiffr::expect_doppelganger(
      "geom_tukey change text_size",
      base_plot + geom_tukey(text_size = 5)
    )

    vdiffr::expect_doppelganger(
      "geom_tukey will show ns",
      base_plot + geom_tukey(show.ns = TRUE)
    )

    vdiffr::expect_doppelganger(
      "geom_tukey can handle data transformation",
      base_plot + geom_tukey(trans_value = function(x){1}, show.ns = TRUE)
    )
  }
)

