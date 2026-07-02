# Generate Fig. 2 (event study / difference-in-differences) for the
# Ferraro & Shimshack policy brief.
#
# Reproduces the paper's Figure 2(a): the estimated effect of the compliance
# workshops on the number of violations, by month relative to training, using
# the preferred treated-only staggered design (later-trained cohorts serve as
# controls for earlier-trained cohorts). Effect is flat at zero with no jump at
# the workshop -- the difference-in-differences result.
#
# Styled for a general audience: word-based y-axis (more / no change / fewer),
# before/after-training framing, and a single soft uncertainty band rather than
# 25 confidence whiskers. The interpretive note lives in the document, not the
# figure.
#
# Validation: the pooled "Post" ATT from this design reproduces Table 3 col. 1
# (0.0043 vs. the paper's 0.004) on 222 treated facilities / 15,912 obs.
#
# Run (from data-viz/):  Rscript code/make-fig2.R  ->  figures/fig2-did.png
# Deps: haven, dplyr, fixest, ggplot2

library(haven)
library(dplyr)
library(fixest)
library(ggplot2)

DATA_FILE <- "data/final_deidentified_dataset_july2025.dta"
DATA_URL  <- "https://osf.io/download/sa56r/"
OUT_PATH  <- "figures/fig2-did.png"

# --- Load data (download if missing) ----------------------------------------
if (!file.exists(DATA_FILE)) {
  message("Downloading ", DATA_FILE, " from OSF (~21 MB)...")
  download.file(DATA_URL, DATA_FILE, mode = "wb")
}

df <- read_dta(DATA_FILE)

# --- Build event time (months relative to a facility's workshop) ------------
# Treated facilities only; `attend` turns on in a facility's first post month.
t <- df |> filter(group == "t")
wm <- t |> filter(attend == 1) |>
  group_by(permit2) |> summarise(wm = min(time), .groups = "drop")
t <- t |> left_join(wm, by = "permit2") |>
  mutate(event = time - wm,
         e     = pmin(pmax(event, -12), 12))   # bin the tails at +/- 12

# --- Event-study regression (eq. 2): facility FE + time FE + weather ---------
# Reference period -1; SEs clustered at the facility level.
m <- feols(viols ~ i(e, ref = -1) + rainfall + avg_temp | permit2 + time,
           data = t, cluster = ~permit2)

ct <- as.data.frame(coeftable(m)); ct$rn <- rownames(ct)
ct <- ct[grepl("^e::", ct$rn), ]
es <- data.frame(event = as.numeric(sub("^e::", "", ct$rn)),
                 est = ct[, 1], se = ct[, 2])
es <- rbind(es, data.frame(event = -1, est = 0, se = 0)) |> arrange(event)
es$lo <- es$est - 1.96 * es$se
es$hi <- es$est + 1.96 * es$se

# --- Design tokens (match _style.tex) ---------------------------------------
INK  <- "#1d2620"
RED  <- "#641111"
BAND <- "#f3e4e2"
AXIS <- "#c4bdad"
MUTE <- "#50534a"

# --- Plot -------------------------------------------------------------------
p <- ggplot(es, aes(event, est)) +
  # before/after-training framing
  annotate("rect", xmin = -0.5, xmax = 12.5, ymin = -Inf, ymax = Inf,
           fill = BAND, alpha = 0.35) +
  annotate("text", x = -6.25, y = 0.92, label = "BEFORE TRAINING",
           size = 2.4, color = MUTE, fontface = "bold") +
  annotate("text", x = 6.25, y = 0.92, label = "AFTER TRAINING",
           size = 2.4, color = RED, fontface = "bold") +
  geom_vline(xintercept = -0.5, color = RED, linetype = "dashed",
             linewidth = 0.4) +
  geom_hline(yintercept = 0, color = MUTE, linewidth = 0.45) +
  # single soft uncertainty band, light points + connecting line
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = AXIS, alpha = 0.35) +
  geom_line(color = INK, alpha = 0.55, linewidth = 0.4) +
  geom_point(color = INK, size = 0.95) +
  # word-based y-axis instead of numbers
  scale_y_continuous(limits = c(-0.8, 1.0), breaks = c(-0.5, 0, 0.5),
    labels = c("Fewer\nviolations", "No change", "More\nviolations")) +
  scale_x_continuous(breaks = seq(-12, 12, 6),
    labels = c("12+ before", "6 before", "Workshop", "6 after", "12+ after"),
    expand = c(0.02, 0)) +
  labs(x = "MONTHS RELATIVE TO TRAINING", y = NULL) +
  theme_minimal(base_size = 7) +
  theme(
    plot.background  = element_rect(fill = "#ffffff", color = NA),
    panel.background = element_rect(fill = "#ffffff", color = NA),
    panel.grid       = element_blank(),
    axis.line.x      = element_line(color = AXIS, linewidth = 0.4),
    axis.ticks.x     = element_line(color = AXIS, linewidth = 0.3),
    axis.ticks.y     = element_blank(),
    axis.text.x      = element_text(color = MUTE, size = 7),
    axis.text.y      = element_text(color = INK, size = 6.6, lineheight = 0.9),
    axis.title.x     = element_text(color = MUTE, size = 6, margin = margin(t = 4))
  )

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave(OUT_PATH, p, width = 5.4, height = 3.1, dpi = 220, bg = "#ffffff")
message("wrote ", OUT_PATH)
