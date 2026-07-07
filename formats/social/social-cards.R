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

# ---- Shared layout ---------------------------------------------------
# One gutter for everything: the card themes inset title + source by this
# much, and save_card() insets the logo by the same, so the logo lines up
# with the headline (left) and the source line. Change it in one place.
CARD_BASE      <- 19                                  # base_size for card themes
CARD_GUTTER_F  <- 1.5                                 # gutter as a multiple of base_size (pt)
CARD_GUTTER_IN <- (CARD_BASE * CARD_GUTTER_F) / 72.27 # same gutter in inches (for the logo inset)

# ---- Save a card -----------------------------------------------------
# Thin wrapper over eil_save() that spreads a SOCIAL_DIMS entry and
# defaults logo = TRUE (a card travels alone, so it carries the mark).
# logo_frac / logo_margin place the lock-up top-right at the mockup's
# size (~156px wide) and inset (~74px). Pass logo = "white" on a
# dark/accent background; bg sets the canvas.
#
# `source` defaults to NULL because the text-card builders draw their own
# source line (so it lands in the mockup's footer). For a chart card, pass
# source= here to render it as the theme caption instead.
save_card <- function(plot, path, dims = SOCIAL_DIMS$landscape,
                      source = NULL, logo = TRUE, bg = eil_pal$canvas,
                      logo_frac = 0.13, logo_margin = 0.41) {
  eil_save(plot, path, width = dims$width, height = dims$height,
           dpi = dims$dpi, bg = bg, source = source, logo = logo,
           logo_frac = logo_frac, logo_margin = logo_margin)
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
theme_eil_social <- function(base_size = CARD_BASE, base_family = "",
                             title_color = eil_pal$ink,
                             caption_color = eil_pal$muted) {
  theme_eil(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # align title + source to the whole card, not the inset plot panel,
      # so the headline starts at the left edge and clears the logo
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      plot.title    = ggplot2::element_text(color = title_color, face = "bold",
                        size = base_size * 1.30, lineheight = 1.05, hjust = 0,
                        margin = ggplot2::margin(b = base_size * 0.7)),
      plot.subtitle = ggplot2::element_text(color = eil_pal$muted,
                        size = base_size * 0.85, lineheight = 1.1,
                        margin = ggplot2::margin(b = base_size)),
      # source line: a quiet footnote, kept smaller than the logo. On a
      # dark/accent card, pass a light caption_color so it stays legible.
      plot.caption  = ggplot2::element_text(color = caption_color, hjust = 0,
                        size = base_size * 0.46,
                        margin = ggplot2::margin(t = base_size * 0.9)),
      axis.text.x   = ggplot2::element_text(size = base_size * 0.80),
      axis.text.y   = ggplot2::element_text(size = base_size * 0.80),
      axis.title.x  = ggplot2::element_text(size = base_size * 0.72),
      plot.margin   = ggplot2::margin(base_size * CARD_GUTTER_F, base_size * CARD_GUTTER_F,
                                      base_size * 1.1, base_size * CARD_GUTTER_F)
    )
}

# ---- Theme: blank cards ---------------------------------------------
# For text-only cards (a stat card). A blank canvas with just the source
# caption styled; the source line and logo are added by save_card().
theme_eil_card <- function(bg = eil_pal$canvas, base_size = CARD_BASE,
                           caption_color = eil_pal$muted) {
  ggplot2::theme_void(base_size = base_size) +
    ggplot2::theme(
      plot.caption.position = "plot",
      plot.background  = ggplot2::element_rect(fill = bg, color = NA),
      panel.background = ggplot2::element_rect(fill = bg, color = NA),
      # source line: a quiet footnote, kept smaller than the logo. On a
      # dark/accent card, pass a light caption_color so it stays legible.
      plot.caption     = ggplot2::element_text(color = caption_color, hjust = 0,
                          size = base_size * 0.46,
                          margin = ggplot2::margin(t = base_size * 0.6)),
      # zero margin: the text-card builders position everything in absolute
      # canvas coords (incl. their own padding), so the panel must fill the
      # whole 1200x675 image.
      plot.margin      = ggplot2::margin(0, 0, 0, 0)
    )
}

# ---- Card geometry (landscape 1200x675) -----------------------------
# The text cards below are laid out on a 0..1 canvas whose vertical
# anchors are transcribed from the mockup's flexbox (space-between of a
# top row, a centred content cluster, and a pinned footer). Anchors are
# CENTRE points (vjust = 0.5) expressed as npc = 1 - y_px/675, and sizes
# are geom units ≈ px * 0.141 at these dims -- so they reproduce the
# mockup's proportions rather than an eyeballed guess. Feed a card into
# theme_eil_card() and save_card() (which adds the logo top-right).
#
# All the *_y / *_size / x args are exposed so a longer headline or a
# square crop can be re-tuned; the defaults match the 1200x675 mockup.

# ---- Builder: stat card ---------------------------------------------
# Eyebrow kicker (top) · hero number + headline + optional sub (centred
# cluster) · rule + source (footer). The top-right corner stays clear
# for the logo lock-up that save_card() adds. Colour args default to the
# light-card palette; override for a dark/accent card.
eil_stat_card <- function(stat, headline, sub = NULL, eyebrow = NULL,
                          source = NULL,
                          accent = eil_pal$accentred,
                          ink = eil_pal$ink, muted = eil_pal$muted,
                          eyebrow_color = eil_pal$muted,
                          rule = TRUE, rule_color = eil_pal$warmrule,
                          source_color = eil_pal$cite,
                          stat_size = 33, head_size = 8.4, sub_size = 4.5,
                          eyebrow_size = 3.0, source_size = 3.1,
                          x = 0.063,
                          eyebrow_y = 0.864, stat_y = 0.631, head_y = 0.421,
                          sub_y = 0.287, rule_y = 0.175, source_y = 0.123,
                          rule_xend = 0.937) {
  p <- ggplot2::ggplot() +
    ggplot2::annotate("text", x = x, y = stat_y, label = stat,
                      hjust = 0, vjust = 0.5, color = accent,
                      fontface = "bold", size = stat_size, lineheight = 0.85) +
    ggplot2::annotate("text", x = x, y = head_y, label = headline,
                      hjust = 0, vjust = 0.5, color = ink,
                      fontface = "bold", size = head_size, lineheight = 1.02) +
    ggplot2::scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
    ggplot2::scale_y_continuous(limits = c(0, 1), expand = c(0, 0)) +
    ggplot2::coord_cartesian(clip = "off")
  if (!is.null(eyebrow)) {
    p <- p + ggplot2::annotate("text", x = x, y = eyebrow_y,
                               label = toupper(eyebrow), hjust = 0, vjust = 0.5,
                               color = eyebrow_color, fontface = "bold",
                               size = eyebrow_size)
  }
  if (!is.null(sub)) {
    p <- p + ggplot2::annotate("text", x = x, y = sub_y, label = sub,
                               hjust = 0, vjust = 0.5, color = muted,
                               size = sub_size, lineheight = 1.12)
  }
  if (isTRUE(rule)) {
    p <- p + ggplot2::annotate("segment", x = x, xend = rule_xend,
                               y = rule_y, yend = rule_y,
                               color = rule_color, linewidth = 0.4)
  }
  if (!is.null(source)) {
    p <- p + ggplot2::annotate("text", x = x, y = source_y, label = source,
                               hjust = 0, vjust = 0.5, color = source_color,
                               size = source_size)
  }
  p
}

# ---- Builder: quote / finding card ----------------------------------
# A single pulled sentence over a dark/accent background — archetype
# "c" in the social style guide (§3, §7). Use ONLY with a real, confirmed,
# attributable line (never a placeholder). An oversized quote mark sits
# above the sentence, the attribution beneath, and the eyebrow / footer
# match the stat card's geometry.
#
# Colours default to the light-on-maroon reading of the house palette:
# quote in `paper`, mark/eyebrow/attribution in a pale-red `band`. The
# whole quote is one colour — ggplot can't emphasise a sub-phrase without
# ggtext; keep the emphasis in the words, not the ink.
eil_quote_card <- function(quote, attribution, eyebrow = NULL, source = NULL,
                           quote_color = eil_pal$paper,
                           mark_color = eil_pal$band,
                           attribution_color = eil_pal$band,
                           eyebrow_color = eil_pal$band,
                           rule = TRUE,
                           rule_color = grDevices::adjustcolor(eil_pal$paper, 0.18),
                           source_color = grDevices::adjustcolor(eil_pal$paper, 0.7),
                           quote_size = 8.1, mark_size = 21, attribution_size = 3.66,
                           eyebrow_size = 3.0, source_size = 3.1,
                           x = 0.063, mark_x = 0.058,
                           eyebrow_y = 0.864, mark_y = 0.73, quote_y = 0.468,
                           attribution_y = 0.255, rule_y = 0.175, source_y = 0.123,
                           rule_xend = 0.937) {
  p <- ggplot2::ggplot() +
    # oversized opening quote mark, set just above the sentence
    ggplot2::annotate("text", x = mark_x, y = mark_y, label = "“",
                      hjust = 0, vjust = 0.5, color = mark_color,
                      fontface = "bold", size = mark_size) +
    ggplot2::annotate("text", x = x, y = quote_y, label = quote,
                      hjust = 0, vjust = 0.5, color = quote_color,
                      fontface = "bold", size = quote_size, lineheight = 1.08) +
    ggplot2::annotate("text", x = x, y = attribution_y, label = attribution,
                      hjust = 0, vjust = 0.5, color = attribution_color,
                      size = attribution_size, lineheight = 1.1) +
    ggplot2::scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
    ggplot2::scale_y_continuous(limits = c(0, 1), expand = c(0, 0)) +
    ggplot2::coord_cartesian(clip = "off")
  if (!is.null(eyebrow)) {
    p <- p + ggplot2::annotate("text", x = x, y = eyebrow_y,
                               label = toupper(eyebrow), hjust = 0, vjust = 0.5,
                               color = eyebrow_color, fontface = "bold",
                               size = eyebrow_size)
  }
  if (isTRUE(rule)) {
    p <- p + ggplot2::annotate("segment", x = x, xend = rule_xend,
                               y = rule_y, yend = rule_y,
                               color = rule_color, linewidth = 0.4)
  }
  if (!is.null(source)) {
    p <- p + ggplot2::annotate("text", x = x, y = source_y, label = source,
                               hjust = 0, vjust = 0.5, color = source_color,
                               size = source_size)
  }
  p
}
