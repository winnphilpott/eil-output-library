# Transitional Costs and the Decline of Coal: Worker-Level Evidence

**Colmer, Krause, Lyubich & Voorheis · Working Paper, July 2026** URI: https://researchonline.lse.ac.uk/id/eprint/126795

## Data

*(Add dataset description here once data is added to `data-viz/data/`.)*

## Reproducing the Brief

```bash
# 1. Generate the figure (recreates the paper's Fig. 7a -> figures/fig1.png)
cd data-viz/
Rscript code/make-fig1.R

# 2. Render the PDF (current version is v2)
cd ../research-highlight/v2/
quarto render coal-worker-transitions_research-highlight_v2.qmd
```

> **Figure note:** `data-viz/code/make-fig1.R` recreates Figure 7(a) (cumulative
> earnings of coal-exposed workers). The point estimates are digitized from the
> published figure — we don't hold the restricted Census/IRS microdata — and
> cross-checked against the paper's text (1.8× a year's pay lost by 2019).
