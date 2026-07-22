# Transitional Costs and the Decline of Coal: Worker-Level Evidence

**Colmer, Krause, Lyubich & Voorheis · Working Paper, July 2026** URI: https://www.environmental-inequality-lab.org/energy

## Data

*(Add dataset description here once data is added to `data-viz/data/`.)*

## Reproducing the Brief

```bash
# 1. Generate the figure (recreates the paper's Fig. 7a -> figures/fig1.png)
cd data-viz/
Rscript code/make-fig1.R

# 2. Build the Background infographic (editable TikZ -> fig-three-paths.pdf)
cd code/
pdflatex fig-three-paths.tex
cd ..

# 3. Render the PDF (current version is v2)
cd ../research-highlight/v2/
quarto render coal-worker-transitions_research-highlight_v2.qmd
```

> **Build note:** step 2 needs the `sansmath` LaTeX package, which keeps the
> `≈` glyph in Source Sans instead of falling back to Computer Modern. It is
> not in a default TinyTeX install — add it once with `tlmgr install sansmath`.

> **Figure note:** `data-viz/code/make-fig1.R` recreates Figure 7(a) (cumulative
> earnings of coal-exposed workers). The point estimates are digitized from the
> published figure — we don't hold the restricted Census/IRS microdata — and
> cross-checked against the paper's text (1.8× a year's pay lost by 2019).

> **Infographic note:** `data-viz/code/fig-three-paths.tex` is the canonical
> source for the "Three paths out of coal" figure that wraps into Background.
> It was built from `concept2_tikz_spec.md`, with `concept2_three_paths.pdf`
> as the visual reference. Type follows the design system rather than the
> reference PDF: Source Sans 3 (the reference fell back to DejaVu) and the
> house `\figtitle`/`\subhead` letter-spacing, which is tighter than the
> reference's. The canvas is fixed, so the width is set by
> `\includegraphics[width=...]` in the `.qmd` — currently 3.1in, matching the
> EPA compliance highlight — and type scales with it.
