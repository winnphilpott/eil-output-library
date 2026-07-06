# =====================================================================
#  data-viz-template.R  ·  Starter for an EIL public-facing figure
#  Conventions: style-guides/data-viz/README.md
#  Theme/palette: formats/data-viz/eil-theme.R
#
#  This runnable template uses SYNTHETIC demo data so you can render it
#  and see the house style immediately. Replace the data-loading block
#  and the encodings with your own; keep the styling patterns.
#
#  Run:  Rscript formats/data-viz/data-viz-template.R
#        -> writes /tmp/eil-data-viz-template.png
#  Deps: dplyr, ggplot2  (+ the theme file below)
# =====================================================================

library(dplyr)
library(ggplot2)

# Source the house theme + palette. Adjust the relative path to wherever
# you run this from (here: repo root).
source("formats/data-viz/eil-theme.R")

OUT_PATH <- "/tmp/eil-data-viz-template.png"
CARD_PATH <- "/tmp/eil-data-viz-template-card.png"   # standalone/social variant

# Source line: pass it to eil_save on EVERY figure (see data-viz README §5).
SOURCE <- "Environmental Inequality Lab · Demo Figure, 2026"

# --- Data ------------------------------------------------------------
# DEMO ONLY: a before/after event series with an uncertainty band.
# Swap this whole block for your real data. Nothing here is a real
# finding — it exists solely to exercise the style.
set.seed(1)
demo <- tibble(
  event = -12:12,
  est   = c(rnorm(12, -0.1, 0.15), 0, rnorm(12, 0.0, 0.15)),
  se    = 0.28
) |>
  mutate(lo = est - 1.96 * se,
         hi = est + 1.96 * se)

# --- Plot ------------------------------------------------------------
# House-style recipe — keep these moves, change the content:
#   1. Frame one idea: shade the "after" region + a dashed event line.
#   2. Orient with caps labels (neutral = muted, emphasis = accentred).
#   3. Show uncertainty softly: ONE light ribbon, labelled once in words.
#   4. Plain-language axes: words, not coefficients/units where possible.
#   5. Restrained data ink: small dark points, thin light connecting line.
#   6. Let the document carry interpretation; keep the figure clean.
p <- ggplot(demo, aes(event, est)) +
  # 1. before/after framing
  annotate("rect", xmin = -0.5, xmax = 12.5, ymin = -Inf, ymax = Inf,
           fill = eil_pal$band, alpha = 0.35) +
  geom_vline(xintercept = -0.5, color = eil_pal$accentred,
             linetype = "dashed", linewidth = 0.4) +
  geom_hline(yintercept = 0, color = eil_pal$muted, linewidth = 0.45) +
  # 2. orientation labels
  annotate("text", x = -6.25, y = 0.92, label = "BEFORE",
           size = 2.4, color = eil_pal$muted, fontface = "bold") +
  annotate("text", x = 6.25, y = 0.92, label = "AFTER",
           size = 2.4, color = eil_pal$accentred, fontface = "bold") +
  # 3. soft uncertainty band, labelled once
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = eil_pal$axis, alpha = 0.35) +
  annotate("text", x = -9, y = 0.62, label = "range of\nuncertainty",
           size = 2.0, color = eil_pal$muted, lineheight = 0.9) +
  # 5. restrained data ink
  geom_line(color = eil_pal$ink, alpha = 0.55, linewidth = 0.4) +
  geom_point(color = eil_pal$ink, size = 0.95) +
  # 4. plain-language axes
  scale_y_continuous(limits = c(-0.8, 1.0), breaks = c(-0.5, 0, 0.5),
    labels = c("Lower", "No change", "Higher")) +
  scale_x_continuous(breaks = seq(-12, 12, 6),
    labels = c("12+ before", "6 before", "Event", "6 after", "12+ after"),
    expand = c(0.02, 0)) +
  labs(x = "TIME RELATIVE TO EVENT", y = NULL) +
  theme_eil()

# --- Export ----------------------------------------------------------
# Embedded figure (goes inside a highlight/release): source line, NO logo.
# The document's masthead already brands the page.
eil_save(p, OUT_PATH, source = SOURCE)

# Standalone / social card: same recipe, re-rendered with the logo lock-up
# added and at a self-contained size. A social card is NEVER a copied export
# of the embedded figure -- it is re-rendered like this (see social README §2).
# Use logo = "white" instead when the card sits on a dark/accent background.
eil_save(p, CARD_PATH, width = 6, height = 6, source = SOURCE, logo = TRUE)
