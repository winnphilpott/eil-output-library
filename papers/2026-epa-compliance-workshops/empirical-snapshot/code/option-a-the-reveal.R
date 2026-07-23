# =====================================================================
#  DRAFT — Empirical Snapshot, Option A: "The Reveal"
#  NOT a final output. One of four exploratory directions for the
#  paper's empirical snapshot; see the other option-*.R scripts in this
#  folder for the alternatives.
#
#  Concept: put the naive before/after comparison next to the rigorous
#  comparison-group estimate, side by side, so the reader sees for
#  themselves why the study design matters -- no surrounding text needed.
#
#  Masthead/title/dek styling matches the house LaTeX macros exactly
#  (see _font-setup.R for the transcribed specs): logo left + tracked
#  label right + 2.2pt rule (\briefheader), 18pt bold title (\brieftitle),
#  Source Serif 4 italic dek (press-release style), 9.75pt tracked
#  accentred section labels (\sectionhead).
#
#  Run from REPO ROOT:
#    Rscript papers/2026-epa-compliance-workshops/empirical-snapshot/code/option-a-the-reveal.R
#    -> writes empirical-snapshot/figures/option-a-the-reveal.png
#  Deps: haven, dplyr, fixest, ggplot2, grid, png, ragg, systemfonts
# =====================================================================

suppressMessages({
  library(haven); library(dplyr); library(fixest); library(ggplot2); library(grid); library(png); library(ragg)
})

source("formats/data-viz/eil-theme.R")
source("papers/2026-epa-compliance-workshops/empirical-snapshot/code/_font-setup.R")

DATA_FILE <- "papers/2026-epa-compliance-workshops/data-viz/data/final_deidentified_dataset_july2025.dta"
DATA_URL  <- "https://osf.io/download/sa56r/"
OUT <- "papers/2026-epa-compliance-workshops/empirical-snapshot/figures/option-a-the-reveal.png"

if (!file.exists(DATA_FILE)) {
  message("Downloading ", DATA_FILE, " from OSF (~21 MB)...")
  dir.create(dirname(DATA_FILE), showWarnings = FALSE, recursive = TRUE)
  download.file(DATA_URL, DATA_FILE, mode = "wb")
}

df <- read_dta(DATA_FILE)
t  <- df |> filter(group == "t")
wm <- t |> filter(attend == 1) |> group_by(permit2) |> summarise(wm = min(time), .groups = "drop")
t  <- t |> left_join(wm, by = "permit2") |> mutate(post = ifelse(time >= wm, 1, 0))

# --- Panel 2 data: event study (facility + time FE, ref = 0) ----------
t2 <- t |> mutate(event = time - wm, e = pmin(pmax(event, -12), 12))
m  <- feols(viols ~ i(e, ref = 0) + rainfall + avg_temp | permit2 + time, data = t2, cluster = ~permit2)
ct <- as.data.frame(coeftable(m)); ct$rn <- rownames(ct)
ct <- ct[grepl("^e::", ct$rn), ]
es <- data.frame(event = as.numeric(sub("^e::", "", ct$rn)), est = ct[, 1], se = ct[, 2])
es <- rbind(es, data.frame(event = 0, est = 0, se = 0)) |> arrange(event)
es$lo <- es$est - 1.96 * es$se
es$hi <- es$est + 1.96 * es$se

# --- Panel 2 plot: event study (the real comparison) --------------------
p2 <- ggplot(es, aes(event, est)) +
  annotate("rect", xmin = 0, xmax = 12.5, ymin = -Inf, ymax = Inf,
           fill = eil_pal$band, alpha = 0.4) +
  geom_vline(xintercept = 0, color = eil_pal$accentred, linetype = "dashed", linewidth = 0.45) +
  geom_hline(yintercept = 0, color = eil_pal$muted, linewidth = 0.5) +
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = eil_pal$axis, alpha = 0.35) +
  geom_line(color = eil_pal$ink, alpha = 0.55, linewidth = 0.45) +
  geom_point(color = eil_pal$ink, size = 1.3) +
  scale_y_continuous(limits = c(-0.85, 1.0), breaks = c(-0.5, 0, 0.5),
                      labels = c("Fewer\nviolations", "No change", "More\nviolations")) +
  scale_x_continuous(breaks = seq(-12, 12, 6),
                      labels = c("12+ before", "6 before", "Workshop", "6 after", "12+ after"),
                      expand = c(0.02, 0)) +
  labs(x = NULL, y = NULL) +
  theme_eil(base_size = 12, base_family = EIL_FONT) +
  theme(
    plot.background  = element_rect(fill = eil_pal$paper, color = NA),
    panel.background = element_rect(fill = eil_pal$paper, color = NA),
    axis.text.x = element_text(size = 8.6),
    axis.text.y = element_text(size = 9.6, lineheight = 0.9),
    plot.margin = margin(2, 10, 2, 0)
  )

# --- Compose on an absolute-inch coordinate system -----------------------
W <- 7.6; H <- 9.85; DPI <- 200
MX <- 0.45                       # left/right margin, inches
CW <- W - 2 * MX                 # content width, inches

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

