# EPA Compliance Workshops Don't Reduce Violations

**Ferraro & Shimshack · Journal of Policy Analysis and Management, 2026**
DOI: [10.1002/pam.70056](https://doi.org/10.1002/pam.70056)

## About

This brief summarizes research on whether EPA compliance assistance programs — workshops, consulting, and technical support offered to polluting facilities — actually reduce violations. The study finds little to no effect, in contrast to the stronger evidence supporting inspections and penalties.

## Data

`data/final_deidentified_dataset_july2025.dta` — de-identified facility-level violation records from Ferraro & Shimshack (2026). Also available at [osf.io/w2fje](https://osf.io/w2fje).

## Reproducing the Brief

```bash
# 1. Generate figure (from this folder)
Rscript code/make-fig1.R

# 2. Render PDF (from text/ subfolder)
cd text/
quarto render epa-compliance-workshops.qmd
```
