library(ggplot2)

base_plot = iris %>%
  tidyr::pivot_longer(-Species) %>%
  dplyr::mutate(
    y = value, x = Species
  ) %>%
  ggplot(aes(x = Species, y = value)) +
  geom_point() +
  stat_summary(geom = GeomCol) +
  facet_grid(rows = vars(name), cols = vars("a"), scale = "free_y")

test_that(
  "Test stat_dunnett", {
    vdiffr::expect_doppelganger(
      "Dunnett Test should work",
      base_plot + stat_dunnett(color = "red", offset = 0)
    )

    vdiffr::expect_doppelganger(
      "Trans Function Should Work",
      base_plot +
        stat_dunnett(color = "red", offset = 0, trans_value = log2)
    )

    vdiffr::expect_doppelganger(
      "Format p.value works",
      base_plot + stat_dunnett(p.format = scales::label_pvalue())
    )

    vdiffr::expect_doppelganger(
      "p-value style 2 works",
      base_plot + stat_dunnett(p.y_align = 2)
    )

    vdiffr::expect_doppelganger(
      "Bracket can work with Dunnett test",
      base_plot + stat_dunnett(geom = "bracket") + scale_y_continuous(expand = expansion(c(0.1, 1)))
    )


    vdiffr::expect_doppelganger(
      "Modification to bracket work",
      base_plot +
        stat_dunnett(geom = "bracket", text_size = 5, line_size = 0.5, linetype = 2) +
        scale_y_continuous(expand = expansion(c(0.1, 1)))
    )
  }

)
