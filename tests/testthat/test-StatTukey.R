library(ggplot2)

base_plot = iris |>
  tidyr::pivot_longer(-Species, values_to = "y") |>
  group_by(Species) |>
  ggplot(aes(x = stringr::str_c(Species, name), y = y)) +
  stat_summary(geom = GeomCol) +
  geom_point() +
  scale_y_continuous(expand = expansion(mult = c(0.1, 2)))



test_that(
  "Test stat_tukey()", {
    vdiffr::expect_doppelganger(
      "Base stat_tukey() works",
      base_plot + stat_tukey()
    )

    vdiffr::expect_doppelganger(
      "stat_tukey() change linetype",
      base_plot + stat_tukey(linetype = 2)
    )

    vdiffr::expect_doppelganger(
      "stat_tukey() change text_size",
      base_plot + stat_tukey(text_size = 5)
    )

    vdiffr::expect_doppelganger(
      "stat_tukey() will show ns",
      base_plot + stat_tukey(show.ns = TRUE)
    )

    vdiffr::expect_doppelganger(
      "stat_tukey() can handle data transformation",
      base_plot + stat_tukey(trans_value = function(x){1}, show.ns = TRUE)
    )

    vdiffr::expect_doppelganger(
      "stat_tukey() can label numeric",
      base_plot + stat_tukey(
        p.format = scales::label_pvalue(),
        show.ns = TRUE
      )
    )

    vdiffr::expect_doppelganger(
      "stat_tukey() can show only selected comparisons",
      base_plot + stat_tukey(
        comparisons = c(1, 2)
      )
    )
  }
)
