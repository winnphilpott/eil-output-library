# EPA Compliance Workshops Don't Reduce Violations

**Ferraro & Shimshack · Journal of Policy Analysis and Management, 2026**
DOI: [10.1002/pam.70056](https://doi.org/10.1002/pam.70056)

## Data

`data-viz/data/final_deidentified_dataset_july2025.dta` — de-identified facility-level violation records from Ferraro & Shimshack (2026). Also available at [osf.io/w2fje](https://osf.io/w2fje).

## Reproducing the Brief

```bash
# 1. Generate figure (from the data-viz/ folder)
cd data-viz/
Rscript code/make-fig1.R

# 2. Render PDF (from the version subfolder)
cd ../research-highlight/v4/
quarto render epa-compliance-workshops_research-highlight_v4.qmd
```

## Reproducing the Social Cards

Three landscape (1200×675) cards — a stat card, the Fig. 2 event study re-rendered for
social, and a quote card:

```bash
# From the REPO ROOT — cards write to social/assets/
Rscript papers/2026-epa-compliance-workshops/social/code/stat-card.R    # -> assets/epa-stat-card.png
Rscript papers/2026-epa-compliance-workshops/social/code/chart-card.R   # -> assets/epa-chart-card.png
Rscript papers/2026-epa-compliance-workshops/social/code/quote-card.R   # -> assets/epa-quote-card.png
```

Post copy lives in `social/copy/` (`linkedin.md`, `x.md`). See
`style-guides/social/README.md` for voice and on-image conventions.
