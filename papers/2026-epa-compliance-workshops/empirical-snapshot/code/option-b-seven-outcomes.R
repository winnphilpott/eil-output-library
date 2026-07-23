# =====================================================================
#  DRAFT — Empirical Snapshot, Option B: "Seven Ways, One Story"
#  NOT a final output. One of four exploratory directions for the
#  paper's empirical snapshot; see the other option-*.R scripts in this
#  folder for the alternatives.
#
#  Concept: the paper's Table 3 tests compliance assistance against SEVEN
#  separate outcomes (violations, probability of violation, and five
#  discharge measures) using the preferred facility-FE + time-FE
#  estimator. Every single 95% CI crosses zero. That's a dense
#  regression table nobody reads outside the paper -- as a forest plot,
#  it shows the null held up across every way the authors checked it,
#  which is a different (and arguably stronger) argument than the single
#  event-study figure already used everywhere else in this paper's
#  output package.
#
#  All point estimates and 95% CIs are transcribed verbatim from the
#  published text (Ferraro & Shimshack 2026, "The effects of compliance
#  assistance on violations and pollution" subsection, p.13). Violations
#  and probability-of-violation are rescaled from raw units to % of their
#  pre-workshop mean (Table 1: 0.74 violations/mo, 0.21 probability) so
#  all seven rows sit on one comparable %-change axis; the five discharge
#  measures are already log-linear (~= % change) in the paper.
#
#  Masthead/title/dek styling matches the house LaTeX macros exactly --
#  see _font-setup.R for the transcribed specs.
#
#  Run from REPO ROOT:
#    Rscript papers/2026-epa-compliance-workshops/empirical-snapshot/code/option-b-seven-outcomes.R
#    -> writes empirical-snapshot/figures/option-b-seven-outcomes.png
#  Deps: ggplot2, grid, png, ragg, systemfonts
# =====================================================================

suppressMessages({
  library(ggplot2); library(grid); library(png); library(ragg)
})

source("formats/data-viz/eil-theme.R")
source("papers/2026-epa-compliance-workshops/empirical-snapshot/code/_font-setup.R")

OUT <- "papers/2026-epa-compliance-workshops/empirical-snapshot/figures/option-b-seven-outcomes.png"

# --- Data: Table 3 (preferred estimator), rescaled to % change ----------
outcomes <- data.frame(
  outcome = c("Number of violations", "Any violation (probability)",
              "TSS discharge", "BOD discharge", "Ammonia (NH3) discharge",
              "Residual chlorine discharge", "Dissolved oxygen"),
  pct = c(0.004/0.74*100, 0.002/0.21*100, 4.1, -2.3, 11.2, 6.7, -1.7),
  lo  = c(-0.143/0.74*100, -0.027/0.21*100, -4.0, -9.6, -2.6, -13.5, -4.1),
  hi  = c(0.152/0.74*100, 0.030/0.21*100, 12.3, 5.0, 25.0, 26.9, 0.7)
)
outcomes$outcome <- factor(outcomes$outcome, levels = rev(outcomes$outcome))

pforest <- ggplot(outcomes, aes(x = pct, y = outcome)) +
  geom_vline(xintercept = 0, color = eil_pal$accentred, linetype = "dashed", linewidth = 0.6) +
  geom_segment(aes(x = lo, xend = hi, yend = outcome), color = eil_pal$axis, linewidth = 3.2,
               lineend = "round") +
  geom_point(size = 3.6, color = eil_pal$ink) +
  annotate("text", x = 0, y = 7.85, label = "NO EFFECT", hjust = 0.5, vjust = 0,
           color = eil_pal$accentred, fontface = "bold", size = 3.3, family = EIL_FONT) +
  scale_x_continuous(labels = function(v) paste0(ifelse(v > 0, "+", ""), v, "%"),
                      breaks = seq(-20, 25, 5), expand = expansion(mult = c(0.03, 0.05))) +
  scale_y_discrete(expand = expansion(add = c(0.6, 0.9))) +
  coord_cartesian(clip = "off") +
  labs(x = "ESTIMATED CHANGE, RELATIVE TO BEFORE THE WORKSHOP", y = NULL) +
  theme_eil(base_size = 13, base_family = EIL_FONT) +
  theme(
    plot.background   = element_rect(fill = eil_pal$paper, color = NA),
    panel.background  = element_rect(fill = eil_pal$paper, color = NA),
    axis.line.x       = element_line(color = eil_pal$axis, linewidth = 0.4),
    axis.ticks.x      = element_line(color = eil_pal$axis, linewidth = 0.3),
    axis.text.x       = element_text(size = 9.5),
    axis.text.y       = element_text(size = 12, color = eil_pal$ink, hjust = 1),
    axis.title.x      = element_text(size = 9, margin = margin(t = 8)),
    panel.grid.major.y = element_line(color = eil_pal$warmrule, linewidth = 0.35),
    plot.margin       = margin(4, 10, 2, 0)
  )

