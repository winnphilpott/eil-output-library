# =====================================================================
#  DRAFT — Empirical Snapshot, Option C: "The Fair Comparison"
#  NOT a final output. One of four exploratory directions for the
#  paper's empirical snapshot; see the other option-*.R scripts in this
#  folder for the alternatives.
#
#  Concept: Options A and B both show RESULTS (a number, seven numbers).
#  This one shows the DESIGN -- the mechanic that makes the 0% estimate
#  trustworthy in the first place. Right now that argument only exists
#  as dense prose in the research highlight's "The Challenge" section
#  and the paper's methods section ("average outcomes of later workshop
#  cohorts represent the counterfactual average outcomes for the earlier
#  workshop cohorts"). Nobody who hasn't read that paragraph twice
#  understands why "early-trained vs. later-trained" is a fair
#  comparison. This makes it visible instead of argued.
#
#  Cohort training months (22, 28 "earlier"; 35, 42 "later") are
#  transcribed verbatim from Appendix Figure A5's notes (Ferraro &
#  Shimshack 2026 online appendix, p.5) -- the paper's own illustrative
#  grouping for its pretrends check, not a number I derived. Calendar
#  labels convert month-of-sample (1 = Jan 2014) to match fig1's own
#  x-axis convention (data-viz/code/make-fig1.R).
#
#  Masthead/title/dek styling matches the house LaTeX macros exactly --
#  see _font-setup.R for the transcribed specs.
#
#  Run from REPO ROOT:
#    Rscript papers/2026-epa-compliance-workshops/empirical-snapshot/code/option-c-fair-comparison.R
#    -> writes empirical-snapshot/figures/option-c-fair-comparison.png
#  Deps: ggplot2, grid, png, ragg, systemfonts
# =====================================================================

suppressMessages({
  library(ggplot2); library(grid); library(png); library(ragg)
})

source("formats/data-viz/eil-theme.R")
source("papers/2026-epa-compliance-workshops/empirical-snapshot/code/_font-setup.R")

OUT <- "papers/2026-epa-compliance-workshops/empirical-snapshot/figures/option-c-fair-comparison.png"

# --- Data: four example cohorts (Appendix Figure A5) ---------------------
cohorts <- data.frame(
  label = c("Trained Oct. 2015", "Trained Apr. 2016", "Trained Nov. 2016", "Trained Jun. 2017"),
  month = c(22, 28, 35, 42)
)
cohorts$label <- factor(cohorts$label, levels = rev(cohorts$label))

SNAPSHOT <- 31  # a calendar moment between cohorts 2 (28) and 3 (35)
TIMELINE_END <- 48  # truncate well short of 72 -- the far tail (everyone
                     # eventually trained) buries the point being made,
                     # which is about the snapshot moment, not month 72

seg_before <- data.frame(label = cohorts$label, x = 1, xend = cohorts$month)
seg_after  <- data.frame(label = cohorts$label, x = cohorts$month, xend = TIMELINE_END)

ptimeline <- ggplot() +
  annotate("rect", xmin = SNAPSHOT - 0.4, xmax = SNAPSHOT + 0.4, ymin = 0.4, ymax = 4.9,
           fill = eil_pal$band, alpha = 0.7) +
  geom_segment(data = seg_before, aes(x = x, xend = xend, y = label, yend = label),
               color = eil_pal$axis, linewidth = 3.6, lineend = "round") +
  geom_segment(data = seg_after, aes(x = x, xend = xend, y = label, yend = label),
               color = eil_pal$accentred, linewidth = 3.6, lineend = "round", alpha = 0.55) +
  geom_point(data = cohorts, aes(x = month, y = label), size = 4.4, color = eil_pal$ink) +
  geom_vline(xintercept = SNAPSHOT, color = eil_pal$ink, linetype = "dashed", linewidth = 0.55) +
  annotate("text", x = SNAPSHOT, y = 4.75, label = "ONE CALENDAR MOMENT",
           hjust = 0.5, vjust = 0, color = eil_pal$ink, fontface = "bold", size = 3.3, family = EIL_FONT) +
  annotate("text", x = 24.5, y = 0.62, label = "already trained",
           hjust = 1, color = eil_pal$accentred, fontface = "bold", size = 3.0, family = EIL_FONT) +
  annotate("text", x = 37.5, y = 0.62, label = "not yet trained",
           hjust = 0, color = eil_pal$muted, fontface = "bold", size = 3.0, family = EIL_FONT) +
  scale_x_continuous(limits = c(1, TIMELINE_END), breaks = c(1, 13, 25, 37),
                      labels = c("2014", "2015", "2016", "2017"),
                      expand = c(0.01, 0)) +
  scale_y_discrete(expand = expansion(add = c(0.5, 0.75))) +
  coord_cartesian(clip = "off") +
  labs(x = NULL, y = NULL) +
  theme_eil(base_size = 13, base_family = EIL_FONT) +
  theme(
    plot.background   = element_rect(fill = eil_pal$paper, color = NA),
    panel.background  = element_rect(fill = eil_pal$paper, color = NA),
    axis.line.x       = element_line(color = eil_pal$axis, linewidth = 0.4),
    axis.ticks.x      = element_line(color = eil_pal$axis, linewidth = 0.3),
    axis.text.x       = element_text(size = 9.5),
    axis.text.y       = element_text(size = 12, color = eil_pal$ink),
    panel.grid.major.y = element_line(color = eil_pal$warmrule, linewidth = 0.35),
    plot.margin       = margin(4, 10, 2, 0)
  )

# --- Compose on an absolute-inch coordinate system -----------------------
W <- 7.6; H <- 6.9; DPI <- 200
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
title_lines <- strwrap("The comparison group wasn't untrained — just not yet trained.", width = 42)
grid.text(paste(title_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$ink, fontface = "bold", fontsize = EIL_TITLE_PT, lineheight = 1.08))
y <- y + pt_in(EIL_TITLE_PT, 1.08, length(title_lines)) + 0.09
dek_lines <- strwrap(paste(
  "Ohio rolled out the workshops in waves across 2015-2017. Facilities trained earlier and",
  "facilities trained later were the same kind of facility, at the same calendar moment --",
  "just at different points in the same rollout."),
  width = 88)
grid.text(paste(dek_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gpar(fontfamily = EIL_FONT_SERIF, fontface = "italic",
                     col = eil_pal$cite, fontsize = EIL_DEK_PT, lineheight = 1.27))
y <- y + pt_in(EIL_DEK_PT, 1.27, length(dek_lines))
y <- y + 0.03
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))

# --- timeline chart -----------------------------------------------------
y <- y + 0.28
chart_h <- 2.75
print(ptimeline, vp = viewport(x = nx(MX), y = ny(y), width = unit(CW, "in"),
                                height = unit(chart_h, "in"), just = c("left", "top")))
y <- y + chart_h

# --- bottom rule + takeaway + source ----------------------------------------
y <- y + 0.20
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))
y <- y + 0.15
takeaway_lines <- strwrap(paste(
  "Because the comparison is early-trained vs. later-trained -- not trained vs. never-trained",
  "-- differences in violations can't be explained by which facilities chose to sign up."),
  width = 74)
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
