# Generate Fig. 1 for the Ferraro & Shimshack policy brief.
# Data: final_deidentified_dataset_july2025.dta (Ferraro & Shimshack 2026, osf.io/w2fje)
#
# The script looks for the .dta file in the current directory. If absent,
# it downloads it automatically from OSF (~21 MB).
#
# Run:  Rscript make_fig1.R   ->  writes figures/fig1.png
# Deps: haven, dplyr, ggplot2

library(haven)
library(dplyr)
library(ggplot2)

DATA_FILE <- "final_deidentified_dataset_july2025.dta"
DATA_URL  <- "https://osf.io/download/sa56r/"
OUT_PATH  <- "figures/fig1.png"

# --- Load data (download if missing) ----------------------------------------
if (!file.exists(DATA_FILE)) {
  message("Downloading ", DATA_FILE, " from OSF (~21 MB)...")
  download.file(DATA_URL, DATA_FILE, mode = "wb")
}

df <- read_dta(DATA_FILE)

# Monthly mean violations for treated facilities (replicates Stata: collapse viols, by(time))
treated <- df |>
  filter(group == "t") |>
  group_by(time) |>
  summarise(viols = mean(viols, na.rm = TRUE), .groups = "drop") |>
  arrange(time)

# Pre-existing trend: linear fit on pre-program months (1-21), projected forward
pre_fit <- lm(viols ~ time, data = filter(treated, time <= 21))
treated  <- mutate(treated, trend = predict(pre_fit, newdata = data.frame(time = time)))

# --- Design tokens (match _brief-style.tex) ---------------------------------
INK   <- "#1d2620"
RED   <- "#641111"
BAND  <- "#f3e4e2"
AXIS  <- "#c4bdad"
MUTE  <- "#50534a"
FAINT <- "#9a978a"

series_labels <- c("Monthly violations", "Pre-existing trend")

# --- Plot -------------------------------------------------------------------
p <- ggplot(treated, aes(x = time)) +
  # Program window shading (months 22-42: first to last workshop cohort)
  annotate("rect", xmin = 22, xmax = 42, ymin = 0, ymax = 1.6, fill = BAND) +
  annotate("segment", x = 22, xend = 22, y = 0, yend = 1.6,
           color = RED, linetype = "dashed", linewidth = 0.4) +
  annotate("segment", x = 42, xend = 42, y = 0, yend = 1.6,
           color = RED, linetype = "dashed", linewidth = 0.4) +
  # Trend and violations lines
  geom_line(aes(y = trend, color = "Pre-existing trend", linetype = "Pre-existing trend"),
            linewidth = 0.45) +
  geom_line(aes(y = viols, color = "Monthly violations", linetype = "Monthly violations"),
            linewidth = 0.5) +
  # Program label
  annotate("text", x = 32, y = 1.44, label = "ASSISTANCE PROGRAM",
           hjust = 0.5, size = 2.3, color = RED, fontface = "bold") +
  annotate("text", x = 32, y = 1.33, label = "2015–2017",
           hjust = 0.5, size = 2.1, color = RED) +
  # Scales — matching breaks/name merges color + linetype into one legend
  scale_color_manual(
    name   = NULL,
    breaks = series_labels,
    values = setNames(c(INK, INK), series_labels)
  ) +
  scale_linetype_manual(
    name   = NULL,
    breaks = series_labels,
    values = setNames(c("solid", "longdash"), series_labels)
  ) +
  scale_x_continuous(
    limits = c(1, 72),
    breaks = c(1, 13, 25, 37, 49, 61),
    labels = c("2014", "2015", "2016", "2017", "2018", "2019"),
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    limits = c(0, 1.6),
    breaks = c(0, 0.5, 1.0, 1.5),
    labels = c("0", ".5", "1.0", "1.5"),
    expand = c(0, 0)
  ) +
  labs(x = "MONTH OF SAMPLE (72 MONTHS)", y = NULL) +
  guides(color = guide_legend(nrow = 1), linetype = guide_legend(nrow = 1)) +
  theme_minimal(base_size = 7) +
  theme(
    plot.background   = element_rect(fill = "#faf8f1", color = NA),
    panel.background  = element_rect(fill = "#faf8f1", color = NA),
    panel.grid        = element_blank(),
    axis.line.x       = element_line(color = AXIS, linewidth = 0.4),
    axis.line.y       = element_line(color = AXIS, linewidth = 0.4),
    axis.ticks        = element_line(color = AXIS, linewidth = 0.3),
    axis.ticks.length = unit(2, "pt"),
    axis.text         = element_text(color = MUTE, size = 7),
    axis.title.x      = element_text(color = FAINT, size = 6, margin = margin(t = 4)),
    legend.position   = "bottom",
    legend.key.width  = unit(20, "pt"),
    legend.text       = element_text(color = MUTE, size = 6.2),
    legend.key        = element_rect(fill = NA, color = NA),
    legend.spacing.x  = unit(10, "pt")
  )

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave(OUT_PATH, p, width = 5.2, height = 2.9, dpi = 220, bg = "#faf8f1")
message("wrote ", OUT_PATH)
