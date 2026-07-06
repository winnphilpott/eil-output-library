# =====================================================================
#  eil-theme.R  ·  House ggplot2 theme + palette for EIL data viz
#  Conventions: style-guides/data-viz/README.md
#  Distilled from papers/2026-epa-compliance-workshops/code/make-fig2.R
#
#  Usage:
#    source("formats/data-viz/eil-theme.R")   # adjust path as needed
#    p <- ggplot(...) + ... + theme_eil()
#    # embedded figure: source line always, no logo
#    eil_save(p, "figures/fig1.png", source = "Environmental Inequality Lab · Short Title, 2026")
#    # standalone / social card: add the logo lock-up
#    eil_save(p, "figures/fig1-card.png", width = 6, height = 6,
#             source = "Environmental Inequality Lab · Short Title, 2026", logo = TRUE)
#
#  Branding convention (style-guides/data-viz/README.md §5):
#    - source line ALWAYS (pass `source=`); it renders as the muted caption.
#    - logo lock-up only on figures that travel alone (`logo = TRUE`, or
#      `logo = "white"` on a dark/accent card). Omit on embedded figures.
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
      # source line renders here (via eil_save(source=)): muted, flush-left, small
      plot.caption     = ggplot2::element_text(color = eil_pal$muted, hjust = 0,
                                               size = base_size * 0.82,
                                               margin = ggplot2::margin(t = 6))
    )
}

# ---- Branding: source line + logo lock-up ---------------------------
# Resolve formats/logos/ by walking up from the working directory, so a
# script run from a paper's data-viz/ folder or from the repo root both
# find it. Override with options(eil.logo_dir = "/path/to/logos").
.eil_find_logo_dir <- function() {
  opt <- getOption("eil.logo_dir")
  if (!is.null(opt)) return(opt)
  dir <- normalizePath(getwd(), mustWork = FALSE)
  repeat {
    cand <- file.path(dir, "formats", "logos")
    if (dir.exists(cand)) return(cand)
    parent <- dirname(dir)
    if (identical(parent, dir)) break        # reached filesystem root
    dir <- parent
  }
  NULL
}

# ---- Export ---------------------------------------------------------
# House defaults for a column-width figure. Keep dpi >= 200 for print.
#
# source: the attribution line (ALWAYS pass it) — rendered as the muted
#   caption, e.g. "Environmental Inequality Lab · Short Title, 2026".
# logo:  FALSE for embedded figures (the document's masthead brands the
#   page); TRUE to inset the maroon lock-up top-right on a standalone /
#   social card; "white" for the white lock-up on a dark/accent card.
#   Dependency-light: uses the tiny `png` package + base `grid` only.
eil_save <- function(plot, path, width = 5.4, height = 3.1, dpi = 220,
                     bg = eil_pal$canvas, source = NULL, logo = FALSE) {
  dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)

  if (!is.null(source)) plot <- plot + ggplot2::labs(caption = source)

  if (isFALSE(logo)) {
    ggplot2::ggsave(path, plot, width = width, height = height, dpi = dpi, bg = bg)
  } else {
    file <- if (identical(logo, "white")) "eil-logo-white.png" else "eil-logo-maroon.png"
    logo_dir <- .eil_find_logo_dir()
    if (is.null(logo_dir))
      stop("eil_save(logo=): could not find formats/logos/. ",
           "Set options(eil.logo_dir = \"/path/to/logos\").")
    img <- png::readPNG(file.path(logo_dir, file))
    # top-right corner of the whole canvas; width in inches keeps aspect ratio
    mark <- grid::rasterGrob(
      img,
      x = grid::unit(1, "npc") - grid::unit(0.05, "in"),
      y = grid::unit(1, "npc") - grid::unit(0.05, "in"),
      just = c("right", "top"),
      width = grid::unit(width * 0.16, "in")
    )
    grDevices::png(path, width = width, height = height, units = "in",
                   res = dpi, bg = bg)
    grid::grid.draw(ggplot2::ggplotGrob(plot))
    grid::grid.draw(mark)
    grDevices::dev.off()
  }
  message("wrote ", path)
}
