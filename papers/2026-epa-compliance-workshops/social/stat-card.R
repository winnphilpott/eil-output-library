# =====================================================================
#  stat-card.R  ·  EPA compliance workshops — social stat card
#  Conventions: style-guides/social/README.md
#  Scaffolding:  formats/social/social-cards.R
#
#  Run (from REPO ROOT):
#    Rscript papers/2026-epa-compliance-workshops/social/stat-card.R
#    -> writes social/assets/epa-stat-card.png
# =====================================================================

library(ggplot2)
source("formats/social/social-cards.R")

OUT <- "papers/2026-epa-compliance-workshops/social/assets/epa-stat-card.png"

# --- Content (real finding: flat "Post" ATT ~ 0) ---------------------
STAT     <- "0%"
HEADLINE <- wrap_text("change in pollution violations", 22)
SUB      <- wrap_text("after free EPA workshops, 222 Ohio facilities", 26)
SOURCE   <- "Environmental Inequality Lab · EPA Compliance Workshops, 2026"

# --- Build + save ----------------------------------------------------
card <- eil_stat_card(STAT, HEADLINE, sub = SUB) + theme_eil_card()
save_card(card, OUT, dims = SOCIAL_DIMS$square, source = SOURCE)
