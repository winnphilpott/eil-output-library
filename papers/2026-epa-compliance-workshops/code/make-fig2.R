# Generate Fig. 2 (event study / difference-in-differences) for the
# Ferraro & Shimshack policy brief.
#
# Reproduces the paper's Figure 2(a): the estimated effect of the compliance
# workshops on the number of violations, by month relative to training, using
# the preferred treated-only staggered design (later-trained cohorts serve as
# controls for earlier-trained cohorts). Effect is flat at zero with no jump at
# the workshop -- the difference-in-differences result.
#
# Validation: the pooled "Post" ATT from this design reproduces Table 3 col. 1
# (0.0043 vs. the paper's 0.004) on 222 treated facilities / 15,912 obs.
#
# Run:  Rscript code/make-fig2.R   ->  writes figures/fig2-did.png
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

# --- Design tokens (match _style.tex / make-fig1.R) -------------------------
INK   <- "#1d2620"
RED   <- "#641111"
BAND  <- "#f3e4e2"
AXIS  <- "#c4bdad"
MUTE  <- "#50534a"

# --- Plot -------------------------------------------------------------------
p <- ggplot(es, aes(event, est)) +
  annotate("rect", xmin = -0.5, xmax = 12.5, ymin = -Inf, ymax = Inf,
           fill = BAND, alpha = 0.7) +
  annotate("text", x = 6, y = 0.62, label = "AFTER WORKSHOP",
           hjust = 0.5, size = 2.3, color = RED, fontface = "bold") +
  geom_hline(yintercept = 0, color = MUTE, linewidth = 0.4) +
  geom_vline(xintercept = -0.5, color = RED, linetype = "dashed",
             linewidth = 0.4) +
  geom_linerange(aes(ymin = lo, ymax = hi), color = INK, linewidth = 0.4,
                 alpha = 0.85) +
  geom_point(color = INK, size = 1.1) +
  scale_x_continuous(
    breaks = seq(-12, 12, 6),
    labels = c("12+ before", "6 before", "Workshop", "6 after", "12+ after"),
    expand = c(0.02, 0)
  ) +
  scale_y_continuous(limits = c(-0.75, 0.75), breaks = c(-0.5, 0, 0.5)) +
  labs(x = "MONTHS RELATIVE TO WORKSHOP", y = "EFFECT ON VIOLATIONS") +
  theme_minimal(base_size = 7) +
  theme(
    plot.background  = element_rect(fill = "#ffffff", color = NA),
    panel.background = element_rect(fill = "#ffffff", color = NA),
    panel.grid       = element_blank(),
    axis.line        = element_line(color = AXIS, linewidth = 0.4),
    axis.ticks       = element_line(color = AXIS, linewidth = 0.3),
    axis.text        = element_text(color = MUTE, size = 7),
    axis.title.x     = element_text(color = MUTE, size = 6, margin = margin(t = 4)),
    axis.title.y     = element_text(color = MUTE, size = 6, margin = margin(r = 4))
  )

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave(OUT_PATH, p, width = 5.2, height = 2.9, dpi = 220, bg = "#ffffff")
message("wrote ", OUT_PATH)
