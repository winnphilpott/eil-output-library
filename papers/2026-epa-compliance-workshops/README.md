# EPA Compliance Workshops Don't Reduce Violations

**Ferraro & Shimshack · Journal of Policy Analysis and Management, 2026**
DOI: [10.1002/pam.70056](https://doi.org/10.1002/pam.70056)

## Data

`data/final_deidentified_dataset_july2025.dta` — de-identified facility-level violation records from Ferraro & Shimshack (2026). Also available at [osf.io/w2fje](https://osf.io/w2fje).

## Reproducing the Brief

```bash
# 1. Generate figure (from this folder)
Rscript code/make-fig1.R

# 2. Render PDF (from the version subfolder)
cd research-highlight/v4/
quarto render epa-compliance-workshops_research-highlight_v4.qmd
```
