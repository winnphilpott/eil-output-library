# =====================================================================
#  social-cards.R  ·  Shared scaffolding for EIL social media cards
#  Conventions: style-guides/social/README.md  (esp. §6 on-image)
#  Builds on:   formats/data-viz/eil-theme.R  (palette, theme, eil_save)
#
#  A social card is a figure RE-RENDERED for social — larger type, a
#  headline baked in, the logo lock-up added, and sized to a platform
#  aspect ratio. It is never a copied export of a print figure
#  (social README §2). This file provides the reusable pieces; the
#  two *-template.R files next to it are runnable starting points.
#
#  Sourced by the templates; you normally don't run this file directly.
#  It sources the data-viz theme, so run templates from the REPO ROOT:
#    Rscript formats/social/stat-card-template.R
# =====================================================================

source("formats/data-viz/eil-theme.R")   # eil_pal, theme_eil(), eil_save()

# ---- Platform dimensions --------------------------------------------
# Width/height in inches at a dpi that lands on standard social pixel
# sizes. Square is the workhorse (safe on X and LinkedIn); reach for the
# others only when a platform-specific crop is worth it.
#   square    1080 x 1080   (X + LinkedIn)   <- default
#   portrait  1080 x 1350   (LinkedIn 4:5)
#   landscape 1200 x 675    (X 16:9)
SOCIAL_DIMS <- list(
  square    = list(width = 6,     height = 6,    dpi = 180),
  portrait  = list(width = 6,     height = 7.5,  dpi = 180),
  landscape = list(width = 6.667, height = 3.75, dpi = 180)
)

# ---- Save a card -----------------------------------------------------
# Thin wrapper over eil_save() that spreads a SOCIAL_DIMS entry and
# defaults logo = TRUE (a card travels alone, so it carries the mark).
# Pass logo = "white" on a dark/accent background; bg sets the canvas.
save_card <- function(plot, path, dims = SOCIAL_DIMS$square,
                      source, logo = TRUE, bg = eil_pal$canvas) {
  eil_save(plot, path, width = dims$width, height = dims$height,
           dpi = dims$dpi, bg = bg, source = source, logo = logo)
}

# ---- Text wrapping ---------------------------------------------------
# ggplot does NOT wrap text -- a long headline runs off the card. Wrap it
# to a character width before you pass it in. Tune `width` per headline:
# lower for bigger type. Base R only (no stringr dependency).
wrap_text <- function(x, width = 24) {
  vapply(x, function(s) paste(strwrap(s, width = width), collapse = "\n"),
         character(1), USE.NAMES = FALSE)
}

# ---- Theme: chart cards ---------------------------------------------
# For cards that hold a CHART. Extends the house theme with social-scale
# type, a bold headline (plot.title), and generous card margins. Bump
# base_size for a bigger canvas; the title/subtitle/caption scale with it.
theme_eil_social <- function(base_size = 19, base_family = "") {
  theme_eil(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # align title + source to the whole card, not the inset plot panel,
      # so the headline starts at the left edge and clears the logo
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      plot.title    = ggplot2::element_text(color = eil_pal$ink, face = "bold",
                        size = base_size * 1.30, lineheight = 1.05, hjust = 0,
                        margin = ggplot2::margin(b = base_size * 0.7)),
      plot.subtitle = ggplot2::element_text(color = eil_pal$muted,
                        size = base_size * 0.85, lineheight = 1.1,
                        margin = ggplot2::margin(b = base_size)),
      plot.caption  = ggplot2::element_text(color = eil_pal$muted, hjust = 0,
                        size = base_size * 0.60,
                        margin = ggplot2::margin(t = base_size * 0.9)),
      axis.text.x   = ggplot2::element_text(size = base_size * 0.80),
      axis.text.y   = ggplot2::element_text(size = base_size * 0.80),
      axis.title.x  = ggplot2::element_text(size = base_size * 0.72),
      plot.margin   = ggplot2::margin(base_size * 1.4, base_size * 1.4,
                                      base_size * 1.1, base_size * 1.4)
    )
}

# ---- Theme: blank cards ---------------------------------------------
# For text-only cards (a stat card). A blank canvas with just the source
# caption styled; the source line and logo are added by save_card().
theme_eil_card <- function(bg = eil_pal$canvas, base_size = 19) {
  ggplot2::theme_void(base_size = base_size) +
    ggplot2::theme(
      plot.caption.position = "plot",
      plot.background  = ggplot2::element_rect(fill = bg, color = NA),
      panel.background = ggplot2::element_rect(fill = bg, color = NA),
      plot.caption     = ggplot2::element_text(color = eil_pal$muted, hjust = 0,
                          size = base_size * 0.60,
                          margin = ggplot2::margin(t = base_size * 0.6)),
      plot.margin      = ggplot2::margin(base_size * 1.6, base_size * 1.6,
                                         base_size * 1.2, base_size * 1.6)
    )
}

# ---- Builder: stat card ---------------------------------------------
# A single hero number + headline (+ optional sub-line), left-aligned on
# a 0..1 canvas. Text sizes are in ggplot geom units (~pt/2.85) so they
# read big on a 1080px card; tune the *_size args to taste. The top-right
# corner is left clear for the logo lock-up that save_card() adds.
# The three text blocks sit at fixed vertical anchors (stat_y / head_y /
# sub_y) -- there is no auto-layout, so if you lengthen the headline you
# may need to nudge these down or shrink *_size. Keep the headline short
# (a stat card is a hero number + a few words); put detail in `sub`.
eil_stat_card <- function(stat, headline, sub = NULL,
                          accent = eil_pal$accentred,
                          stat_size = 40, head_size = 12, sub_size = 8.5,
                          x = 0.03, stat_y = 0.76, head_y = 0.46, sub_y = 0.19) {
  p <- ggplot2::ggplot() +
    ggplot2::annotate("text", x = x, y = stat_y, label = stat,
                      hjust = 0, vjust = 1, color = accent,
                      fontface = "bold", size = stat_size, lineheight = 0.9) +
    ggplot2::annotate("text", x = x, y = head_y, label = headline,
                      hjust = 0, vjust = 1, color = eil_pal$ink,
                      fontface = "bold", size = head_size, lineheight = 1.02) +
    ggplot2::scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
    ggplot2::scale_y_continuous(limits = c(0, 1), expand = c(0, 0))
  if (!is.null(sub)) {
    p <- p + ggplot2::annotate("text", x = x, y = sub_y, label = sub,
                               hjust = 0, vjust = 1, color = eil_pal$muted,
                               size = sub_size, lineheight = 1.08)
  }
  p
}
