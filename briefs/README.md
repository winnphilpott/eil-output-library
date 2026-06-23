# Briefs

Draft and completed policy briefs from the Environmental Inequality Lab.

## Folder Convention

Each brief gets its own folder named `YYYY-[topic-slug]` (e.g., `2026-coal-communities-income`).

```
YYYY-[topic-slug]/
├── code/          # analysis and figure scripts (e.g., make-fig1.R)
├── data/          # datasets used by the brief or figures
├── figures/       # figure outputs (e.g., fig1.png)
├── text/          # source files: .qmd and any .tex style files
└── brief.pdf      # compiled output — rendered from text/, moved here
```

## Naming Conventions

| File type | Pattern | Example |
|---|---|---|
| Brief folder | `YYYY-[topic-slug]` | `2026-epa-compliance-workshops` |
| Brief source | `[topic-slug].qmd` | `epa-compliance-workshops.qmd` |
| Style file | `_style.tex` | `_style.tex` |
| Data files | `YYYY-[description].[ext]` | `2025-deidentified-survey.dta` |
| Figures | `fig[N]-[description].png` | `fig1-violations-per-facility.png` |
| Figure scripts | `make-fig[N]-[description].[ext]` | `make-fig1-violations.R` |
