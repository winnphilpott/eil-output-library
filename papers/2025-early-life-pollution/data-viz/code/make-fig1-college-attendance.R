# =====================================================================
#  make-fig1-college-attendance.R
#  Recreation of Figure 2 from Colmer & Voorheis (2025), "The
#  Intergenerational Effects of Early-Life Pollution Exposure"
#  (J. Political Economy: Microeconomics, forthcoming; DOI 10.1086/740104).
#
#  The finding: parents who breathed cleaner air in the womb — the cohorts
#  born after the 1970 Clean Air Act improved local air quality — go on to
#  have children who are more likely to attend college, decades later.
#  Estimates are relative to the 1971 cohort (the last one before the gains).
#
#  VISUAL RECREATION. The paper's estimates come from confidential U.S.
#  Census microdata (Numident + ACS) the lab cannot access, so the series
#  below were digitized from the published Figure 2 (percentage-point
#  change + 95% CI, read off the vector chart). Values are approximate to
#  ~0.1pp — treat them as a faithful redraw, not re-estimated results.
#
#  Conventions: style-guides/data-viz/README.md
#  Theme/palette: formats/data-viz/eil-theme.R
#
#  Run (from this paper's data-viz/ folder):  Rscript code/make-fig1-college-attendance.R
#    -> figures/fig1-college-attendance.png       (embedded in the highlight)
#    -> figures/fig1-college-attendance-card.png  (standalone, with logo)
#  Deps: dplyr, ggplot2  (+ png for the card logo)
# =====================================================================

library(dplyr)
library(ggplot2)

# House theme + palette. Path is relative to this paper's data-viz/ folder.
source("../../../formats/data-viz/eil-theme.R")

OUT_PATH  <- "figures/fig1-college-attendance.png"
CARD_PATH <- "figures/fig1-college-attendance-card.png"
SOURCE    <- "Environmental Inequality Lab · Early-Life Pollution Exposure, 2025"

# Where the 1970 Clean Air Act gains land. Placed on 1971 to match Figure 2 in
# the paper (its reference/normalization year), so a reader comparing the two
# sees the same pivot. Everything is measured relative to the 1971 cohort.
PIVOT <- 1971

# --- Data ------------------------------------------------------------
# Digitized from Figure 2. `year` = the PARENT's (first-generation) birth
# cohort; `est` = pp change in the CHILD's likelihood of attending college,
# relative to the 1971 cohort; lo/hi = 95% CI. 1971 is the reference (0).
fig <- tribble(
  ~year, ~est,  ~lo,   ~hi,
  1969,  0.6,  -1.5,   2.8,
  1970,  0.9,  -1.2,   3.0,
  1971,  0.0,   0.0,   0.0,
  1972,  1.9,  -0.3,   4.0,
  1973,  2.0,  -0.4,   4.4,
  1974,  2.4,  -0.1,   4.9,
  1975,  4.7,   2.1,   7.3
)

# --- Plot ------------------------------------------------------------
# House recipe: frame one idea (shaded "cleaner air" cohorts + a dashed
# pivot line), soft single uncertainty band, plain-language axes, small
# dark data marks, interpretation left to the document.
p <- ggplot(fig, aes(year, est)) +
  # 1. before/after framing: shade the cohorts that got the cleaner air
  annotate("rect", xmin = PIVOT, xmax = 1975.5, ymin = -Inf, ymax = Inf,
           fill = eil_pal$band, alpha = 0.55) +
  geom_vline(xintercept = PIVOT, color = eil_pal$accentred,
             linetype = "dashed", linewidth = 0.4) +
  geom_hline(yintercept = 0, color = eil_pal$muted, linewidth = 0.45) +
  # 2. orientation labels (neutral before, emphasized after)
  annotate("text", x = 1970, y = 6.6, label = "PARENTS WHO GREW UP\nWITH DIRTIER AIR",
           size = 2.2, color = eil_pal$muted, fontface = "bold", lineheight = 0.9) +
  annotate("text", x = 1973.3, y = -2.3, label = "PARENTS WHO GREW UP\nWITH CLEANER AIR",
           size = 2.2, color = eil_pal$accentred, fontface = "bold", lineheight = 0.9) +
  annotate("text", x = 1971.15, y = 8.1, hjust = 0,
           label = "1970 Clean Air Act\nimproves air quality",
           size = 1.95, color = eil_pal$muted, lineheight = 0.9) +
  # 3. soft uncertainty band (explained in the figure note, not on the chart)
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = eil_pal$axis, alpha = 0.40) +
  # 5. restrained data ink
  geom_line(color = eil_pal$ink, alpha = 0.55, linewidth = 0.5) +
  geom_point(color = eil_pal$ink, size = 1.35) +
  # 4. plain-language axes
  scale_y_continuous(limits = c(-3, 8.6), breaks = c(0, 2, 4, 6, 8),
    labels = c("0\n(no change)", "+2", "+4", "+6", "+8")) +
  scale_x_continuous(breaks = 1969:1975, expand = c(0.02, 0)) +
  labs(x = "PARENT'S BIRTH COHORT",
       y = "CHILD'S COLLEGE ATTENDANCE\n(PERCENTAGE-POINT CHANGE)") +
  theme_eil() +
  theme(
    axis.title.y = element_text(color = eil_pal$muted, size = 6, angle = 90,
                                lineheight = 0.9, margin = margin(r = 4)),
    axis.text.y  = element_text(color = eil_pal$ink, size = 6, lineheight = 0.85)
  )

# --- Export ----------------------------------------------------------
# Embedded figure (goes inside the research highlight): source line, NO logo.
eil_save(p, OUT_PATH, source = SOURCE)

# Standalone variant (travels on its own): same recipe + the logo lock-up.
eil_save(p, CARD_PATH, width = 6, height = 3.5, source = SOURCE, logo = TRUE)
