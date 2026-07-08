# [Paper Title — state the finding as a claim]

**[Authors] · [Journal], 2025**
DOI: [10.xxxx/xxxxx](https://doi.org/[DOI])

<!-- Fill in title, authors, journal, and DOI from the paper. Folder dated 2025
     = year accepted for publication. Source PDF: early-life-pollution_paper.pdf
     (gitignored via papers/*/*.pdf). -->

## Data

*(Add dataset description here once data is added to `data-viz/data/`.)*

## Reproducing the Brief

```bash
# 1. Generate the figure(s) (run from the paper's data-viz/ folder)
cd data-viz/
Rscript code/data-viz-template.R

# 2. Render the PDF (from the research-highlight/ subfolder)
cd ../research-highlight/
quarto render early-life-pollution_research-highlight.qmd
```

## Reproducing the Social Cards

```bash
# From the REPO ROOT — cards write to social/assets/
Rscript papers/2025-early-life-pollution/social/code/stat-card.R    # -> assets/early-life-stat-card.png
Rscript papers/2025-early-life-pollution/social/code/chart-card.R   # -> assets/early-life-chart-card.png
Rscript papers/2025-early-life-pollution/social/code/quote-card.R   # -> assets/early-life-quote-card.png
```

Post copy lives in `social/copy/` (`linkedin.md`, `x.md`). See
`style-guides/social/README.md` for voice and on-image conventions.
