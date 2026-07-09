# Generate Fig. 2 (coefficient comparison) for the Colmer & Doleac
# "Access to Guns in the Heat of the Moment" research highlight.
#
# Recreates the paper's Table 3: the estimated effect of stricter
# concealed-carry laws on the temperature-homicide relationship, across
# the paper's five specifications -- two "Differences-in-Temperature"
# designs comparing different states, and three "Difference-in-
# Differences-in-Temperature" designs that instead track the same
# states/jurisdictions over time as their own laws changed. All five
# point the same direction: hot days produce fewer additional homicides
# once a state's concealed-carry law is more prohibitive.
#
# DATA SOURCE: hand-entered from Table 3 of Colmer & Doleac (2026),
# "Access to Guns in the Heat of the Moment," Review of Economics and
# Statistics 108(1): 30-43 (doi.org/10.1162/rest_a_01395), row
# "Temperature x More Prohibitive". The underlying NIBRS/PRISM/gun-law
# panel (13.5M jurisdiction-day observations) is restricted and not
# available to us, so this recreates the PUBLISHED point estimates and
# standard errors rather than re-running the regressions -- the normal
# way to build a forest-plot recreation of a results table.
#
# Run from anywhere -- this script finds the repo root itself (see
# .find_repo_root() below), so `Rscript code/make-fig2-....R`,
# RStudio's "Source" button, or an interactive session with any working
# directory all work without manually setting the working directory.
#   -> writes papers/2023-access-to-guns/data-viz/figures/fig2-coefficient-comparison.png
# Deps: dplyr, ggplot2, tibble, (formats/data-viz/eil-theme.R)

library(dplyr)
library(ggplot2)

# Walk up from the current working directory until we find the repo
# root (identified by formats/data-viz/eil-theme.R existing beneath
# it) -- same trick eil-theme.R itself uses to locate formats/logos/,
# so this script doesn't care whether it's run from data-viz/, code/,
# the repo root, or launched via RStudio's "Source" button.
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
                       "figures", "fig2-coefficient-comparison.png")
SOURCE   <- "Environmental Inequality Lab · Access to Guns in the Heat of the Moment, 2026"

# --- Data: Table 3, "Temperature x More-Prohibitive" row --------------------
# Units: fewer homicides per 100,000 people per 1-degree-Celsius increase,
# during more-prohibitive concealed-carry policy regimes.
tbl3 <- tibble::tribble(
  ~spec,                                            ~est,       ~se,
  "Comparing different states",                     -0.000511,  0.000200,
  "...excluding years right around a law change",   -0.000562,  0.000203,
  "Tracking states over time",                      -0.000332,  0.000159,
  "Tracking local police departments over time",    -0.000349,  0.000112,
  "Grouping states by timing of their law change",  -0.000216,  0.000115
) |>
  mutate(
    lo = est - 1.96 * se,
    hi = est + 1.96 * se,
    spec = factor(spec, levels = rev(spec))   # keep paper's column order top-to-bottom
  )

# --- Plot ---------------------------------------------------------------
p <- ggplot(tbl3, aes(x = est, y = spec)) +
  geom_vline(xintercept = 0, color = eil_pal$accentred, linetype = "dashed",
             linewidth = 0.4) +
  annotate("text", x = 0, y = Inf, vjust = 1.6, label = "NO EFFECT", size = 2.3,
           color = eil_pal$accentred, fontface = "bold", hjust = 0.5) +
  geom_errorbar(aes(xmin = lo, xmax = hi), orientation = "y", width = 0,
                color = eil_pal$axis, linewidth = 0.6) +
  geom_point(color = eil_pal$ink, size = 1.6) +
  scale_x_continuous(labels = NULL, breaks = NULL,
                      limits = c(-0.00098, 0.00015)) +
  labs(x = "FEWER HOMICIDES ON HOT DAYS, IN STRICTER-LAW STATES →",
       y = NULL, caption = SOURCE) +
  theme_eil(base_size = 7) +
  theme(
    axis.line.x  = element_blank(),
    axis.title.x = element_text(color = eil_pal$muted, size = 6,
                                 margin = margin(t = 4), hjust = 0),
    axis.text.y  = element_text(color = eil_pal$ink, size = 6.6, lineheight = 0.95)
  )

eil_save(p, OUT_PATH, width = 5.4, height = 3.0, source = SOURCE)
