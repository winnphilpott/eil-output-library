# =====================================================================
#  quote-card.R  ·  EPA compliance workshops — social quote card (1c)
#  Conventions: style-guides/social/README.md  (§3c, §7 quote cards)
#  Scaffolding:  formats/social/social-cards.R
#
#  Recreates mockup card 1c: a pulled sentence from the paper over the
#  house maroon, landscape (1200x675), with the white logo lock-up.
#
#  The quote is a verbatim line from Ferraro & Shimshack (JPAM, 2026);
#  §7 of the style guide requires a real, confirmed, attributable quote —
#  never a placeholder.
#
#  Run (from REPO ROOT):
#    Rscript papers/2026-epa-compliance-workshops/social/quote-card.R
#    -> writes social/assets/epa-quote-card.png
#  Deps: ggplot2, png
# =====================================================================

library(ggplot2)
source("formats/social/social-cards.R")

OUT <- "papers/2026-epa-compliance-workshops/social/assets/epa-quote-card.png"

# --- Content (verbatim quote — confirmed, attributable) --------------
EYEBROW     <- "From the paper"
QUOTE       <- wrap_text("We estimate a precise zero effect of compliance assistance on pollution and violations.", 38)
ATTRIBUTION <- "Ferraro & Shimshack · Journal of Policy Analysis & Management, 2026"
SOURCE      <- "Environmental Inequality Lab · Ferraro & Shimshack, 2026"

# --- Build + save (dark/accent card: maroon bg, white logo) ----------
card <- eil_quote_card(QUOTE, ATTRIBUTION, eyebrow = EYEBROW, source = SOURCE) +
  theme_eil_card(bg = eil_pal$accentred)

save_card(card, OUT, dims = SOCIAL_DIMS$landscape, bg = eil_pal$accentred,
          logo = "white")
