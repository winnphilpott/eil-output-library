# =====================================================================
#  DRAFT — Empirical Snapshot, Option D: "The Expanded Infographic"
#  NOT a final output. One of four exploratory directions for the
#  paper's empirical snapshot; see the other option-*.R scripts in this
#  folder for the alternatives.
#
#  Concept: start from the exact "Two Approaches to Compliance" diagram
#  already on page 1 of the research highlight (data-viz/code/
#  fig-two-approaches.tex, reused byte-for-byte -- see
#  fig-two-approaches-expanded.tex in this same folder) and extend its
#  right-hand arrow chain with one more linked box: the result. No new
#  section, no border, no separate callout -- just the next step in the
#  same process, styled solid to read as an outcome rather than an
#  action. The left column simply stops at three boxes, since
#  traditional enforcement wasn't tested here.
#
#  Pipeline: pdflatex renders the TikZ diagram to a vector PDF (already
#  Source Sans 3 via the sourcesanspro package, matching house print),
#  pymupdf (fitz) rasterizes it with alpha so it blends into the page,
#  and this script composites the raster into the same masthead/footer
#  system used by Options A, B, and C -- matched to the exact house
#  LaTeX macro specs (see _font-setup.R): logo left + tracked label
#  right + 2.2pt rule, 18pt bold title, Source Serif 4 italic dek.
#
#  Run from REPO ROOT (after building fig-two-approaches-expanded.pdf
#  and rasterizing it to ../figures/ -- see that .tex file's header):
#    Rscript papers/2026-epa-compliance-workshops/empirical-snapshot/code/option-d-expanded-infographic.R
#    -> writes empirical-snapshot/figures/option-d-expanded-infographic.png
#  Deps: grid, png, ragg, systemfonts
# =====================================================================

suppressMessages({ library(grid); library(png); library(ragg) })

source("formats/data-viz/eil-theme.R")
source("papers/2026-epa-compliance-workshops/empirical-snapshot/code/_font-setup.R")

FIGURES_DIR <- "papers/2026-epa-compliance-workshops/empirical-snapshot/figures"
DIAGRAM <- file.path(FIGURES_DIR, "fig-two-approaches-expanded.png")
OUT <- file.path(FIGURES_DIR, "option-d-expanded-infographic.png")

diagram <- readPNG(DIAGRAM)
dpx <- dim(diagram)[2]; dpy <- dim(diagram)[1]  # source pixel dims

# --- Compose on an absolute-inch coordinate system -----------------------
W <- 7.6; MX <- 0.45; CW <- W - 2 * MX
pt_in <- function(pt, lineheight = 1.15, lines = 1) pt / 72.27 * lineheight * lines
gp <- function(...) gpar(fontfamily = EIL_FONT, ...)

diagram_h <- CW * (dpy / dpx)  # preserve aspect ratio at content width

H <- 8.55  # measured/tuned below; adjust if content over/underflows
DPI <- 200

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
title_lines <- strwrap("Two philosophies of compliance. One of them was tested.", width = 42)
grid.text(paste(title_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$ink, fontface = "bold", fontsize = EIL_TITLE_PT, lineheight = 1.08))
y <- y + pt_in(EIL_TITLE_PT, 1.08, length(title_lines)) + 0.09
dek_lines <- strwrap(paste(
  "Regulators can inspect facilities and fine violators, or they can offer guidance and hope",
  "facilities were just confused about the rules. Ferraro & Shimshack (2026) tested the second belief."),
  width = 88)
grid.text(paste(dek_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gpar(fontfamily = EIL_FONT_SERIF, fontface = "italic",
                     col = eil_pal$cite, fontsize = EIL_DEK_PT, lineheight = 1.27))
y <- y + pt_in(EIL_DEK_PT, 1.27, length(dek_lines))
y <- y + 0.03
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))

# --- diagram --------------------------------------------------------------
y <- y + 0.26
grid.raster(diagram, x = nx(MX), y = ny(y), width = unit(CW, "in"),
            height = unit(diagram_h, "in"), just = c("left", "top"))
y <- y + diagram_h

# --- bottom rule + takeaway + source ----------------------------------------
y <- y + 0.20
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))
y <- y + 0.15
takeaway_lines <- strwrap(paste(
  "The evidence for inspections and fines is stronger than for compliance assistance --",
  "a real trade-off for agencies deciding where to spend a shrinking enforcement budget."),
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
