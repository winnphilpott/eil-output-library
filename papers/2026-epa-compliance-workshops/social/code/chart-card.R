# =====================================================================
#  chart-card.R  ·  EPA compliance workshops — social chart card (1b)
#  Conventions: style-guides/social/README.md  (§2: reuse the recipe,
#               re-render the card — don't copy the print PNG)
#  Scaffolding:  formats/social/social-cards.R
#
#  Recreates mockup card 1b: the paper's Fig. 2 event study re-rendered
#  at social scale (landscape 1200x675) with a plain-language headline,
#  before/after-training framing, and the logo lock-up added. The
#  regression recipe mirrors data-viz/code/make-fig2.R — the marks come
#  from the real data, not the mockup's placeholder SVG.
#
#  Run (from REPO ROOT):
#    Rscript papers/2026-epa-compliance-workshops/social/chart-card.R
#    -> writes social/assets/epa-chart-card.png
#  Deps: haven, dplyr, fixest, ggplot2, png
# =====================================================================

library(haven)
library(dplyr)
library(fixest)
library(ggplot2)
source("formats/social/assets/social-cards.R")

DATA_FILE <- "papers/2026-epa-compliance-workshops/data-viz/data/final_deidentified_dataset_july2025.dta"
DATA_URL  <- "https://osf.io/download/sa56r/"
OUT       <- "papers/2026-epa-compliance-workshops/social/assets/epa-chart-card.png"
SOURCE    <- "Environmental Inequality Lab · Ferraro & Shimshack, 2026 · shaded band = 95% CI"
HEADLINE  <- wrap_text("Free compliance workshops didn't reduce violations", 30)

# --- Event study (eq. 2): facility FE + time FE + weather, ref -1 ----
if (!file.exists(DATA_FILE)) {
  message("Downloading ", DATA_FILE, " from OSF (~21 MB)...")
  dir.create(dirname(DATA_FILE), showWarnings = FALSE, recursive = TRUE)
  download.file(DATA_URL, DATA_FILE, mode = "wb")
}
df <- read_dta(DATA_FILE)
t  <- df |> filter(group == "t")
wm <- t |> filter(attend == 1) |>
  group_by(permit2) |> summarise(wm = min(time), .groups = "drop")
t  <- t |> left_join(wm, by = "permit2") |>
  mutate(event = time - wm, e = pmin(pmax(event, -12), 12))
m  <- feols(viols ~ i(e, ref = -1) + rainfall + avg_temp | permit2 + time,
            data = t, cluster = ~permit2)
ct <- as.data.frame(coeftable(m)); ct$rn <- rownames(ct)
ct <- ct[grepl("^e::", ct$rn), ]
es <- data.frame(event = as.numeric(sub("^e::", "", ct$rn)),
                 est = ct[, 1], se = ct[, 2])
es <- rbind(es, data.frame(event = -1, est = 0, se = 0)) |> arrange(event)
es$lo <- es$est - 1.96 * es$se
es$hi <- es$est + 1.96 * es$se

# --- Plot at social scale --------------------------------------------
# Mockup 1b framing: a soft "after training" band, one dashed workshop
# marker, a word-based y-axis, and a single soft CI ribbon. Colours are
# the house tokens (eil_pal), so the card matches the paper figure.
p <- ggplot(es, aes(event, est)) +
  annotate("rect", xmin = -0.5, xmax = 12.5, ymin = -Inf, ymax = Inf,
           fill = eil_pal$band, alpha = 0.55) +
  annotate("text", x = -6.25, y = 0.92, label = "BEFORE TRAINING",
           size = 2.5, color = eil_pal$muted, fontface = "bold") +
  annotate("text", x = 6.25, y = 0.92, label = "AFTER TRAINING",
           size = 2.5, color = eil_pal$accentred, fontface = "bold") +
  geom_vline(xintercept = -0.5, color = eil_pal$accentred,
             linetype = "dashed", linewidth = 0.6) +
  geom_hline(yintercept = 0, color = eil_pal$muted, linewidth = 0.5) +
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = eil_pal$axis, alpha = 0.30) +
  geom_line(color = eil_pal$ink, alpha = 0.40, linewidth = 0.5) +
  geom_point(color = eil_pal$ink, size = 1.6) +
  scale_y_continuous(limits = c(-0.8, 1.0), breaks = c(-0.5, 0, 0.5),
    labels = c("Fewer\nviolations", "No change", "More\nviolations")) +
  scale_x_continuous(breaks = seq(-12, 12, 6),
    labels = c("12+ before", "6 before", "Workshop", "6 after", "12+ after"),
    expand = c(0.02, 0)) +
  labs(title = HEADLINE, x = "MONTHS RELATIVE TO TRAINING", y = NULL) +
  theme_eil_social() +
  # smaller axis labels: the mockup sets these ~8pt, well below the theme
  # default, so the y-word labels and x ticks have room to breathe.
  theme(
    axis.text.x  = element_text(size = 8),
    axis.text.y  = element_text(size = 8, lineheight = 0.9),
    axis.title.x = element_text(size = 7)
  )

save_card(p, OUT, dims = SOCIAL_DIMS$landscape, source = SOURCE)
