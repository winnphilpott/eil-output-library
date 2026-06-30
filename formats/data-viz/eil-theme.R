# =====================================================================
#  eil-theme.R  ·  House ggplot2 theme + palette for EIL data viz
#  Conventions: style-guides/data-viz/README.md
#  Distilled from papers/2026-epa-compliance-workshops/code/make-fig2.R
#
#  Usage:
#    source("formats/data-viz/eil-theme.R")   # adjust path as needed
#    p <- ggplot(...) + ... + theme_eil()
#    eil_save(p, "figures/fig1.png")
#
#  The palette is locked to the print design system
#  (formats/research-highlight/_style.tex) so figures sit seamlessly
#  inside highlights, press releases, and the newsletter. Edit colours
#  there and here together.
# =====================================================================

# ---- Palette --------------------------------------------------------
# Canonical tokens shared with _style.tex, plus two chart-only tokens
# (band, axis) derived for plotting.
eil_pal <- list(
  ink       = "#1D2620",  # data marks (points, lines), y-axis value labels
  body      = "#33352C",  # long-form text if a chart carries any
  accentred = "#641111",  # the one emphasis colour: highlight, reference line
  muted     = "#50534A",  # annotations, axis text, source line
  cite      = "#6E6D61",  # secondary annotation
  faint     = "#9A978A",  # footnotes / least-prominent text
  warmrule  = "#D8D2C2",  # thin warm-grey dividers (print rules)
  paper     = "#FAF8F1",  # warm page background (use to blend into a page)
  # --- chart-only derived tokens ---
  band      = "#F3E4E2",  # pale red tint for a highlighted region
  axis      = "#C4BDAD",  # axis lines/ticks and soft uncertainty ribbons
  canvas    = "#FFFFFF"   # default figure background (white)
)

# ---- Theme ----------------------------------------------------------
# Minimal, low-chrome theme calibrated for a figure exported at roughly
# 5.4 x 3.1 in and placed at ~0.8 of a print column (hence the small
# base_size). Bump base_size for standalone / web figures.
#
# base_family: leave "" for the system sans default. To match the house
# face, install Source Sans 3 and register it (e.g. systemfonts or
# showtext), then pass base_family = "Source Sans 3".
theme_eil <- function(base_size = 7, base_family = "") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background  = ggplot2::element_rect(fill = eil_pal$canvas, color = NA),
      panel.background = ggplot2::element_rect(fill = eil_pal$canvas, color = NA),
      panel.grid       = ggplot2::element_blank(),          # no gridlines
      axis.line.x      = ggplot2::element_line(color = eil_pal$axis, linewidth = 0.4),
      axis.ticks.x     = ggplot2::element_line(color = eil_pal$axis, linewidth = 0.3),
      axis.ticks.y     = ggplot2::element_blank(),          # no y ticks
      axis.text.x      = ggplot2::element_text(color = eil_pal$muted, size = base_size),
      axis.text.y      = ggplot2::element_text(color = eil_pal$ink,
                                               size = base_size * 0.94, lineheight = 0.9),
      axis.title.x     = ggplot2::element_text(color = eil_pal$muted,
                                               size = base_size * 0.86,
                                               margin = ggplot2::margin(t = 4)),
      axis.title.y     = ggplot2::element_blank(),
      plot.title       = ggplot2::element_text(color = eil_pal$ink, face = "bold"),
      plot.caption     = ggplot2::element_text(color = eil_pal$muted, hjust = 0)
    )
}

# ---- Export ---------------------------------------------------------
# House defaults for a column-width figure. Keep dpi >= 200 for print.
eil_save <- function(plot, path, width = 5.4, height = 3.1, dpi = 220,
                     bg = eil_pal$canvas) {
  dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
  ggplot2::ggsave(path, plot, width = width, height = height, dpi = dpi, bg = bg)
  message("wrote ", path)
}
