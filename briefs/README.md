# Briefs

Draft and completed policy briefs from the Environmental Inequality Lab.

## Folder Convention

Each brief gets its own folder named `YYYY-[topic-slug]` (e.g., `2026-coal-communities-income`).

```
YYYY-[topic-slug]/
├── code/          # analysis and figure scripts (e.g., make-fig1.R)
├── data/          # datasets used by the brief or figures
├── figures/       # figure outputs (e.g., fig1.png); logos live in formats/logos/
├── text/          # source files: .qmd (style pulled from formats/_style.tex)
└── brief.pdf      # compiled output — rendered from text/, moved here
```

## Rendering a Brief to PDF

PDFs are not committed to the repo — render locally from the source files.

**Requirements:** Quarto and a LaTeX distribution (TinyTeX recommended). If Quarto is bundled with RStudio but not on your PATH, use the full path to the RStudio-bundled binary:

```bash
# 1. Generate figures (run from the brief's root folder)
Rscript code/make-fig1.R

# 2. Render the PDF (run from the text/ subfolder)
cd text/
/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto render [topic-slug].qmd
```

The PDF will appear in `text/`. If Quarto is on your system PATH, you can replace the full path above with just `quarto`.

## Naming Conventions

| File type | Pattern | Example |
|---|---|---|
| Brief folder | `YYYY-[topic-slug]` | `2026-epa-compliance-workshops` |
| Brief source | `[topic-slug].qmd` | `epa-compliance-workshops.qmd` |
| Data files | `YYYY-[description].[ext]` | `2025-deidentified-survey.dta` |
| Figures | `fig[N]-[description].png` | `fig1-violations-per-facility.png` |
| Figure scripts | `make-fig[N]-[description].[ext]` | `make-fig1-violations.R` |
