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

**Requirements:** [Quarto](https://quarto.org/docs/get-started/) and a LaTeX distribution. The simplest cross-platform setup is to install Quarto, then run `quarto install tinytex` once — Quarto then locates LaTeX automatically on macOS, Linux, and Windows. If Quarto is bundled with RStudio but not on your PATH, use the full path to the RStudio-bundled binary:

```bash
# 1. Generate figures (run from the paper's root folder)
Rscript code/make-fig1.R

# 2. Render the PDF (run from the research-highlight/ subfolder)
cd research-highlight/
/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto render [topic-slug]_research-highlight.qmd
```

The PDF will appear in `research-highlight/`. If Quarto is on your system PATH, you can replace the full path above with just `quarto`.

**Convenience scripts.** Each `press-release/` folder ships a `render.sh` (macOS / Linux, or Windows via Git Bash or WSL) and a `render.ps1` (native Windows PowerShell) that render every `.qmd` in the folder from any working directory — they locate Quarto themselves and `cd` into their own folder first. Run `./render.sh` or `.\render.ps1`.

## Naming Conventions

| File type | Pattern | Example |
|---|---|---|
| Paper folder | `YYYY-[topic-slug]` | `2026-epa-compliance-workshops` |
| Research highlight source | `[topic-slug]_research-highlight.qmd` | `epa-compliance-workshops_research-highlight.qmd` |
| Press release source | `[topic-slug]_press-release.qmd` | `epa-compliance-workshops_press-release.qmd` |
| Data files | `YYYY-[description].[ext]` | `2025-deidentified-survey.dta` |
| Figures | `fig[N]-[description].png` | `fig1-violations-per-facility.png` |
| Figure scripts | `make-fig[N]-[description].[ext]` | `make-fig1-violations.R` |

**Output sources carry their type in the filename** (`_research-highlight`, `_press-release`, etc.). A paper's research highlight and press release share a topic slug and could otherwise produce identically named files; encoding the output type keeps both the source and the rendered PDF self-describing even when pulled out of their folder. Add a version suffix (`_v4`) when keeping numbered drafts.
