# =====================================================================
#  chart-card-template.R  ·  Starter for an EIL chart card
#  Conventions: style-guides/social/README.md  (archetypes 3a / 3b)
#  Scaffolding: formats/social/social-cards.R
#
#  A paper figure re-rendered for social: same plot recipe, but with a
#  headline baked in, social-scale type, and the logo lock-up added.
#  This is how you turn a highlight figure into a card -- rebuild the
#  plot with theme_eil_social() + a title, don't copy the print PNG
#  (social README §2).
#
#  The demo plot below is a stand-in. In practice, paste the plot recipe
#  from the paper's make-figN.R, swap theme_minimal(...)/theme_eil() for
#  theme_eil_social(), add labs(title=...), and save with save_card().
#
#  Run (from REPO ROOT):
#    Rscript formats/social/chart-card-template.R
#    -> writes /tmp/eil-chart-card.png
#  Deps: dplyr, ggplot2, png  (+ the theme/scaffolding files below)
# =====================================================================

library(dplyr)
library(ggplot2)
source("formats/social/social-cards.R")   # dims, themes, save_card()

OUT_PATH <- "/tmp/eil-chart-card.png"

# --- EDIT HERE: content ----------------------------------------------
# wrap_text() keeps a long headline on the card (ggplot won't wrap it).
HEADLINE <- wrap_text("Free compliance workshops didn't reduce violations", 22)
SOURCE   <- "Environmental Inequality Lab · EPA Compliance Workshops, 2026"

# --- EDIT HERE: format -----------------------------------------------
DIMS <- SOCIAL_DIMS$square      # square | portrait | landscape
BG   <- eil_pal$canvas
LOGO <- TRUE

# --- Data ------------------------------------------------------------
# DEMO ONLY: a flat before/after event series. Replace this block, and
# the plot below, with the real figure's recipe.
set.seed(1)
demo <- tibble(
  event = -12:12,
  est   = c(rnorm(12, -0.1, 0.15), 0, rnorm(12, 0.0, 0.15)),
  se    = 0.28
) |>
  mutate(lo = est - 1.96 * se, hi = est + 1.96 * se)

# --- Plot ------------------------------------------------------------
# Same house moves as data-viz-template.R, at social scale + a headline.
p <- ggplot(demo, aes(event, est)) +
  annotate("rect", xmin = -0.5, xmax = 12.5, ymin = -Inf, ymax = Inf,
           fill = eil_pal$band, alpha = 0.35) +
  geom_vline(xintercept = -0.5, color = eil_pal$accentred,
             linetype = "dashed", linewidth = 0.6) +
  geom_hline(yintercept = 0, color = eil_pal$muted, linewidth = 0.6) +
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = eil_pal$axis, alpha = 0.35) +
  geom_line(color = eil_pal$ink, alpha = 0.55, linewidth = 0.6) +
  geom_point(color = eil_pal$ink, size = 1.8) +
  scale_y_continuous(limits = c(-0.8, 1.0), breaks = c(-0.5, 0, 0.5),
    labels = c("Fewer", "No change", "More")) +
  scale_x_continuous(breaks = seq(-12, 12, 6),
    labels = c("12+ before", "6 before", "Workshop", "6 after", "12+ after"),
    expand = c(0.02, 0)) +
  labs(title = HEADLINE, x = "MONTHS RELATIVE TO TRAINING", y = NULL) +
  theme_eil_social()

# --- Save ------------------------------------------------------------
save_card(p, OUT_PATH, dims = DIMS, source = SOURCE, logo = LOGO, bg = BG)
