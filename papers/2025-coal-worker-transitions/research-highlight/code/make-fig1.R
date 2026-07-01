# Generate Fig. 1 (cumulative earnings of coal-exposed workers) for the
# Colmer, Krause, Lyubich & Voorheis (2025) research highlight.
#
# Recreates the paper's Figure 7(a): cumulative earnings of the most
# coal-exposed workers relative to otherwise similar less-exposed workers,
# normalized to average pre-shock (2007-2011) annual pay, year by year.
#
# IMPORTANT: we do not hold the paper's restricted Census/IRS microdata, so
# the point estimates here are DIGITIZED from the published Figure 7(a) and
# cross-checked against the paper's text (cumulative loss = 1.6x a year's pay
# by 2019). The uncertainty band is an approximation of the published 95% CI.
# This is a faithful recreation for presentation, not a re-estimation.
#
# Styled for a general audience: word-based y-axis (years of pay lost),
# before/after-2011 framing, and a single soft uncertainty band. The
# interpretive note lives in the document, not the figure.
#
# Run (from research-highlight/):  Rscript code/make-fig1.R  -> figures/fig1.png
# Deps: ggplot2

library(ggplot2)

OUT_PATH <- "figures/fig1.png"

# --- Digitized point estimates (coef. on coal exposure, x pre-shock annual pay)
d <- data.frame(
  year = 2007:2021,
  est  = c(0.00, 0.02, 0.03, 0.02, 0.00,
           -0.07, -0.18, -0.33, -0.55, -0.80,
           -1.07, -1.33, -1.60, -1.90, -2.20),
  hw   = c(0.02, 0.02, 0.02, 0.02, 0.02,
           0.05, 0.07, 0.09, 0.11, 0.13,
           0.15, 0.18, 0.20, 0.23, 0.27)  # approx. 95% band half-width
)
d$lo <- d$est - d$hw
d$hi <- d$est + d$hw

# --- Design tokens (match _style.tex / make-fig2.R) -------------------------
INK  <- "#1d2620"; RED <- "#641111"; BAND <- "#f3e4e2"
AXIS <- "#c4bdad"; MUTE <- "#50534a"

# Fixed panel bounds so the shaded region, zero-line, and x-axis line all
# terminate on exactly the same right/left edge.
XLIM <- c(2006.72, 2021.28)

p <- ggplot(d, aes(year, est)) +
  annotate("rect", xmin = 2011, xmax = XLIM[2], ymin = -Inf, ymax = Inf,
           fill = BAND, alpha = 0.35) +
  annotate("text", x = 2008.6, y = 0.20, label = "BEFORE COAL'S DECLINE",
           size = 2.3, color = MUTE, fontface = "bold") +
  annotate("text", x = 2016.5, y = 0.20, label = "AFTER 2011 PEAK",
           size = 2.3, color = RED, fontface = "bold") +
  geom_vline(xintercept = 2011, color = RED, linetype = "dashed", linewidth = 0.4) +
  geom_hline(yintercept = 0, color = MUTE, linewidth = 0.45) +
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = AXIS, alpha = 0.35) +
  geom_line(color = INK, alpha = 0.6, linewidth = 0.45) +
  geom_point(color = INK, size = 1.0) +
  # call out the headline 2019 value, label parked in open space lower-left
  annotate("point", x = 2019, y = -1.60, color = RED, size = 1.7) +
  annotate("segment", x = 2016.2, xend = 2018.85, y = -2.12, yend = -1.66,
           color = RED, linewidth = 0.3) +
  annotate("text", x = 2016.1, y = -2.12, hjust = 1, vjust = 0.5,
           label = "1.6 years' pay\nlost by 2019",
           size = 2.4, color = RED, fontface = "bold", lineheight = 0.9) +
  scale_y_continuous(
    limits = c(-2.5, 0.45),
    breaks = c(0, -0.5, -1.0, -1.5, -2.0, -2.5),
    labels = c("Pre-shock\nearnings", "½ year's\npay", "1 year",
               "1½ years", "2 years", "2½ years\nlost")) +
  scale_x_continuous(breaks = seq(2007, 2021, 2),
                     limits = XLIM, expand = c(0, 0)) +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 7) +
  theme(
    plot.background  = element_rect(fill = "#ffffff", color = NA),
    panel.background = element_rect(fill = "#ffffff", color = NA),
    panel.grid       = element_blank(),
    axis.line.x      = element_line(color = AXIS, linewidth = 0.4),
    axis.ticks.x     = element_line(color = AXIS, linewidth = 0.3),
    axis.ticks.y     = element_blank(),
    axis.text.x      = element_text(color = MUTE, size = 7),
    axis.text.y      = element_text(color = INK, size = 6.4, lineheight = 0.85)
  )

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave(OUT_PATH, p, width = 5.4, height = 3.1, dpi = 220, bg = "#ffffff")
message("wrote ", OUT_PATH)
