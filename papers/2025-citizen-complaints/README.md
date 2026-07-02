# [Paper Title]

**[Authors] · [Venue], 2025** URI: [add link]

<!-- Folder dated 2025 = year accepted for publication. Source PDF: Citizen_Complaint_Paper.pdf (gitignored) -->

## Data

*(Add dataset description here once data is added to `data-viz/data/`.)*

## Reproducing the Brief

```bash
# 1. Generate the figure(s) (run from the paper's data-viz/ folder)
cd data-viz/
Rscript code/make-fig1.R

# 2. Render the PDF (from the research-highlight/ subfolder)
cd ../research-highlight/
quarto render citizen-complaints_research-highlight.qmd
```
