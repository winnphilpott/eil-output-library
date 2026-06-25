# Papers

Output bundles for Environmental Inequality Lab papers. Each paper gets its own folder containing all associated public-facing outputs.

## Folder Convention

Each paper gets its own folder named `YYYY-[topic-slug]` (e.g., `2026-epa-compliance-workshops`).

```
YYYY-[topic-slug]/
├── code/                # figure scripts (e.g., make-fig1.R)
├── data/                # datasets used by the paper or figures
├── figures/             # figure outputs shared across outputs; logos live in formats/logos/
├── research-highlight/  # one-page research highlight (.qmd source + rendered PDF)
├── press-release/       # press release copy
├── blog/                # blog post copy and assets
├── social/              # social media copy and assets
└── README.md
```

## Rendering a Research Highlight to PDF

PDFs are not committed to the repo — render locally from the source files.

**Requirements:** Quarto and a LaTeX distribution (TinyTeX recommended). If Quarto is bundled with RStudio but not on your PATH, use the full path to the RStudio-bundled binary:

```bash
# 1. Generate figures (run from the paper's root folder)
Rscript code/make-fig1.R

# 2. Render the PDF (run from the research-highlight/ subfolder)
cd research-highlight/
/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto render [topic-slug].qmd
```

The PDF will appear in `research-highlight/`. If Quarto is on your system PATH, you can replace the full path above with just `quarto`.

## Naming Conventions

| File type | Pattern | Example |
|---|---|---|
| Paper folder | `YYYY-[topic-slug]` | `2026-epa-compliance-workshops` |
| Research highlight source | `[topic-slug].qmd` | `epa-compliance-workshops.qmd` |
| Data files | `YYYY-[description].[ext]` | `2025-deidentified-survey.dta` |
| Figures | `fig[N]-[description].png` | `fig1-violations-per-facility.png` |
| Figure scripts | `make-fig[N]-[description].[ext]` | `make-fig1-violations.R` |
