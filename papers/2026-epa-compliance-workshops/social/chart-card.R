# =====================================================================
#  chart-card.R  ·  EPA compliance workshops — social chart card
#  Conventions: style-guides/social/README.md  (§2: reuse the recipe,
#               re-render the card — don't copy the print PNG)
#  Scaffolding:  formats/social/social-cards.R
#
#  Re-renders the paper's Fig. 2 event study at social scale, with a
#  headline and the logo lock-up added. The regression recipe mirrors
#  papers/2026-epa-compliance-workshops/data-viz/code/make-fig2.R.
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
source("formats/social/social-cards.R")

DATA_FILE <- "papers/2026-epa-compliance-workshops/data-viz/data/final_deidentified_dataset_july2025.dta"
DATA_URL  <- "https://osf.io/download/sa56r/"
OUT       <- "papers/2026-epa-compliance-workshops/social/assets/epa-chart-card.png"
SOURCE    <- "Environmental Inequality Lab · EPA Compliance Workshops, 2026"
HEADLINE  <- wrap_text("Free compliance workshops didn't reduce violations", 22)

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

# --- Plot at social scale ---------------------------------------------
# Stripped for a card: ONE fill (the soft band), ONE accent (the dashed
# workshop marker), calm marks. The single idea is "flat at zero, before
# and after" -- no competing "after" block, no double x-axis label.
p <- ggplot(es, aes(event, est)) +
  # the one reference and the one accent
  geom_hline(yintercept = 0, color = eil_pal$muted, linewidth = 0.5) +
  geom_vline(xintercept = -0.5, color = eil_pal$accentred,
             linetype = "dashed", linewidth = 0.5) +
  # soft uncertainty -- the only fill on the card
  geom_ribbon(aes(ymin = lo, ymax = hi), fill = eil_pal$axis, alpha = 0.20) +
  # restrained marks: thin connecting line + small points
  geom_line(color = eil_pal$ink, alpha = 0.30, linewidth = 0.5) +
  geom_point(color = eil_pal$ink, size = 1.5) +
  scale_y_continuous(limits = c(-0.75, 0.8), breaks = c(-0.5, 0, 0.5),
    labels = c("Fewer", "No change", "More")) +
  scale_x_continuous(breaks = c(-12, -0.5, 12),
    labels = c("12 mo.\nbefore", "Workshop", "12 mo.\nafter"),
    expand = c(0.06, 0)) +
  labs(title = HEADLINE, x = NULL, y = NULL) +
  theme_eil_social()

save_card(p, OUT, dims = SOCIAL_DIMS$square, source = SOURCE)
