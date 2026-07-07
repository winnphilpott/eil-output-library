# =====================================================================
#  quote-card-template.R  ·  Starter for an EIL quote / finding card
#  Conventions: style-guides/social/README.md  (§3c, §7 quote cards)
#  Scaffolding: formats/social/social-cards.R
#
#  A single pulled sentence over the house maroon: an eyebrow kicker, an
#  oversized quote mark, the sentence, its attribution, source line +
#  white logo baked in. Landscape (1200x675) by default.
#
#  USE WITH A REAL QUOTE ONLY. Style guide §7: leave this format unused
#  until a real, confirmed, attributable line exists — never ship an
#  invented or placeholder quote. The bracketed text below is a slot to
#  fill, not a sentence to post.
#
#  Run (from REPO ROOT):
#    Rscript formats/social/quote-card-template.R
#    -> writes /tmp/eil-quote-card.png
#  Deps: ggplot2, png  (+ the theme/scaffolding files below)
# =====================================================================

library(ggplot2)
source("formats/social/assets/social-cards.R")   # dims, themes, eil_quote_card(), save_card()

OUT_PATH <- "/tmp/eil-quote-card.png"

# --- EDIT HERE: content ----------------------------------------------
# PLACEHOLDER — replace with a verbatim, confirmed, attributable line.
EYEBROW     <- "From the paper"
QUOTE       <- wrap_text("[A verbatim sentence from the paper or author — confirmed and attributable]", 38)
ATTRIBUTION <- "[Author names] · [Journal / venue], [year]"
SOURCE      <- "Environmental Inequality Lab · [Paper short title], [year]"

# --- EDIT HERE: format -----------------------------------------------
DIMS <- SOCIAL_DIMS$landscape   # landscape (mockup default) | square | portrait
BG   <- eil_pal$accentred       # house maroon; the card carries the white logo

# --- Build + save (dark/accent card: maroon bg, white logo) ----------
# Tune quote_size / mark_size / *_y in eil_quote_card() if a longer or
# shorter sentence crowds the attribution.
card <- eil_quote_card(QUOTE, ATTRIBUTION, eyebrow = EYEBROW, source = SOURCE) +
  theme_eil_card(bg = BG)

save_card(card, OUT_PATH, dims = DIMS, bg = BG, logo = "white")