# --- Compose on an absolute-inch coordinate system -----------------------
W <- 7.6; H <- 7.6; DPI <- 200
MX <- 0.45
CW <- W - 2 * MX
pt_in <- function(pt, lineheight = 1.15, lines = 1) pt / 72.27 * lineheight * lines
gp <- function(...) gpar(fontfamily = EIL_FONT, ...)

dir.create(dirname(OUT), showWarnings = FALSE, recursive = TRUE)
agg_png(OUT, width = W, height = H, units = "in", res = DPI, background = eil_pal$paper)
grid.newpage()
grid.rect(gp = gp(fill = eil_pal$paper, col = NA))
pushViewport(viewport(x = 0.5, y = 0.5, width = 1, height = 1,
                       xscale = c(0, W), yscale = c(H, 0)))
nx <- function(v) unit(v, "native")
ny <- function(v) unit(v, "native")

y <- 0.35

# --- masthead: logo left + tracked label right + 2.2pt rule -------------
logo <- readPNG("formats/logos/eil-logo-maroon.png")
LOGO_H <- 0.45; LOGO_W <- LOGO_H * (dim(logo)[2] / dim(logo)[1])
grid.raster(logo, x = nx(MX), y = ny(y), width = unit(LOGO_W, "in"), height = unit(LOGO_H, "in"),
            just = c("left", "top"))
grid.text(track_caps("Empirical Snapshot", 200), x = nx(W - MX), y = ny(y + LOGO_H / 2), just = c("right", "center"),
           gp = gp(col = eil_pal$accentred, fontface = "bold", fontsize = EIL_MASTHEAD_LABEL_PT))
y <- y + LOGO_H + 0.055
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$ink, lwd = pt_lwd(2.2)))

# --- title + dek ------------------------------------------------------------
y <- y + 0.18
title_lines <- strwrap("Across every outcome measured, the effect is the same: none.", width = 42)
grid.text(paste(title_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$ink, fontface = "bold", fontsize = EIL_TITLE_PT, lineheight = 1.08))
y <- y + pt_in(EIL_TITLE_PT, 1.08, length(title_lines)) + 0.09
dek_lines <- strwrap(paste(
  "Ferraro & Shimshack (2026) tested compliance assistance workshops against seven separate",
  "measures of violations and pollution discharges. Every single confidence interval crosses zero."),
  width = 88)
grid.text(paste(dek_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gpar(fontfamily = EIL_FONT_SERIF, fontface = "italic",
                     col = eil_pal$cite, fontsize = EIL_DEK_PT, lineheight = 1.27))
y <- y + pt_in(EIL_DEK_PT, 1.27, length(dek_lines))
y <- y + 0.03
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))

# --- forest plot -------------------------------------------------------------
y <- y + 0.28
chart_h <- 3.55
print(pforest, vp = viewport(x = nx(MX), y = ny(y), width = unit(CW, "in"),
                              height = unit(chart_h, "in"), just = c("left", "top")))
y <- y + chart_h

# footnote on DO's direction (paper aims to *increase* it, unlike the rest)
y <- y + 0.06
note_lines <- strwrap(
  "Note: unlike the other measures, the program aimed to increase dissolved oxygen, not decrease it.",
  width = 115)
grid.text(paste(note_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$faint, fontface = "italic", fontsize = 8.2))
y <- y + pt_in(8.2, 1.15, length(note_lines))

# --- bottom rule + takeaway + source ----------------------------------------
y <- y + 0.18
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))
y <- y + 0.15
takeaway_lines <- strwrap(paste(
  "A program built to reduce violations and pollution didn't detectably reduce either --",
  "on any of the seven measures the authors checked."), width = 74)
grid.text(paste(takeaway_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$ink, fontface = "bold", fontsize = 12, lineheight = 1.25))
y <- y + pt_in(12, 1.25, length(takeaway_lines)) + 0.13
grid.text("Environmental Inequality Lab · Ferraro & Shimshack, 2026 · doi.org/10.1002/pam.70056",
           x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$faint, fontsize = EIL_FOOTER_PT))
y <- y + pt_in(EIL_FOOTER_PT) + 0.26

popViewport()
dev.off()
message("wrote ", OUT, " -- content used ", round(y, 2), "in of ", H, "in page")
