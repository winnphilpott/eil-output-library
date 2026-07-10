# Generate Fig. 1 (temperature-homicide relationship by policy regime)
# for the Colmer & Doleac "Access to Guns in the Heat of the Moment"
# research highlight.
#
# Recreates the shape of the paper's Figure 2: the estimated
# relationship between temperature and homicides, plotted separately
# for less-strict and stricter concealed-carry states. In less-strict
# states the line rises with temperature; in stricter states it stays
# roughly flat -- the paper's clearest single-glance evidence that
# stricter laws blunt heat's effect on homicides. Replaces the earlier
# event-study figure (make-fig1-event-study.R), which is no longer
# referenced by the highlight.
#
# IMPORTANT -- DATA CAVEAT: no public replication package was found for
# this paper (checked openICPSR, the MIT Press article page, and the
# authors' own sites). The anchor points below were read by eye directly
# off the published Figure 2 image (page 33 of the paper PDF) -- every 2
# degrees of temperature, for both the line and the band's half-width --
# then smoothed with a spline for plotting. This is a visual digitization,
# not a pixel-precise extraction and NOT sourced from real data. Before
# this figure is used in any public-facing output, confirm the underlying
# estimates with Colmer & Doleac directly, or locate their replication
# files, and replace this data block with the real numbers.
#
# Run from anywhere -- finds the repo root itself (see .find_repo_root()).
#   -> writes papers/2023-access-to-guns/data-viz/figures/fig1-temp-homicide-by-regime.png
# Deps: dplyr, ggplot2, tibble, (formats/data-viz/eil-theme.R)

library(dplyr)
library(ggplot2)

# Same upward-search trick as the other figure scripts and eil-theme.R's
# own .eil_find_logo_dir() -- works regardless of where this is run from.
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
                       "figures", "fig1-temp-homicide-by-regime.png")
SOURCE   <- "Environmental Inequality Lab · Access to Guns in the Heat of the Moment, 2026"

# --- Data: DIGITIZED BY EYE from the published Figure 2 (see caveat above) --
# x = daily temperature, relative to a typical day at that place and time
#     of year (the paper residualizes out location/month effects).
# y = homicides per 100,000 people, relative to a typical day.
# hw = half-width of the shaded uncertainty band at that point.
#
# Anchor points read off the chart every 2 degrees. Less-strict states:
# the line starts around -0.0019 at x=-10, rises fairly gently through
# the middle of the range, then kinks upward more steeply from about
# x=6 to x=10. Stricter states: the line hovers slightly above zero
# through the middle of the range, then dips below zero toward the hot
# tail. Both bands are tightest near the middle of the temperature
# range and flare out at the tails, more so on the hot (right) side.
anchors_x <- seq(-10, 10, by = 2)

less_strict_anchors <- tibble(
  x  = anchors_x,
  y  = c(-0.0019, -0.0016, -0.0012, -0.0008, -0.0003, 0.0001,
          0.0004,  0.0006,  0.0007,  0.0012,  0.0019),
  hw = c( 0.0014,  0.0011,  0.0009,  0.0007,  0.0006, 0.0005,
          0.0006,  0.0007,  0.0009,  0.0013,  0.0019)
)

stricter_anchors <- tibble(
  x  = anchors_x,
  y  = c( 0.0002,  0.0002,  0.0002,  0.0003,  0.0004,  0.0004,
          0.0005,  0.0004,  0.0002, -0.0002, -0.0005),
  hw = c( 0.0019,  0.0015,  0.0012,  0.0010,  0.0009,  0.0009,
          0.0009,  0.0010,  0.0012,  0.0016,  0.0021)
)

x_grid <- seq(-10, 10, by = 0.1)

# Smooth a natural cubic spline through the digitized anchor points onto
# a fine grid, for both the line and the band half-width, so the plotted
# curve isn't a jagged connect-the-dots.
spline_to_grid <- function(anchors, grid) {
  y_spl  <- stats::spline(anchors$x, anchors$y,  xout = grid, method = "natural")$y
  hw_spl <- stats::spline(anchors$x, anchors$hw, xout = grid, method = "natural")$y
  tibble(x = grid, y = y_spl, hw = pmax(hw_spl, 0.0002))
}

less_strict <- spline_to_grid(less_strict_anchors, x_grid) |> mutate(regime = "LESS STRICT LAWS")
stricter    <- spline_to_grid(stricter_anchors, x_grid)    |> mutate(regime = "STRICTER LAWS")

df <- bind_rows(less_strict, stricter) |>
  mutate(
    lo = y - hw,
    hi = y + hw,
    regime = factor(regime, levels = c("LESS STRICT LAWS", "STRICTER LAWS"))
  )

# --- Plot ---------------------------------------------------------------
p <- ggplot(df, aes(x, y)) +
  geom_hline(yintercept = 0, color = eil_pal$muted, linewidth = 0.45) +
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = eil_pal$axis, alpha = 0.35) +
  geom_line(color = eil_pal$ink, linewidth = 0.6) +
  facet_wrap(~regime, nrow = 1) +
  # limits set wide enough to hold the full ribbon at the tails (max
  # |hi/lo| ~0.0038 at x=+/-10) so nothing clips
  scale_y_continuous(limits = c(-0.004, 0.004), breaks = c(-0.002, 0, 0.002),
    labels = c("Fewer\nhomicides", "No change", "More\nhomicides")) +
  scale_x_continuous(breaks = c(-10, 0, 10), expand = expansion(mult = 0.12),
    labels = c("Cooler\nthan usual", "Typical\nday", "Hotter\nthan usual")) +
  labs(x = NULL, y = NULL, caption = SOURCE) +
  theme_eil(base_size = 7) +
  theme(
    strip.background = element_blank(),
    strip.text = element_text(color = eil_pal$ink, face = "bold", size = 7,
                               margin = margin(b = 5)),
    panel.spacing = unit(16, "pt")
  )

eil_save(p, OUT_PATH, width = 5.4, height = 3.0, source = SOURCE)