y <- 0.35  # cursor: distance from top, inches

# --- masthead: logo left + tracked label right + 2.2pt rule (\briefheader) --
logo <- readPNG("formats/logos/eil-logo-maroon.png")
LOGO_H <- 0.45; LOGO_W <- LOGO_H * (dim(logo)[2] / dim(logo)[1])
grid.raster(logo, x = nx(MX), y = ny(y), width = unit(LOGO_W, "in"), height = unit(LOGO_H, "in"),
            just = c("left", "top"))
grid.text(track_caps("Empirical Snapshot", 200), x = nx(W - MX), y = ny(y + LOGO_H / 2), just = c("right", "center"),
           gp = gp(col = eil_pal$accentred, fontface = "bold", fontsize = EIL_MASTHEAD_LABEL_PT))
y <- y + LOGO_H + 0.055
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$ink, lwd = pt_lwd(2.2)))

# --- title + dek (\brieftitle + press-release dek) --------------------------
y <- y + 0.18
grid.text("Did the workshops work? It depends how you ask.",
           x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$ink, fontface = "bold", fontsize = EIL_TITLE_PT, lineheight = 1.08))
y <- y + pt_in(EIL_TITLE_PT, 1.08) + 0.09
dek_lines <- strwrap(paste(
  "Ferraro & Shimshack (2026) studied hundreds of Ohio wastewater facilities offered free",
  "compliance workshops. Read one way, the workshops look effective. Read the other, they don't."),
  width = 92)
grid.text(paste(dek_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gpar(fontfamily = EIL_FONT_SERIF, fontface = "italic",
                     col = eil_pal$cite, fontsize = EIL_DEK_PT, lineheight = 1.27))
y <- y + pt_in(EIL_DEK_PT, 1.27, length(dek_lines))
y <- y + 0.03
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))

# --- panel 1: the common comparison ----------------------------------------
y <- y + 0.26
grid.text(track_caps("Compare before vs. after", 20), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$accentred, fontface = "bold", fontsize = EIL_SECTIONHEAD_PT))
y <- y + pt_in(EIL_SECTIONHEAD_PT) + 0.06
grid.text("50–60%", x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$accentred, fontface = "bold", fontsize = 40))
y <- y + pt_in(40, 1.0) + 0.07
grid.text("estimated drop in facilities with a violation",
           x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$ink, fontface = "bold", fontsize = 12.5))
y <- y + pt_in(12.5) + 0.12
body1_lines <- strwrap(paste(
  "A routine way agencies judge compliance programs — including a review",
  "that supported expanding this one to other states."), width = 64)
grid.text(paste(body1_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$muted, fontsize = 10.8, lineheight = 1.3))
y <- y + pt_in(10.8, 1.3, length(body1_lines)) + 0.15
grid.text("Source: Ferraro & Shimshack (2026), citing U.S. EPA program documentation",
           x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$faint, fontface = "italic", fontsize = 8.4))
y <- y + pt_in(8.4)

# --- section rule ------------------------------------------------------------
y <- y + 0.24
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))

# --- panel 2: the rigorous comparison ---------------------------------------
y <- y + 0.24
grid.text(track_caps("Compare trained vs. not-yet-trained", 20), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$accentred, fontface = "bold", fontsize = EIL_SECTIONHEAD_PT))
y <- y + pt_in(EIL_SECTIONHEAD_PT) + 0.06
grid.text("0%", x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$accentred, fontface = "bold", fontsize = 40))
y <- y + pt_in(40, 1.0) + 0.07
grid.text("estimated effect on violations",
           x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$ink, fontface = "bold", fontsize = 12.5))
y <- y + pt_in(12.5) + 0.13

chart_h <- 2.6
print(p2, vp = viewport(x = nx(MX), y = ny(y), width = unit(CW, "in"),
                         height = unit(chart_h, "in"), just = c("left", "top")))
y <- y + chart_h

# --- bottom rule + takeaway + source ----------------------------------------
y <- y + 0.18
grid.lines(x = nx(c(MX, W - MX)), y = ny(c(y, y)), gp = gp(col = eil_pal$warmrule, lwd = pt_lwd(0.7)))
y <- y + 0.15
takeaway_lines <- strwrap(paste(
  "Both numbers describe the same program, evaluated two different ways. Once the",
  "comparison accounts for trends already underway, compliance assistance shows no effect."),
  width = 74)
grid.text(paste(takeaway_lines, collapse = "\n"), x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$ink, fontface = "bold", fontsize = 12, lineheight = 1.25))
y <- y + pt_in(12, 1.25, length(takeaway_lines)) + 0.13
grid.text("Environmental Inequality Lab · Ferraro & Shimshack, 2026 · doi.org/10.1002/pam.70056",
           x = nx(MX), y = ny(y), just = c("left", "top"),
           gp = gp(col = eil_pal$faint, fontsize = EIL_FOOTER_PT))
y <- y + pt_in(EIL_FOOTER_PT) + 0.26  # bottom margin

popViewport()
dev.off()
message("wrote ", OUT, " -- content used ", round(y, 2), "in of ", H, "in page")
