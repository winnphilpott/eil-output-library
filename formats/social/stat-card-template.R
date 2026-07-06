# =====================================================================
#  stat-card-template.R  ·  Starter for an EIL "chart / stat card"
#  Conventions: style-guides/social/README.md  (archetype 3b)
#  Scaffolding: formats/social/social-cards.R
#
#  A single number as the whole post: one hero stat, a plain-language
#  headline, an optional sub-line, source line + logo baked in. Good
#  when the result lands at a glance and doesn't need the full story.
#
#  Run (from REPO ROOT):
#    Rscript formats/social/stat-card-template.R
#    -> writes /tmp/eil-stat-card.png
#  Deps: ggplot2, png  (+ the theme/scaffolding files below)
# =====================================================================

library(ggplot2)
source("formats/social/social-cards.R")   # dims, themes, eil_stat_card(), save_card()

OUT_PATH <- "/tmp/eil-stat-card.png"

# --- EDIT HERE: content ----------------------------------------------
# DEMO ONLY — swap for a real finding. Keep numbers honest; no invented
# stats (see social README §4, and the no-placeholder rule).
STAT     <- "0%"
# Keep the headline short and punchy; push detail into SUB. wrap_text()
# breaks a long line to fit (ggplot won't) -- lower the width for bigger type.
HEADLINE <- wrap_text("change in pollution violations", 22)
SUB      <- wrap_text("after free EPA workshops, 222 Ohio facilities", 26)
SOURCE   <- "Environmental Inequality Lab · EPA Compliance Workshops, 2026"

# --- EDIT HERE: format -----------------------------------------------
DIMS <- SOCIAL_DIMS$square      # square | portrait | landscape
BG   <- eil_pal$canvas          # light card; use a dark hex + logo="white" for accent
LOGO <- TRUE                    # TRUE (maroon) | "white" (on dark bg) | FALSE

# --- Build + save -----------------------------------------------------
# Tune stat_size / head_size / sub_size in eil_stat_card() if the text is
# too big or small for your headline length.
card <- eil_stat_card(STAT, HEADLINE, sub = SUB) +
  theme_eil_card(bg = BG)

save_card(card, OUT_PATH, dims = DIMS, source = SOURCE, logo = LOGO, bg = BG)
