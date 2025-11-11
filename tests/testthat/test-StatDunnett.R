
test_that(
  "Test stat_dunnett", {
    plot = iris %>%
      tidyr::pivot_longer(-Species) %>%
      dplyr::mutate(
        y = value, x = Species
      ) %>%
      ggplot(aes(x = Species, y = value)) +
      geom_point() +
      stat_summary(geom = GeomCol) +
      stat_dunnett(color = "red", offset = 0) +
      facet_grid(rows = vars(name), cols = vars("a"), scale = "free_y")
    vdiffr::expect_doppelganger(
      "Dunnett Test should work",
      plot
    )

    vdiffr::expect_doppelganger(
      "Trans Function Should Work",
      iris %>%
        tidyr::pivot_longer(-Species) %>%
        dplyr::mutate(
          y = value, x = Species
        ) %>%
        ggplot(aes(x = Species, y = value)) +
        geom_point() +
        stat_summary(geom = GeomCol) +
        stat_dunnett(color = "red", offset = 0, trans_value = log2) +
        facet_grid(rows = vars(name), cols = vars("a"), scale = "free_y")
    )
  }

)
