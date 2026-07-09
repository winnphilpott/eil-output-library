# Generate Fig. 1 (event study) for the Colmer & Doleac "Access to Guns
# in the Heat of the Moment" research highlight.
#
# Recreates the shape of the paper's Figure 3: how much MORE homicides
# rise on hot days in states that are about to loosen (or have just
# loosened) their concealed-carry law, year by year, relative to the
# year before the law changed (the omitted/reference year, -1).
#
# IMPORTANT -- DATA CAVEAT: no public replication package was found for
# this paper (checked openICPSR, the MIT Press article page, and the
# authors' own sites). The values below are visually approximated from
# the published Figure 3 image to match its general shape -- flat and
# centered near zero with wide uncertainty before the law change, then
# a jump that holds for years afterward -- they are NOT digitized from
# source data or a replication file. Before this figure is used in any
# public-facing output, confirm the underlying estimates with Colmer &
# Doleac directly, or locate their replication files, and replace this
# data block with the real numbers.
#
# Run from anywhere -- finds the repo root itself (see .find_repo_root()).
#   -> writes papers/2023-access-to-guns/data-viz/figures/fig1-event-study.png
# Deps: dplyr, ggplot2, tibble, (formats/data-viz/eil-theme.R)

library(dplyr)
library(ggplot2)

# Same upward-search trick as make-fig2-coefficient-comparison.R and
# eil-theme.R's own .eil_find_logo_dir() -- works regardless of where
# this script is run from.
.find_repo_root <- function() {
  dir <- normalizePath(getwd(), mustWork = FALSE)
  repeat {
    if (file.exists(file.path(dir, "formats", "data-viz", "eil-theme.R"))) return(dir)
    parent <- dirname(dir)
    if (identical(parent, dir)) stop(
      "Could not find the repo root (looked for formats/data-viz/eil-theme.R ",
      "in every parent of ", getwd(), "). Run this script from somewhere ",
      "inside the eil-output-library repo."
    )
    dir <- parent
  }
}
REPO_ROOT <- .find_repo_root()
source(file.path(REPO_ROOT, "formats", "data-viz", "eil-theme.R"))

OUT_PATH <- file.path(REPO_ROOT, "papers", "2023-access-to-guns", "data-viz",
                       "figures", "fig1-event-study.png")
SOURCE   <- "Environmental Inequality Lab · Access to Guns in the Heat of the Moment, 2026"

# --- Data: APPROXIMATED from the published Figure 3 (see caveat above) ------
# Units: additional homicides per 100,000 people per 1-degree-Celsius
# increase, relative to year -1 (the omitted reference year).
es <- tibble::tribble(
  ~year, ~est,      ~se,
  -6,     0.00010,  0.00025,
  -5,     0.00015,  0.00023,
  -4,    -0.00015,  0.00022,
  -3,     0.00010,  0.00020,
  -2,    -0.00010,  0.00018,
  -1,     0,        0.00019,    # reference year -- point estimate fixed at zero
                                 # by construction, but given a plausible SE
                                 # (matching neighboring years) so the ribbon
                                 # flows continuously instead of pinching to
                                 # a single point
   0,     0.00010,  0.00019,
   1,     0.00035,  0.00028,
   2,     0.00015,  0.00030,
   3,     0.00005,  0.00028,
   4,     0.00058,  0.00033,
   5,     0.00035,  0.00027,
   6,     0.00045,  0.00030,
   7,     0.00045,  0.00027,
   8,     0.00040,  0.00025,
   9,     0.00015,  0.00030
) |>
  mutate(lo = est - 1.96 * se, hi = est + 1.96 * se)

# --- Plot ---------------------------------------------------------------
p <- ggplot(es, aes(year, est)) +
  # stricter-law / less-strict-law framing (the state's OWN law, before vs.
  # after it changed -- most transitions in the sample go stricter -> looser)
  annotate("rect", xmin = -0.5, xmax = 9.5, ymin = -Inf, ymax = Inf,
           fill = eil_pal$band, alpha = 0.35) +
  annotate("text", x = -3.5, y = Inf, vjust = 1.6, label = "STRICTER LAWS",
           size = 2.3, color = eil_pal$muted, fontface = "bold") +
  annotate("text", x = 4.75, y = Inf, vjust = 1.6, label = "LESS STRICT LAWS",
           size = 2.3, color = eil_pal$accentred, fontface = "bold") +
  geom_vline(xintercept = -0.5, color = eil_pal$accentred, linetype = "dashed",
             linewidth = 0.4) +
  geom_hline(yintercept = 0, color = eil_pal$muted, linewidth = 0.45) +
  # single soft uncertainty band, light connecting line + small points
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = eil_pal$axis, alpha = 0.35) +
  geom_line(color = eil_pal$ink, alpha = 0.55, linewidth = 0.4) +
  geom_point(color = eil_pal$ink, size = 0.95) +
  # word-based y-axis instead of raw coefficients -- limits set wide enough
  # to hold the full ribbon (max hi ~0.00123 at year 4) so nothing clips
  scale_y_continuous(limits = c(-0.0007, 0.0014), breaks = c(-0.0003, 0, 0.0009),
    labels = c("Fewer\nhomicides", "No change", "More\nhomicides")) +
  scale_x_continuous(breaks = seq(-6, 9, 3),
    labels = c("6 before", "3 before", "Law\nchanges", "3 after", "6 after", "9 after"),
    expand = c(0.02, 0)) +
  labs(x = "YEARS RELATIVE TO A STATE LOOSENING ITS CONCEALED-CARRY LAW",
       y = NULL, caption = SOURCE) +
  theme_eil(base_size = 7)

eil_save(p, OUT_PATH, width = 5.4, height = 3.1, source = SOURCE)
