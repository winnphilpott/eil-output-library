# =====================================================================
#  stat-card-template.R  ·  Starter for an EIL "chart / stat card"
#  Conventions: style-guides/social/README.md  (archetype 3b)
#  Scaffolding: formats/social/social-cards.R
#
#  A single number as the whole post: an eyebrow kicker, one hero stat, a
#  plain-language headline, an optional sub-line, source line + logo baked
#  in. Good when the result lands at a glance and doesn't need the full
#  story. Landscape (1200x675) by default, matching the card mockups.
#
#  Run (from REPO ROOT):
#    Rscript papers/2025-early-life-pollution/social/code/stat-card.R
#    -> writes social/assets/early-life-stat-card.png
#  Deps: ggplot2, png  (+ the theme/scaffolding files below)
# =====================================================================

library(ggplot2)
source("formats/social/assets/social-cards.R")   # dims, themes, eil_stat_card(), save_card()

OUT_PATH <- "papers/2025-early-life-pollution/social/assets/early-life-stat-card.png"

# --- EDIT HERE: content ----------------------------------------------
# PLACEHOLDERS — swap for a real finding. Keep numbers honest; no invented
# stats (see social README §4, and the no-placeholder rule).
EYEBROW  <- "New EIL research · YEAR"
STAT     <- "00%"
# Keep the headline short and punchy; push detail into SUB. wrap_text()
# breaks a long line to fit (ggplot won't) -- lower the width for bigger
# type. On landscape the headline usually fits one line (width ~40).
HEADLINE <- wrap_text("the finding in a few plain words", 40)
SUB      <- wrap_text("one line of supporting context — where, who, how many", 46)
SOURCE   <- "Environmental Inequality Lab · [Paper short title], [year]"

# --- EDIT HERE: format -----------------------------------------------
DIMS <- SOCIAL_DIMS$landscape   # landscape (mockup default) | square | portrait
BG   <- eil_pal$paper           # light card; use a dark hex + logo="white" for accent
LOGO <- TRUE                    # TRUE (maroon) | "white" (on dark bg) | FALSE

# --- Build + save -----------------------------------------------------
# Tune stat_size / head_size / sub_size / *_y in eil_stat_card() if the
# text is too big or small for your headline length (defaults are tuned
# for landscape; bump the sizes for a square card).
card <- eil_stat_card(STAT, HEADLINE, sub = SUB, eyebrow = EYEBROW,
                      source = SOURCE) +
  theme_eil_card(bg = BG)

save_card(card, OUT_PATH, dims = DIMS, logo = LOGO, bg = BG)
