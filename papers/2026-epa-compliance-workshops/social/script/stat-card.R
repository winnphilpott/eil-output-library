# =====================================================================
#  stat-card.R  ·  EPA compliance workshops — social stat card (1a)
#  Conventions: style-guides/social/README.md
#  Scaffolding:  formats/social/social-cards.R
#
#  Recreates mockup card 1a: a hero "0%" over the plain-language finding,
#  landscape (1200x675), house palette + logo lock-up baked in.
#
#  Run (from REPO ROOT):
#    Rscript papers/2026-epa-compliance-workshops/social/stat-card.R
#    -> writes social/assets/epa-stat-card.png
#  Deps: ggplot2, png
# =====================================================================

library(ggplot2)
source("formats/social/social-cards.R")

OUT <- "papers/2026-epa-compliance-workshops/social/assets/epa-stat-card.png"

# --- Content (real finding: flat "Post" ATT ~ 0) ---------------------
EYEBROW  <- "New EIL research · 2026"
STAT     <- "0%"
HEADLINE <- wrap_text("change in pollution violations", 40)
SUB      <- wrap_text("after free EPA compliance workshops at Ohio wastewater plants", 54)
SOURCE   <- "Environmental Inequality Lab · Ferraro & Shimshack, 2026"

# --- Build + save ----------------------------------------------------
card <- eil_stat_card(STAT, HEADLINE, sub = SUB, eyebrow = EYEBROW,
                      source = SOURCE) +
  theme_eil_card(bg = eil_pal$paper)

save_card(card, OUT, dims = SOCIAL_DIMS$landscape, bg = eil_pal$paper)
